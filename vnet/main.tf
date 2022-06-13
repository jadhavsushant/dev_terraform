data "azurerm_client_config" "current" {
}


#####################
# vnet
#####################

resource "azurerm_network_security_group" "default_subnet_nsg" {
  name                = var.default_nsg_name
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_virtual_network" "cosmosdb_vnet" {
  name                = var.vnet_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers



  /* subnet {
    name           = var.vpn_subnet_name
    address_prefix = var.vpn_address_prefix
  }

  subnet {
    name           = var.vpn_subnet_name
    address_prefix = var.vpn_address_prefix
    security_group = azurerm_network_security_group.default_subnet_nsg.id
  } */

}

resource "azurerm_subnet" "vpn_subnet" {
  name                 = var.vpn_subnet_name
  address_prefixes     = var.vpn_address_prefix
  virtual_network_name = azurerm_virtual_network.cosmosdb_vnet.name
  resource_group_name  = var.rg_name

  service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.AzureCosmosDB"]

}

resource "azurerm_subnet" "example" {
  name                 = "default_subnet_name"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.cosmosdb_vnet.name
  address_prefixes     = var.default_address_prefix

}
