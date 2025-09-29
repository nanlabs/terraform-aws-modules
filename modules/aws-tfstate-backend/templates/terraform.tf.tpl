terraform {
  required_version = ">= ${terraform_version}"

  backend "s3" {
    region       = "${region}"
    bucket       = "${bucket}"
    key          = "${terraform_state_file}"
    profile      = "${profile}"
    encrypt      = "${encrypt}"
    use_lockfile = ${use_lockfile}
    %{~ if role_arn != "" ~}

    assume_role {
      role_arn = "${role_arn}"
    }
    %{~ endif ~}
  }
}
