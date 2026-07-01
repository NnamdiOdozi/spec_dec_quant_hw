#!/usr/bin/env bash
# Quantize Qwen/Qwen3-8B with FP8 dynamic quantization using llmcompressor.
#
# Run after setup_envs.sh:
#   bash scripts/quantize_fp8.sh
#
# Useful overrides:
#   MODEL_ID=Qwen/Qwen3-8B SAVE_DIR=/path/to/Qwen3-8B-FP8-Dynamic bash scripts/quantize_fp8.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

if [ ! -d "$ROOT/.git" ]; then
  echo "ERROR: run this from the cloned project repo."
  echo "Resolved ROOT: $ROOT"
  exit 1
fi

mkdir -p "$ROOT/outputs" "$ROOT/logs" "$ROOT/models"
if [ ! -e "$ROOT/output" ]; then
  ln -s outputs "$ROOT/output"
fi

touch "$ROOT/.gitignore"
grep -qxF "outputs/" "$ROOT/.gitignore" || echo "outputs/" >> "$ROOT/.gitignore"
grep -qxF "output/" "$ROOT/.gitignore" || echo "output/" >> "$ROOT/.gitignore"
grep -qxF "logs/" "$ROOT/.gitignore" || echo "logs/" >> "$ROOT/.gitignore"
grep -qxF "models/" "$ROOT/.gitignore" || echo "models/" >> "$ROOT/.gitignore"

MODEL_ID="${MODEL_ID:-Qwen/Qwen3-8B}"
SAVE_DIR="${SAVE_DIR:-$ROOT/models/Qwen3-8B-FP8-Dynamic}"
COMP_PY="$ROOT/comp_venv/bin/python"
LOG_DIR="$ROOT/logs"
mkdir -p "$LOG_DIR" "$(dirname "$SAVE_DIR")"

LOG_FILE="$LOG_DIR/quantize_fp8_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Logging to: $LOG_FILE"
echo "Model:      $MODEL_ID"
echo "Save dir:   $SAVE_DIR"
echo

if [ ! -x "$COMP_PY" ]; then
  echo "ERROR: $COMP_PY not found. Run scripts/setup_envs.sh first."
  exit 1
fi

MODEL_ID="$MODEL_ID" SAVE_DIR="$SAVE_DIR" "$COMP_PY" - <<'PY'
import json
import os
from pathlib import Path

from transformers import AutoModelForCausalLM, AutoTokenizer
from llmcompressor import oneshot
from llmcompressor.modifiers.quantization import QuantizationModifier

model_id = os.environ["MODEL_ID"]
save_dir = Path(os.environ["SAVE_DIR"])

print(f"Loading model: {model_id}")
model = AutoModelForCausalLM.from_pretrained(
    model_id,
    torch_dtype="auto",
    device_map="auto",
)
tokenizer = AutoTokenizer.from_pretrained(model_id)

print("Applying FP8_DYNAMIC quantization to Linear layers, ignoring lm_head")
recipe = QuantizationModifier(
    targets="Linear",
    scheme="FP8_DYNAMIC",
    ignore=["lm_head"],
)
oneshot(model=model, recipe=recipe)

print(f"Saving quantized model to: {save_dir}")
save_dir.mkdir(parents=True, exist_ok=True)
model.save_pretrained(save_dir)
tokenizer.save_pretrained(save_dir)

config_path = save_dir / "config.json"
if config_path.exists():
    config = json.loads(config_path.read_text())
    print("quantization_config / compression_config excerpt:")
    print(json.dumps(config.get("quantization_config", config.get("compression_config", {})), indent=2)[:4000])
else:
    print("WARNING: config.json not found after save")
PY

echo
echo "=== Quantization complete ==="
echo "Saved model:"
echo "  $SAVE_DIR"
echo "Log file:"
echo "  $LOG_FILE"
echo
echo "Check config:"
echo "  grep -R \"quant\|compression\" -n $SAVE_DIR/config.json"
