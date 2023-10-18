
# Enterprise scale config

## those are static values 

root_id              = "MG-gb2"
root_name            = "MG-gb2"
location             = "northeurope"
tfstate_subscription = "08cbb954-de41-4f3e-9e24-cc915f96714b"
#subscription_id = "08cbb954-de41-4f3e-9e24-cc915f96714b"
lz_subscription_id = "08cbb954-de41-4f3e-9e24-cc915f96714b"


landing_zones_subscriptions = {
  
}
platform_subscriptions = {

}

decommissioned_subscriptions = []

# Role Assignements

role_assignements = {




"auto@totototo.onmicrosoft.com" = {
  object_id = "3704466f-218a-4333-8816-a4fe0c58773b"
  role_definition_name = "Owner"
      mg_scope_name        =  "Mg-gb2"
}

 
}


# Policies assignements config

PSCA-ResourceConsistency = {
  listOfAllowedLocations = ["northeurope"]
  listOfResourceTypes    = []
}

PSCA-SecurityBenchmark = {
  allowedContainerPortsInKubernetesClusterPorts = ["-1", "443"]
}

AMA-Deployment-DataCollectionID = "/subscriptions/08cbb954-de41-4f3e-9e24-cc915f96714b/resourceGroups/ter-terenv-main-rg/providers/Microsoft.Insights/dataCollectionRules/LinuxLogs"
