# SFTP Linked Service Module

This module creates an Azure Data Factory SFTP linked service that supports both password and SSH key authentication.

## Features

- **Password Authentication**: Basic authentication using username/password
- **SSH Key Authentication**: More secure authentication using SSH public/private keys
- **Flexible Configuration**: Support for both key file path or inline key content
- **Security Validation**: Input validation to ensure proper authentication parameters

## Usage

### SSH Key Authentication (Recommended)

```hcl
module "sftp_linked_service" {
  source = "./modules/data_factory/linked_services/sftp"

  name               = "sftp-linked-service"
  data_factory_id    = azurerm_data_factory.example.id
  authentication_type = "SshPublicKey"
  host               = "sftp.example.com"
  port               = 22
  username           = "sftpuser"

  # Option 1: Use private key file path
  private_key_path   = "/path/to/private/key"

  # Option 2: Use inline private key content
  # private_key_content = file("~/.ssh/id_rsa")

  # Optional: If private key is encrypted
  # private_key_passphrase = var.ssh_key_passphrase

  # Optional: Host key fingerprint for additional security
  # host_key_fingerprint = "SHA256:..."

  global_settings = var.global_settings
  settings = {
    name = "sftp-secure-connection"
  }
}
```

### Password Authentication (Less Secure)

```hcl
module "sftp_linked_service" {
  source = "./modules/data_factory/linked_services/sftp"

  name                = "sftp-linked-service"
  data_factory_id     = azurerm_data_factory.example.id
  authentication_type = "Basic"
  host                = "sftp.example.com"
  port                = 22
  username            = "sftpuser"
  password            = var.sftp_password  # Should be stored in Key Vault

  global_settings = var.global_settings
  settings = {
    name = "sftp-basic-connection"
  }
}
```

## Authentication Types

### SshPublicKey (Recommended)
- More secure than password authentication
- Requires either `private_key_path` or `private_key_content`
- Optionally supports encrypted private keys with `private_key_passphrase`
- Can include `host_key_fingerprint` for host verification

### Basic (Password)
- Traditional username/password authentication
- Requires `password` parameter
- Less secure than SSH key authentication
- Password should be stored in Azure Key Vault

## Security Best Practices

1. **Prefer SSH Key Authentication**: Use `SshPublicKey` authentication type whenever possible
2. **Store Passwords Securely**: If using Basic authentication, store passwords in Azure Key Vault
3. **Use Host Key Fingerprints**: Include `host_key_fingerprint` for additional security
4. **Encrypt Private Keys**: Use encrypted SSH private keys with passphrases when possible
5. **Limit Network Access**: Configure network security groups to restrict SFTP access

## Variables

### Required
- `name`: Name of the linked service
- `data_factory_id`: Azure Data Factory ID
- `authentication_type`: "Basic" or "SshPublicKey"
- `host`: SFTP server hostname
- `port`: SFTP server port (default: 22)
- `username`: SFTP username

### Authentication-specific
For Basic authentication:
- `password`: SFTP password (sensitive)

For SshPublicKey authentication:
- `private_key_path`: Path to SSH private key file (either this or private_key_content required)
- `private_key_content`: SSH private key content (either this or private_key_path required)
- `private_key_passphrase`: Private key passphrase if encrypted (sensitive)
- `host_key_fingerprint`: SFTP server host key fingerprint

### Optional
- `description`: Description of the linked service
- `integration_runtime_name`: Integration runtime reference
- `annotations`: List of tags
- `parameters`: Map of parameters
- `additional_properties`: Map of additional properties

## Outputs

The module outputs the created SFTP linked service resource for reference in other modules.