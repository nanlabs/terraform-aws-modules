# Glue Workflows Module
# Creates AWS Glue Workflows and associated Triggers referencing existing Glue Jobs

locals {
  resource_prefix = var.name
  tags            = var.tags
}

# Iterate workflows
resource "aws_glue_workflow" "this" {
  for_each    = var.workflows
  name        = "${local.resource_prefix}-wf-${each.key}"
  description = coalesce(try(each.value.description, null), "Glue workflow ${each.key}")
  tags        = merge(local.tags, { Workflow = each.key })
}

# Flatten triggers into a single collection with composite key
locals {
  trigger_map = merge(
    {}
    ,
    # build map("workflowKey|triggerName" => { workflow_key=..., trigger=object })
    { for wf_key, wf in var.workflows : wf_key => [for t in wf.triggers : {
      workflow_key = wf_key
      trigger      = t
    }] }
  )
  # Flatten list
  trigger_list = flatten([for _, lst in local.trigger_map : lst])
  # Unique key per trigger
  trigger_objects = { for o in local.trigger_list : "${o.workflow_key}|${o.trigger.name}" => o }
}

resource "aws_glue_trigger" "this" {
  for_each = local.trigger_objects

  name              = "${local.resource_prefix}-wf-${each.value.workflow_key}-t-${each.value.trigger.name}"
  type              = each.value.trigger.type
  workflow_name     = aws_glue_workflow.this[each.value.workflow_key].name
  start_on_creation = try(each.value.trigger.start_on_creation, true)

  # Scheduled trigger
  schedule = each.value.trigger.type == "SCHEDULED" ? each.value.trigger.schedule : null

  dynamic "predicate" {
    for_each = each.value.trigger.type == "CONDITIONAL" ? [1] : []
    content {
      dynamic "conditions" {
        for_each = each.value.trigger.predicate.conditions
        content {
          job_name         = conditions.value.job_name
          state            = conditions.value.state
          logical_operator = try(conditions.value.logical_operator, "EQUALS")
        }
      }
    }
  }

  dynamic "actions" {
    for_each = each.value.trigger.actions
    content {
      job_name = actions.value.job_name
      timeout  = try(actions.value.timeout, null)
      dynamic "notification_property" {
        for_each = try(actions.value.notification_property.notify_delay_after, null) != null ? [1] : []
        content {
          notify_delay_after = actions.value.notification_property.notify_delay_after
        }
      }
      # Workaround: arguments attribute directly
      arguments              = length(actions.value.arguments) > 0 ? actions.value.arguments : null
      security_configuration = try(actions.value.security_configuration, null)
    }
  }

  tags = merge(local.tags, {
    Workflow = each.value.workflow_key
    Trigger  = each.value.trigger.name
  })
}
