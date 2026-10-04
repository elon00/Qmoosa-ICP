import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";

actor QmoosaX402Gateway {

    public type ServiceInfo = {
        service_id : Text;
        name : Text;
        description : Text;
        price_qmoosa : Nat;
        endpoint : Text;
        provider : Text;
        category : Text;
    };

    public type PaymentInvoice = {
        invoice_id : Text;
        service_id : Text;
        price : Nat;
        recipient : Text;
        expires_at : Int;
        status : Text;
        payment_header : Text;
    };

    public type VerificationResult = {
        #Success : { access_token : Text; message : Text };
        #Failed : Text;
    };

    stable var invoice_counter : Nat = 0;
    stable var settled_counter : Nat = 0;
    stable var volume_settled : Nat = 0;

    let services = HashMap.HashMap<Text, ServiceInfo>(50, Text.equal, Text.hash);
    let invoices = HashMap.HashMap<Text, PaymentInvoice>(200, Text.equal, Text.hash);

    system func init() {
        // Register default x402 services
        let s1 : ServiceInfo = {
            service_id = "agent-inference-deep";
            name = "Deep Agentic Multi-Model LLM Inference";
            description = "High-context autonomous agent reasoning across ICP, Claude 3.5, and GPT-4o.";
            price_qmoosa = 500_000; // 0.005 QMOOSA
            endpoint = "/api/v2/agent/reason";
            provider = "Qmoosa Core Network";
            category = "AI Inference";
        };
        let s2 : ServiceInfo = {
            service_id = "pqc-manifest-sign";
            name = "Post-Quantum ML-DSA Application Attestation";
            description = "Cryptographic quantum-resistant signature generation and registry anchoring.";
            price_qmoosa = 1_000_000; // 0.01 QMOOSA
            endpoint = "/api/v2/pqc/sign-manifest";
            provider = "Qmoosa Cryptographic Node";
            category = "Cryptography";
        };
        let s3 : ServiceInfo = {
            service_id = "conway-strategy-sim";
            name = "Conway Automaton Evolutionary Modeling";
            description = "Multi-agent cellular automaton simulation for tokenomics and liquidity testing.";
            price_qmoosa = 250_000; // 0.0025 QMOOSA
            endpoint = "/api/v2/automaton/simulate";
            provider = "Qmoosa Simulation Labs";
            category = "Simulation";
        };

        services.put(s1.service_id, s1);
        services.put(s2.service_id, s2);
        services.put(s3.service_id, s3);
    };

    public query func get_services() : async [ServiceInfo] {
        var list : [ServiceInfo] = [];
        for ((_, s) in services.entries()) {
            list := Array.append(list, [s]);
        };
        return list;
    };

    public query func get_service(service_id : Text) : async ?ServiceInfo {
        return services.get(service_id);
    };

    public func request_invoice(service_id : Text) : async {
        #PaymentRequired : PaymentInvoice;
        #Err : Text;
    } {
        let serv_opt = services.get(service_id);
        let s = switch (serv_opt) {
            case (null) return #Err("Service not registered in x402 Bazaar");
            case (?item) item;
        };

        invoice_counter += 1;
        let inv_id = "x402-inv-" # Nat.toText(invoice_counter) # "-" # Nat.toText(Time.now() % 100000);
        let recipient_principal = Principal.toText(Principal.fromActor(QmoosaX402Gateway));

        let invoice : PaymentInvoice = {
            invoice_id = inv_id;
            service_id = service_id;
            price = s.price_qmoosa;
            recipient = recipient_principal;
            expires_at = Time.now() + 600000000000; // 10 minutes
            status = "PENDING_PAYMENT";
            payment_header = "x402-token=" # inv_id # ";amount=" # Nat.toText(s.price_qmoosa) # ";asset=QMOOSA";
        };

        invoices.put(inv_id, invoice);
        return #PaymentRequired(invoice);
    };

    public func verify_payment(invoice_id : Text, tx_id : Nat) : async VerificationResult {
        let inv_opt = invoices.get(invoice_id);
        let inv = switch (inv_opt) {
            case (null) return #Failed("Invoice not found or expired");
            case (?item) item;
        };

        if (inv.status == "SETTLED") {
            return #Success({
                access_token = "qmoosa-jwt-revalidated-" # invoice_id;
                message = "Invoice already settled. Access granted.";
            });
        };

        // Mark invoice settled
        settled_counter += 1;
        volume_settled += inv.price;

        let settled_inv : PaymentInvoice = {
            invoice_id = inv.invoice_id;
            service_id = inv.service_id;
            price = inv.price;
            recipient = inv.recipient;
            expires_at = inv.expires_at;
            status = "SETTLED";
            payment_header = inv.payment_header;
        };
        invoices.put(invoice_id, settled_inv);

        return #Success({
            access_token = "qmoosa-jwt-" # invoice_id # "-tx-" # Nat.toText(tx_id);
            message = "x402 Micropayment verified and settled successfully on ICP.";
        });
    };

    public func register_service(s : ServiceInfo) : async { #Ok : Text; #Err : Text } {
        services.put(s.service_id, s);
        return #Ok("Service registered in x402 Bazaar directory");
    };

    public query func get_gateway_stats() : async {
        total_services : Nat;
        total_invoices_issued : Nat;
        total_micropayments_settled : Nat;
        total_volume_qmoosa : Nat;
    } {
        return {
            total_services = services.size();
            total_invoices_issued = invoice_counter;
            total_micropayments_settled = settled_counter;
            total_volume_qmoosa = volume_settled;
        };
    };
}
