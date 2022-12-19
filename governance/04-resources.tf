

resource "azurerm_role_assignment" "enterprise_scale" {
  for_each             = var.role_assignements
  scope                = format("/providers/Microsoft.Management/managementGroups/%s", each.value.mg_scope_name)
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.object_id
  depends_on           = [module.enterprise_scale]
}
