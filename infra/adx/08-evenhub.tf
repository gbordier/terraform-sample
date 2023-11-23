resource "azurerm_eventhub_namespace" "main" {
  name                = "abyss-main-eventhub-nc"
  location            = data.azurerm_resource_group.spoke.location
  resource_group_name = data.azurerm_resource_group.spoke.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = "Production"
  }
}

resource "azurerm_eventhub" "aad" {
  name                = "abyss-aad-eventhub"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = data.azurerm_resource_group.spoke.name
  partition_count     = 2
  message_retention   = 1
}


resource "azurerm_role_assignment" "aad" {
  scope                =  azurerm_eventhub.aad.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_kusto_cluster.adx.identity[0].principal_id
}


resource "azurerm_eventhub_consumer_group" "aad" {
  name                = "congroup1"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.aad.name
  resource_group_name = azurerm_resource_group.spoke.name
  user_metadata       = "some-meta-data"
}


resource "azurerm_eventhub" "defender" {
  name                = "abyss-defender-eventhub"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = azurerm_resource_group.spoke.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_consumer_group" "defender" {
  name                = "congroup2"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.defender.name
  resource_group_name = azurerm_resource_group.spoke.name
  user_metadata       = "some-meta-data"
}

resource "azurerm_role_assignment" "defender" {
  scope                =  azurerm_eventhub.defender.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_kusto_cluster.adx.identity[0].principal_id
}


resource "azurerm_eventhub" "firewall" {
  name                = "abyss-firewall-eventhub"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = azurerm_resource_group.spoke.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_role_assignment" "firewall" {
  scope                =  azurerm_eventhub.firewall.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_kusto_cluster.adx.identity[0].principal_id
}

resource "azurerm_eventhub_consumer_group" "firewall" {
  name                = "congroup2"
  namespace_name      = azurerm_eventhub_namespace.main.name
  eventhub_name       = azurerm_eventhub.firewall.name
  resource_group_name = azurerm_resource_group.spoke.name
  user_metadata       = "some-meta-data"
}
