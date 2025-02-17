provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Single Naming Module for all resources
module "naming" {
  source = "Azure/naming/azurerm"
  prefix = ["test"]
  suffix = ["03"]
}

# Create Resource Group with dynamically generated name
resource "azurerm_resource_group" "rg" {
  name     = module.naming.resource_group.name
  location = "southeastasia"
}

# Create a Storage Account with dynamically generated name
resource "azurerm_storage_account" "storage" {
  name                     = module.naming.storage_account.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create an Azure File Share with dynamically generated name
resource "azurerm_storage_share" "fileshare" {
  name                 = module.naming.storage_share.name
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 5
}

module "df_with_linked_service" {
  source = "../../" # Adjust this path based on your module's location

  # Required variables (adjust values accordingly)
  name                = module.naming.data_factory.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  linked_service_azure_file_storage = {
    example = {
      name              = module.naming.data_factory_linked_service_data_lake_storage_gen2.name
      connection_string = azurerm_storage_account.storage.primary_connection_string
    }
  }

}

