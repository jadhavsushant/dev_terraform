data "azurerm_client_config" "current" {
}

resource "random_integer" "random_integer" {
  min = 5001
  max = 10000
}

resource "random_string" "kv-random-str" {
  special = false
  length  = 7
  upper   = false
  numeric = false

}

module "ad" {
  source              = "./ad"
  rg_name             = var.rg_name
  cosmosdb-account-id = module.cosmos.cosmosdb_id
  private_keyvault_id = module.keyvault.pvt_kv_id
}

module "vnet" {
  source      = "./vnet"
  rg_name     = var.rg_name
  rg_location = var.rg_location

}

module "keyvault" {
  source                 = "./keyvault"
  random_string          = random_string.kv-random-str.result
  rg_name                = var.rg_name
  rg_location            = var.rg_location
  cosmosdb_spi_object_id = module.ad.cosmosdb_spi_object_id
}

module "cosmos" {
  source                    = "./cosmos"
  rg_name                   = var.rg_name
  rg_location               = var.rg_location
  random_int                = random_integer.random_integer.result
  vpn_subnet_id             = module.vnet.vpn_subnet_id
  cosmos_cmk_versionless_id = module.keyvault.pvt_kv_versionless_id
}
