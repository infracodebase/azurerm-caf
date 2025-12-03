variable "settings" {
  description = "Configuration object for the machine learning compute instance"

  validation {
    condition = can(var.settings.computeInstanceName) ? (
      can(regex("^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$", var.settings.computeInstanceName)) &&
      length(var.settings.computeInstanceName) >= 3 &&
      length(var.settings.computeInstanceName) <= 24
    ) : true
    error_message = "Compute instance name is invalid. It can include letters, digits and dashes. It must start with a letter, end with a letter or digit, and be between 3 and 24 characters in length."
  }
}
variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "machine_learning_workspace_name" {}
variable "subnet_id" {}
variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}
variable "tags" {
  description = "(Required) Map of tags to be applied to the resource"
  type        = map(any)
}