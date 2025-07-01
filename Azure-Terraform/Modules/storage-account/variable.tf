variable "resource_group_name" {
  description = "The name of the existing resource group."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}

variable "account_tier" {
  description = "The tier of the storage account."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account."
  type        = string
  default     = "LRS"
}

variable "container_name" {
  description = "The name of the storage container."
  type        = string
}

variable "container_access_type" {
  description = "The access type of the storage container."
  type        = string
  default     = "private"
}