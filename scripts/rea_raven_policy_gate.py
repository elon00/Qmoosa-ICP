#!/usr/bin/env python3
"""Fail-closed evidence check for REA/Raven adoption. No network or credentials."""
import argparse
import json
import pathlib
import sys

REQUIRED = ("upstream_sha", "license_review", "dependency_review",
            "baseline_tests", "security_review", "independent_evidence",
            "human_approval")
ALLOWED = {"PASS", "FAIL", "BLOCKED", "NOT_RUN"}

def validate(path):
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict) or data.get("schema") != 1:
        raise ValueError("Invalid evidence schema")
    gates = data.get("gates", {})
    if not isinstance(gates, dict):
        raise ValueError("Invalid gate map")
    failures = []
    for name in REQUIRED:
        entry = gates.get(name)
        if not isinstance(entry, dict) or entry.get("status") not in ALLOWED:
            failures.append(f"{name}: missing or invalid status")
            continue
        if entry["status"] != "PASS":
            failures.append(f"{name}: {entry['status']}")
        elif not entry.get("evidence"):
            failures.append(f"{name}: missing independently verifiable evidence")
    return failures

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--evidence", type=pathlib.Path)
    p.add_argument("--self-test", action="store_true")
    args = p.parse_args()
    if args.self_test:
        assert len(REQUIRED) == len(set(REQUIRED))
        assert "PASS" in ALLOWED
        print("PASS: Policy structure self-test only; no integration verified")
        return 0
    if not args.evidence or not args.evidence.is_file():
        print("BLOCKED: independent REA/Raven integration evidence missing")
        return 1
    try:
        failures = validate(args.evidence)
    except (OSError, ValueError, TypeError) as exc:
        print(f"BLOCKED: evidence invalid: {exc}")
        return 1
    for f in failures:
        print("BLOCKED:", f)
    if failures:
        return 1
    print("Manifest complete; independent review required before release")
    return 0

if __name__ == "__main__":
    sys.exit(main())
