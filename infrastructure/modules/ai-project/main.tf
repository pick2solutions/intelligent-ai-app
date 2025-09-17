## ------
## Have to register non-terraform providers
## ------
terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = ">= 2.5.0"
    }
  }
  required_version = ">= 1.10.0"
}

locals {
  tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

## ------
## Storage Account
## ------
resource "azurerm_storage_account" "ai_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}

## ------
## Azure Key Vault
## ------
module "keyvault" {
  source              = "../keyvault"
  key_vault_name      = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

## ------
## AI Service
## ------
resource "azurerm_ai_services" "foundry" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  custom_subdomain_name = var.name
  sku_name              = "S0"
  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}


## ------
## Enable Project Management for AI Foundry
## ------
resource "azapi_resource_action" "ai_foundry_project_management" {
  type        = "Microsoft.CognitiveServices/accounts@2025-04-01-preview"
  resource_id = azurerm_ai_services.foundry.id
  method      = "PATCH"

  body = {
    properties = {
      allowProjectManagement = true
    }
  }
}


## ------
## Default Foundry Project
## ------
resource "azapi_resource" "ai_foundry_project" {
  for_each  = var.foundry_projects
  type      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name      = "${each.key}"
  parent_id = azurerm_ai_services.foundry.id
  location  = var.location

  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      displayName = each.value.friendly_name
      description = each.value.description
    }
  }

  depends_on = [azapi_resource_action.ai_foundry_project_management]
}