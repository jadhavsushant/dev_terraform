output "cosmosdb_app_id" {
  value = azuread_application.cosmosdb_ad_app.application_id
}


output "cosmosdb_spi_object_id" {
  value = azuread_service_principal.cosmosdb_ad_spi.object_id
}

output "azuread_app_obj_id" {
  value = azuread_application.cosmosdb_ad_app.object_id
}