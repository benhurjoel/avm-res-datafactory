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

variable "linked_service_databricks" {
  type = map(object({
    adb_domain                 = string
    data_factory_id            = string
    name                       = string
    additional_properties      = optional(map(string), null)
    annotations                = optional(list(string), null)
    description                = optional(string, null)
    integration_runtime_name   = optional(string, null)
    parameters                 = optional(map(string), null)
    access_token               = optional(string, null)
    msi_work_space_resource_id = optional(string, null)
    key_vault_password = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
    existing_cluster_id = optional(string, null)
    instance_pool = optional(object({
      instance_pool_id      = string
      cluster_version       = string
      min_number_of_workers = optional(number, 1)
      max_number_of_workers = optional(number, null)
    }), null)
    new_cluster_config = optional(object({
      cluster_version             = string
      node_type                   = string
      driver_node_type            = optional(string, null)
      max_number_of_workers       = optional(number, null)
      min_number_of_workers       = optional(number, 1)
      spark_config                = optional(map(string), null)
      spark_environment_variables = optional(map(string), null)
      custom_tags                 = optional(map(string), null)
      init_scripts                = optional(list(string), null)
      log_destination             = optional(string, null)
    }), null)
  }))
  default = {}

  description = <<DESCRIPTION
    A map of Azure Data Factory Linked Services for Databricks, where each key represents a unique configuration.
    Each object in the map consists of the following properties:

    - `adb_domain` - (Required) The domain URL of the Databricks instance.
    - `data_factory_id` - (Required) The ID of the Data Factory where the linked service is associated.
    - `name` - (Required) The unique name of the linked service.
    - `additional_properties` - (Optional) Additional custom properties.
    - `annotations` - (Optional) A list of tags to annotate the linked service.
    - `description` - (Optional) A description of the linked service.
    - `integration_runtime_name` - (Optional) The integration runtime reference.
    - `parameters` - (Optional) A map of parameters.

    ### Authentication Options (Only one can be set):
    - `access_token` - (Optional) Authenticate to Databricks via an access token.
    - `key_vault_password` - (Optional) Authenticate via Azure Key Vault. 
      - `linked_service_name` - (Required) Name of the Key Vault Linked Service.
      - `secret_name` - (Required) The secret storing the access token.
    - `msi_work_space_resource_id` - (Optional) Authenticate via managed service identity.

    ### Cluster Integration Options (Only one can be set):
    - `existing_cluster_id` - (Optional) The ID of an existing cluster.
    - `instance_pool` - (Optional) Use an instance pool. This requires a nested `instance_pool` block.
      - `instance_pool_id` - (Required) The identifier of the instance pool.
      - `cluster_version` - (Required) The Spark version.
      - `min_number_of_workers` - (Optional) Minimum worker nodes (default: 1).
      - `max_number_of_workers` - (Optional) Maximum worker nodes.
    - `new_cluster_config` - (Optional) Create a new cluster.
      - `cluster_version` - (Required) Spark version.
      - `node_type` - (Required) Node type.
      - `driver_node_type` - (Optional) Driver node type.
      - `max_number_of_workers` - (Optional) Max workers.
      - `min_number_of_workers` - (Optional) Min workers (default: 1).
      - `spark_config` - (Optional) Key-value pairs for Spark configuration.
      - `spark_environment_variables` - (Optional) Spark environment variables.
      - `custom_tags` - (Optional) Tags for the cluster.
      - `init_scripts` - (Optional) Initialization scripts.
      - `log_destination` - (Optional) Log storage location.
    DESCRIPTION
}
