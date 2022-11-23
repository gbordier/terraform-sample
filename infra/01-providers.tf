/*
 To handle 2 subs
provider "azurerm" {
  features {}
  subscription_id = var.lz_subscription_id
}
*/
provider "azurerm" {
  features {}
  alias           = "connectivity"
  
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}

provider "azurerm" {
  features {}
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id

  # Do not register unused resource providers.
  # Useful for environments with restricted permissions.
  skip_provider_registration = true
}

  