---
name: security-baseline
description: Security review baseline for any codebase: scanner-first CVE discipline, CWE classes to check, redaction, and the finding format. Use when reviewing code, dependencies, IaC, or CI for security.
---

# Security baseline

## Known vulnerabilities come from tools

CVE knowledge from training data is stale and incomplete. Every claim that a package is or isn't vulnerable comes from a scanner run or a live advisory lookup, cited.

1. **Detect** the ecosystems and IaC in the repo: lockfiles, `Dockerfile`, Terraform, CloudFormation, CDK, Kubernetes manifests, and `.github/workflows/`.
2. **Run** whichever applicable scanners are installed:
   - `osv-scanner scan source -r .`: dependency CVEs, all major ecosystems.
   - `trivy fs --scanners vuln,secret,misconfig .`: CVEs, leaked secrets, misconfigurations.
   - `checkov -d <iac-dir>`: IaC misconfigurations. For CDK, run it against `cdk synth` output in `cdk.out`.
   - `gitleaks detect` or `trufflehog filesystem .`: secrets in the tree.
3. **Report coverage.** List which scanners ran and which were unavailable. Where a CI workflow runs the missing scanner, name it.
4. **Confirm reachability.** For each finding, confirm the vulnerable code path is reachable from this codebase. When severity decides the outcome, check the advisory on osv.dev or nvd.nist.gov.

## Weaknesses to check (CWE)

Review the diff with its surrounding context against the CWE Top 25, focusing on:

- **Injection**: command or OS (CWE-78), SQL (CWE-89), template, and log injection.
- **Path traversal** in any uploaded or user-named file path (CWE-22).
- **SSRF**: user-controlled URLs fetched server-side (CWE-918).
- **AuthN/AuthZ**: whether one user can read or act on another user's resource (CWE-639, CWE-862, CWE-863).
- **Secrets**: hardcoded credentials (CWE-798), and secrets in logs, URLs, or plain env files.
- **Unsafe deserialization** of untrusted data (CWE-502).
- **Resource exhaustion**: unbounded allocation, fan-out, or provisioning (CWE-400, CWE-770). This includes cost-based denial of service.
- **CI/CD**:
  - Third-party actions pinned to a full commit SHA (CWE-829).
  - `pull_request_target` never checks out untrusted code.
  - `permissions:` is least-privilege.

## Redaction

Write `<REDACTED>` in place of every secret, token, or credential that appears in output, quotes, or scanner results. Quote only the lines that carry the signal.

## Finding format

```
[critical|high|medium|low] path:line – CWE-NNN or CVE-YYYY-NNNNN – issue. Exploit scenario: <who does what → impact>. Fix: <one line>.
```

Report only findings with a credible exploit scenario.
