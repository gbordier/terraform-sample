
resource "azurerm_private_dns_zone" "private" {
  name                = "adx.abyss"
  resource_group_name = data.azurerm_resource_group.spoke.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke" {
  name                  = "adx-dns-zone-link"
  resource_group_name   = data.azurerm_resource_group.spoke.name
  private_dns_zone_name = azurerm_private_dns_zone.private.name
  virtual_network_id    = azurerm_virtual_network.spoke.id
}
/*
resource "azurerm_private_dns_a_record" "vm_test_dns_record" {
  name                = azurerm_linux_virtual_machine.test_vm.name
  zone_name           = azurerm_private_dns_zone.private.name
  resource_group_name = azurerm_resource_group.spoke.name
  ttl                 = 300
  records             = ["${azurerm_linux_virtual_machine.test_vm.private_ip_address}"]
}
*/