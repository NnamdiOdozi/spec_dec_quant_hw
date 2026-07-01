#!/usr/bin/env bash
# Start a vLLM server for one homework configuration.
#
# Usage:
#   bash scripts/serve_vllm.sh baseline
#   bash scripts/serve_vllm.sh speculative
#   bash scripts/serve_vllm.sh fp8
#   bash scripts/serve_vllm.sh fp8_speculative
#
# This script starts the server in tmux. Stop it with:
#   tmux kill-session -t vllm-serve

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

touch "$ROOT/.gitignore"
grep -qxF "outputs/" "$ROOT/.gitignore" || echo "outputs/" >> "$ROOT/.gitignore"
grep -qxF "output/" "$ROOT/.gitignore" || echo "output/" >> "$ROOT/.gitignore"
grep -qxF "logs/" "$ROOT/.gitignore" || echo "logs/" >> "$ROOT/.gitignore"

BASE_MODEL="${BASE_MODEL:-Qwen/Qwen3-8B}"
FP8_MODEL="${FP8_MODEL:-$ROOT/models/Qwen3-8B-FP8-Dynamic}"
DRAFT_CHECKPOINT="${DRAFT_CHECKPOINT:-$ROOT/outputs/checkpoints/checkpoint_best}"
PORT="${PORT:-8000}"
MAX_MODEL_LEN="${MAX_MODEL_LEN:-2048}"
GPU_MEMORY_UTILIZATION="${GPU_MEMORY_UTILIZATION:-0.90}"
VLLM_BIN="$ROOT/vllm_venv/bin/vllm"
TMUX_SESSION="${TMUX_SESSION:-vllm-serve}"
LOG_DIR="$ROOT/logs"
mkdir -p "$LOG_DIR"

if [ ! -x "$VLLM_BIN" ]; then
  echo "ERROR: $VLLM_BIN not found. Run scripts/setup_envs.sh first."
  exit 1
fi

case "$CONFIG" in
  baseline)
    MODEL="$BASE_MODEL"
    EXTRA_ARGS=()
    ;;
  speculative)
    MODEL="$DRAFT_CHECKPOINT"
    EXTRA_ARGS=()
    ;;
  fp8)
    MODEL="$FP8_MODEL"
    EXTRA_ARGS=()
    ;;
  fp8_speculative)
    # This is the least certain path. If vLLM rejects it, first benchmark fp8 and speculative separately,
    # then inspect the trained checkpoint config and vLLM speculative-decoding arguments.
    MODEL="$DRAFT_CHECKPOINT"
    EXTRA_ARGS=()
    export VLLM_TARGET_MODEL_OVERRIDE="$FP8_MODEL"
    ;;
  *)
    echo "ERROR: unknown config '$CONFIG'"
    echo "Use: baseline | speculative | fp8 | fp8_speculative"
    exit 1
    ;;
esac

if [ "$CONFIG" = "fp8" ] && [ ! -d "$FP8_MODEL" ]; then
  echo "ERROR: FP8 model not found at $FP8_MODEL"
  echo "Run scripts/quantize_fp8.sh first."
  exit 1
fi

if [[ "$CONFIG" == speculative* || "$CONFIG" == fp8_speculative ]]; then
  if [ ! -d "$DRAFT_CHECKPOINT" ]; then
    echo "ERROR: draft checkpoint not found at $DRAFT_CHECKPOINT"
    echo "Run scripts/train_eagle3.sh first."
    exit 1
  fi
fi

if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
  echo "Killing existing tmux session: $TMUX_SESSION"
  tmux kill-session -t "$TMUX_SESSION"
fi

LOG_FILE="$LOG_DIR/vllm_${CONFIG}_$(date +%Y%m%d_%H%M%S).log"

echo "Starting vLLM config: $CONFIG"
echo "Model: $MODEL"
echo "Port:  $PORT"
echo "Log:   $LOG_FILE"

tmux new-session -d -s "$TMUX_SESSION" \
  "cd '$ROOT' && CUDA_VISIBLE_DEVICES='${CUDA_VISIBLE_DEVICES:-0}' '$VLLM_BIN' serve '$MODEL' --port '$PORT' --gpu-memory-utilization '$GPU_MEMORY_UTILIZATION' --max-model-len '$MAX_MODEL_LEN' > '$LOG_FILE' 2>&1"

echo
echo "Waiting for server readiness..."
for i in $(seq 1 120); do
  if curl -fsS "http://localhost:${PORT}/v1/models" >/dev/null 2>&1; then
    echo "vLLM server is ready."
    echo "Attach server session with:"
    echo "  tmux attach -t $TMUX_SESSION"
    echo "Or watch log with:"
    echo "  tail -f $LOG_FILE"
    echo "Now run benchmark, for example:"
    echo "  bash scripts/bench_vllm.sh $CONFIG"
    exit 0
  fi
  sleep 5
done

echo "ERROR: server did not become ready."
echo "Inspect:"
echo "  tail -200 $LOG_FILE"
exit 1
