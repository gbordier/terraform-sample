
resource "azurerm_resource_group" "main" {
  name = "${var.prefix}-${var.env}-main-rg"
  location = var.location

  tags = {
    env = "${var.prefix}-${var.env}"
  }
}

resource "azurerm_resource_group" "spoke" {
  name = "${var.prefix}-${var.env}-spoke-rg"
  location = var.location

  tags = {
    env = "${var.prefix}-${var.env}"
  }
}

import {
  to = azurerm_resource_group.main
  id = "/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/adx-dev-main-rg"
}

import {
  to = azurerm_resource_group.spoke
  id = "/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/adx-dev-spoke-rg"
}