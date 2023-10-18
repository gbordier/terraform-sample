## this is meant to be run from the pipelines folder
. ./.env.sh

[[ -z $TENANT_ID  || -z $SUBSCRIPTION_ID || -z $PREFIX || -z $ENV || -z $FOLDER ]] && echo "missing env vars look for instructions in env.sh.template" && exit 1


./environment.sh --tenant-id $TENANT_ID  --subscription-id $SUBSCRIPTION_ID  --location northeurope --prefix $PREFIX --env $ENV up



