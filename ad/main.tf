data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "current" {
}


#####################
# COSMOS SPI
#####################

resource "azuread_application" "cosmosdb_ad_app" {
  display_name            = "${var.rg_name}-${var.cosmos_app_name}"
  sign_in_audience        = "AzureADMyOrg"
  group_membership_claims = ["All"]
}

resource "azuread_application_password" "cosmosdb_ad_password" {
  application_object_id = azuread_application.cosmosdb_ad_app.id
  end_date              = "2022-12-01T01:02:03Z"
  display_name          = "app secret"
}

resource "azuread_service_principal" "cosmosdb_ad_spi" {
  application_id               = azuread_application.cosmosdb_ad_app.application_id
  app_role_assignment_required = true
}

resource "azuread_service_principal_password" "cosmosdb_ad_spi_password" {
  service_principal_id = azuread_service_principal.cosmosdb_ad_spi.object_id
  end_date             = "2022-12-01T01:02:03Z"
  display_name         = "spi secret"
}


#####################
# COSMOS Role Assignment
#####################


#this is built-in contributor role
resource "azurerm_role_assignment" "cosmos-contributor" {
  scope                = var.cosmosdb-account-id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.cosmosdb_ad_spi.id
}

resource "azurerm_role_assignment" "private-kv-reader" {
  scope                = var.private_keyvault_id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.cosmosdb_ad_spi.id
}




/* 
resource "azurerm_cosmosdb_sql_role_definition" "example" {
  role_definition_id  = "00000000-0000-0000-0000-000000000001"
  resource_group_name = var.rg_name
  account_name        = var.cosmosdb-account-name
  name                = "accounttestreader"
  assignable_scopes   = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.rg_name}/providers/Microsoft.DocumentDB/databaseAccounts/${var.cosmosdb-account-name}"]

  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata",
    "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*",
    "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"]
  }
} */