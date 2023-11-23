locals {
  nsgfloxlogsource_west="/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/adx-west/providers/Microsoft.Storage/storageAccounts/stnsgflowlogswest"
}



resource "azurerm_eventgrid_system_topic" "nsglogs" {
  name                   = "nsg-logs"
  resource_group_name    = "adx-west" #data.azurerm_resource_group.spoke.name
  location               = "westeurope"
   ## location               = "Global"
  source_arm_resource_id = local.nsgfloxlogsource_west
  topic_type             = "Microsoft.Storage.StorageAccounts"

}

resource "azurerm_eventgrid_system_topic_event_subscription" "nsgflowlog-west" {
  name                = "eventgrid-nsgflowlog-west"
  system_topic        = azurerm_eventgrid_system_topic.nsglogs.name
  resource_group_name = data.azurerm_resource_group.spoke.name
  eventhub_endpoint_id = azurerm_eventhub.firewall.id
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