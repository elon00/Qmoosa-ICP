import fs from 'node:fs';
import path from 'node:path';
import { PocketIc, PocketIcServer } from '@dfinity/pic';

const canisters = [
  'token',
  'dao_governance',
  'launchpad',
  'x402_gateway',
  'agent_orchestrator',
  'conway_engine',
  'automation',
  'pqc',
];

const server = await PocketIcServer.create();
const pic = await PocketIc.create(server.getUrl());

try {
  for (const name of canisters) {
    const wasm = path.resolve('.dfx/local/canisters', name, `${name}.wasm`);
    if (!fs.existsSync(wasm)) {
      throw new Error(`compiled WASM not found for ${name}: ${wasm}`);
    }
    const canisterId = await pic.createCanister();
    await pic.installCode({ canisterId, wasm });
    console.log(`[PASS] PocketIC installed real compiled WASM: ${name} -> ${canisterId.toText()}`);
  }
  console.log(`PocketIC integration: PASS (${canisters.length} real canister WASMs installed)`);
} finally {
  await pic.tearDown();
  await server.stop();
}
