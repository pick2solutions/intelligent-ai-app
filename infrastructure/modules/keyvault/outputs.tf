## ------
## Azure Key Vault
## ------
output "key_vault" {
  description = "key vault resource"
  value = {
    id : azurerm_key_vault.vault.id,
    vault_uri : azurerm_key_vault.vault.vault_uri
  }
}

output "secrets" {
  value = local.secrets_map
}