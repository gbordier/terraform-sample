resource "azurerm_virtual_network" "spoke" {
//  name                = format("%s-spoke-vnet",  var.environment)
  name                = format("%s-%s-spoke-vnet", var.prefix, var.env)
  location            = var.location
  resource_group_name = data.azurerm_resource_group.spoke.name
  address_space       = var.vnetAddressSpace
}

resource "azurerm_subnet" "spoke-default" {
//  name                 = format("%s-spoke-snet",var.environment)
  name                = format("%s-%s-spoke-snet-default", var.prefix, var.env)

  resource_group_name  = data.azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.subnetAddressSpace1
}

resource "azurerm_subnet" "spoke-pe" {
//  name                 = format("%s-spoke-snet",var.environment)
  name                = format("%s-%s-spoke-snet-pe", var.prefix, var.env)

  resource_group_name  = data.azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.subnetAddressSpace2
}

resource "azurerm_network_security_group" "spoke" {

    name                = format("%s-%s-spoke-nsg", var.prefix, var.env)
//  name                = format("%s-spoke-nsg",  var.environment)
  location            = var.location
  resource_group_name = data.azurerm_resource_group.spoke.name
  security_rule {
    name                       = "DenyAllInboundDangerousTcpPortFromDsbVnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["1-20", "37", "60008", "33567", "31337", "179", "6670", "6346", "4950", "515", "40421", "12345-12346", "20034", "30100", "3700", "1170", "2989", "2023", "135", "31", "79", "21", "20432", "1981", "161-162", "119", "1080", "111", "512", "514", "16660", "65000", "23", "1243", "27374", "6000-6255", "6400", "6667", "33270", "27665", "2001", "33568", "1234", "5900", "3024"]
    source_address_prefix      = azurerm_virtual_network.spoke.address_space[0]
    destination_address_prefix = azurerm_virtual_network.spoke.address_space[0]
  }

  security_rule {
    name                       = "DenyAllInboundDangerousUdpPortFromDsbVnet"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_ranges    = ["2140", "137-139", "137-139", "123", "520", "20433", "18753", "161-162", "111", "1900", "1-20", "37", "69", "31335", "27444"]
    source_address_prefix      = azurerm_virtual_network.spoke.address_space[0]
    destination_address_prefix = azurerm_virtual_network.spoke.address_space[0]
  }

  security_rule {
    name                       = "AllowVnetInBound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowAllInBound"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllOutboundDangerousTcpPortFromDsbVnet"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["1-20", "37", "60008", "33567", "31337", "179", "6670", "6346", "4950", "515", "40421", "12345-12346", "20034", "30100", "3700", "1170", "2989", "2023", "135", "31", "79", "21", "20432", "1981", "161-162", "119", "1080", "111", "512", "514", "16660", "65000", "23", "1243", "27374", "6000-6255", "6400", "6667", "33270", "27665", "2001", "33568", "1234", "5900", "3024"]
    source_address_prefix      = azurerm_virtual_network.spoke.address_space[0]
    destination_address_prefix = azurerm_virtual_network.spoke.address_space[0]
  }

  security_rule {
    name                       = "DenyAllOutboundDangerousUdpPortFromDsbVnet"
    priority                   = 101
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_ranges    = ["2140", "137-139", "137-139", "123", "520", "20433", "18753", "161-162", "111", "1900", "1-20", "37", "69", "31335", "27444"]
    source_address_prefix      = azurerm_virtual_network.spoke.address_space[0]
    destination_address_prefix = azurerm_virtual_network.spoke.address_space[0]
  }

  security_rule {
    name                       = "AllowVnetOutBound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowAllOutBound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "spoke-default" {
  subnet_id                 = azurerm_subnet.spoke-default.id
  network_security_group_id = azurerm_network_security_group.spoke.id
}


resource "azurerm_subnet_network_security_group_association" "spoke-pe" {
  subnet_id                 = azurerm_subnet.spoke-pe.id
  network_security_group_id = azurerm_network_security_group.spoke.id
}

resource "azurerm_route_table" "spoke" {
//  name                          = format("%s-rt",  var.environment)
    name                = format("%s-%s-rt", var.prefix, var.env)
  location                      = var.location
  resource_group_name           = azurerm_resource_group.spoke.name
  disable_bgp_route_propagation = false

  route {
    name                   = "route-0.0.0.0-0"
    address_prefix         = "10.145.245.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.252.160.86"
  }

}

resource "azurerm_subnet_route_table_association" "spoke-default" {
  subnet_id      = azurerm_subnet.spoke-default.id
  route_table_id = azurerm_route_table.spoke.id
}

resource "azurerm_subnet_route_table_association" "spoke-pe" {
  subnet_id      = azurerm_subnet.spoke-pe.id
  route_table_id = azurerm_route_table.spoke.id
}


resource "azurerm_private_endpoint" "adx" {
  name                = format("%s-%s-pe-adx", var.prefix, var.env)
  location                      = var.location
  resource_group_name           = azurerm_resource_group.spoke.name

  subnet_id           = azurerm_subnet.spoke-pe.id

  private_service_connection {
    name                = format("%s-%s-serviceconnection-adx", var.prefix, var.env)
    private_connection_resource_id = azurerm_kusto_cluster.adx.id
    subresource_names = ["cluster"]
    //subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "example-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.private.id]
  }
}