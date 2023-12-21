data "azurerm_client_config" "current" {
}


data "azurerm_resource_group" "main" {
  provider = azurerm.connectivity
  name = "${var.prefix}-${var.env}-main-rg"
  
}


data "azurerm_resource_group" "spoke" {
  provider = azurerm.connectivity
  name = "${var.prefix}-${var.env}-spoke-rg"
  
}

