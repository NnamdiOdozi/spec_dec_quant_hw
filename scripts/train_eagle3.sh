#!/usr/bin/env bash
# Train EAGLE-3 draft head using precomputed hidden states.
#
# Run after prepare_eagle_data.sh:
#   bash scripts/train_eagle3.sh
#
# Useful overrides:
#   EPOCHS=5 TRAIN_SEQ_LEN=2048 LR=1e-4 bash scripts/train_eagle3.sh

set -euo pipefail

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

MODEL_ID="${MODEL_ID:-Qwen/Qwen3-8B}"
DATA_DIR="${DATA_DIR:-$ROOT/outputs/eagle3_qwen3_8b_sharegpt}"
HIDDEN_STATES_DIR="${HIDDEN_STATES_DIR:-$DATA_DIR/hidden_states}"
CHECKPOINT_DIR="${CHECKPOINT_DIR:-$ROOT/outputs/checkpoints}"
EPOCHS="${EPOCHS:-5}"
LR="${LR:-1e-4}"
TRAIN_SEQ_LEN="${TRAIN_SEQ_LEN:-2048}"
DRAFT_VOCAB_SIZE="${DRAFT_VOCAB_SIZE:-32000}"

SPEC_DIR="$ROOT/external/speculators"
SPEC_PY="$ROOT/speculators_venv/bin/python"
LOG_DIR="$ROOT/logs"
mkdir -p "$LOG_DIR" "$CHECKPOINT_DIR"

LOG_FILE="$LOG_DIR/train_eagle3_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Logging to:    $LOG_FILE"
echo "Model:         $MODEL_ID"
echo "Data dir:      $DATA_DIR"
echo "Hidden states: $HIDDEN_STATES_DIR"
echo "Checkpoints:   $CHECKPOINT_DIR"
echo "Epochs:        $EPOCHS"
echo "Train seq len: $TRAIN_SEQ_LEN"
echo

if [ ! -d "$SPEC_DIR" ]; then
  echo "ERROR: $SPEC_DIR not found. Run scripts/setup_envs.sh first."
  exit 1
fi

if [ ! -x "$SPEC_PY" ]; then
  echo "ERROR: $SPEC_PY not found. Run scripts/setup_envs.sh first."
  exit 1
fi

if [ ! -d "$HIDDEN_STATES_DIR" ]; then
  echo "ERROR: hidden states not found at $HIDDEN_STATES_DIR"
  echo "Run scripts/prepare_eagle_data.sh first."
  exit 1
fi

echo "=== Train EAGLE-3 draft head ==="
cd "$SPEC_DIR"
"$SPEC_PY" scripts/train.py \
  --verifier-name-or-path "$MODEL_ID" \
  --data-path "$DATA_DIR" \
  --hidden-states-path "$HIDDEN_STATES_DIR" \
  --save-path "$CHECKPOINT_DIR" \
  --draft-vocab-size "$DRAFT_VOCAB_SIZE" \
  --epochs "$EPOCHS" \
  --lr "$LR" \
  --total-seq-len "$TRAIN_SEQ_LEN" \
  --on-missing raise

echo
echo "=== Training complete ==="
echo "Checkpoints:"
ls -lah "$CHECKPOINT_DIR" || true
echo
echo "Best checkpoint should be at:"
echo "  $CHECKPOINT_DIR/checkpoint_best"
echo "Compatibility path also works if output -> outputs symlink exists:"
echo "  $ROOT/output/checkpoints/checkpoint_best"
echo "Log file:"
echo "  $LOG_FILE"
