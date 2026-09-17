# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]



## [1.18.0] - 2026-09-17



## [1.17.0] - 2026-09-17
### Added
- `docs/STARTER_COMPATIBILITY.md`: starter-to-library module map and migration notes (closes #17)
- `examples/starter-reference/`: minimal VPC + bastion starter consuming pinned modules (closes #18)

### Fixed
- Standardized pinned remote source examples across all module READMEs; local paths labeled for in-repository development (closes #19)
- `README.md` quick usage now pins `?ref=v1.16.0` instead of `v0.2.0`




## [1.16.0] - 2026-09-17



## [1.15.0] - 2026-09-17
### Changed
- Updated all third-party module pins to latest: `vpc` 6.7.2, `security-group` 6.0.0, `rds` 7.2.1, `rds-aurora` 10.4.0, `s3-bucket` 5.16.0, `iam` 6.8.1, `transit-gateway` 3.3.1, `eks-cluster` 4.15.0, `eks-node-group` 3.4.0, `msk-apache-kafka-cluster` 2.6.0
- Raised minimum AWS provider constraints to match upstream requirements and refreshed all committed `.terraform.lock.hcl` files
- Regenerated all `docs/MODULE.md` files with terraform-docs

### Fixed
- Fixed 3 configs that failed validation and were not covered by CI: `examples/data-processing-pipeline`, `modules/aws-data-lake-infrastructure/examples/with-encryption`, `modules/__template__`
- Replaced deprecated `data.aws_region.current.id` with `.region` across 8 files

### Removed (BREAKING)
- `aws-rds-aurora`: output `cluster_master_password` (upstream uses write-only passwords); variables `iam_role_managed_policy_arns` and `iam_role_force_detach_policies` (feature removed upstream)
- `modules/__template__`: outputs `bucket_website_endpoint` and `bucket_website_domain` (removed from AWS provider v6)




## [1.14.0] - 2026-09-11



## [1.13.0] - 2026-09-11



## [1.12.0] - 2026-09-11



## [1.11.0] - 2026-09-11



## [1.10.0] - 2026-08-03
### Fixed
- `aws-github-oidc-provider`: avoid inconsistent conditional types when using multi-repository mode with `additional_github_repositories`




## [1.9.0] - 2025-11-20



## [1.8.0] - 2025-09-29



## [1.7.0] - 2025-08-20



## [1.6.0] - 2025-07-23



## [1.5.0] - 2025-07-23



## [1.4.0] - 2025-07-23



## [1.3.0] - 2025-07-14



## [1.2.0] - 2025-07-14



## [1.1.0] - 2025-07-14



## [1.0.0] - 2025-07-12



## [0.5.0] - 2025-07-12



## [0.4.0] - 2025-07-11



## [0.3.0] - 2025-06-24
### Added

- Comprehensive usage guide with advanced patterns and best practices
- Complete technical documentation moved from README to dedicated guides
- Enhanced module catalog with detailed information, features, and cost estimates

### Changed

- Simplified main README to focus on marketing and quick start while maintaining visual appeal
- Moved detailed technical content to specialized documentation files
- Reorganized documentation structure for better discoverability

### Improved

- Better separation of concerns between marketing content and technical documentation
- Enhanced user experience with clearer navigation paths
- More accessible entry points for different user types




## [0.2.0] - 2025-06-24



## [0.3.0] - 2025-06-24

## [0.2.0] - 2025-06-24

### Added

- Enhanced maintenance script for improved repository management
- Terraform version and provider requirements to all examples
- Comprehensive module documentation updates via terraform-docs automation
- AWS VPC Endpoints module documentation

### Changed

- Updated all example configurations with proper version constraints
- Enhanced README documentation for better clarity
- Improved MongoDB Atlas cluster module documentation
- Updated all modules with consistent Terraform version requirements

### Fixed

- Documentation consistency across all modules
- Example configurations now include proper provider requirements

## [0.1.0] - 2025-06-24

### Added

- Initial repository versioning and release automation strategy
- Automated release workflow with semantic versioning
- Enhanced CI/CD validation for Terraform modules
- Comprehensive changelog management

### Changed

- Enhanced PR template to include changelog requirements
- Updated documentation with versioning strategy

### Deprecated

### Removed

### Fixed

### Security

<!--
## How to update this changelog

### For Contributors:
When submitting a PR, add your changes under the [Unreleased] section in the appropriate category:
- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** for vulnerability fixes

### For Maintainers:
When creating a release:
1. Move items from [Unreleased] to a new version section
2. Add the release date
3. Update the version links at the bottom
4. Create a new empty [Unreleased] section

### Format:
## [Version] - YYYY-MM-DD
### Category
- Description of change (#PR-number)

Links format:
[Unreleased]: https://github.com/nanlabs/terraform-aws-modules/compare/v1.18.0...HEAD
[1.18.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.18.0
[1.17.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.17.0
[1.16.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.16.0
[1.15.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.15.0
[1.14.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.14.0
[1.13.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.13.0
[1.12.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.12.0
[1.11.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.11.0
[1.10.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.10.0
[1.9.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.9.0
[1.8.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.8.0
[1.7.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.7.0
[1.6.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.6.0
[1.5.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.5.0
[1.4.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.4.0
[1.3.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.3.0
[1.2.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.2.0
[1.1.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.1.0
[1.0.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v1.0.0
[0.5.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v0.5.0
[0.4.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v0.4.0
[0.3.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v0.3.0
[0.2.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v0.2.0
[0.3.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v0.3.0
[0.2.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v0.2.0
[0.1.0]: https://github.com/nanlabs/terraform-aws-modules/releases/tag/v0.1.0
-->
