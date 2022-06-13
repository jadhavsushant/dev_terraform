output "vnet_id" {
  value = azurerm_virtual_network.cosmosdb_vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.cosmosdb_vnet.name
}

output "vpn_subnet_id" {
  value = azurerm_subnet.vpn_subnet.id
}