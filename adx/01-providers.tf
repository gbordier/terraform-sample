provider "azurerm" {
  features {}
  }


provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  alias           = "connectivity"
  subscription_id = var.lz_subscription_id
}
