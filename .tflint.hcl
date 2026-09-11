# TFlint configuration: this repository is AWS-only, so declare only the AWS
# ruleset plugin. This avoids downloading unrelated provider plugins (e.g.
# azurerm from MegaLinter's default config), whose registry fetch has failed
# the MegaLinter gate with transient GitHub API 401s.
plugin "aws" {
  enabled = true
  version = "0.48.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
