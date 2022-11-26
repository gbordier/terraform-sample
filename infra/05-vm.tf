resource "azurerm_virtual_network" "spoke" {
  name                = format("%s-spoke-vnet",  var.environment)
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space       = var.vnetAddressSpace
}

resource "azurerm_subnet" "spoke" {
  name                 = format("%s-spoke-snet",var.environment)
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.subnetAddressSpace
}

resource "azurerm_network_security_group" "spoke" {
  name                = format("%s-spoke-nsg",  var.environment)
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
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

resource "azurerm_subnet_network_security_group_association" "spoke" {
  subnet_id                 = azurerm_subnet.spoke.id
  network_security_group_id = azurerm_network_security_group.spoke.id
}

resource "azurerm_route_table" "spoke" {
  name                          = format("%s-rt",  var.environment)
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

resource "azurerm_subnet_route_table_association" "spoke" {
  subnet_id      = azurerm_subnet.spoke.id
  route_table_id = azurerm_route_table.spoke.id
}

resource "azurerm_network_interface" "test_vm" {
  name                = format("%s-test-nic", var.environment)
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.252.162.4"
  }
}

resource "tls_private_key" "test_vm" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "test_vm" {
  name                            = format("%s-test-vm",  var.environment)
  resource_group_name             = azurerm_resource_group.spoke.name
  location                        = var.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  computer_name                   = "test-vm"
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.test_vm.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.test_vm.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8_3"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}
resource "azurerm_virtual_machine_extension" "AADSSHLoginForLinux" {
    name = "AADSSHLoginForLinux"
    type = "AADSSHLoginForLinux"
    virtual_machine_id   = azurerm_linux_virtual_machine.test_vm.id
    publisher            = "Microsoft.Azure.ActiveDirectory"
    type_handler_version = "1.0"
}
resource "azurerm_virtual_machine_extension" "example" {
  name                 = "hostname"
  virtual_machine_id   = azurerm_linux_virtual_machine.test_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
  "commandToExecute": "hostname && uptime"
 }
SETTINGS

}
/*
resource "null_resource" "AADSSHLoginForLinux" {
  triggers = {
    resource_group_name = azurerm_resource_group.spoke.name
    vm_name             = azurerm_linux_virtual_machine.test_vm.name
    lz_subscription_id  = var.subscription_id
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      az account set --subscription ${self.triggers.lz_subscription_id}
      az vm extension set \
        --publisher Microsoft.Azure.ActiveDirectory \
        --name AADSSHLoginForLinux \
        --resource-group ${self.triggers.resource_group_name} \
        --vm-name ${self.triggers.vm_name} 
    EOT
  }

  depends_on = [
    azurerm_linux_virtual_machine.test_vm
  ]
}
*/
locals {
  fileUris = join("", ["https://", var.storageAccountName, ".blob.core.windows.net/ctn-carbonblack/ScriptsForAzure/Carbon-black-sensor-linux-Azure-V1.sh"])
  command  = join(" ", ["./Carbon-black-sensor-linux-Azure-V1.sh", var.region])
}
/*
resource "azurerm_virtual_machine_extension" "SetupVmTest" {
  name                       = "CbEdrAndIperf"
  virtual_machine_id         = azurerm_linux_virtual_machine.test_vm.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = true

  protected_settings = <<PROTECTED_SETTINGS
{
  "commandToExecute": "sudo dnf install iperf3 -y && iperf3 -s -p 5001 &",
  "storageAccountName": "${var.storageAccountName}",
  "storageAccountKey": "${var.storageAccountKey}",
  "fileUris": ["${local.fileUris}"]  
}
PROTECTED_SETTINGS

}
*/
/*
resource "azurerm_virtual_machine_extension" "DiagnosticSettingsExtension" {
  name                 = "DiagnosticSettings"
  virtual_machine_id   = azurerm_linux_virtual_machine.test_vm.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "OmsAgentForLinux"
  type_handler_version = "1.13"

  settings = <<SETTINGS
{
  "workspaceId": "${var.logAnalyticsWorkspaceId}",
  "skipDockerProviderInstall": "true"
}
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
{
  "workspaceKey": "${var.logAnalyticsWorkspaceKey}"
}
PROTECTED_SETTINGS

}
*/

resource "azurerm_private_dns_zone" "dsb" {
  name                = "dsb.agora.alstom.hub"
  resource_group_name = azurerm_resource_group.spoke.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke" {
  name                  = "dsb-dns-zone-link"
  resource_group_name   = azurerm_resource_group.spoke.name
  private_dns_zone_name = azurerm_private_dns_zone.dsb.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_a_record" "vm_test_dns_record" {
  name                = azurerm_linux_virtual_machine.test_vm.name
  zone_name           = azurerm_private_dns_zone.dsb.name
  resource_group_name = azurerm_resource_group.spoke.name
  ttl                 = 300
  records             = ["${azurerm_linux_virtual_machine.test_vm.private_ip_address}"]
}
