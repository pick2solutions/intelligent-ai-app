## ------
## Cognitive Account Variables
## ------
variable "name" {
  description = "The name of the cognitive account"
  type        = string
}

variable "location" {
  description = "The location/region where the cognitive account will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the cognitive account"
  type        = string
}

variable "kind" {
  description = "The kind of the cognitive account (e.g., OpenAI, TextAnalytics, etc.)"
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the cognitive account (e.g., S0, S1, etc.)"
  type        = string
}

variable "custom_subdomain_name" {
  description = "The custom subdomain name for the cognitive account"
  type        = string
}

variable "create_cognitive_account" {
  description = "Flag to create a new cognitive account. Set to false to use an existing account."
  type        = bool
  default     = false
}

variable "cognitive_account_id" {
  description = "The ID of an existing cognitive account to use instead of creating a new one"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the cognitive account"
  type        = map(string)
  default     = {}
}

## ------
## Cognitive Deployment Variables
## ------
variable "deployments" {
  description = "List of deployment configurations for the cognitive account"
  type = list(object({
    name = string
    model = object({
      format  = string
      name    = string
      version = string
    })
    sku = object({
      name     = string
      capacity = optional(number, null)
    })
  }))
  default = []
}