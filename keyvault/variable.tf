#############
# rg
#############

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

#############
# kv variable
#############

variable "pvt_kv_name" {
  type    = string
  default = "cosmos-pvt-kv"
}

variable "sku_name" {
  type    = string
  default = "standard"

}

variable "random_string" {
  type = string
}

#############
# kv access
#############

variable "pvt_key_permissions" {
  type = list(string)
  default = [
    "Create",
    "Delete",
    "Get",
    "List",
    "Update",
    "WrapKey",
    "UnwrapKey"
  ]
}

variable "pvt_secret_permissions" {
  type = list(string)
  default = ["Backup",
    "Delete",
    "Get",
    "List",
    "Recover",
    "Restore",
  "Set"]

}


variable "cosmosdb_spi_object_id" {
  type = string
}

/* variable "cosmosdb-resource-id" {
  type    = string
  default = "a232010e-820c-4083-83bb-3ace5fc29d0b"
} */

variable "cmk_managed_permission" {
  type    = list(string)
  default = ["Get", "UnwrapKey", "WrapKey"]

}

variable "cosmosdb-defult-name" {
  type    = string
  default = "Azure Cosmos DB"
}
