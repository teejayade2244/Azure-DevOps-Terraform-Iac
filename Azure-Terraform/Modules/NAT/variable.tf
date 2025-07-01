variable "nat_gateway_pip_name" {
  description = "The name of the NAT Gateway Public IP."
  type        = string
}

variable "nat_gateway_name" {
  description = "The name of the NAT Gateway."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the NAT Gateway will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the NAT Gateway will be created."
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "aks_subnet_id" {
  description = "The ID of the AKS subnet to associate with the NAT Gateway."
  type        = string
}