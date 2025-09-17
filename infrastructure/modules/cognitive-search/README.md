# Azure Cognitive Search Terraform Module

This Terraform module provisions an Azure Cognitive Search service and configures indexes, indexers, and data sources using REST API resources. It also assigns the necessary role to the search service for accessing a provided storage account.

## Features

- Creates an Azure Cognitive Search service.
- Configures indexes, indexers, and data sources dynamically based on JSON inputs.
- Assigns the `Storage Blob Data Reader` role to the search service for the specified storage account.

## Usage

```hcl
module "cognitive_search" {
  source = "./modules/cognitive-search"

  # Azure Cognitive Search Service Configuration
  search_service_name = "my-search-service"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  sku                 = "Standard"

  # Storage Account ID for Role Assignment
  storage_account_id = azurerm_storage_account.my_storage_account.id

  # Data Sources Configuration
  datasource_jsons = {
    datasource1 = jsonencode({
      name = "datasource1"
      type = "azureblob"
      container = { name = "my-container" }
    })
  }

  # Indexes Configuration
  index_jsons = {
    index1 = jsonencode({
      name = "index1"
      fields = [
        { name = "id", type = "Edm.String", key = true, searchable = false },
        { name = "content", type = "Edm.String", searchable = true }
      ]
    })
  }

  # Indexers Configuration
  indexer_jsons = {
    indexer1 = jsonencode({
      name = "indexer1"
      dataSourceName = "datasource1"
      targetIndexName = "index1"
    })
  }
}