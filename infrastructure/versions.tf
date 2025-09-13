terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0"
    }
    restapi = {
        source = "mastercard/restapi"
        version = "2.0.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "pick2_terraform"
    storage_account_name = "pick2terraform"
    container_name       = "tfstate"
    key                  = "ai-demo.terraform.tfstate"
    subscription_id      = "06c81f33-20f5-4c88-81f0-c02c1cfc158f"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
