ENV=dev
PROJECT=abyss
REPO=$PROJECT
ORG=gbordier_microsoft



appname=github-action-${PROJECT}-${ENV}

[[ -f ./.$appname.json ]] && appjson=$(cat ./.$appname.json) || appjson=$(az ad app create --display-name $appname)


a=$(az ad app create --display-name github-actions-abyss-dev)

appid=$(echo $appjson | jq -r '.appId')

sp=$(az ad sp list --query "[?appId=='$appid'].id" -o tsv --all)

[[ -z $sp ]] && sp=$(az ad sp create --id $appid --query id -o tsv)
az ad sp list --all --query "[?appId=='$appid']"  > ./.$appname-sp.json


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

az ad app federated-credential create --id $appid --parameters ./.credential.json
