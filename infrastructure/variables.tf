
variable "azure_ai_token" {
  description = "The API token or key for accessing Azure AI services."
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "The Azure Subscription ID to deploy resources into."
  type        = string
}

