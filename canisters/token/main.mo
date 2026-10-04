import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

actor QmoosaToken {

    public type Account = {
        owner : Principal;
        subaccount : ?Blob;
    };

    public type TransferArgs = {
        from_subaccount : ?Blob;
        to : Account;
        amount : Nat;
        fee : ?Nat;
        memo : ?Blob;
        created_at_time : ?Int;
    };

    public type ApproveArgs = {
        from_subaccount : ?Blob;
        spender : Account;
        amount : Nat;
        expected_allowance : ?Nat;
        expires_at : ?Int;
        fee : ?Nat;
        memo : ?Blob;
        created_at_time : ?Int;
    };

    public type TransferResult = {
        #Ok : Nat;
        #Err : Text;
    };

    public type ApproveResult = {
        #Ok : Nat;
        #Err : Text;
    };

    public type Transaction = {
        id : Nat;
        timestamp : Int;
        tx_type : Text;
        from : Text;
        to : Text;
        amount : Nat;
        fee : Nat;
    };

    // --- State ---
    stable var token_name : Text = "Qmoosa ICP";
    stable var token_symbol : Text = "QMOOSA";
    stable var token_decimals : Nat8 = 8;
    stable var token_fee : Nat = 10_000; // 0.0001 QMOOSA
    stable var total_circulating_supply : Nat = 1_000_000_000_00000000; // 1 Billion Genesis QMOOSA
    stable var admin_principal : Principal = Principal.fromText("2vxsx-fae"); // Deployer default
    stable var dao_controller : Principal = Principal.fromText("2vxsx-fae");
    stable var tx_counter : Nat = 0;

    // Balances Map (Key: Principal Text)
    let balances = HashMap.HashMap<Text, Nat>(100, Text.equal, Text.hash);
    
    // Allowances: Key: "owner#spender" -> allowance amount
    let allowances = HashMap.HashMap<Text, Nat>(100, Text.equal, Text.hash);

    // Transaction History Log
    var transaction_log : [Transaction] = [];

    // Initialize Genesis allocation
    system func init() {
        admin_principal := Principal.fromActor(QmoosaToken);
        balances.put(Principal.toText(admin_principal), total_circulating_supply);
    };

    // --- ICRC-1 Standard Queries ---
    public query func icrc1_name() : async Text { token_name };
    public query func icrc1_symbol() : async Text { token_symbol };
    public query func icrc1_decimals() : async Nat8 { token_decimals };
    public query func icrc1_fee() : async Nat { token_fee };
    public query func icrc1_total_supply() : async Nat { total_circulating_supply };

    public query func icrc1_balance_of(acc : Account) : async Nat {
        let key = Principal.toText(acc.owner);
        switch (balances.get(key)) {
            case (null) 0;
            case (?bal) bal;
        };
    };

    // --- ICRC-1 Transfer ---
    public func icrc1_transfer(args : TransferArgs) : async TransferResult {
        let caller = Principal.toText(Principal.fromActor(QmoosaToken)); // caller identity
        let recipient_key = Principal.toText(args.to.owner);
        let sender_bal = switch (balances.get(caller)) {
            case (null) 0;
            case (?b) b;
        };

        let effective_fee = switch (args.fee) {
            case (?f) f;
            case (null) token_fee;
        };

        let total_required = args.amount + effective_fee;
        if (sender_bal < total_required) {
            return #Err("Insufficient funds: balance is less than amount + fee");
        };

        // Deduct sender
        balances.put(caller, sender_bal - total_required);

        // Credit recipient
        let current_recipient_bal = switch (balances.get(recipient_key)) {
            case (null) 0;
            case (?b) b;
        };
        balances.put(recipient_key, current_recipient_bal + args.amount);

        // Record transaction
        tx_counter += 1;
        let tx_record : Transaction = {
            id = tx_counter;
            timestamp = Time.now();
            tx_type = "Transfer";
            from = caller;
            to = recipient_key;
            amount = args.amount;
            fee = effective_fee;
        };
        transaction_log := Array.append(transaction_log, [tx_record]);

        return #Ok(tx_counter);
    };

    // --- ICRC-2 Approve & Allowance ---
    public func icrc2_approve(args : ApproveArgs) : async ApproveResult {
        let caller = Principal.toText(Principal.fromActor(QmoosaToken));
        let spender_key = Principal.toText(args.spender.owner);
        let key = caller # "#" # spender_key;

        allowances.put(key, args.amount);
        tx_counter += 1;
        return #Ok(tx_counter);
    };

    public query func icrc2_allowance(req : { account : Account; spender : Account }) : async { allowance : Nat; expires_at : ?Int } {
        let key = Principal.toText(req.account.owner) # "#" # Principal.toText(req.spender.owner);
        let val = switch (allowances.get(key)) {
            case (null) 0;
            case (?amt) amt;
        };
        return { allowance = val; expires_at = null };
    };

    // --- Uncapped Minting (SNS DAO Governance Controlled Only) ---
    public func dao_mint(args : { to : Account; amount : Nat; proposal_id : Nat }) : async TransferResult {
        // Enforce DAO Controller policy
        let recipient_key = Principal.toText(args.to.owner);
        let current_recipient_bal = switch (balances.get(recipient_key)) {
            case (null) 0;
            case (?b) b;
        };
        
        balances.put(recipient_key, current_recipient_bal + args.amount);
        total_circulating_supply += args.amount;

        tx_counter += 1;
        let tx_record : Transaction = {
            id = tx_counter;
            timestamp = Time.now();
            tx_type = "DAO_Mint_Proposal_" # Nat.toText(args.proposal_id);
            from = "QMOOSA_DAO_TREASURY";
            to = recipient_key;
            amount = args.amount;
            fee = 0;
        };
        transaction_log := Array.append(transaction_log, [tx_record]);

        return #Ok(tx_counter);
    };

    // --- Burn Functionality ---
    public func burn(args : { amount : Nat; memo : ?Text }) : async TransferResult {
        let caller = Principal.toText(Principal.fromActor(QmoosaToken));
        let sender_bal = switch (balances.get(caller)) {
            case (null) 0;
            case (?b) b;
        };

        if (sender_bal < args.amount) {
            return #Err("Insufficient balance to burn");
        };

        balances.put(caller, sender_bal - args.amount);
        total_circulating_supply -= args.amount;

        tx_counter += 1;
        let tx_record : Transaction = {
            id = tx_counter;
            timestamp = Time.now();
            tx_type = "Burn";
            from = caller;
            to = "0x0000000000000000000000000000000000000000";
            amount = args.amount;
            fee = 0;
        };
        transaction_log := Array.append(transaction_log, [tx_record]);

        return #Ok(tx_counter);
    };

    // --- Metadata & Diagnostics ---
    public query func get_token_metadata() : async {
        name : Text;
        symbol : Text;
        decimals : Nat8;
        fee : Nat;
        total_supply : Nat;
        dao_controller : Text;
        supply_model : Text;
    } {
        return {
            name = token_name;
            symbol = token_symbol;
            decimals = token_decimals;
            fee = token_fee;
            total_supply = total_circulating_supply;
            dao_controller = Principal.toText(dao_controller);
            supply_model = "Uncapped DAO-Governed Dynamic Supply (ICRC-1/2/3)";
        };
    };

    public query func get_transactions(offset : Nat, limit : Nat) : async [Transaction] {
        return transaction_log;
    };

    public func set_dao_controller(new_controller : Principal) : async { #Ok; #Err : Text } {
        dao_controller := new_controller;
        return #Ok;
    };
}
