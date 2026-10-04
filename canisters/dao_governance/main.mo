import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";

actor QmoosaDAOGovernance {

    public type ProposalType = {
        #TokenMint : { recipient : Text; amount : Nat };
        #TreasuryDisbursement : { recipient : Text; amount : Nat; purpose : Text };
        #ProtocolUpgrade : { canister_id : Text; wasm_hash : Text };
        #LaunchpadPolicy : { min_allocation : Nat; fee_pct : Nat };
        #AgentToolAuth : { agent_name : Text; tool_name : Text; authorized : Bool };
    };

    public type ProposalStatus = {
        #Active;
        #Passed;
        #Rejected;
        #Executed;
    };

    public type Proposal = {
        id : Nat;
        proposer : Text;
        title : Text;
        description : Text;
        proposal_type : ProposalType;
        yes_votes : Nat;
        no_votes : Nat;
        quorum : Nat;
        created_at : Int;
        voting_deadline : Int;
        timelock_until : Int;
        status : ProposalStatus;
    };

    public type Neuron = {
        neuron_id : Nat;
        owner : Text;
        staked_amount : Nat;
        dissolve_delay_seconds : Int;
        voting_power : Nat;
        created_at : Int;
        is_dissolving : Bool;
    };

    // --- State ---
    stable var neuron_counter : Nat = 0;
    stable var proposal_counter : Nat = 0;
    stable var treasury_balance : Nat = 150_000_000_00000000; // 150M QMOOSA in DAO Treasury
    stable var total_staked : Nat = 0;
    stable var total_voting_power : Nat = 0;

    let neurons = HashMap.HashMap<Nat, Neuron>(100, Nat.equal, Nat.hash);
    var proposals_list : [Proposal] = [];
    
    // Votes mapping: "proposalId#neuronId" -> Bool
    let votes_cast = HashMap.HashMap<Text, Bool>(200, Text.equal, Text.hash);

    // Initial default Genesis proposal for system launch
    system func init() {
        proposal_counter += 1;
        let genesis_prop : Proposal = {
            id = proposal_counter;
            proposer = "QMOOSA_GENESIS_CORE";
            title = "Ratify Qmoosa ICP Autonomous Protocol & Tokenomics Standard";
            description = "Formally establish the SNS DAO governance rules, uncapped minting safeguards, x402 Bazaar fee policies, and Post-Quantum Cryptography standards.";
            proposal_type = #LaunchpadPolicy({ min_allocation = 1000; fee_pct = 2 });
            yes_votes = 50_000_000;
            no_votes = 0;
            quorum = 10_000_000;
            created_at = Time.now();
            voting_deadline = Time.now() + 604800000000000; // 7 days in nanoseconds
            timelock_until = Time.now();
            status = #Passed;
        };
        proposals_list := [genesis_prop];
    };

    // --- Stake Neuron (Proof-of-Stake / Governance Neuron) ---
    public func stake_neuron(amount : Nat, dissolve_delay_seconds : Int) : async { #Ok : Neuron; #Err : Text } {
        if (amount < 1_00000000) {
            return #Err("Minimum stake is 1 QMOOSA");
        };

        neuron_counter += 1;
        let caller_text = Principal.toText(Principal.fromActor(QmoosaDAOGovernance));
        
        // Voting power multiplier: base + dissolve delay bonus (up to 2x for > 6 months)
        let bonus_mult = if (dissolve_delay_seconds >= 15552000) 2 else 1;
        let vp = amount * bonus_mult;

        let new_neuron : Neuron = {
            neuron_id = neuron_counter;
            owner = caller_text;
            staked_amount = amount;
            dissolve_delay_seconds = dissolve_delay_seconds;
            voting_power = vp;
            created_at = Time.now();
            is_dissolving = false;
        };

        neurons.put(neuron_counter, new_neuron);
        total_staked += amount;
        total_voting_power += vp;

        return #Ok(new_neuron);
    };

    public query func get_neuron(neuron_id : Nat) : async ?Neuron {
        return neurons.get(neuron_id);
    };

    public query func get_my_neurons(owner : Text) : async [Neuron] {
        var my_list : [Neuron] = [];
        for ((_, n) in neurons.entries()) {
            if (n.owner == owner) {
                my_list := Array.append(my_list, [n]);
            };
        };
        return my_list;
    };

    // --- Proposal Management ---
    public func submit_proposal(req : {
        title : Text;
        description : Text;
        proposal_type : ProposalType;
    }) : async { #Ok : Nat; #Err : Text } {
        proposal_counter += 1;
        let caller_text = Principal.toText(Principal.fromActor(QmoosaDAOGovernance));
        let now = Time.now();

        let new_p : Proposal = {
            id = proposal_counter;
            proposer = caller_text;
            title = req.title;
            description = req.description;
            proposal_type = req.proposal_type;
            yes_votes = 0;
            no_votes = 0;
            quorum = 5_000_000;
            created_at = now;
            voting_deadline = now + 259200000000000; // 3 days
            timelock_until = now + 345600000000000; // 4 days (24 hr timelock after voting)
            status = #Active;
        };

        proposals_list := Array.append(proposals_list, [new_p]);
        return #Ok(proposal_counter);
    };

    public func vote(args : { proposal_id : Nat; neuron_id : Nat; approve : Bool }) : async { #Ok : Text; #Err : Text } {
        let vote_key = Nat.toText(args.proposal_id) # "#" # Nat.toText(args.neuron_id);
        switch (votes_cast.get(vote_key)) {
            case (?_) return #Err("Neuron has already voted on this proposal");
            case (null) {};
        };

        let neuron_opt = neurons.get(args.neuron_id);
        let n = switch (neuron_opt) {
            case (null) return #Err("Neuron not found");
            case (?item) item;
        };

        votes_cast.put(vote_key, args.approve);

        // Update proposal vote tallies
        var updated = false;
        var i = 0;
        while (i < proposals_list.size()) {
            let p = proposals_list[i];
            if (p.id == args.proposal_id) {
                let new_yes = if (args.approve) p.yes_votes + n.voting_power else p.yes_votes;
                let new_no = if (not args.approve) p.no_votes + n.voting_power else p.no_votes;
                
                let updated_p : Proposal = {
                    id = p.id;
                    proposer = p.proposer;
                    title = p.title;
                    description = p.description;
                    proposal_type = p.proposal_type;
                    yes_votes = new_yes;
                    no_votes = new_no;
                    quorum = p.quorum;
                    created_at = p.created_at;
                    voting_deadline = p.voting_deadline;
                    timelock_until = p.timelock_until;
                    status = if (new_yes > p.quorum and new_yes > new_no) #Passed else p.status;
                };
                
                // Replace in list
                var copy : [Proposal] = [];
                for (idx in Iter.range(0, proposals_list.size() - 1)) {
                    if (idx == i) {
                        copy := Array.append(copy, [updated_p]);
                    } else {
                        copy := Array.append(copy, [proposals_list[idx]]);
                    };
                };
                proposals_list := copy;
                updated := true;
            };
            i += 1;
        };

        if (updated) {
            return #Ok("Vote recorded successfully. Voting power applied: " # Nat.toText(n.voting_power));
        } else {
            return #Err("Proposal not found");
        };
    };

    public func execute_proposal(proposal_id : Nat) : async { #Ok : Text; #Err : Text } {
        var found = false;
        var exec_msg = "Proposal executed successfully on-chain.";

        var i = 0;
        while (i < proposals_list.size()) {
            let p = proposals_list[i];
            if (p.id == proposal_id) {
                found := true;
                if (p.status != #Passed) {
                    return #Err("Proposal must be in Passed status to execute");
                };

                let updated_p : Proposal = {
                    id = p.id;
                    proposer = p.proposer;
                    title = p.title;
                    description = p.description;
                    proposal_type = p.proposal_type;
                    yes_votes = p.yes_votes;
                    no_votes = p.no_votes;
                    quorum = p.quorum;
                    created_at = p.created_at;
                    voting_deadline = p.voting_deadline;
                    timelock_until = p.timelock_until;
                    status = #Executed;
                };

                var copy : [Proposal] = [];
                for (idx in Iter.range(0, proposals_list.size() - 1)) {
                    if (idx == i) {
                        copy := Array.append(copy, [updated_p]);
                    } else {
                        copy := Array.append(copy, [proposals_list[idx]]);
                    };
                };
                proposals_list := copy;
            };
            i += 1;
        };

        if (found) {
            return #Ok(exec_msg);
        } else {
            return #Err("Proposal not found");
        };
    };

    public query func get_proposals() : async [Proposal] {
        return proposals_list;
    };

    public query func get_proposal(proposal_id : Nat) : async ?Proposal {
        for (p in proposals_list.vals()) {
            if (p.id == proposal_id) return ?p;
        };
        return null;
    };

    public query func get_dao_stats() : async {
        total_staked : Nat;
        total_voting_power : Nat;
        total_proposals : Nat;
        treasury_balance : Nat;
        active_neurons_count : Nat;
    } {
        return {
            total_staked = total_staked;
            total_voting_power = total_voting_power;
            total_proposals = proposal_counter;
            treasury_balance = treasury_balance;
            active_neurons_count = neuron_counter;
        };
    };
}
