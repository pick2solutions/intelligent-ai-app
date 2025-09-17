variable "index_jsons" {
  description = "A map of JSON strings for indexes. Keys are index names."
  type        = map(string)
  default     = {}
}

variable "indexer_jsons" {
  description = "A map of JSON strings for indexers. Keys are indexer names."
  type        = map(string)
  default     = {}
}

variable "datasource_jsons" {
  description = "A map of JSON strings for data sources. Keys are data source names."
  type        = map(string)
  default     = {}
}

variable "skillset_jsons" {
  description = "A map of JSON strings defining the skillsets."
  type        = map(string)
  default     = {}
}

variable "search_service_name" {
  description = "The name of the Azure Search Service."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Azure Search Service is deployed."
  type        = string
}

variable "location" {
  description = "The Azure region where the Azure Search Service is deployed."
  type        = string
}

variable "sku" {
  description = "The SKU of the Azure Search Service (e.g., 'Basic', 'Standard', 'Standard2')."
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the storage account to be used as a data source."
  type        = string
}

variable "semantic_search_sku" {
  description = "value for semantic search SKU"
  type        = string
  default     = "standard"
}