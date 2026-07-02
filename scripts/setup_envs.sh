#!/usr/bin/env bash
# Project-specific environment setup for speculative decoding + quantization homework.
#
# This script must be run from the cloned repo copy:
#   bash scripts/setup_envs.sh
#
# It must NOT be run as /tmp/setup_envs.sh, because it resolves the project root
# from its own location.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT"



if [ ! -d "$ROOT/.git" ]; then
  echo "ERROR: setup_envs.sh must be run from inside the cloned project repo."
  echo "Resolved ROOT was: $ROOT"
  echo
  echo "This usually means you ran a copied /tmp/setup_envs.sh instead of:"
  echo "  <repo>/scripts/setup_envs.sh"
  exit 1
fi

case "$ROOT" in
  /tmp|/tmp/*|/)
    echo "ERROR: Refusing to use unsafe project root: $ROOT"
    echo "Run the repo copy instead:"
    echo "  cd <repo>"
    echo "  bash scripts/setup_envs.sh"
    exit 1
    ;;
esac

echo "=== Project environment setup ==="
echo "Project root: $ROOT"
echo

LOG_DIR="$ROOT/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/setup_envs_$(date +%Y%m%d_%H%M%S).log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "Logging to: $LOG_FILE"

export PATH="$HOME/.local/bin:$PATH"

if [ -f "$HOME/.local/bin/env" ]; then
  # shellcheck disable=SC1090
  source "$HOME/.local/bin/env"
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "ERROR: uv not found. setup_gpu.sh should install uv first."
  exit 1
fi

echo "=== uv version ==="
uv --version
echo

echo "=== Ensure Python 3.12 is available ==="
uv python install 3.12

echo "=== Create project folders ==="
mkdir -p \
  "$ROOT/envs/speculators" \
  "$ROOT/envs/vllm" \
  "$ROOT/envs/compressor" \
  "$ROOT/external" \
  "$ROOT/scripts" \
  "$ROOT/outputs"

echo "=== Ensure .gitignore contains generated folders ==="
touch "$ROOT/.gitignore"

add_gitignore_line() {
  local line="$1"
  grep -qxF "$line" "$ROOT/.gitignore" || echo "$line" >> "$ROOT/.gitignore"
}

add_gitignore_line "speculators_venv/"
add_gitignore_line "vllm_venv/"
add_gitignore_line "comp_venv/"
add_gitignore_line "external/"
add_gitignore_line ".venv/"

echo "=== Fetch Speculators repo at v0.5.0 ==="
SPEC_DIR="$ROOT/external/speculators"

if [ -d "$SPEC_DIR/.git" ]; then
  cd "$SPEC_DIR"
  git fetch --tags
  git checkout v0.5.0
else
  git clone --branch v0.5.0 https://github.com/vllm-project/speculators "$SPEC_DIR"
fi

cd "$ROOT"

echo "=== Write env pyproject files if missing ==="

if [ ! -f "$ROOT/envs/speculators/pyproject.toml" ]; then
  cat > "$ROOT/envs/speculators/pyproject.toml" <<'EOF'
[project]
name = "hw3-speculators-env"
version = "0.1.0"
requires-python = ">=3.12,<3.13"
dependencies = [
  "speculators",
  "ipykernel",
  "datasets",
  "transformers",
  "accelerate",
]

[tool.uv]
package = false

[tool.uv.sources]
speculators = { path = "../../external/speculators", editable = true }
EOF
else
  echo "Keeping existing envs/speculators/pyproject.toml"
fi

if [ ! -f "$ROOT/envs/vllm/pyproject.toml" ]; then
  cat > "$ROOT/envs/vllm/pyproject.toml" <<'EOF'
[project]
name = "hw3-vllm-env"
version = "0.1.0"
requires-python = ">=3.12,<3.13"
dependencies = [
  "vllm==0.20.0",
  "fastapi<0.137",
  "ipykernel",
]

[tool.uv]
package = false
EOF
else
  echo "Keeping existing envs/vllm/pyproject.toml"
fi

if [ ! -f "$ROOT/envs/compressor/pyproject.toml" ]; then
  cat > "$ROOT/envs/compressor/pyproject.toml" <<'EOF'
[project]
name = "hw3-compressor-env"
version = "0.1.0"
requires-python = ">=3.12,<3.13"
dependencies = [
  "llmcompressor==0.12.0",
  "ipykernel",
  "transformers",
  "accelerate",
]

[tool.uv]
package = false
EOF
else
  echo "Keeping existing envs/compressor/pyproject.toml"
fi

echo
echo "=== Sync speculators environment ==="
cd "$ROOT/envs/speculators"
UV_PROJECT_ENVIRONMENT="$ROOT/speculators_venv" uv sync

echo
echo "=== Sync vLLM environment ==="
cd "$ROOT/envs/vllm"
UV_PROJECT_ENVIRONMENT="$ROOT/vllm_venv" uv sync

echo
echo "=== Sync compressor environment ==="
cd "$ROOT/envs/compressor"
UV_PROJECT_ENVIRONMENT="$ROOT/comp_venv" uv sync

cd "$ROOT"

echo
echo "=== Verify environments ==="

echo "Speculators Python:"
"$ROOT/speculators_venv/bin/python" -c "import sys; print(sys.executable)"

echo "Speculators distribution:"
"$ROOT/speculators_venv/bin/python" -c "import importlib.metadata as md; print(md.version('speculators'))"

echo "vLLM version:"
"$ROOT/vllm_venv/bin/python" -c "import vllm; print(vllm.__version__)"

echo "llmcompressor version:"
"$ROOT/comp_venv/bin/python" -c "import llmcompressor; print(llmcompressor.__version__)"

echo "Torch CUDA visibility from vLLM env:"
"$ROOT/vllm_venv/bin/python" -c "import torch; print('torch:', torch.__version__); print('cuda available:', torch.cuda.is_available()); print('device count:', torch.cuda.device_count())" || true

echo
echo "=== Save environment fingerprints ==="

VIRTUAL_ENV="$ROOT/speculators_venv" uv pip freeze > "$ROOT/outputs/env_speculators_freeze.txt"
VIRTUAL_ENV="$ROOT/vllm_venv" uv pip freeze > "$ROOT/outputs/env_vllm_freeze.txt"
VIRTUAL_ENV="$ROOT/comp_venv" uv pip freeze > "$ROOT/outputs/env_compressor_freeze.txt"

{
  echo "speculators_venv:"
  "$ROOT/speculators_venv/bin/python" --version
  "$ROOT/speculators_venv/bin/python" -c "import sys; print(sys.executable)"
  echo

  echo "vllm_venv:"
  "$ROOT/vllm_venv/bin/python" --version
  "$ROOT/vllm_venv/bin/python" -c "import sys; print(sys.executable)"
  echo

  echo "comp_venv:"
  "$ROOT/comp_venv/bin/python" --version
  "$ROOT/comp_venv/bin/python" -c "import sys; print(sys.executable)"
} > "$ROOT/outputs/python_versions.txt"

if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi > "$ROOT/outputs/nvidia_smi.txt"
else
  echo "nvidia-smi not found" > "$ROOT/outputs/nvidia_smi.txt"
fi

git rev-parse HEAD > "$ROOT/outputs/git_commit.txt" || true
df -h > "$ROOT/outputs/disk_space.txt" || true

echo
echo "=== Environment setup complete ==="
echo
echo "Virtual environments:"
echo "  $ROOT/speculators_venv"
echo "  $ROOT/vllm_venv"
echo "  $ROOT/comp_venv"
echo
echo "Fingerprints saved in:"
echo "  $ROOT/outputs/"
echo
echo "Useful checks:"
echo "  $ROOT/speculators_venv/bin/python -c \"import importlib.metadata as md; print(md.version('speculators'))\""
echo "  $ROOT/vllm_venv/bin/python -c \"import vllm; print(vllm.__version__)\""
echo "  $ROOT/comp_venv/bin/python -c \"import llmcompressor; print(llmcompressor.__version__)\""