variable "key_vault_name" {
  description = "Name of the key vault for the function app secrets."
  type        = string
  validation {
    condition     = var.key_vault_name == null || (can(regex("^[a-z][a-z0-9-]*$", var.key_vault_name)) && length(var.key_vault_name) >= 3 && length(var.key_vault_name) <= 20)
    error_message = "The name must be 3-20 characters long, lowercase, alphanumeric, start with a letter, and may include hyphens."
  }
}

variable "location" {
  description = "Location that the resources should be deployed to."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group the resources should be deployed to."
  type        = string
}

variable "allowed_ip_addresses" {
  description = "List of IP addresses to allow access to the Key Vault."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "key_vault_sku" {
  description = "SKU for Key Vault (default to standard)"
  type        = string
  default     = "standard"
}

variable "secrets" {
  description = "Secrets to be stored in Key Vault."
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the Key Vault."
  type        = bool
  default     = false
}