output "cosmosdb_id" {
  value = azurerm_cosmosdb_account.db.id
}

output "cosmosdb_connection_strings" {
  value = azurerm_cosmosdb_account.db.connection_strings
}


output "cosmosdb_account_name" {
  value = azurerm_cosmosdb_account.db.name

}