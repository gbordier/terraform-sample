terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.18.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "eu-ceu-platformengineering-rg"
    storage_account_name = "ceutfstate01"
    container_name       = "platform-engineering"
    key                  = "intapps/governance.terraform.tfstate"
  }
}
