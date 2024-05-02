locals {
  nsgfloxlogsource_west="/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/adx-west/providers/Microsoft.Storage/storageAccounts/stnsgflowlogswest"
  resource_group_name ="adx-west"
  location="northeurope"

  ##toto =  jsondecode(file("${path.module}/${file}"))
  toto =  jsondecode(file("../../conf/.dev.json"))


#  eventhub_id = "/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/adx/providers/Microsoft.EventHub/namespaces/hubadxprivate/eventhubs/hubadxprivate"
}


resource "azurerm_eventgrid_system_topic" "nsglogs" {
  name                   = "nsg-logs"
  resource_group_name    = var.nsgresourcegroup_north
  location               = local.location
  
  source_arm_resource_id = var.nsgflowlogsource_north
  topic_type             = "Microsoft.Storage.StorageAccounts"
  
  identity {
    type = "SystemAssigned"
  }
}
/*
variable "eventgrid_sources" {
  type = map(
    object({
      sourcestorageaccount = string
      location = string
      resource_group_name = string
    })
  )
}
*/

module "eventgrids" {
  source =  "./modules/eventgrid"
  for_each = local.toto.eventgrid_sources
  nsg_topic_name  = format("nsg-logs-%s",each.key)
  nsg_resource_group_name = each.value.resource_group_name
  location =  each.value.location
  source_storage_account = each.value.sourcestorageaccount
  eventhub_id = azurerm_eventhub.nsg.id
}


resource "azurerm_eventgrid_system_topic_event_subscription" "eventgrid_subscription" {
  name                = "eventgrid-nsgflowlog-north"
  system_topic        = azurerm_eventgrid_system_topic.nsglogs.name
  resource_group_name = azurerm_eventgrid_system_topic.nsglogs.resource_group_name
  eventhub_endpoint_id = azurerm_eventhub.nsg.id
  included_event_types = [
    "Microsoft.Storage.BlobCreated"
  ]
  advanced_filter  {
    string_not_in {
    key = "data.api"
    values = [
      "CreateFile"
    ]
    }
       
  }
}