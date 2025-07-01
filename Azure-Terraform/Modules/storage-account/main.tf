
resource "azurerm_storage_account" "my_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  tags                     = var.common_tags
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

resource "azurerm_storage_container" "my_storage_account_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.my_storage_account.id
  container_access_type = var.container_access_type
}