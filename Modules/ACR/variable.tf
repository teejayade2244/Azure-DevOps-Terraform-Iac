
variable "acr_name" {
  description = "The name of the Azure Container Registry."
  type        = string
}

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

# variable "acr_private_endpoint_name" {
#   description = "The name of the private endpoint for the Azure Container Registry."
#   type        = string
# }