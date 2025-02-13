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

