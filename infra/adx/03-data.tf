data "azurerm_client_config" "current" {
}


data "azurerm_resource_group" "main-rg" {
  provider = azurerm.connectivity
  name = "${var.prefix}-${var.env}-main-rg"
  // name     = format("%s-%s-%s-%s-hub-rg", var.site_code_hub, var.client_code_hub, var.aip_code_hub, var.environment)
}


data "azurerm_resource_group" "spoke" {
  provider = azurerm.connectivity
  name = "${var.prefix}-${var.env}-spoke-rg"
  // name     = format("%s-%s-%s-%s-hub-rg", var.site_code_hub, var.client_code_hub, var.aip_code_hub, var.environment)
}

/* references hub vnet  for routes
data "azurerm_virtual_network" "hub" {
  provider            = azurerm.connectivity
  name                = format("%s-%s-%s-%s-hub-vnet", var.site_code_hub, var.client_code_hub, var.aip_code_hub, var.environment)
  resource_group_name = data.azurerm_resource_group.hub.name
}

*/