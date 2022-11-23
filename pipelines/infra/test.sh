
PREFIX=ter
ENV=terenv

keyVaultName=$PREFIX-$ENV-pl-kv
az login

az keyvault secret list --vault-name $keyVaultName
## cauthion but loads secrets as environment variables
eval $(az keyvault secret list --vault-name $keyVaultName --query "[].[name]" -o tsv | xargs -l1 az keyvault secret show --vault-name $keyVaultName   --name |  jq -r '(.name | gsub("-";""))  +"="+ (.value | @sh) '  )

## shell variable do not support dashes :( 
terraform init -backend-config="storage_account_name=${PREFIX}${ENV}tfsa" -backend-config="container_name=terraform-state" -backend-config="access_key=$SAACCOUNTKEY" -backend-config="key=terraform.tfstate"
terraform plan -var-file=./tf-vars/${ENV}.tfvars -var="client_id=$SPID" -var="client_secret=$SPPASSWORD" -var="tenant_id=$TENANTID" -var="subscription_id=$SUBSCRIPTIONID" -out="out.plan"