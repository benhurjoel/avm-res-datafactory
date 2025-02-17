provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Naming Module for Consistent Resource Names
module "naming" {
  source = "Azure/naming/azurerm"
  prefix = ["test"]
  suffix = ["01"]
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = module.naming.resource_group.name
  location = "southeastasia"
}

# Create Resource Group
resource "azurerm_resource_group" "host" {
  name     = module.naming.resource_group.name
  location = "southeastasia"
}

resource "azurerm_data_factory" "host" {
  name                = module.naming.data_factory.name
  location            = azurerm_resource_group.host.location
  resource_group_name = azurerm_resource_group.host.name
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "host" {
  name            = module.naming.data_factory_integration_runtime_managed.name
  data_factory_id = azurerm_data_factory.host.id
}



module "df_with_integration_runtime_self_hosted" {
  source = "../../" # Adjust this path based on your module's location

  # Required variables (adjust values accordingly)
  name                = module.naming.data_factory.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  integration_runtime_self_hosted = {
    example = {
      name        = module.naming.data_factory_integration_runtime_managed.name
      description = "test description"
      rbac_authorization = {
        resource_id = azurerm_data_factory_integration_runtime_self_hosted.host.id
      }
    }
  }

}


