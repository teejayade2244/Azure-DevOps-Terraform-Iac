resource "azurerm_public_ip" "nat_gateway_pip" {
  name                = var.nat_gateway_pip_name
  tags                = var.common_tags
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = var.nat_gateway_name
  tags                = var.common_tags
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "aks_subnet_nat_gateway_association" {
  subnet_id      = var.aks_subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}