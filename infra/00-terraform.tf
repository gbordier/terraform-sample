terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.18.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
    null = {
      version = "~> 3.0.0"
    }
  }

  backend "azurerm" {}
}
