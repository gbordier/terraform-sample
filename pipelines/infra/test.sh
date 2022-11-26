
PREFIX=ter
ENV=terenv

keyVaultName=$PREFIX-$ENV-pl-kv
az login

az keyvault secret list --vault-name $keyVaultName
## cauthion but loads secrets as environment variables replace dashes with underscores
eval $(az keyvault secret list --vault-name $keyVaultName --query "[].[name]" -o tsv | xargs -l1 az keyvault secret show --vault-name $keyVaultName   --name |  jq -r '(.name | gsub("-";"_"))  +"="+ (.value | @sh) '  )

## shell variable do not support dashes :( 
terraform init -backend-config="storage_account_name=${PREFIX}${ENV}tfsa" -backend-config="container_name=terraform-state" -backend-config="access_key=$SA_ACCOUNTKEY" -backend-config="key=terraform.tfstate"
terraform plan -var-file=./tf-vars/${ENV}.tfvars -var="client_id=$SP_ID" -var="client_secret=$SP_PASSWORD" -var="tenant_id=$TENANT_ID" -var="subscription_id=$SUBSCRIPTION_ID" -out="out.plan"
## apply the plan
terraform apply "out.plan"