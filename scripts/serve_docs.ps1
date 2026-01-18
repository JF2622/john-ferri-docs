# Serve MkDocs locally (Windows PowerShell)
# Usage: .\scripts\serve_docs.ps1

$ErrorActionPreference = "Stop"

# Go to repo root (script may be run from anywhere)
Set-Location (Split-Path -Parent $PSScriptRoot)

# Create venv if missing
if (-Not (Test-Path ".\.venv\Scripts\python.exe")) {
    py -V:3.12 -m venv .venv
}

# Upgrade pip and install dependencies
.\.venv\Scripts\python -m pip install --upgrade pip
.\.venv\Scripts\pip install -r requirements.txt

# Serve docs
.\.venv\Scripts\mkdocs serve
