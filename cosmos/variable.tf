
variable "random_int" {
  type = number
}

variable "rg_location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "cosmosdb_offer_type" {
  type    = string
  default = "Standard"
}

variable "cosmosdb_kind" {
  type    = string
  default = "GlobalDocumentDB"
}

variable "ip_range_filter" {
  type    = list(string)
  default = ["0.0.0.0"]
}

variable "vpn_subnet_id" {
  type = string
}

variable "cosmos_cmk_versionless_id" {
  type = string
}