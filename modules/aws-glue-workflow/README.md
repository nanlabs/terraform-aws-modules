# AWS Glue Workflow Terraform Module

Minimal module to define AWS Glue Workflows and Triggers referencing existing Glue Jobs (created e.g. by
`aws-glue-jobs` module). Focused on job orchestration without advanced branching logic outside what Glue natively
supports.

## Features

- Creates multiple Glue Workflows via a single map input
- Supports trigger types: SCHEDULED, CONDITIONAL, ON_DEMAND (EVENT placeholder)
- Multiple actions (jobs) per trigger
- Predicate conditions for sequential dependencies
- Tag propagation & naming convention alignment

## Usage

### Consume from GitHub (pinned)

```hcl
module "glue-workflow" {
  source = "git::https://github.com/nanlabs/terraform-aws-modules.git//modules/aws-glue-workflow?ref=v1.16.0"
}}
```

> The remaining examples use local paths for repository-local development.
 (Example)

```hcl
module "glue_workflows" {
  source = "../../modules/aws/aws-glue-workflow"
  name   = "dwh-develop"

  workflows = {
    sales_daily = {
      description = "Daily sales pipeline"
      triggers = [
        {
          name     = "ingest"
          type     = "SCHEDULED"
          schedule = "cron(0 2 * * ? *)"
          actions  = [{ job_name = module.glue_jobs.glue_job_names["ingest"] }]
        },
        {
          name = "quality"
          type = "CONDITIONAL"
          predicate = { conditions = [{ job_name = module.glue_jobs.glue_job_names["ingest"], state = "SUCCEEDED" }] }
          actions  = [{ job_name = module.glue_jobs.glue_job_names["quality"] }]
        }
      ]
    }
  }
}
```

## Notes

- For branching on failures consider Step Functions; Glue predicates only support success state.
- Avoid secrets in arguments; reference Secrets Manager ARNs.

## Outputs

- `workflow_names` map
- `trigger_names` map (composite key `workflow|trigger`)
- `workflows_summary` with trigger list per workflow

## TODO / Future Enhancements

- Support Crawler actions
- Add optional CloudWatch dashboard
- EVENT trigger wiring via EventBridge

---
Generated initial version.
