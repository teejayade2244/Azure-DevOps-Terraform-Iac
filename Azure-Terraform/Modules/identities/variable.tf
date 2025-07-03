variable "common_tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Azure Container Registry will be created."
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group where the Azure Container Registry will be created."
  type        = string
}
variable "aks_identity_name" {
  description = "The name of the User Assigned Identity for AKS."
  type        = string
}

variable "acr_id" {
  description = "The resource ID of the Azure Container Registry (ACR) to which the AKS identity will be granted access."
  type        = string
  
}

