import fs from 'node:fs';

const failures = [];
const warnings = [];

const required = [
  'dfx.json',
  'Cargo.toml',
  'canisters/pqc/Cargo.toml',
  'canisters/pqc/src/lib.rs',
  'canisters/pqc/pqc.did',
  'tests/pocketic.integration.js',
  'scripts/deploy-mainnet.sh',
  'frontend/package-lock.json'
];

for (const file of required) {
  if (!fs.existsSync(file)) failures.push(`missing required file: ${file}`);
}

if (fs.existsSync('canisters/pqc/src/lib.rs')) {
  const pqc = fs.readFileSync('canisters/pqc/src/lib.rs', 'utf8');
  if (!pqc.includes('fips204') || !pqc.includes('pk.verify')) {
    failures.push('PQC: Rust canister does not contain real FIPS 204 ML-DSA verification');
  }
}

if (fs.existsSync('tests/pocketic.integration.js')) {
  const pic = fs.readFileSync('tests/pocketic.integration.js', 'utf8');
  if (!pic.includes('@dfinity/pic') || !pic.includes('installCode')) {
    failures.push('PocketIC: integration test is not performing real WASM installation');
  }
}

const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
if (pkg.scripts?.['test:pocketic'] !== 'node tests/pocketic.integration.js') {
  failures.push('PocketIC: package script is not wired to the real integration test');
}

const dfx = JSON.parse(fs.readFileSync('dfx.json', 'utf8'));
if (dfx.canisters?.pqc?.type !== 'rust') {
  failures.push('PQC: dfx.json is not configured to build the Rust verifier canister');
}

const deploy = fs.readFileSync('scripts/deploy-mainnet.sh', 'utf8');
if (!deploy.includes('readiness:mainnet')) {
  failures.push('deploy-mainnet.sh is not protected by the strict no-cycles readiness gate');
}

const deploymentManifestCandidates = ['canister_ids.json', '.dfx/ic/canister_ids.json', 'deployments/mainnet.json'];
if (!deploymentManifestCandidates.some((p) => fs.existsSync(p))) {
  warnings.push('No Qmoosa mainnet canister-ID manifest is committed yet; this is expected before first mainnet deployment');
}

console.log('=== Qmoosa ICP Mainnet Readiness — NO CYCLES SPENT ===');
for (const w of warnings) console.log(`WARN: ${w}`);
if (failures.length) {
  for (const f of failures) console.error(`BLOCKED: ${f}`);
  console.error(`Mainnet readiness: BLOCKED (${failures.length} blocking gate(s))`);
  process.exit(1);
}
console.log('Mainnet readiness: GREEN (static preflight)');
