variable "name" {
  description = "(Required) Specifies the name of the Data Factory Linked Service. Changing this forces a new resource to be created. Must be globally unique."
}

variable "data_factory_id" {
  description = "(Required) The Data Factory name in which to associate the Linked Service with. Changing this forces a new resource."
}

variable "description" {
  description = "(Optional) The description for the Data Factory Linked Service."
}

variable "integration_runtime_name" {
  description = "(Optional) The integration runtime reference to associate with the Data Factory Linked Service."
}

variable "annotations" {
  description = "(Optional) List of tags that can be used for describing the Data Factory Linked Service."
}

variable "parameters" {
  description = "(Optional) A map of parameters to associate with the Data Factory Linked Service."
}

variable "additional_properties" {
  description = "(Optional) A map of additional properties to associate with the Data Factory Linked Service."
}

variable "authentication_type" {
  description = "(Required) The type of authentication used to connect to the SFTP server. Valid options are Basic and SshPublicKey."
  validation {
    condition = contains(["Basic", "SshPublicKey"], var.authentication_type)
    error_message = "Authentication type must be either 'Basic' (password) or 'SshPublicKey' (SSH key authentication). SshPublicKey is recommended for better security."
  }
}

variable "host" {
  description = "(Required) The SFTP server hostname."
}

variable "port" {
  description = "(Required) The TCP port number that the SFTP server uses to lsiten for client connection. Default value is 22."
}

variable "username" {
  description = "(Required) The username used to log on to the SFTP server."
}

variable "password" {
  description = "(Optional) Password to logon to the SFTP Server for Basic Authentication. Required when authentication_type is 'Basic'."
  default     = null
  sensitive   = true
}

variable "private_key_path" {
  description = "(Optional) Path to the SSH private key for SshPublicKey authentication. Required when authentication_type is 'SshPublicKey'."
  default     = null
}

variable "private_key_content" {
  description = "(Optional) Content of the SSH private key for SshPublicKey authentication. Required when authentication_type is 'SshPublicKey'."
  default     = null
  sensitive   = true
}

variable "private_key_passphrase" {
  description = "(Optional) Passphrase for the SSH private key if it's encrypted."
  default     = null
  sensitive   = true
}

variable "host_key_fingerprint" {
  description = "(Optional) The host key fingerprint of the SFTP server."
  default     = null
}