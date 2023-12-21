To Create an environnement
1) create /edit .env.sh from env.sh.sample 
2) run ./up.sh

If deploying from pipeline, 
    - create related github secrets/variables to map AAD Service Principal to github action


if deploying from script
run 
    - ./02-build.sh to create terraform plan
    - ./03-deploy.sh to actually run the terraform plan
    - ./99-down.sh to destroy everything