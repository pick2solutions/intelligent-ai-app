data "azurerm_client_config" "current" {
}

locals {
  secrets_map = {
    for key, secret in var.secrets :
    key => azurerm_key_vault_secret.kv_secrets[key].id
  }
}

resource "azurerm_key_vault" "vault" {
  name                          = var.key_vault_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku_name                      = var.key_vault_sku
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  rbac_authorization_enabled    = true
  purge_protection_enabled      = true
  public_network_access_enabled = var.public_network_access_enabled
  tags = merge(
    {
      ManagedBy = "Terraform"
    },
    var.tags
  )
}

resource "azurerm_role_assignment" "client_kv_user" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "kv_secrets" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.vault.id
  depends_on   = [azurerm_role_assignment.client_kv_user]
}