#!/bin/bash
. ./.env.sh
appfile=.${ENV}-aad-builder.json
AZURE_CLIENT_ID=$(cat ../conf/$appfile | jq -r  .appId  )
AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
AZURE_TENANT_ID=$TENANT_ID

for var in  AZURE_TENANT_ID AZURE_SUBSCRIPTION_ID AZURE_CLIENT_ID ;
do
    echo "Setting $var"
    gh secret set $var -e $ENV  -a actions -b $!{var}
    
done
