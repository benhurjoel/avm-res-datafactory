terraform {
  required_version = "~> 1.7"
  required_providers {
    # azapi = {
    #   source  = "Azure/azapi"
    #   version = "~> 1.15"
    # }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}