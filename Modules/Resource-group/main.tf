# This Terraform configuration creates an Azure Resource Group with a specified name and location.
resource "azurerm_resource_group" "aks_resource_group" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
  tags     = var.common_tags
}