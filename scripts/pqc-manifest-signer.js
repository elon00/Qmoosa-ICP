// PQC manifest metadata audit.
// IMPORTANT: this script does NOT perform ML-DSA signature verification.
import crypto from 'node:crypto';

console.log('--- PQC Manifest Metadata Audit (non-cryptographic) ---');

const expectedGenesisHash = 'e7b6ed5a8efb2f8177b958cb35778621822b94ba78d5eb578747fa591dfc25bc';
const manifest = {
  version: '1.0.0',
  name: 'Qmoosa ICP Core Canisters Genesis Build',
  algorithm: 'NIST FIPS 204 (ML-DSA-65)',
  targetHash: expectedGenesisHash
};

if (!/^[0-9a-f]{64}$/i.test(manifest.targetHash)) {
  console.error('[FAIL] targetHash must be a 32-byte SHA-256 hex digest');
  process.exit(1);
}

const digest = crypto.createHash('sha256').update(manifest.name + ':' + manifest.version).digest('hex');
console.log(`[PASS] Manifest metadata is structurally valid: ${manifest.name}`);
console.log(`Metadata audit digest: ${digest}`);
console.log('NOTICE: ML-DSA verification is NOT implemented by this script and must not be inferred from this PASS.');
