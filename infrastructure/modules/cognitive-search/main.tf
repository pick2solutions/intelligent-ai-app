terraform {
  required_providers {
    restapi = {
      source  = "mastercard/restapi"
      version = "2.0.1"
    }
  }
  required_version = ">= 1.10.0"
}

## ------
## REST API Client - Indexer, Index, and Data Source are not ARM resources
## ------
provider "restapi" {
  uri                  = "https://${azurerm_search_service.search.name}.search.windows.net"
  write_returns_object = true
  debug                = true

  headers = {
    "api-key"      = azurerm_search_service.search.primary_key,
    "Content-Type" = "application/json"
  }

  create_method  = "POST"
  update_method  = "PUT"
  destroy_method = "DELETE"
}


## ------
## Azure Search Service
## ------
resource "azurerm_search_service" "search" {
  name                = var.search_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  identity {
    type = "SystemAssigned"
  }
  semantic_search_sku          = var.semantic_search_sku
  local_authentication_enabled = true
  authentication_failure_mode  = "http403"
}

## ------
## Role Assignment for Storage Account
## ------
resource "azurerm_role_assignment" "search_to_storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_search_service.search.identity[0].principal_id
  depends_on           = [azurerm_search_service.search]
}

## ------
## Indexes
## ------
resource "restapi_object" "create_indexes" {
  for_each                  = var.index_jsons
  path                      = "/indexes"
  query_string              = "api-version=2025-05-01-preview"
  data                      = each.value
  id_attribute              = "name" # The ID field on the response
  ignore_all_server_changes = true
}

## ------
## Skillsets
## ------
resource "restapi_object" "create_skillsets" {
  for_each                  = var.skillset_jsons
  path                      = "/skillsets"
  query_string              = "api-version=2025-05-01-preview"
  data                      = each.value
  id_attribute              = "name" # The ID field on the response
  ignore_all_server_changes = true
  depends_on = [
    azurerm_role_assignment.search_to_storage
  ]
}

## ------
## Indexers
## ------
resource "restapi_object" "create_indexers" {
  for_each                  = var.indexer_jsons
  path                      = "/indexers"
  query_string              = "api-version=2025-05-01-preview"
  data                      = each.value
  id_attribute              = "name" # The ID field on the response
  ignore_all_server_changes = true
  depends_on = [
    azurerm_role_assignment.search_to_storage,
    restapi_object.create_datasources,
    restapi_object.create_skillsets
  ]
}

## ------
## Data Sources
## ------
resource "restapi_object" "create_datasources" {
  for_each                  = var.datasource_jsons
  path                      = "/datasources"
  query_string              = "api-version=2025-05-01-preview"
  data                      = each.value
  id_attribute              = "name" # The ID field on the response
  ignore_all_server_changes = true
  depends_on = [
    azurerm_role_assignment.search_to_storage,
  ]
}