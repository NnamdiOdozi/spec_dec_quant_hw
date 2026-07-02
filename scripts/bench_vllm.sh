#!/usr/bin/env bash
# Run vLLM serve benchmark against a running server.
#
# Usage:
#   bash scripts/bench_vllm.sh baseline
#   bash scripts/bench_vllm.sh speculative
#   bash scripts/bench_vllm.sh fp8
#   bash scripts/bench_vllm.sh fp8_speculative

set -euo pipefail

CONFIG="${1:-baseline}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

if [ ! -d "$ROOT/.git" ]; then
  echo "ERROR: run this from the cloned project repo."
  echo "Resolved ROOT: $ROOT"
  exit 1
fi

mkdir -p "$ROOT/outputs" "$ROOT/logs"
if [ ! -e "$ROOT/output" ]; then
  ln -s outputs "$ROOT/output"
fi

PORT="${PORT:-8000}"
MODEL_FOR_BENCH="${MODEL_FOR_BENCH:-Qwen/Qwen3-8B}"
# The model name sent to the server and the tokenizer used by the benchmark
# can differ. This matters for EAGLE/speculative serving, where the server
# model id may be a local checkpoint path, but the tokenizer should still be
# the base model tokenizer.
TOKENIZER_FOR_BENCH="${TOKENIZER_FOR_BENCH:-$MODEL_FOR_BENCH}"
DATASET_NAME="${DATASET_NAME:-hf}"
DATASET_PATH="${DATASET_PATH:-philschmid/mt-bench}"
MAX_CONCURRENCY="${MAX_CONCURRENCY:-8}"
NUM_PROMPTS="${NUM_PROMPTS:-80}"

VLLM_BIN="$ROOT/vllm_venv/bin/vllm"
RESULT_DIR="$ROOT/outputs/benchmarks"
mkdir -p "$RESULT_DIR"

RESULT_FILE="$RESULT_DIR/${CONFIG}_bench_$(date +%Y%m%d_%H%M%S).txt"
LATEST_FILE="$RESULT_DIR/${CONFIG}_bench_latest.txt"

if [ ! -x "$VLLM_BIN" ]; then
  echo "ERROR: $VLLM_BIN not found. Run scripts/setup_envs.sh first."
  exit 1
fi

if ! curl -fsS "http://localhost:${PORT}/v1/models" >/dev/null 2>&1; then
  echo "ERROR: no vLLM server appears to be running on port $PORT."
  echo "Start it first, e.g.:"
  echo "  bash scripts/serve_vllm.sh $CONFIG"
  exit 1
fi

{
  echo "# Benchmark metadata"
  echo "config=$CONFIG"
  echo "date=$(date --iso-8601=seconds)"
  echo "git_commit=$(git rev-parse HEAD 2>/dev/null || true)"
  echo "model_for_bench=$MODEL_FOR_BENCH"
  echo "tokenizer_for_bench=$TOKENIZER_FOR_BENCH"
  echo "base_url=http://localhost:${PORT}"
  echo "dataset_name=$DATASET_NAME"
  echo "dataset_path=$DATASET_PATH"
  echo "max_concurrency=$MAX_CONCURRENCY"
  echo "num_prompts=$NUM_PROMPTS"
  echo
  echo "# vLLM bench output"
} | tee "$RESULT_FILE"

"$VLLM_BIN" bench serve \
  --model "$MODEL_FOR_BENCH" \
  --tokenizer "$TOKENIZER_FOR_BENCH" \
  --base-url "http://localhost:${PORT}" \
  --dataset-name "$DATASET_NAME" \
  --dataset-path "$DATASET_PATH" \
  --max-concurrency "$MAX_CONCURRENCY" \
  --num-prompts "$NUM_PROMPTS" 2>&1 | tee -a "$RESULT_FILE"

cp "$RESULT_FILE" "$LATEST_FILE"

echo
echo "Benchmark saved to:"
echo "  $RESULT_FILE"
echo "Latest copy saved to:"
echo "  $LATEST_FILE"
