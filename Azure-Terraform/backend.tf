# terraform {
#   backend "azurerm" {
#     resource_group_name  = "ukwest-dev-demo-resource-group"
#     storage_account_name = "ukwestdevstorageaccount"   
#     container_name       = "ukwestdev-container"        
#     key                  = "terraform.tfstate"
#   }
# }