ENV=dev
PROJECT=abyss
BRANCH=main
REPO=terraform-sample
ORG=gbordier_microsoft

$envconffile=./pipeline/tf-vars/$ENV.json

appname=github-action-${PROJECT}-${ENV}

[[ -f ./.$appname.json ]] && appjson=$(cat ./.$appname.json) || appjson=$(az ad app create --display-name $appname)


a=$(az ad app create --display-name github-actions-abyss-dev)

appid=$(echo $appjson | jq -r '.appId')

sp=$(az ad sp list --query "[?appId=='$appid'].id" -o tsv --all)

[[ -z $sp ]] && sp=$(az ad sp create --id $appid --query id -o tsv)
az ad sp list --all --query "[?appId=='$appid']"  > ./.$appname-sp.json


if [[ -z $github_environment]]; then

cat > ./.credential.json <<EOF
{
    "name": "Testing",
    "issuer": "https://token.actions.githubusercontent.com",    
    "subject": "repo:$ORG/$REPO:environment:$ENV",
    "description": "Testing",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}
EOF

else

cat > ./.credential.json <<EOF
{
    "name": "Testing",
    "issuer": "https://token.actions.githubusercontent.com",    
    "subject": "repo:$ORG/$REPO:refs:ref/heads/$BRANCH",
    "description": "Testing",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}
EOF

fi
az ad app federated-credential create --id $appid --parameters ./.credential.json


  for i in $(cat $envconffile  | jq ".pipeline.resourceGroups | .[] "); do
    echo "assigning rbac roles to github sp on created resource groups"
    r=$(az role assignment create --assignee "$appid" --scope "$i" --role "owner")
  done
  for i in $(cat $envconffile  | jq ".pipeline.resourceGroups | .[] "); do
    echo "assigning rbac roles to github sp on created resource groups"
    r=$(az role assignment create --assignee "$appid" --scope "$i" --role "owner")
  done


## set permissison on storage account
terraform_rg = $(cat $envconffile  | jq -r ".pipeline.resourceGroups.terraform-rg")
az role assignment create --assignee "$appid" --scope "$terraform_rg" --role "Storage Blob Data Contributor"

az role assignment create --assignee "$appid" --scope "$pipeline_kv_id" --role "reader"
az keyvault set-policy --name $pipeline_kv --spn $appid --subscription "$SUBSCRIPTION_ID" --secret-permissions "get" "list"

    r=$(az role assignment create --assignee "$appid" --scope "$pipeline_kv_id" --role "reader")
    
    echo
