output "search_service" {
  description = "search service information"
  value = {
    id           = azurerm_search_service.search.id
    name         = azurerm_search_service.search.name
    principal_id = azurerm_search_service.search.identity[0].principal_id
  }
}