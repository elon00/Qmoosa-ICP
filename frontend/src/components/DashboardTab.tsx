import React from 'react';
import { 
  Coins, 
  Vote, 
  Rocket, 
  Zap, 
  Cpu, 
  ShieldCheck, 
  ArrowUpRight, 
  Clock, 
  Network,
  Sparkles,
  Server
} from 'lucide-react';
import { TabType } from '../types';

interface DashboardTabProps {
  onNavigate: (tab: TabType) => void;
  onOpenQR: () => void;
}

export const DashboardTab: React.FC<DashboardTabProps> = ({ onNavigate, onOpenQR }) => {
  const canisters = [
    { name: 'token', type: 'ICRC-1/2/3', id: 'rrkah-fqaaa-aaaaa-aaaaq-cai', cycles: '4.88 T', status: 'Healthy' },
    { name: 'dao_governance', type: 'SNS Neuron Staking', id: 'ryjl3-tyaaa-aaaaa-aaaba-cai', cycles: '4.75 T', status: 'Healthy' },
    { name: 'launchpad', type: 'Token Factory', id: 'r7inp-6aaaa-aaaaa-aaabq-cai', cycles: '4.91 T', status: 'Healthy' },
    { name: 'x402_gateway', type: 'HTTP 402 Micropayments', id: 'rkp4c-7iaaa-aaaaa-aaaca-cai', cycles: '4.62 T', status: 'Healthy' },
    { name: 'agent_orchestrator', type: 'Multi-Model Router', id: 'rno2w-sqaaa-aaaaa-aaacq-cai', cycles: '4.80 T', status: 'Healthy' },
    { name: 'conway_engine', type: 'Cellular Automaton AI', id: 'renrk-eyaaa-aaaaa-aaada-cai', cycles: '4.95 T', status: 'Healthy' },
    { name: 'automation', type: 'Native Canister Timers', id: 'rdmx6-jaaaa-aaaaa-aaadq-cai', cycles: '4.70 T', status: 'Healthy' },
    { name: 'pqc', type: 'NIST FIPS 204 ML-DSA', id: 'qvhpv-4qaaa-aaaaa-aaaea-cai', cycles: '4.85 T', status: 'Healthy' },
  ];

  return (
    <div className="space-y-6">
      {/* Hero Banner */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-indigo-950 via-slate-900 to-slate-950 border border-indigo-500/30 p-6 lg:p-8 shadow-2xl">
        <div className="absolute top-0 right-0 -mr-16 -mt-16 w-80 h-80 rounded-full bg-cyan-500/10 blur-3xl pointer-events-none" />
        <div className="relative z-10 flex flex-col lg:flex-row items-start lg:items-center justify-between gap-6">
          <div className="max-w-2xl">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/20 border border-indigo-400/30 text-indigo-300 text-xs font-mono mb-3">
              <Sparkles className="w-3.5 h-3.5 text-cyan-300" />
              <span>Full-Stack Autonomous Web3 + AI Architecture</span>
            </div>
            <h1 className="text-3xl lg:text-4xl font-extrabold text-white tracking-tight">
              Qmoosa ICP Autonomous Operating Platform
            </h1>
            <p className="mt-2 text-sm text-slate-300 leading-relaxed">
              Synchronizing ICRC-1/2/3 tokenomics, SNS DAO neuron staking, no-code launchpad, x402 machine micropayments, Conway Automaton AI, post-quantum security (ML-DSA/ML-KEM), and native canister timers on the Internet Computer.
            </p>
          </div>

          <div className="flex flex-wrap gap-3">
            <button
              onClick={() => onNavigate('token_dao')}
              className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-mono font-bold shadow-lg shadow-indigo-600/30 transition-all"
            >
              <Coins className="w-4 h-4" />
              <span>Stake QMOOSA</span>
            </button>
            <button
              onClick={() => onNavigate('launchpad')}
              className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-cyan-600 hover:bg-cyan-500 text-white text-xs font-mono font-bold shadow-lg shadow-cyan-600/30 transition-all"
            >
              <Rocket className="w-4 h-4" />
              <span>Launchpad</span>
            </button>
            <button
              onClick={onOpenQR}
              className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-mono font-bold border border-slate-700 transition-all"
            >
              <span>Instant QR Pay</span>
              <ArrowUpRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* 4 Primary System Telemetry Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Token Metric */}
        <div className="glass-card rounded-xl p-5 border border-slate-800/80">
          <div className="flex items-center justify-between text-slate-400 mb-2">
            <span className="text-xs font-mono uppercase">QMOOSA Supply</span>
            <Coins className="w-4 h-4 text-indigo-400" />
          </div>
          <div className="text-2xl font-bold font-mono text-white">1,000,000,000</div>
          <div className="text-xs text-indigo-300 font-mono mt-1 flex items-center gap-1">
            <span>Model: Uncapped DAO-Controlled</span>
          </div>
        </div>

        {/* Staking & Governance */}
        <div className="glass-card rounded-xl p-5 border border-slate-800/80">
          <div className="flex items-center justify-between text-slate-400 mb-2">
            <span className="text-xs font-mono uppercase">SNS Staked in Neurons</span>
            <Vote className="w-4 h-4 text-cyan-400" />
          </div>
          <div className="text-2xl font-bold font-mono text-white">245,000,000</div>
          <div className="text-xs text-emerald-400 font-mono mt-1 flex items-center gap-1">
            <span>24.5% Circulating Locked in DAO</span>
          </div>
        </div>

        {/* x402 Micropayments */}
        <div className="glass-card rounded-xl p-5 border border-slate-800/80">
          <div className="flex items-center justify-between text-slate-400 mb-2">
            <span className="text-xs font-mono uppercase">x402 Micropayments</span>
            <Zap className="w-4 h-4 text-yellow-400" />
          </div>
          <div className="text-2xl font-bold font-mono text-white">14,290 txs</div>
          <div className="text-xs text-cyan-300 font-mono mt-1 flex items-center gap-1">
            <span>Machine-to-Machine HTTP 402</span>
          </div>
        </div>

        {/* PQC Security */}
        <div className="glass-card rounded-xl p-5 border border-slate-800/80">
          <div className="flex items-center justify-between text-slate-400 mb-2">
            <span className="text-xs font-mono uppercase">PQC Quantum Security</span>
            <ShieldCheck className="w-4 h-4 text-emerald-400" />
          </div>
          <div className="text-xl font-bold font-mono text-emerald-400">FIPS 204 ML-DSA</div>
          <div className="text-xs text-slate-400 font-mono mt-1 flex items-center gap-1">
            <span>Release Bytecode Attested</span>
          </div>
        </div>
      </div>

      {/* Canister Status Grid */}
      <div className="glass-card rounded-xl p-6 border border-slate-800">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-2">
            <Server className="w-5 h-5 text-indigo-400" />
            <h2 className="text-base font-bold text-white font-mono">Synchronized ICP Canisters Topology</h2>
          </div>
          <span className="text-xs text-emerald-400 font-mono bg-emerald-950/60 border border-emerald-800 px-2 py-0.5 rounded-full">
            All 8 Canisters Synchronized
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
          {canisters.map((c) => (
            <div key={c.name} className="bg-slate-950/80 border border-slate-800/90 rounded-lg p-3 hover:border-indigo-500/40 transition-colors">
              <div className="flex items-center justify-between">
                <span className="font-mono text-xs font-bold text-white">{c.name}</span>
                <span className="text-[10px] font-mono text-emerald-400 bg-emerald-900/40 px-1.5 py-0.5 rounded">
                  {c.status}
                </span>
              </div>
              <div className="text-[11px] text-slate-400 mt-1">{c.type}</div>
              <div className="text-[10px] font-mono text-slate-500 mt-2 truncate">ID: {c.id}</div>
              <div className="text-[10px] font-mono text-cyan-400 mt-0.5">Cycles: {c.cycles}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
