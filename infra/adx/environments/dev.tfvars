location = "northeurope"
env = "dev"
prefix ="adx"


//cr_sku = "Basic"

//subscription_id = "08cbb954-de41-4f3e-9e24-cc915f96714b"
lz_subscription_id = "30ee7660-5010-445b-8bd1-6f4cf54c89a7"
//platform_connectivity_subscription = "08cbb954-de41-4f3e-9e24-cc915f96714b"
//platform_connectivity_subscription = "a5614dbc-94c9-4aae-90f6-dc38858b6ff9"


vnetAddressSpace= ["10.252.163.0/24"]
subnetAddressSpace1= ["10.252.163.0/28"]
subnetAddressSpace2= ["10.252.163.32/28"]
/*
replaced by json version in .env.json
eventgrid_sources =  {
        "nsgflow-west" = {
        sourcestorageaccount = "/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/adx-west/providers/Microsoft.Storage/storageAccounts/stnsgflowlogswest",
        location = "westeurope",
        resource_group_name = "nsglogs"
        },
     
        "nsgflow-north" = {
        sourcestorageaccount = "/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/nsgflow/providers/Microsoft.Storage/storageAccounts/gbordierstnsgflowlogs" ,
        location = "northeurope",
        resource_group_name = "nsglogs"
    }

}
*/
nsgresourcegroup_north="nsgflow"
nsgflowlogsource_north="/subscriptions/30ee7660-5010-445b-8bd1-6f4cf54c89a7/resourceGroups/nsgflow/providers/Microsoft.Storage/storageAccounts/gbordierstnsgflowlogs"

  