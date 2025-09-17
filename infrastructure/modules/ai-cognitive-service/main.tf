## ------
## Cognitive Account
## ------
resource "azurerm_cognitive_account" "cognitive_account" {
  count                 = var.create_cognitive_account == true ? 1 : 0
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = var.kind
  sku_name              = var.sku_name
  custom_subdomain_name = var.custom_subdomain_name

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

## ------
## Cognitive Deployments
## ------
resource "azurerm_cognitive_deployment" "cognitive_deployments" {
  for_each = { for idx, deployment in var.deployments : idx => deployment }

  name                 = each.value.name
  cognitive_account_id = var.create_cognitive_account == false ? var.cognitive_account_id : azurerm_cognitive_account.cognitive_account[0].id

  model {
    format  = each.value.model.format
    name    = each.value.model.name
    version = each.value.model.version
  }

  sku {
    name     = each.value.sku.name
    capacity = each.value.sku.capacity != null ? each.value.sku.capacity : 1
  }
}