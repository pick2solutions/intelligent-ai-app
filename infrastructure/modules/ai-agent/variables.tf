variable "project_endpoint" {
  type        = string
  description = "Azure AI Foundry project endpoint"

  validation {
    condition     = can(regex("^https://[^.]+\\.services\\.ai\\.azure\\.com/api/projects/[^/]+$", var.project_endpoint))
    error_message = "Project endpoint must be in the format: https://resource.services.ai.azure.com/api/projects/project-name"
  }
}

variable "azure_ai_token" {
  type        = string
  description = "Azure AI Foundry access token"
}

variable "agents" {
  type = map(object({
    name         = optional(string)
    model        = optional(string)
    description  = optional(string)
    instructions = string
    temperature  = optional(number)
    top_p        = optional(number) # Add this
    metadata     = optional(map(string), {})

    # Add response_format support
    response_format = optional(string)

    tools = optional(list(any), [])

    # Add tool_resources support
    tool_resources = optional(object({
      code_interpreter = optional(object({
        file_ids = optional(list(string), [])
      }))
      file_search = optional(object({
        vector_store_ids = optional(list(string), [])
      }))
      azure_ai_search = optional(object({
        indexes = optional(list(object({
          index_connection_id = string
          index_name          = string
          query_type          = optional(string, "simple")
          top_k               = optional(number, 10)
        })), [])
      }))
    }))
  }))

  description = "Map of agent configurations to create"
}

variable "default_model" {
  type        = string
  description = "Default model for agents that don't specify one"
  default     = "gpt-4o"
}

variable "debug_mode" {
  type        = bool
  description = "Enable debug mode for REST API calls"
  default     = false
}