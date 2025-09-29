# Provider Configuration

provider "aws" {
  region = var.region

  default_tags {
    tags = merge(var.tags, {
      Platform = "SecureMultiEnvironmentDataPlatform"
    })
  }
}