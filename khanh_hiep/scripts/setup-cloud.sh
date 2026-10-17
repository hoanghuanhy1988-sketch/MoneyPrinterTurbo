#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
test -f uv.lock
if ! command -v uv >/dev/null 2>&1; then
  python3 -m venv storage/khanh-hiep-bootstrap
  storage/khanh-hiep-bootstrap/bin/python -m pip install uv
  UV="$PWD/storage/khanh-hiep-bootstrap/bin/uv"
else
  UV="$(command -v uv)"
fi
"$UV" sync --frozen --python 3.11
if [ ! -f config.toml ]; then
  cp khanh_hiep/config.local.example.toml config.toml
fi
.venv/bin/python -X utf8 khanh_hiep/scripts/smoke.py
