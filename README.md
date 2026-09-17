<!-- Banner -->
<div align="center">

# 🚀 NaN Labs' Terraform AWS Modules

## Deploy Production Infrastructure in Minutes, Not Months

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/nanlabs/terraform-aws-modules?style=for-the-badge)](https://github.com/nanlabs/terraform-aws-modules/stargazers)

🔥 **Battle-tested** • 🔒 **Security-first** • 💰 **Cost-optimized** • 🚀 **Developer-friendly**

> From MVP to Enterprise: Infrastructure that scales with your business

</div>

---

## 🧭 TL;DR

Deploy production-grade AWS building blocks fast with battle-tested Terraform modules (secure defaults, full customization, clear docs).

```bash
# Try the smallest stack (~$46/mo)
git clone https://github.com/nanlabs/terraform-aws-modules.git
cd terraform-aws-modules/examples/simple-web-app
terraform init && terraform apply
```

Need something bigger? Jump to the example catalog or full module list below.

## ✨ Why These Modules?

Secure by default, production-proven, cost-aware, and fully overridable. Built to scale from MVP to multi-account enterprise without rewriting your Terraform.

<details>
<summary><strong>Show feature matrix</strong></summary>

<div align="left">

<ul>
  <li><b>🛡️ Reliability:</b> Multi‑AZ patterns, zero‑downtime friendly changes, safe defaults that avoid accidental data loss.</li>
  <li><b>🔐 Security:</b> KMS encryption everywhere, least‑privilege IAM surfaces, GitHub OIDC (keyless CI), optional CloudTrail + Config integration.</li>
  <li><b>💰 Cost Awareness:</b> Right‑sized defaults, opt‑in NAT / Transit Gateway, lifecycle policies for cold data, no hidden always‑on extras.</li>
  <li><b>📊 Observability:</b> VPC Flow Logs ready, log/metrics hooks, consistent naming for tracing & tagging, surfaces for future dashboards.</li>
  <li><b>🧪 Developer Experience:</b> Consistent variable names, “complete wrapper” philosophy, rich runnable examples, auto‑generated docs.</li>
  <li><b>🧩 Extensibility:</b> All upstream module variables & outputs exposed, composable building blocks, feature flags instead of forks.</li>
</ul>

</div>

</details>

## 🎪 Examples

Pick a starting point:

| Tier | Example | What You Get | Est. Cost* |
|------|---------|--------------|-----------|
| Starter | [🌐 Simple Web App](./examples/simple-web-app) | Minimal VPC + one compute entrypoint (low cost) | ~$46 |
| Growth | [⚙️ Medium Complexity](./examples/medium-complexity-infrastructure) | EKS + RDS + Bastion (microservices base) | ~$300 |
| Enterprise | [🏢 Complete Enterprise](./examples/complete-enterprise-setup) | Full platform: multi-AZ network, EKS, RDS (HA), MSK, TGW | ~$940 |

Need data / security / networking patterns? See the expanded catalog.

<details>
<summary><strong>Full example catalog (with costs & focus areas)</strong></summary>

| Example | Core Services | Focus | Est. Cost* |
|---------|---------------|-------|-----------|
| [🌐 Simple Web App](./examples/simple-web-app) | VPC + minimal compute | MVP / quick start | ~$46 |
| [⚙️ Medium Complexity](./examples/medium-complexity-infrastructure) | VPC, EKS, RDS, Bastion | Microservices staging | ~$300 |
| [🏢 Complete Enterprise](./examples/complete-enterprise-setup) | VPC (multi-AZ), EKS, RDS (HA), MSK, TGW, encryption | Production foundation | ~$940 |
| [🔐 Secure Multi-Environment Data Platform](./examples/secure-multi-environment-data-platform) | CloudTrail, Config, Data Lake, Glue, KMS | Compliance & governance | ~$420 |
| [🛰️ Hub & Spoke Networking](./examples/hub-and-spoke-networking-architecture) | Transit Gateway + multi-VPC | Segmentation / org networking | ~$160 |
| [📊 Analytics + Document Store](./examples/analytics-platform-with-document-store) | Data Lake, DocumentDB, MSK, Glue | Hybrid analytics (structured + doc) | ~$780 |
| [🔄 Data Processing Pipeline](./examples/data-processing-pipeline) | Data Lake, Glue Jobs + Workflow | Batch ETL / curation | ~$180 |
| [🧩 Multi-Account Data Platform (Simulated)](./examples/multi-account-data-platform) | Central KMS, TGW, Data Lake, Glue, Bastion | Multi-account pattern | ~$210 |

*Estimates at authoring time, us-east-1 on-demand, minimal throughput. Validate with AWS Pricing Calculator / Infracost before production.

</details>

> [!TIP]
> New here? Jump to the [Usage Guide](docs/USAGE.md) or scan the modules below.

## 🎯 Motivation

Building and maintaining infrastructure across cloud providers can become repetitive and error-prone. This repository consolidates reusable Terraform modules following best practices, allowing your team to provision infrastructure efficiently, securely, and consistently—whether it's an AWS VPC, a Kubernetes cluster, or a MongoDB Atlas database.

## 📦 Modules Overview

Highly opinionated wrappers around official modules—simple defaults, full override capability.

**Categories:**

- Network & Access: VPC, Bastion, Transit Gateway (+ Spokes), Shared Networking
- Compute & Orchestration: EKS, Amplify
- Data & Analytics: RDS / Aurora, MSK, DocumentDB, Data Lake infra & encryption, Glue suite
- Security & Governance: CloudTrail, Config, GitHub OIDC, TF State Backend
- Multi-Cloud: MongoDB Atlas

<details>
<summary><strong>Show full module catalog</strong></summary>

| Module | Description | Use Cases |
|--------|-------------|-----------|
| 🌐 [AWS VPC](./modules/aws-vpc) | VPC with subnets, flow logs, sane defaults | Network foundation, multi-AZ setup |
| ⚡ [AWS EKS](./modules/aws-eks) | Managed Kubernetes + addons wrapper | Microservices, container orchestration |
| 🗄️ [AWS RDS](./modules/aws-rds) | Relational DB (backups, monitoring) | Application persistence |
| 🗄️ [AWS RDS Aurora](./modules/aws-rds-aurora) | High-performance Aurora cluster | HA & read scaling |
| 📨 [AWS MSK](./modules/aws-msk) | Managed Kafka (secure & multi-AZ) | Event streaming, pipelines |
| 🏰 [AWS Bastion](./modules/aws-bastion) | SSM-based secure jump host | Admin access, troubleshooting |
| 📊 [AWS DocumentDB](./modules/aws-docdb) | MongoDB-compatible document store | Flexible JSON workloads |
| 👤 [AWS IAM Role](./modules/aws-iam-role) | Opinionated IAM role creation | Least-privilege access |
| 🌍 [AWS Amplify App](./modules/aws-amplify-app) | Frontend hosting & CI/CD | Static & SPA delivery |
| 🔐 [AWS CloudTrail](./modules/aws-cloudtrail) | Central activity logging | Audit & compliance |
| 🛡️ [AWS Config](./modules/aws-config) | Resource config tracking & rules | Governance & drift detection |
| 🧱 [AWS Data Lake Encryption](./modules/aws-data-lake-encryption) | Central KMS (S3 + Glue keys) | Unified encryption & rotation |
| 🗃️ [AWS Data Lake Infrastructure](./modules/aws-data-lake-infrastructure) | Medallion S3 layout scaffold | Bronze/Silver/Gold zoning |
| 🧬 [AWS Glue Code Registry](./modules/aws-glue-code-registry) | Schema/code registry | ETL governance |
| 📚 [AWS Glue Data Lake Catalog](./modules/aws-glue-data-lake-catalog) | Catalog databases / tables | Metadata discovery |
| 🛠️ [AWS Glue Jobs](./modules/aws-glue-jobs) | Map-based multi Glue jobs | Batch / Spark ETL |
| 🔄 [AWS Glue Workflow](./modules/aws-glue-workflow) | Workflow & trigger orchestration | Chained ETL processes |
| ✈️ [AWS Transit Gateway](./modules/aws-transit-gateway) | Central routing hub | Multi-VPC topology |
| 🛰️ [AWS Transit Gateway Spoke](./modules/aws-transit-gateway-spoke) | VPC attachment wrapper | Hub & spoke expansion |
| 🕸️ [AWS Shared Networking](./modules/aws-shared-networking) | Shared services networking layer | Central endpoints & DNS |
| 📦 [AWS TF State Backend](./modules/aws-tfstate-backend) | S3 + DynamoDB state backend | Remote state & locking |
| 🔐 [AWS GitHub OIDC Provider](./modules/aws-github-oidc-provider) | OIDC federation for CI | Keyless deployments |

<div align="center">

### Other Cloud Providers

</div>

| Module | Description | Use Cases |
|--------|-------------|-----------|
| 🍃 [MongoDB Atlas Cluster](./modules/mongodb-atlas-cluster) | Managed multi-cloud MongoDB | Global & serverless data |

## 🚀 Quick Module Usage

Each module is designed to be **plug-and-play** with sensible defaults, yet highly customizable for complex requirements.

```hcl
module "vpc" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-vpc?ref=v1.16.0"

  vpc_cidr = "10.0.0.0/16"
  # That's it! VPC with best practices is ready 🎉
}
```

> 📖 See the [Usage Guide](docs/USAGE.md) for advanced patterns (version pinning, multi-account, remote state, KMS sharing).

## 🎯 Ready to Get Started?

<div align="center">

| 🚀 **Quick Start** | 📚 **Learn More** | 🤝 **Get Help** |
|:---:|:---:|:---:|
| [Browse Examples](examples/) | [Read Documentation](docs/) | [Join Discussions](https://github.com/nanlabs/terraform-aws-modules/discussions) |
| Pick an example that fits your needs | Understand best practices | Ask questions, share ideas |

⭐ **If this project helps you, please consider giving it a star!** ⭐

</div>

## 🤝 Contributing

We **love** contributions! Whether you're:

- 🐛 **Reporting bugs** or suggesting improvements
- 📝 **Improving documentation** or adding examples
- 🚀 **Adding new modules** or enhancing existing ones
- 💡 **Sharing ideas** for new features

**Every contribution matters!** Check our [Contributing Guidelines](docs/CONTRIBUTING_GUIDELINES.md) to get started.

### 🌟 Ways to Contribute

1. **Star this repo** - It helps others discover these modules
2. **Share your experience** - Write a blog post or tweet about your usage
3. **Submit feedback** - Open issues with suggestions or bug reports
4. **Code contributions** - Submit PRs for new features or fixes
5. **Documentation** - Help improve guides and examples

## 📚 Documentation

<div align="center">

| 📖 **Guide** | 🎯 **Purpose** |
|:---|:---|
| [📚 Usage Guide](docs/USAGE.md) | Complete module usage, versioning, and advanced patterns |
| [🛠️ Development Setup](docs/DEV_SETUP.md) | Set up your development environment |
| [📦 Modules Guide](docs/MODULES.md) | How to use and create modules |
| [⭐ Best Practices](docs/BEST_PRACTICES.md) | Module design, security, and guidelines |
| [🚀 Versioning Strategy](docs/VERSIONING.md) | Release management and versioning |
| [🔄 GitHub Actions](docs/GITHUB_ACTIONS.md) | CI/CD workflows and automation |
| [🤝 Contributing](docs/CONTRIBUTING_GUIDELINES.md) | How to contribute to this repository |

</div>

## 📚 Additional Resources

- 🚀 [Awesome NAN](https://github.com/nanlabs/awesome-nan) - Best practices and resources
- 📖 [Terraform Documentation](https://www.terraform.io/docs/index.html) - Official Terraform docs
- ☁️ [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) - AWS provider reference
- 💬 [NaN Labs Blog](https://www.nan-labs.com/blog) - Technical articles and insights

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Contributors

[![Contributors](https://contrib.rocks/image?repo=nanlabs/terraform-aws-modules)](https://github.com/nanlabs/terraform-aws-modules/graphs/contributors)

Made with [contributors-img](https://contrib.rocks).

---

<div align="center">

### 🌟 Built with ❤️ by [NaN Labs](https://www.nan-labs.com/)

[![Website](https://img.shields.io/badge/website-nan--labs.com-blue?style=flat-square)](https://nan-labs.com/)
[![LinkedIn](https://img.shields.io/badge/linkedin-nanlabs-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/company/nan-labs/)

🚀 Accelerating development through proven technology solutions

</div>
