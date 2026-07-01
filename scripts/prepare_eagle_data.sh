#!/usr/bin/env bash
# Prepare ShareGPT-style data and generate verifier hidden states for offline EAGLE-3 training.
#
# Run on the GPU VM after setup_envs.sh:
#   bash scripts/prepare_eagle_data.sh
#
# Cheap smoke test:
#   MAX_SAMPLES=50 SEQ_LENGTH=1024 CONCURRENCY=8 bash scripts/prepare_eagle_data.sh
#
# Full-ish starting run:
#   MAX_SAMPLES=3000 SEQ_LENGTH=2048 CONCURRENCY=32 bash scripts/prepare_eagle_data.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

if [ ! -d "$ROOT/.git" ]; then
  echo "ERROR: run this from the cloned project repo."
  echo "Resolved ROOT: $ROOT"
  exit 1
fi

# Keep one canonical output folder, but also create an 'output' symlink for notebook wording compatibility.
mkdir -p "$ROOT/outputs" "$ROOT/logs"
if [ ! -e "$ROOT/output" ]; then
  ln -s outputs "$ROOT/output"
fi

touch "$ROOT/.gitignore"
grep -qxF "outputs/" "$ROOT/.gitignore" || echo "outputs/" >> "$ROOT/.gitignore"
grep -qxF "output/" "$ROOT/.gitignore" || echo "output/" >> "$ROOT/.gitignore"
grep -qxF "logs/" "$ROOT/.gitignore" || echo "logs/" >> "$ROOT/.gitignore"

MODEL_ID="${MODEL_ID:-Qwen/Qwen3-8B}"
MAX_SAMPLES="${MAX_SAMPLES:-3000}"
SEQ_LENGTH="${SEQ_LENGTH:-2048}"
VLLM_MAX_MODEL_LEN="${VLLM_MAX_MODEL_LEN:-$((SEQ_LENGTH + 64))}"
CONCURRENCY="${CONCURRENCY:-32}"
PORT="${PORT:-8000}"
GPU_MEMORY_UTILIZATION="${GPU_MEMORY_UTILIZATION:-0.90}"

SPEC_DIR="$ROOT/external/speculators"
SPEC_PY="$ROOT/speculators_venv/bin/python"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT/outputs/eagle3_qwen3_8b_sharegpt}"
HIDDEN_STATES_DIR="${HIDDEN_STATES_DIR:-$OUTPUT_DIR/hidden_states}"
TMP_HIDDEN_STATES_DIR="${TMP_HIDDEN_STATES_DIR:-/tmp/hidden_states}"
TMUX_SESSION="${TMUX_SESSION:-eagle-hs-vllm}"
LOG_DIR="$ROOT/logs"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR" "$HIDDEN_STATES_DIR"

LOG_FILE="$LOG_DIR/prepare_eagle_data_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Logging to:   $LOG_FILE"
echo "Project root: $ROOT"
echo "Model:        $MODEL_ID"
echo "Output dir:   $OUTPUT_DIR"
echo "Hidden dir:   $HIDDEN_STATES_DIR"
echo "Max samples:  $MAX_SAMPLES"
echo "Seq length:   $SEQ_LENGTH"
echo "vLLM max len: $VLLM_MAX_MODEL_LEN"
echo "Concurrency:  $CONCURRENCY"
echo

if [ ! -d "$SPEC_DIR" ]; then
  echo "ERROR: $SPEC_DIR not found. Run scripts/setup_envs.sh first."
  exit 1
fi

if [ ! -x "$SPEC_PY" ]; then
  echo "ERROR: $SPEC_PY not found. Run scripts/setup_envs.sh first."
  exit 1
fi

echo "=== Disk before data prep ==="
df -h "$ROOT" || true
echo

echo "=== Step 1: Prepare ShareGPT-style dataset ==="
cd "$SPEC_DIR"
"$SPEC_PY" scripts/prepare_data.py \
  --model "$MODEL_ID" \
  --data sharegpt \
  --output "$OUTPUT_DIR" \
  --max-samples "$MAX_SAMPLES" \
  --seq-length "$SEQ_LENGTH"

echo
echo "=== Step 2: Start vLLM hidden-state extraction server in tmux ==="

if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
  echo "Existing tmux session '$TMUX_SESSION' found; leaving it running."
else
  mkdir -p "$TMP_HIDDEN_STATES_DIR"
  VLLM_LOG="$LOG_DIR/hidden_state_vllm_$(date +%Y%m%d_%H%M%S).log"

  tmux new-session -d -s "$TMUX_SESSION" \
    "cd '$SPEC_DIR' && CUDA_VISIBLE_DEVICES='${CUDA_VISIBLE_DEVICES:-0}' '$SPEC_PY' scripts/launch_vllm.py '$MODEL_ID' --hidden-states-path '$TMP_HIDDEN_STATES_DIR' -- --port '$PORT' --gpu-memory-utilization '$GPU_MEMORY_UTILIZATION' --max-model-len '$VLLM_MAX_MODEL_LEN' > '$VLLM_LOG' 2>&1"

  echo "Started tmux session: $TMUX_SESSION"
  echo "vLLM log: $VLLM_LOG"
fi

echo
echo "=== Step 3: Wait for vLLM server ==="
for i in $(seq 1 120); do
  if curl -fsS "http://localhost:${PORT}/v1/models" >/dev/null 2>&1; then
    echo "vLLM server is ready on port $PORT"
    break
  fi
  if [ "$i" -eq 120 ]; then
    echo "ERROR: vLLM server did not become ready."
    echo "Inspect logs with:"
    echo "  tmux attach -t $TMUX_SESSION"
    echo "  tail -200 $LOG_DIR/hidden_state_vllm_*.log"
    exit 1
  fi
  sleep 5
done

echo
echo "=== Step 4: Generate hidden states offline ==="
cd "$SPEC_DIR"
"$SPEC_PY" scripts/data_generation_offline.py \
  --preprocessed-data "$OUTPUT_DIR" \
  --endpoint "http://localhost:${PORT}/v1" \
  --output "$HIDDEN_STATES_DIR" \
  --max-samples "$MAX_SAMPLES" \
  --concurrency "$CONCURRENCY" \
  --validate-outputs

echo
echo "=== Disk after hidden-state generation ==="
du -sh "$OUTPUT_DIR" "$HIDDEN_STATES_DIR" 2>/dev/null || true
df -h "$ROOT" || true

echo
echo "=== Data preparation complete ==="
echo "Prepared dataset: $OUTPUT_DIR"
echo "Hidden states:    $HIDDEN_STATES_DIR"
echo "Log file:         $LOG_FILE"
echo
echo "To stop the hidden-state vLLM server:"
echo "  tmux kill-session -t $TMUX_SESSION"
