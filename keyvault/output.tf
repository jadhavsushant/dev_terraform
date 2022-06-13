output "pvt_kv_id" {
  value = azurerm_key_vault.pvt_kv.id
}

output "pvt_kv_versionless_id" {
  value = azurerm_key_vault_key.cosmos_encryption_key.versionless_id
}