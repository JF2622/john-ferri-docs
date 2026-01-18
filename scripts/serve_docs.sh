#!/usr/bin/env bash
set -e

# Serve MkDocs locally (WSL/Linux)
# Usage (from repo root): bash scripts/serve_docs.sh

cd "$(dirname "$0")/.."

# Use a separate venv for WSL to avoid conflicts with Windows .venv
if [ ! -f ".venv-wsl/bin/python" ]; then
  python3 -m venv .venv-wsl
fi

source .venv-wsl/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt

# Bind to 0.0.0.0 so Windows browser can reach it via WSL2 port forwarding
mkdocs serve -a 0.0.0.0:8000
