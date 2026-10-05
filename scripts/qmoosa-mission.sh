#!/usr/bin/env bash
set -euo pipefail

echo "================================================================="
echo " QMOOSA ICP — ONE-CLICK TECHNICAL VALIDATION (NO MAINNET SPEND) "
echo "================================================================="
echo "[1/8] Runtime validation..."
node -v

echo "[2/8] Unit tests..."
npm test

echo "[3/9] Frontend dependency security audit..."
npm run audit:deps

echo "[4/9] Frontend build..."
npm run build

echo "[5/9] Candid inventory..."
found=0
for did in canisters/*/*.did; do
  [ -e "$did" ] || continue
  found=1
  echo "  -> $did"
done
if [ "$found" -eq 0 ]; then
  echo "WARN: no checked-in .did files found"
fi

echo "[6/9] PQC manifest metadata audit..."
node scripts/pqc-manifest-signer.js

echo "[7/9] x402 simulation checks..."
node scripts/simulate-x402.js

echo "[8/9] Real PocketIC integration..."
npm run test:pocketic

echo "[9/9] Strict ICP mainnet readiness gate..."
npm run readiness:mainnet

echo "================================================================="
echo " QMOOSA ICP — TECHNICAL GATES GREEN; MAINNET PREFLIGHT GREEN "
echo "================================================================="
