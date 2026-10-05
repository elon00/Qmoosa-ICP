# Qmoosa ICP Mission Design — Genuine Green Before Mainnet

## Objective

The mission is complete only when the repository proves, through executable checks, that all technical layers required for a safe ICP deployment are green. Mainnet deployment is intentionally excluded from the validation mission because it spends cycles. The mainnet script remains locked behind the same readiness gate.

## Single-Click Entry Points

- Linux/macOS: `npm run mission`
- Windows PowerShell: `npm run mission:ps1`
- GitHub Actions: **Qmoosa Reality-Gated Mission** → Run workflow

## Gate Architecture

1. Runtime gate — Node and toolchain availability.
2. Unit-test gate — repository logic tests must pass.
3. Dependency gate — frontend install is reproducible and high-severity npm audit is clean.
4. Frontend build gate — TypeScript and Vite production build must succeed.
5. Rust reproducibility gate — Cargo.lock is generated before DFX performs its locked build.
6. Canister compile gate — every configured Motoko/Rust canister must compile through DFX.
7. PQC truth gate — ML-DSA-65 verification must be implemented in the Rust canister; metadata checks must not claim cryptographic verification.
8. PocketIC gate — compiled WASM must install in a real PocketIC environment; static/mock success is not accepted.
9. x402 gate — payment-flow simulation must pass.
10. Mainnet preflight gate — static deployment readiness checks must pass without spending cycles.

## Mainnet Safety Lock

`scripts/deploy-mainnet.sh` must always execute `npm run readiness:mainnet` before `dfx deploy --network ic`.

If any reality gate fails:
- deployment stops;
- no cycle-spending command is executed;
- the failure remains visible in GitHub Actions;
- the mission must not be described as completed.

## Definition of Done

The repository may print:

`MISSION COMPLETED SUCCESSFULLY — ALL REALITY GATES ARE GREEN`

only when the **Qmoosa Reality-Gated Mission** workflow completes successfully on the current main branch commit.

That marker means **technical preflight completed**, not **mainnet deployed**.

Mainnet-live status requires a separate controlled deployment plus:
1. successful `dfx deploy --network ic`,
2. captured Qmoosa canister IDs,
3. committed deployment manifest,
4. independent verification on ICP Dashboard.

## Current Policy

No ICP mainnet cycles should be spent until all zero-spend technical gates are genuinely green.
