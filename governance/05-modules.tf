module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "2.4.1"


  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id   = data.azurerm_client_config.core.tenant_id
  root_id          = var.root_id # limited to 10 caracteres
  root_name        = var.root_name
  library_path     = "${path.root}/lib"
  default_location = var.location

  archetype_config_overrides = {
    root           = local.archetype_config_root
    decommissioned = local.archetype_config_decommissioned
    sandboxes      = local.archetype_config_sandboxes
    landing-zones  = local.archetype_config_landing_zones
    platform       = local.archetype_config_platform
    connectivity   = local.archetype_config_pltf_connectivity
    management     = local.archetype_config_pltf_management
    identity       = local.archetype_config_pltf_identity
  }

  deploy_core_landing_zones = true
  disable_base_module_tags  = false
  deploy_demo_landing_zones = false

  custom_landing_zones = {
    "${var.root_id}-dsb" = {
      display_name               = "DSB"
      parent_management_group_id = "${var.root_id}-landing-zones"
//      subscription_ids           = var.landing_zones_subscriptions.dsb
      subscription_ids =[]
      archetype_config           = local.archetype_config_lz_dsb
    }
  }

  subscription_id_overrides = {
    root           = [var.tfstate_subscription]
    sandboxes      = []
    decommissioned = var.decommissioned_subscriptions
    platform       = []
    landing-zones  = []
//    connectivity   = [var.platform_subscriptions.connectivity]
//    management     = [var.platform_subscriptions.management]
//    identity       = [var.platform_subscriptions.identity]
  }
}
