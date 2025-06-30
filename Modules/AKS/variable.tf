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

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace for AKS."
  type        = string  
}

variable "aks_cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "dns_prefix_name" {
  description = "The DNS prefix for the AKS cluster's public IP."
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster."
  type        = string
}

variable "azurerm_user_assigned_identity_aks_identity_id" {
  description = "The ID of the User Assigned Identity created for AKS."
  type        = string
}

variable "user_assigned_identity_id" {
  description = "The ID of the User Assigned Identity for AKS."
  type        = string
}

variable "aks_subnet_id" {
  description = "The ID of the subnet for the AKS node pool."
  type        = string
}