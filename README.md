<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-cache-redis

This module implements the AVM version of the Azure Cache for Redis and supporting resources.  It includes the standard AVM interfaces.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.7)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.0, < 5.0.0)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azurerm_data_factory.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) (resource)
- [azurerm_data_factory_credential_service_principal.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_credential_service_principal) (resource)
- [azurerm_data_factory_credential_user_managed_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_credential_user_managed_identity) (resource)
- [azurerm_data_factory_integration_runtime_self_hosted.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_self_hosted) (resource)
- [azurerm_data_factory_linked_service_azure_blob_storage.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_blob_storage) (resource)
- [azurerm_data_factory_linked_service_azure_databricks.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_databricks) (resource)
- [azurerm_data_factory_linked_service_azure_file_storage.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_file_storage) (resource)
- [azurerm_data_factory_linked_service_azure_sql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_sql_database) (resource)
- [azurerm_data_factory_linked_service_data_lake_storage_gen2.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_data_lake_storage_gen2) (resource)
- [azurerm_data_factory_linked_service_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_key_vault) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.this_managed_dns_zone_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.this_unmanaged_dns_zone_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint_application_security_group_association) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/Azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/Azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: The Azure region where this and supporting resources should be deployed.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this resource.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_credential_service_principal"></a> [credential\_service\_principal](#input\_credential\_service\_principal)

Description:     A map of Azure Data Factory Credentials, where each key represents a unique configuration.  
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

Type:

```hcl
map(object({
    name                 = string
    data_factory_id      = optional(string)
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
```

Default: `{}`

### <a name="input_credential_user_managed_identity"></a> [credential\_user\_managed\_identity](#input\_credential\_user\_managed\_identity)

Description:     A map of Azure Data Factory Credentials using User Assigned Managed Identity, where each key represents a unique configuration.  
    Each object in the map consists of the following properties:

    - `name` - (Required) The unique name of the credential.
    - `data_factory_id` - (Required) The ID of the Data Factory where the credential is associated.
    - `identity_id` - (Required) The Resource ID of an existing User Assigned Managed Identity. **Attempting to create a Credential resource without first assigning the identity to the parent Data Factory will result in an Azure API error.**
    - `annotations` - (Optional) A list of tags to annotate the credential. **Manually altering the resource may cause annotations to be lost.**
    - `description` - (Optional) A description of the credential.

Type:

```hcl
map(object({
    name            = string
    data_factory_id = optional(string)
    identity_id     = string
    annotations     = optional(list(string), null)
    description     = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_customer_managed_key_id"></a> [customer\_managed\_key\_id](#input\_customer\_managed\_key\_id)

Description: Specifies the Azure Key Vault Key ID to be used as the Customer Managed Key (CMK). Required with user assigned identity.

Type: `string`

Default: `null`

### <a name="input_customer_managed_key_identity_id"></a> [customer\_managed\_key\_identity\_id](#input\_customer\_managed\_key\_identity\_id)

Description: Specifies the ID of the user assigned identity associated with the Customer Managed Key. Must be supplied if customer\_managed\_key\_id is set.

Type: `string`

Default: `null`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description:     This variable controls whether or not telemetry is enabled for the module.  
    For more information see <https://aka.ms/avm/telemetryinfo>.  
    If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_github_configuration"></a> [github\_configuration](#input\_github\_configuration)

Description:   Defines the GitHub configuration for the Data Factory.
  - account\_name: Specifies the GitHub account name.
  - branch\_name: Specifies the branch of the repository to get code from.
  - git\_url: Specifies the GitHub Enterprise host name. Defaults to https://github.com for open source repositories.
  - repository\_name: Specifies the name of the git repository.
  - root\_folder: Specifies the root folder within the repository. Set to / for the top level.
  - publishing\_enabled: Is automated publishing enabled? Defaults to true.
  **You must log in to the Data Factory management UI to complete the authentication to the GitHub repository.**

Type:

```hcl
object({
    account_name       = string
    branch_name        = string
    git_url            = optional(string, null)
    repository_name    = string
    root_folder        = string
    publishing_enabled = optional(bool, true)
  })
