# naming for ML compute instance (validation handled in variables.tf)
resource "azurecaf_name" "ci" {
  name          = var.settings.computeInstanceName
  resource_type = "azurerm_linux_virtual_machine" # Using Linux VM type as generic compute naming
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

# create compute instance
resource "azurerm_resource_group_template_deployment" "mlci" {

  name                = format("mlci-%s", azurecaf_name.ci.result)
  resource_group_name = var.resource_group_name

  template_content = file(local.arm_filename)

  parameters_content = jsonencode(local.parameters_content)

  deployment_mode = "Incremental"

  timeouts {
    create = "10h"
    update = "10h"
    delete = "10h"
    read   = "5m"
  }
}