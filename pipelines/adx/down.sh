. ./.env.sh

[[ -z $TENANT_ID  || -z $SUBSCRIPTION_ID || -z $PREFIX || -z $ENV ]] && echo "missing env vars look for instructions in env.sh.template" && exit 1


 ./environment.sh --tenant-id $TENANT_ID  --subscription-id $SUBSCRIPTION_ID  --location northeurope --prefix adx --env dev down

folder=${PWD##*/}
keyVaultName=$PREFIX-$ENV-pl-kv
tenant_id=$(cat ./tf-vars/${ENV}.json  | jq -r '."tenant-id"' | sed 's/"//g')

[[ $(az account get-access-token -o tsv --query "expiresOn")  < $(date +"%Y-%m-%d %H:%M:%S") ]] &&  az login --tenant "$tenant_id"



az keyvault secret list --vault-name $keyVaultName
## cauthion but loads secrets as environment variables replace dashes with underscores
eval $(az keyvault secret list --vault-name $keyVaultName --query "[].[name]" -o tsv | xargs -l1 az keyvault secret show --vault-name $keyVaultName   --name |  jq -r '(.name | gsub("-";"_"))  +"="+ (.value | @sh) '  )

## cd to the terrform folder for this part
cd ../../$folder



terraform plan -var-file=./environments/${ENV}.tfvars \
    -var="tenant_id=$TENANT_ID" \
    -out="out.plan"

terraform destroy -var-file=./environments/${ENV}.tfvars \
    -var="tenant_id=$TENANT_ID" \


az keyvault purge --name $PREFIX-$ENV-pl-kv

