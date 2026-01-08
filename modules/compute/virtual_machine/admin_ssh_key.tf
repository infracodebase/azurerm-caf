
#
# SSH keys to be stored in KV only if public_key_pem_file is not set
# Keyvault has to be in the same subscription as the VM when local.create_sshkeys is true
#

locals {
  # Generate SSH Keys only if a public one is not provided
  create_sshkeys = (local.os_type == "linux" || local.os_type == "legacy") && can(var.settings.public_key_pem_file) == false && can(var.settings.virtual_machine_settings[var.settings.os_type].admin_ssh_keys) == false
}

resource "azurerm_key_vault_secret" "ssh_private_key" {
  for_each = local.create_sshkeys ? var.settings.virtual_machine_settings : {}

  name         = can(azurecaf_name.legacy_computer_name[each.key].result) ? format("%s-ssh-private-key", azurecaf_name.legacy_computer_name[each.key].result) : format("%s-ssh-private-key", data.azurecaf_name.linux_computer_name[each.key].result)
  value        = tls_private_key.ssh[each.key].private_key_pem
  key_vault_id = local.keyvault.id

  lifecycle {
    ignore_changes = [
      name, value, key_vault_id
    ]
  }
}

resource "azurerm_key_vault_secret" "ssh_public_key_openssh" {
  for_each = local.create_sshkeys ? var.settings.virtual_machine_settings : {}

  name         = can(azurecaf_name.legacy_computer_name[each.key].result) ? format("%s-ssh-public-key-openssh", azurecaf_name.legacy_computer_name[each.key].result) : format("%s-ssh-public-key-openssh", data.azurecaf_name.linux_computer_name[each.key].result)
  value        = tls_private_key.ssh[each.key].public_key_openssh
  key_vault_id = local.keyvault.id

  lifecycle {
    ignore_changes = [
      name, value, key_vault_id
    ]
  }
}


# Native Terraform data sources to retrieve SSH keys (replaces external scripts)
data "azurerm_ssh_public_key" "ssh_public_key_id" {
  for_each = {
    for key, value in try(var.settings.virtual_machine_settings[var.settings.os_type].admin_ssh_keys, {}) : key => value if can(value.ssh_public_key_id)
  }

  # Extract resource name from ID (last part after /)
  name                = split("/", each.value.ssh_public_key_id)[length(split("/", each.value.ssh_public_key_id)) - 1]
  resource_group_name = split("/", each.value.ssh_public_key_id)[4]
}

data "azurerm_key_vault_secret" "secret_key_id" {
  for_each = {
    for key, value in try(var.settings.virtual_machine_settings[var.settings.os_type].admin_ssh_keys, {}) : key => value if can(value.secret_key_id)
  }

  # Extract vault ID and secret name from full resource ID
  key_vault_id = join("/", slice(split("/", each.value.secret_key_id), 0, 9))
  name         = split("/", each.value.secret_key_id)[length(split("/", each.value.secret_key_id)) - 1]
}

# from keyvault
data "azurerm_key_vault_secret" "ssh_secret_keyvault" {
  for_each = {
    for key, value in try(var.settings.virtual_machine_settings[var.settings.os_type].admin_ssh_keys, {}) : key => value if can(value.keyvault_key)
  }

  name         = each.value.secret_name
  key_vault_id = var.keyvaults[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.keyvault_key].id
}