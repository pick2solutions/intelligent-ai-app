output "account" {
  value = {
    id          = azurerm_ai_services.foundry.id
    endpoint    = azurerm_ai_services.foundry.endpoint
    name        = azurerm_ai_services.foundry.name
    identity_id = azurerm_ai_services.foundry.identity[0].principal_id
  }
}