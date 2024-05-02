#! /bin/bash

[[ -z $FOLDER ]] && FOLDER=${PWD##*/}


[[ -z $PREFIX || -z $ENV || -z $FOLDER ]] && echo "missing env vars look for instructions in env.sh.template" && exit 1

[[ -f "./import.tf" ]] && rm ./import.tf

while read -r f;do 
    eval $f
    echo "routing group is $resourcegroupname"
    echo "location is $location"
    echo "source storage acconut is $sourcestorageaccount"

    ## check the resource exists on source
    sourcestorageaccount=$(az storage account show --id $sourcestorageaccount --query id -o tsv) 
    [[ -z $sourcestorageaccount ]] && (echo "storage account not found" ; exit 1 )

    ## check for eventgrid presence
    eventgridid=$(az eventgrid system-topic list -g $resourcegroupname --query "[?source=='$sourcestorageaccount'].id" -o tsv)

    echo "event grid id is $eventgridid"

    [[ -z $eventgridid  ]] || cat >> ./import.tf << EOF
import {
    to = azurerm_eventgrid_system_topic.nsglogs 
    id = "$eventgridid"
}
EOF
done <<<  $(cat ../../conf/.${ENV}.json  |jq -r '.eventgrid_sources | keys[] as $k | "nsgflowname=\($k) location=\(.[$k] | .location) sourcestorageaccount=\(.[$k] | .sourcestorageaccount) resourcegroupname=\(.[$k] | .resource_group_name)"')

## look for the resource in TF files
### sourcestorageaccount=$(grep 'nsgflowlogsource_north.*=' *.tf | cut -d= -f2 | tr -d '"')
### resourcegroupname=nsgflow

## check the resource exists on source
### sourcestorageaccount=$(az storage account show --id $sourcestorageaccount --query id -o tsv) 
### [[ -z $sourcestorageaccount ]] || (echo "storage account not found" ; exit 1 )

## check for eventgrid presence
### eventgridid=$(az eventgrid system-topic list -g $resourcegroupname --query "[?source=='$sourcestorageaccount'].id" -o tsv)

## [[ -z $eventgridid  ]] || cat >> ./import.tf << EOF
## import {
##    to = azurerm_eventgrid_system_topic.nsglogs 
##    id = "$eventgridid"
## }
## EOF



mainrg=$( az group list --query "[?name=='${PREFIX}-${ENV}-main-rg'].id" -o tsv)
spokerg=$( az group list --query "[?name=='${PREFIX}-${ENV}-spoke-rg'].id" -o tsv)

echo "main rg id is $mainrg "
echo "spoke rg id is $spokerg "

[[ -z $mainrg ]] || cat >> ./import.tf << EOF
    import {
        to = azurerm_resource_group.main
        id = "$mainrg"
    }
EOF

[[ -z $spokerg ]] ||cat >> ./import.tf << EOF
    import {
        to = azurerm_resource_group.spoke
        id = "$spokerg"
    }
EOF