```

Default: `null`

### <a name="input_global_parameters"></a> [global\_parameters](#input\_global\_parameters)

Description:   Defines a list of global parameters for the Data Factory.
  - name: Specifies the global parameter name.
  - type: Specifies the global parameter type. Possible values: Array, Bool, Float, Int, Object, or String.
  - value: Specifies the global parameter value.
  **For type Array and Object, it is recommended to use jsonencode() for the value.**

Type:

```hcl
list(object({
    name  = string
    type  = string
    value = any
  }))
```

Default: `[]`

### <a name="input_identity"></a> [identity](#input\_identity)

Description:     Defines the Managed Service Identity for the Data Factory.
    - type: Specifies the type of Managed Service Identity. Possible values: SystemAssigned, UserAssigned, or both.
    - identity\_ids: A list of User Assigned Managed Identity IDs. Required if type includes UserAssigned.

Type:

```hcl
object({
    type         = string
    identity_ids = optional(list(string), [])
  })
```

Default: `null`

### <a name="input_integration_runtime_self_hosted"></a> [integration\_runtime\_self\_hosted](#input\_integration\_runtime\_self\_hosted)

Description:     A map of Azure Data Factory Self-hosted Integration Runtimes, where each key represents a unique configuration.  
    Each object in the map consists of the following properties:
    - `data_factory_id` - (Required) The ID of the Data Factory where the integration runtime is associated.
    - `name` - (Required) The unique name of the integration runtime. Changing this forces a new resource to be created.
    - `description` - (Optional) A description of the integration runtime.
    - `self_contained_interactive_authoring_enabled` - (Optional) Specifies whether to enable interactive authoring when the self-hosted integration runtime cannot establish a connection with Azure Relay.
    - `rbac_authorization` - (Optional) Defines RBAC authorization settings. Changing this forces a new resource to be created.
      - `resource_id` - (Required) The resource identifier of the integration runtime to be shared.
      **Note:** RBAC Authorization creates a linked Self-hosted Integration Runtime targeting the Shared Self-hosted Integration Runtime in `resource_id`. The linked Self-hosted Integration Runtime requires Contributor access to the Shared Self-hosted Data Factory.

Type:

```hcl
map(object({
    data_factory_id                              = optional(string)
    name                                         = string
    description                                  = optional(string, null)
    self_contained_interactive_authoring_enabled = optional(bool, null)
    rbac_authorization = optional(object({
      resource_id = string
    }), null)
  }))
```

Default: `{}`

### <a name="input_linked_service_azure_blob_storage"></a> [linked\_service\_azure\_blob\_storage](#input\_linked\_service\_azure\_blob\_storage)

Description:     A map of Azure Blob Storage linked services, where each key represents a unique linked service configuration.  
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

Type:

```hcl
map(object({
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
    }), null)

    # Service Principal Linked Key Vault Key (Optional)
    service_principal_linked_key_vault_key = optional(object({
      linked_service_name = string
      secret_name         = string
    }), null)
  }))
