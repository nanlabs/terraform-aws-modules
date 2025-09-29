# Multi-Account Data Platform (Infra + Dev) Example

This example simulates a multi-account analytics/data lake platform using **provider aliases** to represent separate AWS accounts. It is intentionally self-contained and runnable without real cross-account roles, while documenting how to evolve toward a production-grade multi-account architecture.

## Accounts (Conceptual)

| Alias | Purpose | Typical Real Account |
|-------|---------|----------------------|
| `aws.infrastructure` | Shared networking, transit gateway, encryption (KMS) | `infrastructure` / `network` |
| `aws.workloads_dev`  | Development data lake & Glue processing jobs | `workloads-dev` |
| `aws.workloads_staging` (commented) | Pre-production validation | `workloads-staging` |
| `aws.workloads_prod` (commented) | Production hardened workloads | `workloads-prod` |

## Components Provisioned

Infrastructure (infra account):

- VPC (no NAT for simplicity)
- Transit Gateway (TGW) with auto-accept + default association/propagation enabled
- Centralized KMS keys (S3 + Glue) using `aws-data-lake-encryption` module

Development (dev account):

- Dedicated VPC attached to TGW
- Data lake S3 buckets (storage + temp) using central S3 KMS key
- Glue job (Spark ETL) + scheduled workflow
- Optional bastion host (SSM-compatible) for troubleshooting

## Why Central KMS?

Centralizing encryption in infra (or sometimes a security account) allows:

- Unified key rotation policies
- Central auditing of decrypt/generate events (CloudTrail)
- Delegated key grants to workload accounts

In real multi-account setups you'd add explicit key policies and grants referencing workload account principals. Here it's simplified because aliases share the same credentials.

## Naming Convention

`namespace-short_domain-<account>-<component>-<env>`

Example: `dwh-wl-workloads-dev-data-lake`.

## Promotion Path (Staging / Prod)

Commented blocks in `main.tf` show how you would replicate dev for staging and prod with environment-specific differences:

- Versioned / hardened Glue scripts
- Additional lifecycle policies
- Possibly more subnets, NAT gateways, stricter CIDR ingress
- Stricter tagging (e.g., `DataClassification = confidential`)

## How to Use

```bash
terraform init
terraform plan
```

(Optional) Override defaults:

```bash
terraform apply -var namespace=dwh -var short_domain=wl -var environment=dev
```
 
## Key Outputs

- `infrastructure` – VPC, subnets, TGW ID/ARN, KMS key ARNs
- `dev_environment` – Data lake bucket IDs, Glue job/workflow names, bastion private IP
- Central KMS logging enabled for key usage insights.

## Extending to Real Multi-Account

1. Replace provider alias definitions with real `assume_role` blocks pointing to each account.
2. Add cross-account IAM roles for Glue + S3 access (data lake read/write, logs, temp bucket staging).
3. Add explicit KMS key grants mapping each workload account principal to required operations (Encrypt, Decrypt, GenerateDataKey*).
4. Externalize state per account (e.g., one backend key per account) and inject remote TGW ID via SSM or remote state.
5. Introduce per-environment CIDR separation + centralized DNS resolver endpoints.

## Security Notes

- Example uses wide-open `allowed_admin_cidrs` (0.0.0.0/0) for simplicity—restrict this in any real environment.
- No NAT gateway included to keep cost minimal; add if private subnets need egress.
- Ensure cross-account KMS grants + IAM roles when moving to real accounts.

## Cleanup

```bash
terraform destroy
```
