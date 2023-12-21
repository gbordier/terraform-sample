. ./.env.sh

[[ -z $TENANT_ID  || -z $SUBSCRIPTION_ID || -z $PREFIX || -z $ENV || -z $FOLDER ]] && echo "missing env vars look for instructions in env.sh.template" && exit 1


cd ../infra/$FOLDER

terraform apply "out.plan"
