# Provider configuration
provider "aws" {
  region = var.region

  default_tags {
    tags = merge(var.tags, {
      Platform = "AnalyticsPlatformWithDocumentStore"
    })
  }
}