#!/usr/bin/env bash
set -euo pipefail

echo "================================================================="
echo " QMOOSA ICP — ONE-CLICK TECHNICAL VALIDATION (NO MAINNET SPEND) "
echo "================================================================="
echo "[1/8] Runtime validation..."
node -v

echo "[2/8] Unit tests..."
npm test

echo "[3/8] Frontend dependency security audit..."
npm run audit:deps

echo "[4/8] Frontend build..."
npm run build

echo "[5/8] Candid inventory..."
found=0
for did in canisters/*/*.did; do
  [ -e "$did" ] || continue
  found=1
  echo "  -> $did"
done
if [ "$found" -eq 0 ]; then
  echo "WARN: no checked-in .did files found"
fi

echo "[6/8] PQC manifest metadata audit..."
node scripts/pqc-manifest-signer.js

echo "[7/8] x402 simulation checks..."
node scripts/simulate-x402.js

echo "[8/8] Strict ICP mainnet readiness gate..."
npm run readiness:mainnet

echo "================================================================="
echo " QMOOSA ICP — TECHNICAL GATES GREEN; MAINNET PREFLIGHT GREEN "
echo "================================================================="
