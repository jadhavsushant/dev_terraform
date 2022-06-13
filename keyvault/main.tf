data "azurerm_client_config" "current" {}


#############
# Keyvault
#############

resource "azurerm_key_vault" "pvt_kv" {
  name                        = "${var.pvt_kv_name}-${var.random_string}"
  location                    = var.rg_location
  resource_group_name         = var.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = var.sku_name

  /* network_acls {
      default_action = "Deny"
      bypass = "None"
      ip_rules = ["0.0.0.0/24"]
  } */
}


##########################
# Keyvault policy
##########################

## firstparty identity which is provided by Microsoft
data "azuread_service_principal" "cosmosdb-first-party-id" {
  display_name = var.cosmosdb-defult-name
}

## login in user keyvault access ploicy
resource "azurerm_key_vault_access_policy" "pvt_kv_current" {
  key_vault_id = azurerm_key_vault.pvt_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions    = var.pvt_key_permissions
  /* secret_permissions = var.pvt_secret_permissions */

  depends_on = [
    azurerm_key_vault.pvt_kv
  ]
}


resource "azurerm_key_vault_access_policy" "cosmos-db-account" {

  key_vault_id = azurerm_key_vault.pvt_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_service_principal.cosmosdb-first-party-id.id

  key_permissions    = var.cmk_managed_permission

  depends_on = [
    azurerm_key_vault.pvt_kv,
    azurerm_key_vault_access_policy.pvt_kv_current
  ]
}



## cosmso db spi
resource "azurerm_key_vault_access_policy" "pvt_kv_cosmosdb" {
  key_vault_id = azurerm_key_vault.pvt_kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.cosmosdb_spi_object_id

  key_permissions    = var.pvt_key_permissions
  secret_permissions = var.pvt_secret_permissions

  depends_on = [
    azurerm_key_vault.pvt_kv
  ]
}



##########################
# generate key
##########################

resource "azurerm_key_vault_key" "cosmos_encryption_key" {
  name            = "cosmosdb-encryption-key"
  key_vault_id    = azurerm_key_vault.pvt_kv.id
  key_type        = "RSA"
  key_size        = 2048
  expiration_date = "2022-12-31T23:59:00Z"

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [
    azurerm_key_vault.pvt_kv,
    azurerm_key_vault_access_policy.pvt_kv_cosmosdb,
    azurerm_key_vault_access_policy.pvt_kv_current,
    azurerm_key_vault_access_policy.cosmos-db-account,
  ]
}