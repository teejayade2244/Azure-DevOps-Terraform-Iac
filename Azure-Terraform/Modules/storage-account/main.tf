# data "azurerm_resource_group" "myrg" {
#   name = "ukwest-dev-demo-resource-group"
# }

resource "azurerm_storage_account" "my_storage_account" {
  name                     = "ukwestdevstorageaccount"
  resource_group_name      = data.azurerm_resource_group.tfstate.name
  location                 = data.azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "my_storage_account_container" {
  name                  = "ukwestdev-container"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}