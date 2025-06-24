<!-- Banner -->
<div align="center">

# 🚀 NaN Labs Terraform Modules

## Deploy Production Infrastructure in Minutes, Not Months

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/nanlabs/terraform-modules?style=for-the-badge)](https://github.com/nanlabs/terraform-modules/stargazers)

🔥 **Battle-tested** • 🔒 **Security-first** • 💰 **Cost-optimized** • 🚀 **Developer-friendly**

> From MVP to Enterprise: Infrastructure that scales with your business

</div>

---

## 🎯 How to Use This Repository

<div align="center">

| 📚 **As Reference** | 🏗️ **As Template** | 🧩 **Direct Usage** |
|:---:|:---:|:---:|
| Study our best practices and patterns for your IaC projects | Fork and customize as starting point for your terraform-modules repository | Import modules directly into your Terraform projects |
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

### 🌐 Simple Web App (~$46/month)

Perfect for MVPs and small applications

```bash
cd examples/simple-web-app
terraform init && terraform apply
```

### ⚙️ Medium Complexity (~$300/month)

Microservices with EKS + RDS + Monitoring

```bash
cd examples/medium-complexity-infrastructure
terraform init && terraform apply
```

### 🏢 Complete Enterprise (~$940/month)

Full-scale infrastructure with everything included

```bash
cd examples/complete-enterprise-setup
terraform init && terraform apply
```

> 💡 **New here?** Check our [📚 Usage Guide](docs/USAGE.md) or jump to [🎪 Examples](examples/) • [📦 All Modules](#-available-modules)

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
  source = "git::https://github.com/nanlabs/terraform-modules.git//modules/aws-vpc?ref=v0.2.0"

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
| [Browse Examples](examples/) | [Read Documentation](docs/) | [Join Discussions](https://github.com/nanlabs/terraform-modules/discussions) |
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

[![Contributors](https://contrib.rocks/image?repo=nanlabs/terraform-modules)](https://github.com/nanlabs/terraform-modules/graphs/contributors)

Made with [contributors-img](https://contrib.rocks).

---

<div align="center">

### 🌟 Built with ❤️ by [NaN Labs](https://www.nanlabs.com/)

[![Website](https://img.shields.io/badge/website-nanlabs.com-blue?style=flat-square)](https://www.nanlabs.com/)
[![Twitter](https://img.shields.io/badge/twitter-@nanlabs-1DA1F2?style=flat-square&logo=twitter&logoColor=white)](https://twitter.com/nanlabs)
[![LinkedIn](https://img.shields.io/badge/linkedin-nanlabs-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/company/nanlabs/)

🚀 Accelerating development through proven technology solutions

</div>
