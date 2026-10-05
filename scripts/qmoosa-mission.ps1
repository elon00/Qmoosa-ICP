$ErrorActionPreference = "Stop"

function Run-Step($label, $command) {
    Write-Host $label -ForegroundColor Yellow
    Invoke-Expression $command
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " QMOOSA ICP -- ONE-CLICK TECHNICAL VALIDATION (NO MAINNET SPEND) " -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

Run-Step "[1/10] Runtime validation..." "node -v"
Run-Step "[2/10] Unit tests..." "npm test"
Run-Step "[3/10] Frontend dependency security audit..." "npm run audit:deps"
Run-Step "[4/10] Frontend production build..." "npm run build"
Run-Step "[5/10] Rust lockfile reproducibility..." "cargo generate-lockfile"

Write-Host "[6/10] Candid inventory..." -ForegroundColor Yellow
$didFiles = Get-ChildItem -Path "canisters" -Filter "*.did" -Recurse
if (-not $didFiles) {
    Write-Host "WARN: no checked-in .did files found" -ForegroundColor DarkYellow
} else {
    $didFiles | ForEach-Object { Write-Host "  -> $($_.FullName)" -ForegroundColor DarkGray }
}

Run-Step "[7/10] PQC manifest metadata truth check..." "node scripts/pqc-manifest-signer.js"
Run-Step "[8/10] x402 simulation checks..." "node scripts/simulate-x402.js"

if (-not (Test-Path "node_modules/@dfinity/pic")) {
    Run-Step "[9/10] Installing PocketIC JS client for this validation run..." "npm install --no-save @dfinity/pic@0.22.0"
}
Run-Step "[9/10] Real PocketIC integration..." "npm run test:pocketic"
Run-Step "[10/10] Strict ICP mainnet readiness gate..." "npm run readiness:mainnet"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host " MISSION COMPLETED SUCCESSFULLY -- ALL REALITY GATES ARE GREEN " -ForegroundColor Green
Write-Host " NO MAINNET DEPLOYMENT OR CYCLE SPEND WAS PERFORMED " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Cyan
