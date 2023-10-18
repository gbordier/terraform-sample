folder=${PWD##*/}

. ../pipelines/$folder/.env.sh

[[ -z $TENANT_ID  || -z $SUBSCRIPTION_ID || -z $PREFIX || -z $ENV ]] && echo "missing env vars look for instructions in env.sh.template" && exit 1

## load variables and secrets from keyvault
keyVaultName=$PREFIX-$ENV-pl-kv
tenant_id=$(cat ./tf-vars/${ENV}.json  | jq -r '."tenant-id"' | sed 's/"//g')

## this will provoke an interactive login
[[ $(az account get-access-token -o tsv --query "expiresOn")  < $(date +"%Y-%m-%d %H:%M:%S") ]] &&  az login --tenant "$tenant_id"

az keyvault secret list --vault-name $keyVaultName
## cauthion but loads secrets as environment variables replace dashes with underscores
eval $(az keyvault secret list --vault-name $keyVaultName --query "[].[name]" -o tsv | xargs -l1 az keyvault secret show --vault-name $keyVaultName   --name |  jq -r '(.name | gsub("-";"_"))  +"="+ (.value | @sh) '  )

## cd to the terrform folder for this part
cd ../../$folder

## shell variable do not support dashes :( 
terraform init -backend-config="storage_account_name=${PREFIX}${ENV}tfsa" \
    -backend-config="container_name=terraform-state" \
    -backend-config="access_key=$SA_ACCOUNTKEY" \
    -backend-config="key=${PWD##*/}.terraform.tfstate" \
    -backend-config="resource_group_name=${PREFIX}-${ENV}-tf-rg"

## for this test we have created the rgsource groups to be able to set delegation on those before terraform
## we need to import them in the state 


rg=$(cat ../pipelines/$folder/tf-vars/${ENV}.json | jq -r '.terraform.resourceGroups."main-rg"')
terraform import  -var="tenant_id=$TENANT_ID" -var-file=./environments/${ENV}.tfvars   "azurerm_resource_group.main" $rg
rg=$(cat ../pipelines/$folder/tf-vars/${ENV}.json | jq -r '.terraform.resourceGroups."spoke-rg"')
terraform import  -var="tenant_id=$TENANT_ID" -var-file=./environments/${ENV}.tfvars   "azurerm_resource_group.spoke" $rg


terraform plan -var-file=./environments/${ENV}.tfvars \
    -var="tenant_id=$TENANT_ID" \
    -out="out.plan"



