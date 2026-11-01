---
name: security-aws
description: Opt-in AWS security checks (IAM, network exposure, encryption, cost-based DoS) layered on security-baseline. Use when reviewing AWS infrastructure, CDK, CloudFormation, or Terraform for AWS.
---

# AWS security checks

Apply these on top of `security-baseline`. Project-specific exposure, such as which ports are meant to be public, comes from the project's `AGENTS.md`. Treat anything it doesn't declare as unintended.

- **IAM** (CWE-269, CWE-732):
  - No wildcard `Action` or `Resource` where a specific ARN works.
  - Conditions (`aws:SourceAccount`, `aws:SourceArn`) on every service-role trust policy.
  - No IAM users with access keys for workloads: use roles, OIDC for CI, or IAM Identity Center for humans.
- **Network exposure** (CWE-284):
  - Security groups open to `0.0.0.0/0` or `::/0` only on ports the project declares public.
  - No public S3 buckets, RDS instances, or OpenSearch domains.
  - Block Public Access enabled at account and bucket level.
- **Encryption** (CWE-311, CWE-319): encryption at rest on S3, EBS, RDS, DynamoDB, and SQS/SNS. TLS enforced in transit, for example with `aws:SecureTransport` deny statements and HTTPS-only listeners.
- **Secrets** (CWE-798): credentials come from Secrets Manager or SSM SecureString, resolved at runtime. They never appear in plaintext env vars, CDK context, or template parameters with defaults.
- **Cost-based DoS** (CWE-400, CWE-770):
  - Every user-triggerable provisioning path (instances, tasks, functions) has a per-user and a global ceiling.
  - Idle resources scale to zero or are reaped.
  - Billing alarms exist.
- **Logging**: CloudTrail on in all regions, and access logs on public entry points (ALB, CloudFront, API Gateway).
- **IaC scanning**: for CDK, run `cdk synth`, then `checkov -d cdk.out`, or enable `cdk-nag` `AwsSolutionsChecks`.
