use candid::{CandidType, Deserialize};
use fips204::{
    ml_dsa_65::{PublicKey, PK_LEN, SIG_LEN},
    traits::{SerDes, Verifier},
};
use std::{cell::RefCell, collections::HashMap};

const ML_DSA_CONTEXT: &[u8] = b"qmoosa-icp-manifest-v1";

#[derive(Clone, CandidType, Deserialize)]
enum PqcAlgorithm {
    ML_DSA_44,
    ML_DSA_65,
    ML_DSA_87,
    ML_KEM_768,
    ML_KEM_1024,
}

#[derive(Clone, CandidType, Deserialize)]
struct PqcManifest {
    manifest_id: String,
    name: String,
    sha256_hash: String,
    algorithm: PqcAlgorithm,
    public_key_hex: String,
    signature_hex: String,
    signed_by: String,
    timestamp: u64,
    is_verified: bool,
}

#[derive(CandidType, Deserialize)]
struct RegisterManifestRequest {
    manifest_id: String,
    name: String,
    sha256_hash: String,
    algorithm: PqcAlgorithm,
    public_key_hex: String,
    signature_hex: String,
    signed_by: String,
}

#[derive(CandidType, Deserialize)]
enum RegisterResult {
    Ok(PqcManifest),
    Err(String),
}

#[derive(CandidType, Deserialize)]
enum VerifyResult {
    Ok(bool),
    Err(String),
}

#[derive(CandidType, Deserialize)]
struct PqcSecurityReport {
    total_pqc_manifests: u64,
    verified_manifests: u64,
    supported_standards: Vec<String>,
    quantum_resistance_status: String,
}

thread_local! {
    static MANIFESTS: RefCell<HashMap<String, PqcManifest>> = RefCell::new(HashMap::new());
}

fn decode_hex<const N: usize>(s: &str) -> Result<[u8; N], String> {
    if s.len() != N * 2 {
        return Err(format!("expected {} hex characters, got {}", N * 2, s.len()));
    }
    let mut out = [0u8; N];
    let bytes = s.as_bytes();
    for i in 0..N {
        let hi = hex_nibble(bytes[2 * i])?;
        let lo = hex_nibble(bytes[2 * i + 1])?;
        out[i] = (hi << 4) | lo;
    }
    Ok(out)
}

fn hex_nibble(b: u8) -> Result<u8, String> {
    match b {
        b'0'..=b'9' => Ok(b - b'0'),
        b'a'..=b'f' => Ok(b - b'a' + 10),
        b'A'..=b'F' => Ok(b - b'A' + 10),
        _ => Err("invalid hexadecimal input".to_string()),
    }
}

fn verify_manifest(m: &PqcManifest) -> Result<bool, String> {
    match m.algorithm {
        PqcAlgorithm::ML_DSA_65 => {}
        _ => return Err("only ML-DSA-65 cryptographic verification is enabled in v1".to_string()),
    }

    let message = decode_hex::<32>(&m.sha256_hash)?;
    let pk_bytes = decode_hex::<PK_LEN>(&m.public_key_hex)?;
    let signature = decode_hex::<SIG_LEN>(&m.signature_hex)?;

    let pk = PublicKey::try_from_bytes(pk_bytes)
        .map_err(|e| format!("invalid ML-DSA-65 public key: {e}"))?;

    Ok(pk.verify(&message, &signature, ML_DSA_CONTEXT))
}

#[ic_cdk::update]
fn register_manifest(req: RegisterManifestRequest) -> RegisterResult {
    if req.sha256_hash.len() != 64 {
        return RegisterResult::Err(
            "Expected a 32-byte SHA-256 digest encoded as 64 hex characters".to_string(),
        );
    }

    let item = PqcManifest {
        manifest_id: req.manifest_id.clone(),
        name: req.name,
        sha256_hash: req.sha256_hash,
        algorithm: req.algorithm,
        public_key_hex: req.public_key_hex,
        signature_hex: req.signature_hex,
        signed_by: req.signed_by,
        timestamp: ic_cdk::api::time(),
        is_verified: false,
    };

    MANIFESTS.with(|m| {
        m.borrow_mut().insert(req.manifest_id, item.clone());
    });

    RegisterResult::Ok(item)
}

#[ic_cdk::update]
fn verify_signature(manifest_id: String) -> VerifyResult {
    MANIFESTS.with(|store| {
        let mut store = store.borrow_mut();
        let Some(manifest) = store.get_mut(&manifest_id) else {
            return VerifyResult::Err("Manifest not found".to_string());
        };

        match verify_manifest(manifest) {
            Ok(valid) => {
                manifest.is_verified = valid;
                VerifyResult::Ok(valid)
            }
            Err(e) => VerifyResult::Err(e),
        }
    })
}

#[ic_cdk::query]
fn get_manifests() -> Vec<PqcManifest> {
    MANIFESTS.with(|m| m.borrow().values().cloned().collect())
}

#[ic_cdk::query]
fn get_manifest(manifest_id: String) -> Option<PqcManifest> {
    MANIFESTS.with(|m| m.borrow().get(&manifest_id).cloned())
}

#[ic_cdk::query]
fn get_pqc_security_report() -> PqcSecurityReport {
    MANIFESTS.with(|m| {
        let values = m.borrow();
        let verified = values.values().filter(|x| x.is_verified).count() as u64;
        PqcSecurityReport {
            total_pqc_manifests: values.len() as u64,
            verified_manifests: verified,
            supported_standards: vec![
                "NIST FIPS 204 ML-DSA-65".to_string(),
                "NIST FIPS 203 ML-KEM (declared roadmap; not verified by this canister)".to_string(),
            ],
            quantum_resistance_status:
                "ML-DSA-65 signature verification implemented in-canister using pure Rust FIPS 204"
                    .to_string(),
        }
    })
}

ic_cdk::export_candid!();