```

Default: `{}`

### <a name="input_linked_service_azure_file_storage"></a> [linked\_service\_azure\_file\_storage](#input\_linked\_service\_azure\_file\_storage)

Description:     A map of Azure Data Factory Linked Services for Azure File Storage, where each key represents a unique configuration.  
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

Type:

```hcl
map(object({
    name                     = string
    data_factory_id          = optional(string)
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
```

Default: `{}`

### <a name="input_linked_service_azure_sql_database"></a> [linked\_service\_azure\_sql\_database](#input\_linked\_service\_azure\_sql\_database)

Description:     A map of Azure Data Factory Linked Services for Azure SQL Database, where each key represents a unique configuration.  
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

Type:

```hcl
map(object({
    name                     = string
    data_factory_id          = optional(string)
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
```

Default: `{}`

### <a name="input_linked_service_data_lake_storage_gen2"></a> [linked\_service\_data\_lake\_storage\_gen2](#input\_linked\_service\_data\_lake\_storage\_gen2)

Description:     A map of Azure Data Factory Linked Services for Data Lake Storage Gen2, where each key represents a unique configuration.  
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

Type:

```hcl
map(object({
    name                     = string
    data_factory_id          = optional(string)
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
```

Default: `{}`

### <a name="input_linked_service_databricks"></a> [linked\_service\_databricks](#input\_linked\_service\_databricks)

Description:     A map of Azure Data Factory Linked Services for Databricks, where each key represents a unique configuration.  
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

Type:

```hcl
map(object({
    adb_domain                 = string
    data_factory_id            = optional(string)
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
```

Default: `{}`

### <a name="input_linked_service_key_vault"></a> [linked\_service\_key\_vault](#input\_linked\_service\_key\_vault)

Description:     A map of Azure Data Factory Linked Services for Azure Key Vault, where each key represents a unique configuration.  
    Each object in the map consists of the following properties:

    - `name` - (Required) The unique name of the linked service.
    - `data_factory_id` - (Required) The ID of the Data Factory where the linked service is associated.
    - `key_vault_id` - (Required) The ID of the Azure Key Vault resource.
    - `description` - (Optional) A description of the linked service.
    - `integration_runtime_name` - (Optional) The integration runtime reference.
    - `annotations` - (Optional) A list of tags to annotate the linked service.
    - `parameters` - (Optional) A map of parameters.
    - `additional_properties` - (Optional) Additional custom properties.

Type:

```hcl
map(object({
    name                     = string
    data_factory_id          = optional(string)
    key_vault_id             = string
    description              = optional(string, null)
    integration_runtime_name = optional(string, null)
    annotations              = optional(list(string), null)
    parameters               = optional(map(string), null)
    additional_properties    = optional(map(string), null)
  }))
```

Default: `{}`

### <a name="input_lock"></a> [lock](#input\_lock)

Description:     Controls the Resource Lock configuration for this resource. The following properties can be specified:

    - `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
    - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

    Example Input:
    ```hcl
    lock = {
      kind = "CanNotDelete"
      name = "Delete"
    }
    
```

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled)

Description: Is Managed Virtual Network enabled?

Type: `bool`

Default: `false`

### <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints)

Description:     A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

    - `name` - (Optional) The name of the private endpoint. One will be generated if not set.
    - `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
    - `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
    - `tags` - (Optional) A mapping of tags to assign to the private endpoint.
    - `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
    - `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
    - `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
    - `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
    - `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
    - `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
    - `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
    - `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
    - `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
      - `name` - The name of the IP configuration.
      - `private_ip_address` - The private IP address of the IP configuration.

    Example Input:

    ```hcl
    private_endpoints = {
      endpoint1 = {
        subnet_resource_id            = azurerm_subnet.endpoint.id
        private_dns_zone_group_name   = "private-dns-zone-group"
        private_dns_zone_resource_ids = [azurerm_private_dns_zone.this.id]
      }
    }
    
```

Type:

```hcl
map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
```

Default: `{}`

### <a name="input_private_endpoints_manage_dns_zone_group"></a> [private\_endpoints\_manage\_dns\_zone\_group](#input\_private\_endpoints\_manage\_dns\_zone\_group)

Description: Default to true. Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy.

Type: `bool`

Default: `true`

### <a name="input_public_network_enabled"></a> [public\_network\_enabled](#input\_public\_network\_enabled)

Description: Is the Data Factory visible to the public network?

Type: `bool`

Default: `true`

### <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id)

Description: Specifies the ID of the purview account resource associated with the Data Factory.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A mapping of tags to assign to the resource.

Type: `map(string)`

Default: `null`

### <a name="input_vsts_configuration"></a> [vsts\_configuration](#input\_vsts\_configuration)

Description:   Defines the VSTS configuration for the Data Factory.
  - account\_name: Specifies the VSTS account name.
  - branch\_name: Specifies the branch of the repository to get code from.
  - project\_name: Specifies the name of the VSTS project.
  - repository\_name: Specifies the name of the git repository.
  - root\_folder: Specifies the root folder within the repository. Set to / for the top level.
  - tenant\_id: Specifies the Tenant ID associated with the VSTS account.
  - publishing\_enabled: Is automated publishing enabled? Defaults to true.

Type:

```hcl
object({
    account_name       = string
    branch_name        = string
    project_name       = string
    repository_name    = string
    root_folder        = string
    tenant_id          = string
    publishing_enabled = optional(bool, true)
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_name"></a> [name](#output\_name)

Description: The name of the Data Factory resource

### <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints)

Description: A map of private endpoints. The map key is the supplied input to var.private\_endpoints. The map value is the entire azurerm\_private\_endpoint resource.

### <a name="output_resource"></a> [resource](#output\_resource)

Description: This is the full output for the resource.

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: The resource id of the Data Factory resource.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->