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

variable "data_factory_credential" {
  type = map(object({
    name                 = string
    data_factory_id      = string
    tenant_id            = string
    service_principal_id = string
    annotations          = optional(list(string), null)
    description          = optional(string, null)

    service_principal_key = optional(object({
      linked_service_name = string
      secret_name         = string
      secret_version      = optional(string, null)
    }), null)
  }))
  default = {}

  description = <<DESCRIPTION
    A map of Azure Data Factory Credentials, where each key represents a unique configuration.
    Each object in the map consists of the following properties:

    - `name` - (Required) The unique name of the credential.
    - `data_factory_id` - (Required) The ID of the Data Factory where the credential is associated.
    - `tenant_id` - (Required) The Tenant ID of the Service Principal.
    - `service_principal_id` - (Required) The Client ID of the Service Principal.
    - `annotations` - (Optional) A list of tags to annotate the credential.
    - `description` - (Optional) A description of the credential.
    - `service_principal_key` - (Optional) A block defining the service principal key details.
      - `linked_service_name` - (Required) The name of the Linked Service to use for the Service Principal Key.
      - `secret_name` - (Required) The name of the Secret in the Key Vault.
      - `secret_version` - (Optional) The version of the Secret in the Key Vault.
  DESCRIPTION
}

variable "data_factory_credential_user_managed_identity" {
  type = map(object({
    name            = string
    data_factory_id = string
    identity_id     = string
    annotations     = optional(list(string), null)
    description     = optional(string, null)
  }))
  default = {}

  description = <<DESCRIPTION
    A map of Azure Data Factory Credentials using User Assigned Managed Identity, where each key represents a unique configuration.
    Each object in the map consists of the following properties:

    - `name` - (Required) The unique name of the credential.
    - `data_factory_id` - (Required) The ID of the Data Factory where the credential is associated.
    - `identity_id` - (Required) The Resource ID of an existing User Assigned Managed Identity. **Attempting to create a Credential resource without first assigning the identity to the parent Data Factory will result in an Azure API error.**
    - `annotations` - (Optional) A list of tags to annotate the credential. **Manually altering the resource may cause annotations to be lost.**
    - `description` - (Optional) A description of the credential.
  DESCRIPTION
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

variable "linked_service_azure_file_storage" {
  type = map(object({
    name                     = string
    data_factory_id          = string
    description              = optional(string, null)
    host                     = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations              = optional(list(string), null)
    parameters               = optional(map(string), null)
    password                 = optional(string, null)
    user_id                  = optional(string, null)
    additional_properties    = optional(map(string), null)
    connection_string        = string
    file_share               = optional(string, null)
    key_vault_password = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
  }))
  default = {}

  description = <<DESCRIPTION
    A map of Azure Data Factory Linked Services for Azure File Storage, where each key represents a unique configuration.
    Each object in the map consists of the following properties:

    - `name` - (Required) The unique name of the linked service.
    - `data_factory_id` - (Required) The ID of the Data Factory where the linked service is associated.
    - `description` - (Optional) A description of the linked service.
    - `host` - (Optional) The Host name of the server.
    - `integration_runtime_name` - (Optional) The integration runtime reference.
    - `annotations` - (Optional) A list of tags to annotate the linked service.
    - `parameters` - (Optional) A map of parameters.
    - `password` - (Optional) The password to log in to the server.
    - `user_id` - (Optional) The user ID to log in to the server.
    - `additional_properties` - (Optional) Additional custom properties.
    - `connection_string` - (Required) The connection string.
    - `file_share` - (Optional) The name of the file share.

    ### Key Vault Password Block:
    - `key_vault_password` - (Optional) Use an existing Key Vault to store the Azure File Storage password.
      - `linked_service_name` - (Required) The name of the Key Vault Linked Service.
      - `secret_name` - (Required) The secret storing the Azure File Storage password.
    DESCRIPTION
}

variable "linked_service_azure_sql_database" {
  type = map(object({
    name                     = string
    data_factory_id          = string
    connection_string        = optional(string, null)
    use_managed_identity     = optional(bool, null)
    service_principal_id     = optional(string, null)
    service_principal_key    = optional(string, null)
    tenant_id                = optional(string, null)
    description              = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations              = optional(list(string), null)
    parameters               = optional(map(string), null)
    additional_properties    = optional(map(string), null)
    credential_name          = optional(string, null)

    key_vault_connection_string = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)

    key_vault_password = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
  }))
  default = {}

  description = <<DESCRIPTION
    A map of Azure Data Factory Linked Services for Azure SQL Database, where each key represents a unique configuration.
    Each object in the map consists of the following properties:

    - `name` - (Required) The unique name of the linked service.
    - `data_factory_id` - (Required) The ID of the Data Factory where the linked service is associated.
    - `connection_string` - (Optional) The connection string used to authenticate with Azure SQL Database. **Exactly one of** `connection_string` **or** `key_vault_connection_string` **must be specified.**
    - `use_managed_identity` - (Optional) Whether to use the Data Factory's managed identity for authentication. **Incompatible with** `service_principal_id` **and** `service_principal_key`.
    - `service_principal_id` - (Optional) The service principal ID for authentication. **Required if** `service_principal_key` **is set.**
    - `service_principal_key` - (Optional) The service principal key (password) for authentication. **Required if** `service_principal_id` **is set.**
    - `tenant_id` - (Optional) The tenant ID for authentication.
    - `description` - (Optional) A description of the linked service.
    - `integration_runtime_name` - (Optional) The integration runtime reference.
    - `annotations` - (Optional) A list of tags to annotate the linked service.
    - `parameters` - (Optional) A map of parameters.
    - `additional_properties` - (Optional) Additional custom properties.
    - `credential_name` - (Optional) The name of a User-assigned Managed Identity for authentication.
    - `key_vault_connection_string` - (Optional) Use an existing Key Vault to store the Azure SQL Database connection string.
      - `linked_service_name` - (Required) The name of the Key Vault Linked Service.
      - `secret_name` - (Required) The secret storing the SQL Server connection string.
    - `key_vault_password` - (Optional) Use an existing Key Vault to store the Azure SQL Database password.
      - `linked_service_name` - (Required) The name of the Key Vault Linked Service.
      - `secret_name` - (Required) The secret storing the SQL Server password.
  DESCRIPTION
}

