output "workflow_names" {
  description = "Map of workflow logical keys to actual AWS Glue workflow names"
  value       = { for k, w in aws_glue_workflow.this : k => w.name }
}

output "trigger_names" {
  description = "Map of trigger composite key to trigger name"
  value       = { for k, t in aws_glue_trigger.this : k => t.name }
}

output "workflows_summary" {
  description = "Summary of workflows and triggers"
  value = {
    for wf_key, wf in aws_glue_workflow.this : wf_key => {
      name     = wf.name
      triggers = [for k, t in aws_glue_trigger.this : t.name if regex("^${wf.name}-t-", t.name) != null]
    }
  }
}
