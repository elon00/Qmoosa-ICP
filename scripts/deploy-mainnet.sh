#!/usr/bin/env bash
set -euo pipefail

echo "=== Qmoosa ICP Mainnet Deployment ==="
echo "Running strict no-cycles readiness gate first..."
npm run readiness:mainnet

echo "Readiness gate is GREEN. Verifying ICP network connectivity..."
dfx ping ic

echo "Deploying canisters to ICP mainnet with cycles..."
dfx deploy --network ic token
dfx deploy --network ic dao_governance
dfx deploy --network ic launchpad
dfx deploy --network ic x402_gateway
dfx deploy --network ic agent_orchestrator
dfx deploy --network ic conway_engine
dfx deploy --network ic automation
dfx deploy --network ic pqc
dfx deploy --network ic frontend

echo "=== Mainnet Deployment Successful ==="
for c in token dao_governance launchpad x402_gateway agent_orchestrator conway_engine automation pqc frontend; do
  echo "$c=$(dfx canister id --network ic "$c")"
done
echo "Frontend Mainnet URL: https://$(dfx canister id --network ic frontend).icp0.io"
