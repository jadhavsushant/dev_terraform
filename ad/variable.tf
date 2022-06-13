#####################
# COSMOS SPI
#####################

variable "rg_name" {
  type = string
}

variable "cosmos_app_name" {
  type    = string
  default = "cosmosdb"
}

variable "cosmosdb-account-id" {
  type = string
}

variable "private_keyvault_id" {
  type = string
}