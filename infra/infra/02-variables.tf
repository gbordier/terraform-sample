/*
variable "tenant_id" {
  type = string
  description = "Azure tenant ID"
}

variable "subscription_id" {
  type = string
  description = "Azure subscription ID"
}
*/
/*
variable "environment" {
  type        = string
  description = "Environment"
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


variable "environment" {
  type        = string
  description = "Environment"
  
}

variable "location" {
  type        = string
  description = "Location"
}
/*
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
*/
variable "platform_connectivity_subscription" {
  type        = string
  description = "Platform Connectivity subscription"
}


variable "lz_subscription_id" {
  type        = string
  description = "LZ subscription ID"
}
/*
variable "lz_subscription_code" {
  type        = string
  description = "LZ subscription code"
}
*/

variable "region" {
  type        = string
  description = "Region for carbon black"
  default = "EMEA"
}

/*
variable "cr_sku" {
  type = string
  description = "Azure Container Registry SKU"
}
*/

variable "vnetAddressSpace" {
  type = list(string)
  description = "vnet address space" 
}

variable "subnetAddressSpace" {
type = list(string)
description=""
}

// those are supposed to be infra related, role assignment should go into governance

/*
resource "azurerm_role_assignment" "rg_based" {
  for_each             = var.role_assignements
  scope                = format("/subscriptions/%s/resourceGroups/%s",var.subscription_id, each.value.rg_scope_name)
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.object_id
//  depends_on           = [module.enterprise_scale]
}
*/

/*

variable "role_assignements" {
  type = map(object({
    object_id            = string
    role_definition_name = string
    rg_scope_name        = string
  }))
  description = "Roles to be assign on management group to service principal"
}
*/