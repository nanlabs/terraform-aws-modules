<!-- Banner -->
<div align="center">

# 🚀 NaN Labs Terraform Modules

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

## 🎯 How to Use This Repository

<div align="center">

| 📚 **As Reference** | 🏗️ **As Template** | 🧩 **Direct Usage** |
|:---:|:---:|:---:|
| Study our best practices and patterns for your IaC projects | Fork and customize as starting point for your terraform-aws-modules repository | Import modules directly into your Terraform projects |
| Perfect for learning and inspiration | Ideal for teams building their own module library | Ready-to-use modules for immediate deployment |

</div>

---

## ✨ What Makes Our Modules Special?

<div align="center">

| 🏆 **Enterprise-Ready** | 🔒 **Security First** | 💰 **Cost Optimized** | 📊 **Observability** | 🚀 **Developer Experience** |
|:---:|:---:|:---:|:---:|:---:|
| Zero-downtime deployments | Encryption by default | Intelligent scaling | Comprehensive logging | One-command deploy |
| Production-tested patterns | Zero-trust networking | Resource optimization | Monitoring dashboards | Extensive examples |
| High availability design | Compliance ready | Budget-friendly defaults | Alerting ready | Clear documentation |

</div>

### 🎯 Why Choose These Modules?

- **⚡ Faster Time-to-Market**: Deploy in minutes what used to take weeks
- **🛡️ Battle-Tested Reliability**: Used in production by dozens of companies
- **💡 Best Practices Built-In**: Security, performance, and cost optimization from day one
- **🔧 Highly Configurable**: From simple setups to complex enterprise requirements
- **📚 Comprehensive Documentation**: Every module includes examples and detailed guides
- **🤝 Community Driven**: Open source with active maintenance and support

---

## 🎪 Quick Start Examples

Choose your adventure:

### 📘 Example Index & Estimated Monthly Cost

| Example | Path | Core Services | Est. Monthly Cost* | When to Use |
|---------|------|---------------|--------------------|-------------|
| 🌐 Simple Web App | `examples/simple-web-app` | VPC, EC2/ALB (or minimal compute), basic networking | ~$46 | MVPs, prototypes, hackathons |
| ⚙️ Medium Complexity | `examples/medium-complexity-infrastructure` | VPC, EKS, RDS, Bastion, basic logging | ~$300 | Growing microservices, staging clusters |
| 🏢 Complete Enterprise | `examples/complete-enterprise-setup` | Multi-AZ VPC, EKS, RDS (HA), MSK, Bastion, Transit GW, logging, encryption | ~$940 | Production-grade platforms |
| 🔐 Secure Multi-Environment Data Platform | `examples/secure-multi-environment-data-platform` | VPC, CloudTrail, Config, Data Lake, KMS, Glue | ~$420 | Regulated / compliance-focused data workloads |
| 🛰️ Hub & Spoke Networking Architecture | `examples/hub-and-spoke-networking-architecture` | Central VPC + spoke VPCs, Transit Gateway | ~$160 | Multi-team / multi-VPC segmentation |
| 📊 Analytics Platform w/ Document Store | `examples/analytics-platform-with-document-store` | Data Lake, DocumentDB, MSK, Glue, Bastion | ~$780 | Mixed structured + semi-structured analytics |
| 🔄 Data Processing Pipeline | `examples/data-processing-pipeline` | Data Lake, Glue Jobs/Workflow, KMS | ~$180 | Scheduled ETL / batch processing |
| 🧩 Multi-Account Data Platform (Simulated) | `examples/multi-account-data-platform` | Central KMS, Transit GW, Data Lake, Glue, Bastion (aliased providers) | ~$210 | Learning multi-account patterns |

*These cost estimates were calculated at the time each example was authored using on-demand pricing in a common AWS region (e.g., us-east-1) and assume minimal throughput. Actual costs vary by region, usage, data transfer, storage growth, and instance sizing. Always run your own cost validation (AWS Pricing Calculator / Infracost) before production use.

