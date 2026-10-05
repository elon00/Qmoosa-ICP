import fs from 'node:fs';

const failures = [];
const warnings = [];
const mustExist = [
  'dfx.json',
  'scripts/deploy-mainnet.sh',
  'canisters/pqc/main.mo',
  'frontend/package-lock.json'
];

for (const file of mustExist) {
  if (!fs.existsSync(file)) failures.push(`missing required file: ${file}`);
}

const pqc = fs.readFileSync('canisters/pqc/main.mo', 'utf8');
if (pqc.includes('No in-canister FIPS 204 verifier is integrated')) {
  failures.push('PQC: real in-canister FIPS 204 signature verification is not integrated');
}
if (pqc.includes('verified_manifests=0')) {
  warnings.push('PQC report currently hard-codes zero verified manifests');
}

const pocketicPath = 'tests/pocketic_mock.js';
if (fs.existsSync(pocketicPath)) {
  failures.push('Integration testing: tests/pocketic_mock.js is a simulation, not a real PocketIC execution');
}

const deploymentManifestCandidates = ['canister_ids.json', '.dfx/ic/canister_ids.json', 'deployments/mainnet.json'];
if (!deploymentManifestCandidates.some((p) => fs.existsSync(p))) {
  warnings.push('No Qmoosa mainnet canister-ID manifest is committed (expected before claiming mainnet-live)');
}

const deploy = fs.readFileSync('scripts/deploy-mainnet.sh', 'utf8');
if (!deploy.includes('readiness:mainnet')) {
  failures.push('deploy-mainnet.sh is not protected by the strict no-cycles readiness gate');
}

console.log('=== Qmoosa ICP Mainnet Readiness — NO CYCLES SPENT ===');
for (const w of warnings) console.log(`WARN: ${w}`);
if (failures.length) {
  for (const f of failures) console.error(`BLOCKED: ${f}`);
  console.error(`Mainnet readiness: BLOCKED (${failures.length} blocking gate(s))`);
  process.exit(1);
}
console.log('Mainnet readiness: GREEN');
