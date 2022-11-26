variable "tenant_id" {
  type = string
  description = "Azure tenant ID"
}

variable "subscription_id" {
  type = string
  description = "Azure subscription ID"
}

variable "client_id" {
  type = string
  description = "Azure service principal ID"
}

variable "client_secret" {
  type = string
  description = "Azure service srincipal client secret"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "location" {
  type        = string
  description = "Location"
}

variable "site_code" {
  type        = string
  description = "Site code"
}

variable "client_code" {
  type        = string
  description = "Client code"
}

variable "site_code_hub" {
  type        = string
  description = "Site code of the Hub"
}

variable "client_code_hub" {
  type        = string
  description = "Client code of the Hub"
}

variable "aip_code_hub" {
  type        = string
  description = "AIP code of the Hub"
}
/*
variable "platform_connectivity_subscription" {
  type        = string
  description = "Platform Connectivity subscription"
}
*/
/*
variable "lz_subscription_id" {
  type        = string
  description = "LZ subscription ID"
}

variable "lz_subscription_code" {
  type        = string
  description = "LZ subscription code"
}
*/

variable "storageAccountName" {
  type        = string
  description = "Storage account where the carbon black is"
}

/*
variable "storageAccountKey" {
  type        = string
  description = "Storage account key where the carbon black is"
}
*/

variable "region" {
  type        = string
  description = "Region for carbon black"
}
/*
variable "logAnalyticsWorkspaceId" {
  type        = string
  description = "Log Analytics Workspace ID"
}

variable "logAnalyticsWorkspaceKey" {
  type        = string
  description = "Log Analytics Workspace Key"
}
*/


variable "env" {
  type = string
  description = "Environment identifier"
}

variable "prefix" {
  type = string
  description = "Short prefix for all the resource names"
}

variable "cr_sku" {
  type = string
  description = "Azure Container Registry SKU"
}

variable "api_asp_sku_tier" {
  type = string
  description = "Azure App Service Plan tier for API app"
}

variable "api_asp_sku_size" {
  type = string
  description = "Azure App Service Plan size for API app"
}

variable "api_app_always_on" {
  type = string
  description = "always_on setting for API app"
}

variable "func_asp_sku_tier" {
  type = string
  description = "Azure App Service Plan tier for Functions app"
}

variable "func_asp_sku_size" {
  type = string
  description = "Azure App Service Plan size for Functions app"
}

variable "vnetAddressSpace" {
  type = list(string)
  description = "vnet address space" 
}
variable "subnetAddressSpace" {
type = list(string)
description=""
}
