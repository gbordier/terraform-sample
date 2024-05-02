variable nsg_topic_name { 
  type=string
}
variable nsg_resource_group_name {
  type=string
}

variable location {
  type=string
}
variable source_storage_account {
  type=string
}

variable eventhub_id{
  type=string
}

resource "azurerm_eventgrid_system_topic" "nsglogs" {
  name                = var.nsg_topic_name
  resource_group_name    = var.nsg_resource_group_name
  location               = var.location
  
  source_arm_resource_id = var.source_storage_account
  topic_type             = "Microsoft.Storage.StorageAccounts"
  
  identity {
    type = "SystemAssigned"
  }
}



resource "azurerm_eventgrid_system_topic_event_subscription" "eventgrid_subscription" {
  name                = "${var.nsg_topic_name}-subscription"
  system_topic        = azurerm_eventgrid_system_topic.nsglogs.name
  resource_group_name = azurerm_eventgrid_system_topic.nsglogs.resource_group_name
  eventhub_endpoint_id = var.eventhub_id
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