variable "linked_service_data_lake_storage_gen2" {
  type = map(object({
    name                     = string
    data_factory_id          = string
    description              = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations              = optional(list(string), null)
    parameters               = optional(map(string), null)
    additional_properties    = optional(map(string), null)
    url                      = string
    storage_account_key      = optional(string, null)
    use_managed_identity     = optional(bool, null)
    service_principal_id     = optional(string, null)
    service_principal_key    = optional(string, null)
    tenant                   = optional(string, null)
  }))
  default = {}

  description = <<DESCRIPTION
    A map of Azure Data Factory Linked Services for Data Lake Storage Gen2, where each key represents a unique configuration.
    Each object in the map consists of the following properties:

    - `name` - (Required) The unique name of the linked service.
    - `data_factory_id` - (Required) The ID of the Data Factory where the linked service is associated.
    - `description` - (Optional) A description of the linked service.
    - `integration_runtime_name` - (Optional) The integration runtime reference.
    - `annotations` - (Optional) A list of tags to annotate the linked service.
    - `parameters` - (Optional) A map of parameters.
    - `additional_properties` - (Optional) Additional custom properties.
    - `url` - (Required) The endpoint for the Azure Data Lake Storage Gen2 service.

    ### Authentication Options (Only one can be set):
    - `storage_account_key` - (Optional) The Storage Account Key used for authentication. **Incompatible with** `service_principal_id`, `service_principal_key`, `tenant`, and `use_managed_identity`.
    - `use_managed_identity` - (Optional) Whether to use the Data Factory's managed identity for authentication. **Incompatible with** `service_principal_id`, `service_principal_key`, `tenant`, and `storage_account_key`.
    - `service_principal_id` - (Optional) The service principal ID used for authentication. **Incompatible with** `storage_account_key` and `use_managed_identity`.
    - `service_principal_key` - (Optional) The service principal key used for authentication. **Required if** `service_principal_id` **is set.**
    - `tenant` - (Optional) The tenant ID where the service principal exists. **Required if** `service_principal_id` **is set.**
  DESCRIPTION
}

variable "linked_service_key_vault" {
  type = map(object({
    name                     = string
    data_factory_id          = string
    key_vault_id             = string
    description              = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations              = optional(list(string), null)
    parameters               = optional(map(string), null)
    additional_properties    = optional(map(string), null)
  }))
  default = {}

  description = <<DESCRIPTION
    A map of Azure Data Factory Linked Services for Azure Key Vault, where each key represents a unique configuration.
    Each object in the map consists of the following properties:

    - `name` - (Required) The unique name of the linked service.
    - `data_factory_id` - (Required) The ID of the Data Factory where the linked service is associated.
    - `key_vault_id` - (Required) The ID of the Azure Key Vault resource.
    - `description` - (Optional) A description of the linked service.
    - `integration_runtime_name` - (Optional) The integration runtime reference.
    - `annotations` - (Optional) A list of tags to annotate the linked service.
    - `parameters` - (Optional) A map of parameters.
    - `additional_properties` - (Optional) Additional custom properties.
  DESCRIPTION
}