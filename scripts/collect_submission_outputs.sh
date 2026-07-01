#!/usr/bin/env bash
# Collect the files that are most useful for pasting into the homework notebook.
#
# Usage:
#   bash scripts/collect_submission_outputs.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

OUT_DIR="$ROOT/outputs/submission_bundle"
BENCH_DIR="$ROOT/outputs/benchmarks"
mkdir -p "$OUT_DIR"

REPORT="$OUT_DIR/submission_results.md"

{
  echo "# Speculative Decoding + FP8 Quantization Homework Outputs"
  echo
  echo "Generated: $(date --iso-8601=seconds)"
  echo "Git commit: $(git rev-parse HEAD 2>/dev/null || true)"
  echo

  for cfg in speculative fp8 fp8_speculative baseline; do
    latest="$BENCH_DIR/${cfg}_bench_latest.txt"
    echo "## ${cfg} benchmark"
    echo
    if [ -f "$latest" ]; then
      echo '```text'
      cat "$latest"
      echo '```'
    else
      echo "Missing: $latest"
    fi
    echo
  done

  echo "## Environment fingerprints"
  echo
  for f in \
    outputs/machine_fingerprint.txt \
    outputs/env_speculators_freeze.txt \
    outputs/env_vllm_freeze.txt \
    outputs/env_compressor_freeze.txt \
    outputs/nvidia_smi.txt \
    outputs/git_commit.txt \
    outputs/disk_space.txt; do
    if [ -f "$ROOT/$f" ]; then
      echo "### $f"
      echo '```text'
      sed -n '1,240p' "$ROOT/$f"
      echo '```'
      echo
    fi
  done
} > "$REPORT"

# Copy latest benchmark files alongside the markdown report.
if [ -d "$BENCH_DIR" ]; then
  cp "$BENCH_DIR"/*_bench_latest.txt "$OUT_DIR"/ 2>/dev/null || true
fi

echo "Submission bundle written to:"
echo "  $OUT_DIR"
echo
echo "Main report:"
echo "  $REPORT"
