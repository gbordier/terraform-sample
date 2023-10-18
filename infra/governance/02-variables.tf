
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

variable "root_id" {
  type        = string
  description = "The root management group ID"
}

variable "root_name" {
  type        = string
  description = "The root management group name"
}

variable "location" {
  type        = string
  description = "The default location"
}

variable "tfstate_subscription" {
  type        = string
  description = "TF State subscription"
}

variable "platform_subscriptions" {
  type        = map(string)
  description = "Platform subscriptions"
}

variable "landing_zones_subscriptions" {
  type        = map(list(string))
  description = "Landing Zones subscriptions"
}

variable "decommissioned_subscriptions" {
  type        = list(string)
  description = "Decommissioned subscriptions"
}

variable "role_assignements" {
  type = map(object({
    object_id            = string
    role_definition_name = string
    mg_scope_name        = string
  }))
  description = "Roles to be assign on management group to service principal"
}

variable "PSCA-ResourceConsistency" {
  type = object({
    listOfAllowedLocations = list(string)
    listOfResourceTypes    = list(string)
  })
  description = "The policy parameters to apply to PSCA-ResourceConsistency"
}

variable "PSCA-SecurityBenchmark" {
  type = object({
    allowedContainerPortsInKubernetesClusterPorts = list(string)
  })
  description = "The policy parameters to apply to PSCA-SecurityBenchmark"
}

variable "storageAccountKey" {
  type        = string
  description = "TODO delete because just use in connectivity"
  default     = "secret"
}

variable "logAnalyticsWorkspaceKey" {
  type        = string
  description = "Log Analytics Workspace Key"
  default     = "secret"
}

variable "AMA-Deployment-DataCollectionID" {
  type = string     
  description = "AMA Deplyment policy parameters"
}