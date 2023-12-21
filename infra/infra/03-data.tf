data "azurerm_resource_group" "main-rg" {
  provider = azurerm.connectivity
  name = "${var.prefix}-${var.env}-main-rg"
  
}


data "azurerm_resource_group" "spoke" {
  provider = azurerm.connectivity
  name = "${var.prefix}-${var.env}-spoke-rg"
  
}


