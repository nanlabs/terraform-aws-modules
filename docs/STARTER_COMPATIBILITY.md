# Starter Compatibility Guide

How to consume these modules from `nanlabs/terraform-aws-starter` (or any external
repository) instead of duplicating them. Closes #17.

## Pattern

```hcl
module "vpc" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-vpc?ref=v1.18.0"

  name = "starter-vpc"
  tags = { Environment = "dev" }
}
```

Pin a tag (`?ref=vX.Y.Z`), never a branch. See `examples/starter-reference/` for a
minimal end-to-end starter layout (VPC + bastion).

## Module map (starter → library)

| Starter module (legacy, local) | Library module | Notes |
|---|---|---|
| `vpc` | `modules/aws-vpc` | Upstream `vpc/aws` 6.7.2 |
| `bastion` | `modules/aws-bastion` | Upstream `security-group/aws` 6.0.0, structured rules |
| `docdb` | `modules/aws-docdb` | Same |
| `eks` | `modules/aws-eks` | Upstream `eks-cluster` 4.15.0, `eks-node-group` 3.4.0 |
| `iam-role` | `modules/aws-iam-role` | Same |
| `mongodb` | `modules/mongodb-atlas-cluster` | Same |
| `msk` | `modules/aws-msk` | Upstream 2.6.0 |
| `rds` | `modules/aws-rds` | Upstream `rds/aws` 7.2.1, write-only `password_wo` |
| `rds-aurora` | `modules/aws-rds-aurora` | Upstream 10.4.0, cluster/instance split |
| `amplify-app` | `modules/aws-amplify-app` | Same |

## Migration notes (breaking upstreams)

- **security-group v6**: `ingress_rules`/`egress_rules` are maps of structured
  objects (`ip_protocol`, `cidr_ipv4`, `referenced_security_group_id`); the
  `ingress_with_*` families and `["all-all"]` shorthand are gone. Outputs renamed
  (`security_group_id` → `id`). State adoption is automatic via `moved` blocks
  (no replacement) for wrappers created by v5.
- **rds v7 / aurora v10**: master passwords are write-only (`password_wo` +
  `password_wo_version`). Aurora splits cluster vs per-instance settings
  (`cluster_instance_class`, `instances` map, object-typed parameter groups,
  shard group and activity stream).
- **iam v6**: the `iam-assumable-role` submodule is now `iam-role`
  (`create`, `name`, `trust_policy_permissions`, `policies`).
- **Providers**: wrappers require AWS provider 6.x (up to `>= 6.59.0` for EKS);
  Terraform `>= 1.11`.
