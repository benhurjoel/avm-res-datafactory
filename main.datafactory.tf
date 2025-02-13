

resource "azurerm_data_factory" "this" {
  name                = var.name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  public_network_enabled = var.public_network_enabled
  customer_managed_key_id = var.customer_managed_key_id
  customer_managed_key_identity_id = var.customer_managed_key_identity_id
  purview_id = var.purview_id
  tags = var.tags

  dynamic "github_configuration" {
    for_each = var.github_configuration != null ? [var.github_configuration] : []
    content {
      account_name = github_configuration.value.account_name
      brbranch_name = github_configuration.value.branch_name
      git_url = github_configuration.value.git_url
      repository_name = github_configuration.value.repository_name
      root_folder = github_configuration.value.root_folder
      ppublishing_enabled = github_configuration.value.publishing_enabled
        
        
        }
    
  }

  dynamic "global_parameter" {
    for_each = var.global_parameter != null ? [var.global_parameter] : []
    content {
      name = global_parameter.value.name
      type = global_parameter.value.type
      value = global_parameter.value.value
    }
    
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type = identity.value.type
      user_assigned_identity_id = identity
    
  }

  dynamic "vsts_configuration" {
    for_each = var.vsts_configuration != null ? [var.vsts_configuration] : []
    content {
      account_name = vsts_configuration.value.account_name
      branch_name = vsts_configuration.value.branch_name
      project_name = vsts_configuration.value.project_name
      repository_name = vsts_configuration.value.repository_name
      root_folder = vsts_configuration.value.root_folder
      tenant_id = vsts_configuration.value.tenant_id
    }
    
  }`
}




resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_data_factory.this.id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."

  depends_on = [
    azurerm_data_factory.this
  ]
}