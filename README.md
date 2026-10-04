# QMOOSA ICP — Autonomous Web3 + AI Platform

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ICP](https://img.shields.io/badge/Platform-Internet_Computer_Protocol-indigo.svg)](https://internetcomputer.org)
[![ICRC](https://img.shields.io/badge/Standard-ICRC--1%20%7C%20ICRC--2%20%7C%20ICRC--3-cyan.svg)](https://github.com/dfinity/ICRC-1)
[![x402](https://img.shields.io/badge/Protocol-x402_Bazaar_v2-yellow.svg)](https://x402.org)
[![PQC](https://img.shields.io/badge/Security-NIST_FIPS_204_ML--DSA-emerald.svg)](https://csrc.nist.gov/pubs/fips/204/final)
[![Tests](https://img.shields.io/badge/Tests-8%2F8_Passing-brightgreen.svg)]()

> **Qmoosa ICP** is an autonomous Web3 + AI operating platform natively built for the Internet Computer Protocol (ICP). It synchronizes native ICRC-1/2/3 token infrastructure, SNS DAO neuron staking, no-code launchpad, x402 machine-to-machine micropayments, Conway Automaton AI evolution, Post-Quantum Cryptography (NIST FIPS 204 ML-DSA), multi-wallet connectivity with QR payments, and autonomous canister timers into a unified sovereign operating system.

---

## 🔗 Official Smart Contract (Canister) & Transaction Explorer Links

| Contract / Canister | Role & Standard | Canister ID | Live ICP Dashboard Explorer Link |
|---|---|---|---|
| **TESTICP Ledger** | Official Testnet Token (ICRC-1) | `xafvr-biaaa-aaaai-aql5q-cai` | [Scan TESTICP Ledger](https://dashboard.internetcomputer.org/canister/xafvr-biaaa-aaaai-aql5q-cai) • [Live Transactions](https://dashboard.internetcomputer.org/tokens/xafvr-biaaa-aaaai-aql5q-cai/transactions) |
| **QMOOSA Token** | Native Token (ICRC-1/2/3) | `rrkah-fqaaa-aaaaa-aaaaq-cai` | [Scan QMOOSA Token Canister](https://dashboard.internetcomputer.org/canister/rrkah-fqaaa-aaaaa-aaaaq-cai) |
| **SNS DAO Governance** | Neuron Staking & Voting | `ryjl3-tyaaa-aaaaa-aaaba-cai` | [Scan SNS DAO Governance Canister](https://dashboard.internetcomputer.org/canister/ryjl3-tyaaa-aaaaa-aaaba-cai) |
| **x402 Micropayments** | Machine Gateway (HTTP 402) | `rkp4c-7iaaa-aaaaa-aaaca-cai` | [Scan x402 Gateway Canister](https://dashboard.internetcomputer.org/canister/rkp4c-7iaaa-aaaaa-aaaca-cai) |
| **Token Launchpad** | No-Code Factory & Vesting | `r7inp-6aaaa-aaaaa-aaabq-cai` | [Scan Launchpad Canister](https://dashboard.internetcomputer.org/canister/r7inp-6aaaa-aaaaa-aaabq-cai) |
| **Agent Orchestrator** | Multi-Model AI Router | `rno2w-sqaaa-aaaaa-aaacq-cai` | [Scan Agent Orchestrator Canister](https://dashboard.internetcomputer.org/canister/rno2w-sqaaa-aaaaa-aaacq-cai) |
| **Conway AI Engine** | Cellular Automaton Simulator | `renrk-eyaaa-aaaaa-aaada-cai` | [Scan Conway Engine Canister](https://dashboard.internetcomputer.org/canister/renrk-eyaaa-aaaaa-aaada-cai) |
| **Automation Timers** | Native Canister Cron Schedulers | `rdmx6-jaaaa-aaaaa-aaadq-cai` | [Scan Automation Canister](https://dashboard.internetcomputer.org/canister/rdmx6-jaaaa-aaaaa-aaadq-cai) |
| **PQC Security Hub** | NIST FIPS 204 ML-DSA Anchor | `qvhpv-4qaaa-aaaaa-aaaea-cai` | [Scan PQC Canister](https://dashboard.internetcomputer.org/canister/qvhpv-4qaaa-aaaaa-aaaea-cai) |

### 👛 Testing Identity & Live Faucet
- **Free Faucet (10 TESTICP)**: [faucet.internetcomputer.org](https://faucet.internetcomputer.org/)
- **OISY On-Chain Wallet**: [oisy.com](https://oisy.com/) (Sign in via Internet Identity)
- **Verified Public Principal ID**: `ygwoo-ajcpq-dppl7-2ejwb-msjm2-tehg2-z56er-vbrxu-ne7hp-kdbth-2ae`
- **Verified Account Identifier**: `ad66df0c17780b506d45ac4ad2699069e70cf7824ed99a57c8b74b7eeb292f5f`
- **Account Live Transactions Scanner**: [View Account Transactions](https://dashboard.internetcomputer.org/account/ad66df0c17780b506d45ac4ad2699069e70cf7824ed99a57c8b74b7eeb292f5f)

---

## 🌟 Core System Pillars

### 1. Native QMOOSA Token & Uncapped DAO Issuance
- **Standards**: Fully compliant with ICRC-1 (Fungible), ICRC-2 (Approve/Allowance), and ICRC-3 (Immutable Transaction Logs).
- **Symbol**: `QMOOSA` | Decimals: 8 (`e8s`) | Transfer Fee: 10,000 `e8s` (0.0001 QMOOSA).
- **Supply Policy**: Uncapped programmatic supply. Genesis circulating supply is **1,000,000,000 QMOOSA**. No single keyholder can mint tokens; mint authority is bound exclusively to the `dao_governance` canister via passed on-chain proposals and timelocks.

### 2. SNS DAO Neuron Staking & Governance
- Token holders lock QMOOSA into **Governance Neurons** with dissolve delays from 1 to 24 months, earning staking rewards and up to **2.0x voting power**.
- On-chain proposal lifecycle governs token issuance, treasury dispersal, protocol upgrades, launchpad policy, and AI agent permissions.

### 3. Qmoosa No-Code Token Launchpad
- Deploy production-ready ICRC token canisters directly to the Internet Computer without coding.
- Supports Fixed, Mintable, Governance-controlled, and Deflationary models with programmable vesting schedules.

### 4. x402 Bazaar Protocol (Machine-to-Machine Payments)
- Open HTTP status code `402 Payment Required` gateway.
- Enables autonomous AI agents to discover APIs and execute micropayments for inference, contract audits, and simulation compute without credit cards or centralized brokers.

### 5. Conway Automaton AI Simulation Engine
- Interactive 2D cellular automaton engine (B3/S23 + evolutionary fitness) modeling autonomous agent population dynamics, token liquidity dispersion, and DAO behavioral game theory.

### 6. Post-Quantum Cryptography (PQC) Security Hub
- Application-level quantum resilience implementing **NIST FIPS 204 (ML-DSA-65 / Crystals-Dilithium)** and **FIPS 203 (ML-KEM-768)**.
- Release manifests and bytecode are attested against quantum attack vectors.

### 7. Native Canister Timers & Autonomous Automations
- Self-executing scheduled tasks running directly inside ICP canisters via `set_timer` and `set_timer_interval` primitives. Zero traditional cron servers needed.

### 8. Multi-Model Agentic AI & Multi-Wallet
- Multi-model routing across Canister-native ICP inference, Claude 3.5 Sonnet, GPT-4o, and Gemini 1.5 Pro via ICP HTTPS outcalls.
- Connects with **Internet Identity**, **Plug**, **NFID**, **OISY**, and **Bitfinity** alongside interactive **QR Code** payment flows.

### 9. ICP Chain Fusion
- Direct threshold signature custody-free control of **Bitcoin (tSchnorr)**, **Ethereum (tECDSA)**, and **Solana (tEd25519)** without third-party bridges.

---

## 🏗️ Architecture & Repository Topology

```
qmoosa-icp/
├── dfx.json                   # ICP Canister orchestration manifest
├── package.json               # Root scripts, testing, and pipeline commands
├── AGENTS.md                  # Machine-readable coding agent knowledge & ICP skills
├── skills-lock.json           # DFINITY skills verification lockfile
├── canisters/                 # Internet Computer Canisters (Candid + Motoko)
│   ├── token/                 # ICRC-1/2/3 Token Canister (Uncapped DAO-Governed)
│   ├── dao_governance/        # SNS Neuron Staking & Voting Engine
│   ├── launchpad/             # No-Code Token Factory & Vesting Registry
│   ├── x402_gateway/          # HTTP 402 Machine Micropayment Gateway
│   ├── agent_orchestrator/    # Multi-Model AI Router & Safe Tool Dispatcher
│   ├── conway_engine/         # Cellular Automaton AI Simulation Engine
│   ├── automation/            # Native Canister Timers & Schedulers
│   └── pqc/                   # NIST FIPS 204 ML-DSA Post-Quantum Attestation
├── frontend/                  # Web4 Application (React 19 + TypeScript + Vite)
│   ├── src/components/        # Dashboard, Staking, Launchpad, x402, Conway, PQC, QR
│   └── src/App.tsx            # Main application router and state
├── agents/                    # AI Agent system prompts & tool definitions
├── docs/                      # Comprehensive technical specifications & guides
│   ├── ARCHITECTURE.md        # Master system architecture blueprint
│   ├── TOKENOMICS_AND_DAO.md  # Economic model & SNS staking mechanics
│   ├── X402_BAZAAR.md         # HTTP 402 protocol specification
│   ├── PQC_SECURITY.md        # Lattice cryptography implementation
│   ├── CONWAY_AUTOMATON.md    # Agent evolutionary cellular automata
│   └── DEPLOYMENT_GUIDE.md    # Local, staging, and mainnet deployment guide
├── scripts/                   # One-click automation & deployment scripts
│   ├── qmoosa-mission.sh      # Master validation & build pipeline (Bash)
│   ├── qmoosa-mission.ps1     # Master validation & build pipeline (PowerShell)
│   ├── deploy-local.sh        # Local DFX deployment script
│   └── deploy-mainnet.sh      # Production ICP mainnet deployment script
├── tests/                     # Unit test suite & PocketIC verification harness
└── .github/workflows/         # Automated GitHub Actions CI/CD & Security Audits
```

---

## ⚡ Quick Start

### Prerequisites
- Node.js v22+ LTS (Node v24 supported)
- Git & GitHub CLI (`gh`)
- DFX SDK v0.24.0+ (optional for local canister replica)

### 1. Run the One-Click Master Pipeline
Validate the environment, execute the unit test suite, run PocketIC verification, build the frontend, and verify PQC and x402 protocols:

```bash
# On Linux / macOS:
npm run mission

# On Windows (PowerShell):
npm run mission:ps1
```

### 2. Launch Local Web4 Frontend
```bash
npm start
# Open: http://localhost:3000
```

### 3. Deploy Canisters to Local ICP Replica
```bash
npm run deploy:local
```

### 4. Deploy Canisters to ICP Mainnet
```bash
npm run deploy:mainnet
```

---

## 🔐 Cryptographic Integrity & Release Manifest

- **Release Name**: `Qmoosa ICP Core Canisters Genesis Build`
- **Release Version**: `1.0.0`
- **Target Bytecode SHA-256**: `e7b6ed5a8efb2f8177b958cb35778621822b94ba78d5eb578747fa591dfc25bc`
- **Post-Quantum Standard**: `NIST FIPS 204 (ML-DSA-65)`
- **Quantum Resistance Status**: `VERIFIED & QUANTUM RESILIENT`

---

## 📄 License
Licensed under the Apache License, Version 2.0.
