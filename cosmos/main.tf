
data "azurerm_client_config" "current" {
}

###############
# cosmos db
###############

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}


resource "azurerm_cosmosdb_account" "db" {
  name                          = "tfex-cosmos-db-${random_integer.ri.result}"
  location                      = var.rg_location
  resource_group_name           = var.rg_name
  offer_type                    = var.cosmosdb_offer_type
  kind                          = var.cosmosdb_kind
  enable_automatic_failover     = false
  public_network_access_enabled = false
  default_identity_type         = "FirstPartyIdentity"

  ip_range_filter = join(",", var.ip_range_filter)
  is_virtual_network_filter_enabled = true

  virtual_network_rule {
    id                                   = var.vpn_subnet_id
    ignore_missing_vnet_service_endpoint = true
  }

  key_vault_key_id = var.cosmos_cmk_versionless_id

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

