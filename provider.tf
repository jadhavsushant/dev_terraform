terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.23.0"
    }
  }
}

provider "azurerm" {
  features {
  }
  # Configuration options
}

provider "random" {
  # Configuration options
}

provider "azuread" {
  # Configuration options
}
