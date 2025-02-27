terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.87"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "basic" {
  source = "../../" # Adjust this path based on your module's location

  # Required variables (adjust values accordingly)
  name                = "test-datafactory"
  resource_group_name = "rg-jay-test-02"
  location            = "southeastasia"
}

