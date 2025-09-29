#------------------------------------------------------------------------------
# Required Variables
#------------------------------------------------------------------------------

variable "name" {
  description = "Name prefix for workflow-related resources (align with glue-jobs module name)."
  type        = string
}

variable "tags" {
  description = "Common tags to apply"
  type        = map(string)
  default     = {}
}

# workflows map: each workflow defines a set of triggers; each trigger contains actions (Glue jobs)
# Only job-based actions supported initially (no crawlers to keep scope minimal)
variable "workflows" {
  description = <<EOT
Map of Glue workflows to create. Structure:
{
  workflow_key = {
    description = optional(string)
    triggers = [
      {
        name              = string                      # unique within workflow
        type              = string                      # SCHEDULED | CONDITIONAL | ON_DEMAND | EVENT (EVENT reserved for later use)
        start_on_creation = optional(bool, true)
        schedule          = optional(string)            # required when type == SCHEDULED (cron or rate expression)
        predicate = optional(object({                   # only for CONDITIONAL triggers
          conditions = list(object({
            job_name         = string                   # Existing Glue job name
            state            = string                   # Only "SUCCEEDED" currently supported by AWS Glue
            logical_operator = optional(string, "EQUALS")
          }))
        }))
        actions = list(object({
          job_name              = string                # Existing Glue job name to invoke
          arguments             = optional(map(string), {})
          notification_property = optional(object({
            notify_delay_after = number                 # minutes
          }))
          security_configuration = optional(string)     # if specific security config per action
          timeout               = optional(number)      # override job timeout (minutes)
        }))
      }
    ]
  }
}
EOT
  type = map(object({
    description = optional(string)
    triggers = list(object({
      name              = string
      type              = string
      start_on_creation = optional(bool, true)
      schedule          = optional(string)
      predicate = optional(object({
        conditions = list(object({
          job_name         = string
          state            = string
          logical_operator = optional(string, "EQUALS")
        }))
      }))
      actions = list(object({
        job_name               = string
        arguments              = optional(map(string), {})
        notification_property  = optional(object({ notify_delay_after = number }))
        security_configuration = optional(string)
        timeout                = optional(number)
      }))
    }))
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, wf in var.workflows : alltrue([
        for t in wf.triggers : contains(["SCHEDULED", "CONDITIONAL", "ON_DEMAND", "EVENT"], t.type) &&
        (t.type != "SCHEDULED" || try(length(t.schedule) > 0, false)) &&
        (t.type != "CONDITIONAL" || try(length(t.predicate.conditions) > 0, false))
      ])
    ])
    error_message = "Invalid workflow trigger configuration (check type, schedule for SCHEDULED, predicate.conditions for CONDITIONAL)."
  }
}
