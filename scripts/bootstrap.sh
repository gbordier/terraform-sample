## this is meant to be run from the pipelines folder
. ./.env.sh

[[ -z $TENANT_ID  || -z $SUBSCRIPTION_ID || -z $PREFIX || -z $ENV || -z $FOLDER ]] && echo "missing env vars look for instructions in env.sh.template" && exit 1

[[ -z $USE_OIDC ]] && USE_OIDC=false

if [[ -z $GITHUB_REPO || -z $GITHUB_ORG ]]; then 

./environment.sh --tenant-id $TENANT_ID  --subscription-id $SUBSCRIPTION_ID  --location northeurope --prefix $PREFIX \
    --use-oidc $USE_OIDC --env $ENV --folder $FOLDER  up 
else
echo "this is github mode"
./environment.sh --tenant-id $TENANT_ID  --subscription-id $SUBSCRIPTION_ID  --location northeurope --prefix $PREFIX \
    --use-oidc $USE_OIDC --env $ENV --folder $FOLDER  --github-org $GITHUB_ORG --github-repo $GITHUB_REPO up 
fi



