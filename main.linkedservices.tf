resource "azurerm_data_factory_linked_service_azure_blob_storage" "linked_service_azure_blob_storage" {
  for_each = var.linked_service_azure_blob_storage

  name                       = each.value.name
  data_factory_id            = azurerm_data_factory.this.id
  description                = each.value.description
  integration_runtime_name   = each.value.integration_runtime_name
  annotations                = each.value.annotations
  parameters                 = each.value.parameters
  additional_properties      = each.value.additional_properties
  connection_string          = each.value.connection_string
  connection_string_insecure = each.value.connection_string_insecure
  sas_uri                    = each.value.sas_uri
  service_endpoint           = each.value.service_endpoint
  use_managed_identity       = each.value.use_managed_identity
  service_principal_id       = each.value.service_principal_id
  service_principal_key      = each.value.service_principal_key
  storage_kind               = each.value.storage_kind
  tenant_id                  = each.value.tenant_id

  dynamic "key_vault_sas_token" {
    for_each = each.value.key_vault_sas_token != null ? [each.value.key_vault_sas_token] : []

    content {
      linked_service_name = key_vault_sas_token.value.linked_service_name
      secret_name         = key_vault_sas_token.value.secret_name
    }
  }

  dynamic "service_principal_linked_key_vault_key" {
    for_each = each.value.service_principal_linked_key_vault_key != null ? [each.value.service_principal_linked_key_vault_key] : []
    content {
      linked_service_name = service_principal_linked_key_vault_key.value.linked_service_name
      secret_name         = service_principal_linked_key_vault_key.value.secret_name
    }
  }
}
