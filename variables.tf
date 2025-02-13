########## Required variables
variable "location" {
  type        = string
  description = "The Azure region where this and supporting resources should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the this resource."

  validation {
    condition     = can(regex("^[-A-Za-z0-9]{1,63}$", var.name))
    error_message = "The name must be between 1 and 63 characters long and can only contain alphanumerics and hyphens."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "linked_service_azure_blob_storage" {
  type = map(object({
    name                       = string
    description                = optional(string, null)
    integration_runtime_name   = optional(string, null)
    annotations                = optional(list(string), null)
    parameters                 = optional(map(string), null)
    additional_properties      = optional(map(string), null)
    connection_string          = optional(string, null)
    connection_string_insecure = optional(string, null)
    sas_uri                    = optional(string, null)
    service_endpoint           = optional(string, null)
    use_managed_identity       = optional(bool, null)
    service_principal_id       = optional(string, null)
    service_principal_key      = optional(string, null)
    storage_kind               = optional(string, null)
    tenant_id                  = optional(string, null)

    # Key Vault SAS Token (Optional)
    key_vault_sas_token = optional(object({
      linked_service_name = string
      secret_name         = string
    }), [])

    # Service Principal Linked Key Vault Key (Optional)
    service_principal_linked_key_vault_key = optional(object({
      linked_service_name = string
      secret_name         = string
    }), [])
  }))
  default = {}

  validation {
    condition = alltrue([
      for ls in values(var.linked_service_azure_blob_storage) : length(compact([
        ls.connection_string,
        ls.connection_string_insecure,
        ls.sas_uri,
        ls.service_endpoint
      ])) <= 1
    ])
    error_message = "Only one of connection_string, connection_string_insecure, sas_uri, or service_endpoint may be set per linked service."
  }

  description = <<DESCRIPTION
    A map of Azure Blob Storage linked services, where each key represents a unique linked service configuration.
    Each object in the map consists of the following properties:

    - `name` - (Required) Specifies the name of the Azure Data Factory Linked Service.
    - `description` - (Optional) A description for the linked service.
    - `integration_runtime_name` - (Optional) The integration runtime reference associated with the linked service.
    - `annotations` - (Optional) A list of annotations (tags) for additional metadata.
    - `parameters` - (Optional) A map of parameters to associate with the linked service.
    - `additional_properties` - (Optional) Additional custom properties for the linked service.

    ### Authentication Options (Only one can be set):
    - `connection_string` - (Optional) The secure connection string for the storage account. **Conflicts with** `connection_string_insecure`, `sas_uri`, and `service_endpoint`.
    - `connection_string_insecure` - (Optional) The connection string sent insecurely. **Conflicts with** `connection_string`, `sas_uri`, and `service_endpoint`.
    - `sas_uri` - (Optional) The Shared Access Signature (SAS) URI for authentication. **Conflicts with** `connection_string`, `connection_string_insecure`, and `service_endpoint`.
    - `service_endpoint` - (Optional) The Service Endpoint for direct connectivity. **Conflicts with** `connection_string`, `connection_string_insecure`, and `sas_uri`.

    ### Identity Options:
    - `use_managed_identity` - (Optional) Whether to use a managed identity for authentication.
    - `service_principal_id` - (Optional) The service principal ID for authentication.
    - `service_principal_key` - (Optional) The service principal key (password) for authentication.
    - `tenant_id` - (Optional) The tenant ID for authentication.

    ### Storage Options:
    - `storage_kind` - (Optional) The kind of storage account. Allowed values: `Storage`, `StorageV2`, `BlobStorage`, `BlockBlobStorage`.

    ### Key Vault Options:
    - `key_vault_sas_token` - (Optional) A Key Vault SAS Token object containing:
      - `linked_service_name` - The name of the existing Key Vault Linked Service.
      - `secret_name` - The name of the secret in Azure Key Vault that stores the SAS token.

    - `service_principal_linked_key_vault_key` - (Optional) A Key Vault object for storing the Service Principal Key:
      - `linked_service_name` - The name of the existing Key Vault Linked Service.
      - `secret_name` - The name of the secret in Azure Key Vault that stores the Service Principal Key.
    DESCRIPTION
}


