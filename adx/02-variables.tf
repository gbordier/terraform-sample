
variable "tenant_id" {
  type = string
  description = "Azure tenant ID"
}


variable "env" {
  type = string
  description = "Environment identifier"
}

variable "prefix" {
  type = string
  description = "Short prefix for all the resource names"
}


variable "location" {
  type        = string
  description = "Location"
}


variable "lz_subscription_id" {
  type        = string
  description = "LZ subscription ID"
}


variable "vnetAddressSpace" {
  type = list(string)
  description = "vnet address space" 
}

variable "subnetAddressSpace1" {
type = list(string)
description=""
}

variable "subnetAddressSpace2" {
type = list(string)
description=""
}
