locals {
  nsgfloxlogsource_west="/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/adx-west/providers/Microsoft.Storage/storageAccounts/stnsgflowlogswest"
  nsgresourcegroup_north="nsgflow"
  nsgflowlogsource_north="/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/nsgflow/providers/Microsoft.Storage/storageAccounts/gbordierstnsgflowlogs"
  resource_group_name ="adx-west"
  location="northeurope"
#  eventhub_id = "/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/adx/providers/Microsoft.EventHub/namespaces/hubadxprivate/eventhubs/hubadxprivate"
}



resource "azurerm_eventgrid_system_topic" "nsglogs" {
  name                   = "nsg-logs"
  resource_group_name    = local.nsgresourcegroup_north
  location               = local.location
  
  source_arm_resource_id = local.nsgflowlogsource_north
  topic_type             = "Microsoft.Storage.StorageAccounts"
  
  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_eventgrid_system_topic_event_subscription" "nsgflowlog-north" {
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