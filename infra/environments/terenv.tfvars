location = "northeurope"


cr_sku = "Basic"

//subscription_id = "08cbb954-de41-4f3e-9e24-cc915f96714b"
lz_subscription_id = "08cbb954-de41-4f3e-9e24-cc915f96714b"
platform_connectivity_subscription = "08cbb954-de41-4f3e-9e24-cc915f96714b"
//platform_connectivity_subscription = "a5614dbc-94c9-4aae-90f6-dc38858b6ff9"


vnetAddressSpace= ["10.252.162.0/24"]
subnetAddressSpace= ["10.252.162.0/28"]

/*
site_code                          = "sdc3"
client_code                        = "dsb"
site_code_hub                      = "sdc3"
client_code_hub                    = "agr"
aip_code_hub                       = "0000"
*/

## region for carbon black
region                             = "EMEA"

/*

role_assignements = {


    "Azure Agora IntApp - DXC Owner" = {
      object_id            = "702524f5-27aa-4966-90b7-3a77fa3d2ebb"
      role_definition_name = "Owner"
      rg_scope_name        = "ter-terenv-main-rg"
    }

    "Azure Agora IntApp - MICROSOFT Reader" = {
      object_id            = "ff66a6a9-7927-4bfb-8bf9-6d6107766a48"
      role_definition_name = "Reader"
      rg_scope_name        = "ter-terenv-spoke-rg"
    }


"Azure Agora IntApp Hub - MICROSOFT VirtualMachineAdmin" = {
      object_id            = "2907dff8-e61d-482e-9ce5-3d2572cb0599"
      role_definition_name = "Virtual Machine Administrator Login"
      rg_scope_name        = "ter-terenv-main-rg"
    }
    
    "Azure Agora IntApp Hub - MICROSOFT VirtualMachineAdmin" = {
      object_id            = "2907dff8-e61d-482e-9ce5-3d2572cb0599"
      role_definition_name = "Virtual Machine Administrator Login"
      rg_scope_name        = "ter-terenv-spoke-rg"
    }
}
*/