> [!TIP]
> **New here?** Check our [📚 Usage Guide](docs/USAGE.md) or jump to [🎪 Examples](examples/) • [📦 All Modules](#-available-modules)

## 🎯 Motivation

Building and maintaining infrastructure across cloud providers can become repetitive and error-prone. This repository consolidates reusable Terraform modules following best practices, allowing your team to provision infrastructure efficiently, securely, and consistently—whether it's an AWS VPC, a Kubernetes cluster, or a MongoDB Atlas database.

## 📦 Available Modules

<div align="center">

### AWS Infrastructure Modules

</div>

| Module | Description | Use Cases |
|--------|-------------|-----------|
| 🌐 [AWS VPC](modules/aws-vpc/) | Virtual Private Cloud with best practices | Network foundation, multi-AZ setup |
| ⚡ [AWS EKS](modules/aws-eks/) | Managed Kubernetes with essential addons | Microservices, container orchestration |
| 🗄️ [AWS RDS](modules/aws-rds/) | Relational database with monitoring | Application databases, data persistence |
| 🗄️ [AWS RDS Aurora](modules/aws-rds-aurora/) | High-performance Aurora cluster | High-availability databases, read replicas |
| 📨 [AWS MSK](modules/aws-msk/) | Managed Apache Kafka streaming | Event streaming, data pipelines |
| 🏰 [AWS Bastion](modules/aws-bastion/) | Secure jump host with SSM | Secure access, troubleshooting |
| 📊 [AWS DocumentDB](modules/aws-docdb/) | MongoDB-compatible database | Document storage, NoSQL applications |
| 👤 [AWS IAM Role](modules/aws-iam-role/) | IAM roles with best practices | Service permissions, access control |
| 🌍 [AWS Amplify App](modules/aws-amplify-app/) | Frontend hosting and CI/CD | Static sites, SPAs, JAMstack |
| 🔐 [AWS CloudTrail](modules/aws-cloudtrail/) | Organization / account activity logging | Audit, compliance, security monitoring |
| 🛡️ [AWS Config](modules/aws-config/) | Resource configuration tracking & rules | Governance, drift detection |
| 🧱 [AWS Data Lake Encryption](modules/aws-data-lake-encryption/) | Central KMS keys for S3 / Glue | Centralized encryption, key rotation |
| 🗃️ [AWS Data Lake Infrastructure](modules/aws-data-lake-infrastructure/) | Medallion S3 buckets + structure | Bronze/Silver/Gold data zones |
| 🧬 [AWS Glue Code Registry](modules/aws-glue-code-registry/) | Schema / code artifacts registry | ETL governance, versioning |
| 📚 [AWS Glue Data Lake Catalog](modules/aws-glue-data-lake-catalog/) | Database + tables scaffolding | Metadata management |
| 🛠️ [AWS Glue Jobs](modules/aws-glue-jobs/) | Batch / Spark ETL jobs wrapper | Data transformation pipelines |
| 🔄 [AWS Glue Workflow](modules/aws-glue-workflow/) | Orchestrated job scheduling | Dependency / time-based ETL |
| ✈️ [AWS Transit Gateway](modules/aws-transit-gateway/) | Central routing hub | Multi-VPC / multi-account networking |
| 🛰️ [AWS Transit Gateway Spoke](modules/aws-transit-gateway-spoke/) | Attach VPCs to TGW | Hub & spoke expansion |
| 🕸️ [AWS Shared Networking](modules/aws-shared-networking/) | Shared services / DNS / endpoints | Centralized networking services |
| 📦 [AWS TF State Backend](modules/aws-tfstate-backend/) | S3 + DynamoDB backend provisioning | Remote state storage |
| 🔐 [AWS GitHub OIDC Provider](modules/aws-github-oidc-provider/) | Federated CI access (no long-lived keys) | Secure GitHub Actions deployments |

<div align="center">

### Other Cloud Providers

</div>

| Module | Description | Use Cases |
|--------|-------------|-----------|
| 🍃 [MongoDB Atlas Cluster](modules/mongodb-atlas-cluster/) | Managed MongoDB in the cloud | Global databases, serverless apps |

## 🚀 Quick Module Usage

Each module is designed to be **plug-and-play** with sensible defaults, yet highly customizable for complex requirements.

```hcl
module "vpc" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-vpc?ref=v0.2.0"

  vpc_cidr = "10.0.0.0/16"
  # That's it! VPC with best practices is ready 🎉
}
```

> 📖 **Need more details?** Check our [complete usage guide](docs/USAGE.md) with advanced patterns and best practices.

---

## 🎯 Ready to Get Started?

<div align="center">

| 🚀 **Quick Start** | 📚 **Learn More** | 🤝 **Get Help** |
|:---:|:---:|:---:|
| [Browse Examples](examples/) | [Read Documentation](docs/) | [Join Discussions](https://github.com/nanlabs/terraform-aws-modules/discussions) |
| Pick an example that fits your needs | Understand best practices | Ask questions, share ideas |

⭐ **If this project helps you, please consider giving it a star!** ⭐

</div>

---

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
|:---:|:---:|
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
