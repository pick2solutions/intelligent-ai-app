output "account" {
  value = {
    id       = var.create_cognitive_account == true ? azurerm_cognitive_account.cognitive_account[0].id : var.cognitive_account_id
    endpoint = var.create_cognitive_account == true ? azurerm_cognitive_account.cognitive_account[0].endpoint : ""
  }
}