locals {

  archetype_config_root = {
    archetype_id = "root_management_group"
    parameters = {
      PSCA-ResourceConsistency = {
        listOfAllowedLocations = var.PSCA-ResourceConsistency.listOfAllowedLocations
        listOfResourceTypes    = var.PSCA-ResourceConsistency.listOfResourceTypes
      },
      PSCA-SecurityBenchmark = {
        allowedContainerPortsInKubernetesClusterPorts = var.PSCA-SecurityBenchmark.allowedContainerPortsInKubernetesClusterPorts
      },
      AMA-Deployment-Linux = {
            dcrResourceId = var.AMA-Deployment-DataCollectionID
      }
      
      
    }
    access_control = {}
     
  }

  archetype_config_platform = {
    archetype_id   = "platform_management_group"
    parameters     = {}
    access_control = {}
  }

  archetype_config_pltf_identity = {
    archetype_id   = "pltf_identity_management_group"
    parameters     = {}
    access_control = {}
  }

  archetype_config_pltf_management = {
    archetype_id   = "pltf_management_management_group"
    parameters     = {}
    access_control = {}
  }

  archetype_config_pltf_connectivity = {
    archetype_id   = "pltf_connectivity_management_group"
    parameters     = {}
    access_control = {}
  }

  archetype_config_landing_zones = {
    archetype_id   = "landing_zones_management_group"
    parameters     = {}
    access_control = {}
  }

  archetype_config_lz_dsb = {
    archetype_id   = "lz_dsb_management_group"
    parameters     = {}
    access_control = {}
  }

  archetype_config_decommissioned = {
    archetype_id   = "decommissioned_management_group"
    parameters     = {}
    access_control = {}
  }

  archetype_config_sandboxes = {
    archetype_id   = "sandboxes_management_group"
    parameters     = {}
    access_control = {}
  }

}
