variable "name" {
  description = "The name of the AI Foundry resource."
  type        = string
}

variable "location" {
  description = "The location/region where the resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the AI Foundry resource will be created."
  type        = string
}

variable "friendly_name" {
  description = "A friendly name for the AI Foundry resource."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account to be used by the AI Foundry resource."
  type        = string
}

variable "key_vault_name" {
  description = "The name of the Azure Key Vault to be used by the AI Foundry resource."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "foundry_projects" {
  description = <<EOT
A map of projects to create under the AI Foundry resource. Each key is the project name, 
and the value is an object containing 'friendly_name' and 'description'.
EOT
  type = map(object({
    friendly_name = string
    description   = string
  }))
}