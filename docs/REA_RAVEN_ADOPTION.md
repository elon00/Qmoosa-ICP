# REA + Raven RSI — Controlled Adoption Pilot

Status: **PROPOSED / NOT INSTALLED / NOT DEPLOYED**. This file is an integration policy, not proof of working REA or Raven execution.

## Objective
Evaluate [REA](https://github.com/morluto/rea) (MIT) for authorized static and binary analysis, and [Raven](https://github.com/EverMind-AI/Raven) (pre-alpha; review its license and pinned commit) for sandboxed multi-agent planning and evidence-driven iteration. Neither may override existing ICP security, governance, transaction or release policies.

## Scope
Pilot: `elon00/Qmoosa-ICP` only. Do not propagate to other repositories until the pilot demonstrates measurable benefit, dependency/license compatibility, clean verification, and human-reviewed approval. Exclude forks or imported third-party mirrors; check git provenance and owner history, not repository name alone.

## Phased controls
1. **Inventory** existing dependency manifests, tests, package versions, CI, documentation, and known blockers.
2. **Isolated evaluation**: pin full upstream Git commit SHAs; inspect release signatures, licenses, install scripts and transitive dependencies. No `curl | bash`, auto-upgrade, or privileged unattended installation.
3. **REA use**: analyze only code/binaries owned by the user or otherwise authorized. Default to static inspection. No secret extraction, exploit delivery, external scanning, or privileged application hooks.
4. **Raven use**: orchestrate research/coding agents in an isolated workspace with repository-read and proposal-only permissions. No auto-merge, no network wallet signing, no production secrets, and no access to mainnet keys.
5. **Benchmark** against immutable evaluation cases: build results, vulnerability counts, verified ICP canister execution, real x402 settlement, and genuine FIPS 204 signatures. A failing test must remain failing until corrected.
6. **Review** every patch via GitHub PR; human approval required for CI policy, financial logic, deployment, security controls, or secret-handling changes.
7. **Progressive rollout** only to verified owned AI/crypto/blockchain/quantum/algorithm repos after project-specific fit, no duplicates, and baseline status are recorded.

## Reality-gate contract
Statuses: PASS / FAIL / BLOCKED / NOT_RUN. Do not claim PASS from README assertions, mocked integration, generated JSON flags, local-only emulator tests, or source code presence. Store source revision, test command, timestamp, environment, immutable logs and independently verifiable chain/canister receipts. A report that lacks cryptographic/chain evidence is NOT_RUN or BLOCKED.

ICP production release remains **LOCKED** until real in-canister ML-DSA verification, PocketIC/non-mock integration evidence, genuine canister IDs, security review and explicit owner approval. Passing baseline unit tests is not enough.

## Immediate follow-ups (not yet executed)
- Pin and examine REA and Raven release artifacts in a disposable environment.
- Record existing CI status and tests; compare before/after with unchanged criteria.
- Open separately reviewed implementation PRs for useful project-specific integrations.
- Complete live reality gates without cycles or mainnet expenditure.

## External links
- REA: https://github.com/morluto/rea
- REA documentation: https://rea.tools/guides/
- Raven: https://github.com/EverMind-AI/Raven
- Raven documentation: https://evermind-ai.github.io/Raven/
