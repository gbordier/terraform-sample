. ./.env.sh

[[ -z $TENANT_ID  || -z $SUBSCRIPTION_ID || -z $PREFIX || -z $ENV ]] && echo "missing env vars look for instructions in env.sh.template" && exit 1

cd ../infra/$FOLDER

folder=${PWD##*/}
keyVaultName=$PREFIX-$ENV-pl-kv

[[ $(az account get-access-token -o tsv --query "expiresOn")  < $(date +"%Y-%m-%d %H:%M:%S") ]] &&  az login --tenant "$TENANT_ID"




az keyvault secret list --vault-name $keyVaultName
## cauthion but loads secrets as environment variables replace dashes with underscores
eval $(az keyvault secret list --vault-name $keyVaultName --query "[].[name]" -o tsv | xargs -l1 az keyvault secret show --vault-name $keyVaultName   --name |  jq -r '(.name | gsub("-";"_"))  +"="+ (.value | @sh) '  )


terraform plan -var-file=./environments/${ENV}.tfvars \
    -var="tenant_id=$TENANT_ID" \
    -out="out.plan"

terraform destroy -var-file=./environments/${ENV}.tfvars \
    -var="tenant_id=$TENANT_ID" \


cd ../../scripts


./environment.sh --tenant-id $TENANT_ID  --subscription-id $SUBSCRIPTION_ID  --location northeurope --prefix $PREFIX \
    --env $ENV --folder $FOLDER down

az keyvault purge --name $PREFIX-$ENV-pl-kv



## cd to the terrform folder for this part
