resource "azurecaf_name" "dataset" {
  name          = var.settings.name
  resource_type = "azurerm_data_factory" #"azurerm_data_factory_dataset_azure_blob"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}
resource "azurerm_data_factory_linked_service_sftp" "linked_service_sftp" {
  name                     = azurecaf_name.dataset.name
  data_factory_id          = var.data_factory_id
  description              = try(var.description, null)
  integration_runtime_name = try(var.integration_runtime_name, null)
  annotations              = try(var.annotations, null)
  parameters               = try(var.parameters, null)
  additional_properties    = try(var.additional_properties, null)
  authentication_type      = var.authentication_type
  host                     = var.host
  port                     = var.port
  username                 = var.username

  # Password authentication (Basic)
  password                 = var.authentication_type == "Basic" ? var.password : null

  # SSH key authentication (SshPublicKey)
  private_key_path         = var.authentication_type == "SshPublicKey" ? var.private_key_path : null
  private_key_content      = var.authentication_type == "SshPublicKey" ? var.private_key_content : null
  private_key_passphrase   = var.authentication_type == "SshPublicKey" ? var.private_key_passphrase : null
  host_key_fingerprint     = var.authentication_type == "SshPublicKey" ? var.host_key_fingerprint : null

  lifecycle {
    precondition {
      condition = var.authentication_type == "Basic" ? var.password != null : (var.private_key_path != null || var.private_key_content != null)
      error_message = "When using 'Basic' authentication, password must be provided. When using 'SshPublicKey' authentication, either private_key_path or private_key_content must be provided."
    }
  }
}