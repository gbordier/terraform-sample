
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
