resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "West Europe"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "tfex-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = false

  analytical_storage {
    schema_type = "WellDefined"
  }

  analytical_storage_enabled = true

  identity {
    type = "SystemAssigned"
  }

  capabilities {
    name = "EnableAggregationPipeline"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    failover_priority = 0
    location = "westeurope"
  }
}



resource "null_resource" "db" {
  provisioner "local-exec" {
    command = <<EOT
    az cosmosdb update --name tfex-cosmos-db-11864 --resource-group example-resource-group --default-identity 'SystemAssignedIdentity'
    EOT
  }
  depends_on = [
    azurerm_cosmosdb_account.db
  ]
} 
