terraform {
  backend "azurerm" {
    resource_group_name  = "ukwest-dev-demo-resource-group"
    storage_account_name = "demostorageaccount4125"   
    container_name       = "demo-tfstate"        
    key                  = "terraform.tfstate"
  }
}