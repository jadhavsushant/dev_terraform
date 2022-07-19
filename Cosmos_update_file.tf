
data "azurerm_client_config" "current" {
}

terraform {
  required_providers {
      azapi = {
      source = "Azure/azapi"
      version = "0.4.0"
    }
  }
}

###############
# cosmos db
###############

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}


resource "azurerm_cosmosdb_account" "db" {
  name                          = "tfex-cosmos-db20220707"
  location                      = var.rg_location
  resource_group_name           = var.rg_name
  offer_type                    = var.cosmosdb_offer_type
  kind                          = var.cosmosdb_kind
  enable_automatic_failover     = false
  public_network_access_enabled = true
  default_identity_type         = "FirstPartyIdentity"
  /* default_identity_type = "SystemAssignedIdentity" */

  ip_range_filter                   = join(",", var.ip_range_filter)
  is_virtual_network_filter_enabled = true

  ## new update
  analytical_storage_enabled = false
  analytical_storage {
    schema_type =  "WellDefined"
  }

  virtual_network_rule {
    id                                   = var.vpn_subnet_id
    ignore_missing_vnet_service_endpoint = true
  }

  ##system managed identity for this cosmosdb resource
  identity {
    type = "SystemAssigned"
  }

  /* key_vault_key_id = var.cosmos_cmk_versionless_id */

  capabilities {
    name = "EnableAggregationPipeline"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.rg_location
    failover_priority = 0
  }
}

################ update it later


resource "azapi_update_resource" "cosmosdb_analytical_storage_enabled" {
  type = "Microsoft.DocumentDB/databaseAccounts@2021-10-15"
  resource_id = azurerm_cosmosdb_account.db.id
  body = jsonencode(
    {
      properties = {
        enableAnalyticalStorage = true
      }
    }
  )
  depends_on = [
    azurerm_cosmosdb_account.db
  ]
}

resource "azapi_update_resource" "cosmosdb_default_id_systemassign" {
  type = "Microsoft.DocumentDB/databaseAccounts@2021-10-15"
  resource_id = azurerm_cosmosdb_account.db.id
  body = jsonencode(
    {
      properties = {
        defaultIdentity = "SystemAssignedIdentity"
      }
    }
  )
  depends_on = [
    azurerm_cosmosdb_account.db,
    azapi_update_resource.cosmosdb_analytical_storage_enabled
  ]
}
