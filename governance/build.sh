




PREFIX=ter
ENV=terenv

keyVaultName=$PREFIX-$ENV-pl-kv
az login

az keyvault secret list --vault-name $keyVaultName
## cauthion but loads secrets as environment variables replace dashes with underscores
eval $(az keyvault secret list --vault-name $keyVaultName --query "[].[name]" -o tsv | xargs -l1 az keyvault secret show --vault-name $keyVaultName   --name |  jq -r '(.name | gsub("-";"_"))  +"="+ (.value | @sh) '  )



folder=${PWD##*/}

terraform init --reconfigure  -backend-config="storage_account_name=${PREFIX}${ENV}tfsa" \
	-backend-config="container_name=terraform-state" \
	-backend-config="access_key=$SA_ACCOUNTKEY" \
	-backend-config="key=${PWD##*/}.terraform.tfstate" \
	-backend-config="resource_group_name=${PREFIX}-${ENV}-tf-rg"

terraform plan -var-file=./environments/${ENV}.tfvars -out="out.plan"
