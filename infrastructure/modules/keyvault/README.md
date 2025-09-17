# Key Vault Module

This module provisions an Azure Key Vault along with role assignments and secrets. It is designed to simplify the management of sensitive information and access control in Azure.

## Features

- Creates an Azure Key Vault with RBAC authorization enabled.
- Assigns roles for secrets management (`Key Vault Secrets Officer`, `Key Vault Secrets Reader`, and `Key Vault Secrets User`).
- Stores secrets in the Key Vault.

---

## Inputs

| Name                | Type          | Description                                                                                     | Default     |
|---------------------|---------------|-------------------------------------------------------------------------------------------------|-------------|
| `key_vault_name`    | `string`      | Name of the Key Vault. Must be 3-20 characters, lowercase, alphanumeric, and start with a letter. | N/A         |
| `location`          | `string`      | Azure region where the Key Vault will be deployed.                                              | N/A         |
| `resource_group_name` | `string`    | Name of the resource group where the Key Vault will be deployed.                                | N/A         |
| `key_vault_sku`     | `string`      | SKU for the Key Vault. Defaults to `standard`.                                                  | `standard`  |
| `read_access`       | `list(string)`| List of principal IDs to be granted `Key Vault Secrets Reader` access.                         | `[]`        |
| `write_access`      | `list(string)`| List of principal IDs to be granted `Key Vault Secrets User` access.                           | `[]`        |
| `secrets`           | `map(string)` | Map of secrets to be stored in the Key Vault.                                                   | `{}`        |

---

## Outputs

| Name         | Description                          |
|--------------|--------------------------------------|
| `key_vault`  | The Key Vault resource details, including `id` and `vault_uri`. |

---

## Usage Example

```hcl
module "keyvault" {
  source              = "../keyvault"
  key_vault_name      = "my-keyvault"
  location            = "eastus"
  resource_group_name = "my-resource-group"
  key_vault_sku       = "standard"
  read_access         = ["<reader-principal-id>"]
  write_access        = ["<writer-principal-id>"]
  secrets = {
    "example-secret" = "example-value"
    "api-key"        = "12345"
  }
}