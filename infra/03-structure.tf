
resource "azurerm_resource_group" "main-rg" {
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


resource "azurerm_role_assignment" "assign-vm-role" {
  scope                = azurerm_resource_group.spoke.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = "35d238e3-ada0-49f6-8739-4e770cf98c17"
}
