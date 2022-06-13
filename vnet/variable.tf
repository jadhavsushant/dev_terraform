
#####################
# vnet + subnet (cosmosdb_vnet)
#####################


variable "vnet_name" {
  type    = string
  default = "vnet-cosmosdb"
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.0.0.4", "10.0.0.5"]

}

variable "vpn_subnet_name" {
  type    = string
  default = "vpn_subnet"
}

variable "vpn_address_prefix" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}



#####################
# no_cosmos_db
#####################

variable "default_subnet_name" {
  type    = string
  default = "non-vpn-subnet"
}

variable "default_address_prefix" {
  type    = list(string)
  default = ["10.0.2.0/24"]

}


#####################
# nsg
#####################

variable "default_nsg_name" {
  type    = string
  default = "default-subnet-nsg"

}


#####################
# rg
#####################


variable "rg_location" {
  type = string
}

variable "rg_name" {
  type = string
}

