resource "random_string" "unique_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "pick2-intelligent-app-rg"
  location = "East US"
}

## ------
## AI Foundry Account and Project
## ------
module "ai_foundry" {
  source = "git::https://github.com/pick2solutions/pick2-iac-core.git//azure/ai-project?ref=main"

  name                 = "pick2-intelligent-app-foundry"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  friendly_name        = "Pick2 Intelligent AI App Foundry"
  storage_account_name = "pick2aiappsa"
  key_vault_name       = "pick2aiappkv"

  foundry_projects = {
    "intelligent-app-demo" = {
      friendly_name = "Intelligent App Demo"
      description   = "Demo project for the Pick2 Intelligent AI App platform."
      unique_id     = random_string.unique_suffix.result
    }
  }
}

## ------
## AI Model Deployments
## ------
module "openai_deployments" {
  source = "git::https://github.com/pick2solutions/pick2-iac-core.git//azure/ai-cognitive-service?ref=main"

  name                     = "openai-services"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  kind                     = "OpenAI"
  sku_name                 = "S0"
  custom_subdomain_name    = "pick2ai"
  create_cognitive_account = false
  cognitive_account_id     = module.ai_foundry.account.id
  deployments = [
    {
      name = "gpt-4.1"
      model = {
        format  = "OpenAI"
        name    = "gpt-4.1"
        version = "2025-04-14"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 50
      }
    },
    {
      name = "text-embedding-3-large"
      model = {
        format  = "OpenAI"
        name    = "text-embedding-3-large"
        version = "1"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 300
      }
    }
  ]
}



## ------
## AI Agents
## ------
provider "restapi" {
  alias = "ai_foundry"

  uri                   = "https://pick2-intelligent-app-foundry.services.ai.azure.com/api/projects/intelligent-app-demo-${random_string.unique_suffix.result}"
  debug                 = true
  write_returns_object  = true
  create_returns_object = true

  headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${var.azure_ai_token}"
  }
}

module "recruiter_agent" {
  source = "git::https://github.com/pick2solutions/pick2-iac-core.git//azure/ai-agent?ref=main"

  providers = {
    restapi.ai_foundry = restapi.ai_foundry
  }

  project_endpoint    = "https://pick2-intelligent-app-foundry.services.ai.azure.com/api/projects/intelligent-app-demo-${random_string.unique_suffix.result}"
  azure_ai_token      = var.azure_ai_token
  agents = {
    recruiter = {
      name            = "RecruiterAgent"
      instructions    = "Review the provided resume and evaluate whether the candidate is a good fit for the specified role. Consider the candidate’s experience, skills, education, and achievements in relation to the job requirements. Provide a summary of your assessment, highlighting strengths, potential concerns, and a clear recommendation on suitability for the role."
      temperature     = 1
      model           = "gpt-4.1"
      response_format = "auto"
      top_p           = 1
    }
  }
}



## ------
## AI Search
## ------
resource "azurerm_storage_account" "ai_search_data" {
  name                     = "pick2aisearchsa${random_string.unique_suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags = {
    environment = "dev"
    purpose     = "ai-search-data-source"
  }
}

module "ai_search" {
  source = "git::https://github.com/pick2solutions/pick2-iac-core.git//azure/cognitive-search?ref=main"

  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  search_service_name = "pick2aiappsearch"
  sku                 = "basic"
  storage_account_id  = azurerm_storage_account.ai_search_data.id

  #   datasource_jsons = {
  #     for file_name in fileset("${path.module}/data-sources", "*.json") :
  #     file_name => templatefile("${path.module}/data-sources/${file_name}", {
  #       search_service_name  = "pick2aiappsearch"
  #       storage_account_name = ""
  #     })
  #   }

  #   index_jsons = {
  #     for file_name in fileset("${path.module}/indexes", "*.json") :
  #     file_name => templatefile("${path.module}/indexes/${file_name}", {
  #       search_service_name = "pick2aiappsearch"
  #       openai_name         = ""
  #       foundry_name        = module.ai_foundry.account.name
  #     })
  #   }

  #   indexer_jsons = {
  #     for file_name in fileset("${path.module}/indexers", "*.json") :
  #     file_name => templatefile("${path.module}/indexers/${file_name}", {
  #       search_service_name = "pick2aiappsearch"
  #     })
  #   }
}
