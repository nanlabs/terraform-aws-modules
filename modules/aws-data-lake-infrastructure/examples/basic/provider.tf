provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = "example"
      Project     = "data-warehouse"
    }
  }
}
