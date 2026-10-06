#!/usr/bin/env bash
set -euo pipefail

echo "=== Qmoosa Safe Self-Healing ==="
echo "Scope: reproducibility/tooling repairs only. No mainnet deployment. No cycle spend."

changed=0

if [ -f Cargo.toml ]; then
  echo "[heal] Regenerating Cargo.lock..."
  cargo generate-lockfile
  if ! git diff --quiet -- Cargo.lock 2>/dev/null; then
    changed=1
  fi
fi

if [ -f frontend/package-lock.json ]; then
  echo "[heal] Reinstalling frontend dependencies from lockfile..."
  npm --prefix frontend ci
fi

echo "[heal] Re-running zero-spend technical mission..."
npm test
npm run audit:deps
npm run build

echo "[heal] Static mainnet readiness..."
npm run readiness:mainnet

if [ "$changed" -eq 1 ]; then
  echo "SELF_HEAL_CHANGED=1"
else
  echo "SELF_HEAL_CHANGED=0"
fi

echo "Self-healing pass completed without masking failures."
