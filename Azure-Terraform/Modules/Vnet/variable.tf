variable "vnet_name" {
  description = "The name of the virtual network to create."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the virtual network will be created."
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "AKS_subnet_name" {
  description = "The name of the AKS subnet."
  type        = string
}

variable "AKS_subnet_address_prefix" {
  description = "The address prefix for the AKS subnet."
  type        = list(string)
}

