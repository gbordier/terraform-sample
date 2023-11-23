resource "azurerm_kusto_cluster" "adx" {
  name                = "${var.prefix}${var.env}adxcluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
  sku {
    name = "Dev(No SLA)_Standard_E2a_v4"
    capacity = 1
    
        
  }
  
  
  identity {
     type = "SystemAssigned"
  }
 auto_stop_enabled = true

  purge_enabled = true



  tags = {
    env = "${var.prefix}-${var.env}"
  }
  
}

resource "azurerm_kusto_database" "db1" {
  name                = "abyss_db_1"
  resource_group_name = data.azurerm_resource_group.spoke.name
  location            = var.location
  cluster_name        = azurerm_kusto_cluster.adx.name

  hot_cache_period   = "P1D"
  soft_delete_period = "P3D"
  
}

resource "azurerm_kusto_eventhub_data_connection" "aad" {
  name                = "db1-eventhub1-aad"
  resource_group_name = data.azurerm_resource_group.spoke.name
  location = data.azurerm_resource_group.spoke.location

  cluster_name        = azurerm_kusto_cluster.adx.name
  database_name       = azurerm_kusto_database.db1.name

  eventhub_id    = azurerm_eventhub.aad.id
  consumer_group = azurerm_eventhub_consumer_group.aad.name

  table_name        = "rawlog_aad"         #(Optional)
  mapping_rule_name = "raw_mapping" #(Optional)
  data_format       = "JSON"             #(Optional)
  identity_id =  azurerm_kusto_cluster.adx.id
}
 
 resource "azurerm_kusto_script" "example" {
  name                               = "example"
  database_id                        = azurerm_kusto_database.db1.id
  script_content = <<-EOF
.create table ['rawlog_aad']   (records:dynamic) 
.create table ['rawlog_aad'] ingestion json mapping 'raw_mapping' '[{"column":"records", "Properties":{"Path":"$[\'records\']"}}]'
.create table ['rawlog_defender']   (records:dynamic) 
.create table ['rawlog_defender'] ingestion json mapping 'raw_mapping' '[{"column":"records", "Properties":{"Path":"$[\'records\']"}}]'
.create table ['rawlog_firewall']   (records:dynamic) 
.create table ['rawlog_firewall'] ingestion json mapping 'raw_mapping' '[{"column":"records", "Properties":{"Path":"$[\'records\']"}}]'
 EOF

  continue_on_errors_enabled         = true
  force_an_update_when_value_changed = "first"
}


resource "azurerm_kusto_eventhub_data_connection" "defender" {
  name                = "db1-eventhub1-defender"
  resource_group_name = data.azurerm_resource_group.spoke.name
  location = data.azurerm_resource_group.spoke.location

  cluster_name        = azurerm_kusto_cluster.adx.name
  database_name       = azurerm_kusto_database.db1.name

  eventhub_id    = azurerm_eventhub.defender.id
  consumer_group = azurerm_eventhub_consumer_group.defender.name

  table_name        = "rawlog_defender"         #(Optional)
  mapping_rule_name = "raw_mapping" #(Optional)
  data_format       = "JSON"             #(Optional)
  identity_id =  azurerm_kusto_cluster.adx.id
}
 
 resource "azurerm_kusto_eventhub_data_connection" "firewall" {
  name                = "db1-eventhub1-firewall"
  resource_group_name = data.azurerm_resource_group.spoke.name
  location = data.azurerm_resource_group.spoke.location

  cluster_name        = azurerm_kusto_cluster.adx.name
  database_name       = azurerm_kusto_database.db1.name

  eventhub_id    = azurerm_eventhub.firewall.id
  consumer_group = azurerm_eventhub_consumer_group.firewall.name

  table_name        = "rawlog_firewall"         #(Optional)
  mapping_rule_name = "raw_mapping" #(Optional)
  data_format       = "JSON"             #(Optional)
  identity_id =  azurerm_kusto_cluster.adx.id
}
 