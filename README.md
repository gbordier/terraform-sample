#  Why this template 
First off this template is meant to leverage enterprise-scale like deployment either on
- Az Devops
- Github actions

It is therefore meant to be deployed on *multiple* subscription where the runner / service principal has all permissions at the subscription level

However, since this might not be practical for testing,  the ./environment.sh script is provided to: 
- create several resource groups to serve as delegation points for terraform
- create a storage account to store the TF state file

> Note:
>
>- In "command line" or "Az Devops" mode we need to use a service principal for Terraform to get access to Azure so the script actually creates/modify an AAD Service Principal and stores the secret in a dedicated keyvault. The terraform service principal has access to the target resource group the secret for those loaded in the SPID and SPPASSWORD variables and the Storage account key SAACCOUNTKEY variable contains the key for terraform to access its state.

>- In "github action"  mode we use Github and Terraform AAD integration and we use the same service principal and grant it access to the target resource groups.

TODO : move azdevops to OICD integration

# How to use

## repo folder structure
- **infra** contains the terraform code for the infrastructure (infra), an ADX cluster with event hub sample (adx), a governance sample (governance) and a function sample (function)
- **pipelines** contains the azure devops pipeline  yaml file
- **.github/workflows** contains the github actions pipeline yaml file
- **conf** contains the project configuration files 
- **scripts** contains the scripts to create the environment and bootstrap the pipeline

## What are Pipeline Resources
Pipeline resource groupe contains resources are necessary to run pipelines, if Terraform OICD integration there is no necessary resources, 
Otherwise , it is where we create the keyvault with the necessary service principal secrets for terraform to deploy resources.

only the owner is delegated access to this resource group.


## What are Terraform  Resources
Terraform resource group stores Terraform specific resources such as the storage account that holds the terraform state

The Terraform service principal has access to this resource group

When Terraform AAD integration is enabled, the same SP is used for the pipeline and terraform identity.


## Prerequisites
create a .env.sh fil using the env.sh.template file for guidance



```
TENANT_ID=<your tenant id>
SUBSCRIPTION_ID=<your subscription id>
PREFIX=<a short prefix to prepend all resource names>
ENV=<the environment name> # dev, test, prod, etc. will also be added to the resource names
FOLDER=<terraform folder> # adx,infra,governance, function ... the folder with the terraform code to use within the infra folder
USE_OIDC=true ## instruct the bootstrap script to use OIDC for terraform and az cli access
```


# Boot strap
Bootstraping the pipeline means create necessary objects to run the pipeline itself, such as creating Service Principals,  secrets , and delegating access at the subscription or resource group level to those SPs.

Bootstraping is also useful when we want to test terraform code locally without the pipeline to help

> note : good security practices commands that both terraform secrets and related SP do not have permissions on multiple environments we can re-use the same storage account for the state but we need separate containers for each environment

The environment bootstraping script is heavily inspired by [Maninderjit Bindra](https://twitter.com/maniSbindra)'s article on [Medium](https://medium.com/@maninder.bindra/creating-a-single-azure-devops-yaml-pipeline-to-provision-multiple-environments-using-terraform-e6d05343cae2).



## OIDC (OAuth) or not

OIDC (Oauth) github or azdevops integration is the best way for deploying from a pipeline, since no secret need to be kept. 
But sometimes it is not possible (such as when we deploy from the command line)

When is we cannot use OIDC for terraform and azure access we also:
- create a SP and secret for terraform and delegates the SP permissions to the target resource groups
- create a keyvault for terraform in the pipeline resource group
- store the SP secret and the storage account account key in the keyvault
- for az devops create a service connection in Az Devops to access the keyvault and an associated SP
- (TODO) for github actions create a separate  SP with access to the keyvault and associated secret and store them in github secrets to access the keyvault

using two SPs allow to segregate access from the pipeline and from terraform if necessary

if running in an environment SP can be delegated the entire subscription :
- the environment script does not neeed to create resource groups and can simply delegate the SP at the subscription level
- the build.sh script does not need to try importing the created resource groups.

*at this point the environmnet script always creates the resource groups, so don't use it if you can delegate the SP to the whole sub*


# GitHub terraform template

the github action template is located in the .guthub/workflow/cd.yml file.

it performs the following actions:
- sets the variable for github and terraform AAD integration
- init the terraform state in the storage account
- identify target resource groups and create import blocks for them

# Azure DevOps pipeline template

## secret management with Az Devops
the azdevops pipelines are from  [Maninderjit Bindra](https://twitter.com/maniSbindra)'s article on [Medium](https://medium.com/@maninder.bindra/creating-a-single-azure-devops-yaml-pipeline-to-provision-multiple-environments-using-terraform-e6d05343cae2).

cd.yml has been slightly modified so that we ensure the same version of terraform runs on build and deploy phase.


### pipeline secret management with Az Devops
using the  template at ../templates/pipeline-secrets.yml pulls the secret from the keyvault that has been created by the environment script.

SP_ID and SP_PASSWORD are pulled from the keyvault and used for terraform to login to azure



# Environments

### Creating an environment
1. create e .env.sh file from the env.sh.template file  and set the following variable
   - TENANT_ID
   - PREFIX (this string will prefix all your resource names)
   - ENV
2. Run `./01-bootstrap.sh`

   This will create the needed service principals, an Azure DevOps service connection and the following resource groups and resources:

   - **[PREFIX]-[ENV]-pl-rg**
     - _[PREFIX]-[ENV]-pl-kv_: Key vault for pipeline secrets
   - **[PREFIX]-[ENV]-tf-rg**
     - _[PREFIX][env]tfsa_: Storage account for Terraform
       - _terraform-state_: Blob container for Terraform state
   - **[PREFIX]-[ENV]-main-rg**
     - This represent the "hub" landing zone where we will not be deploying anything
   - **[PREFIX]-[ENV]-spoke-rg** where we deploy all resources

3.  linking to your CICD pipelint:
 - In Azure DevOps, go to `Project settings Service connections` (or click the link from the script output), select your new connection, click `Edit` and `Verify connection`. Click OK.
 - in GithubAction, use the ghsecrets.sh file to load the environments Service principal, subscription and tenant ids in github secrets for your environnement

4. Create a `tfvars` file for the new environment at `infra/tf-vars/[ENV].tfvars`. Use the same environment identifier that you used with the script.

### Removing an environment

use the ./99-down.sh script to remove resources and then delete environnemnt 

## Pipelines

### Creating a pipeline

1. In Azure DevOps, create a new pipeline using existing YAML file. Available pipeline templates are described below.
2. Add an environment variables `PREFIX` and `ENV` with the same values that you used with the environment script.
3. Run the pipeline.
4. Rename your pipeline with environment specific name so they are easier to recognize.
5. You may want to add a manual approval check before deploying to some environments. Approval checks can be created in Azure DevOps at `Pipelines > Environments > [PREFIX]-[ENV]-infra > Approvals and checks`.

### Infra pipeline templates

#### Continuous Delivery (`pipelines/infra/cd.yml`)

Runs Terraform plan against your environment and after successful plan, the changes will be applied and the updated infrastructure will be deployed. The pipeline will be triggered when new infra-related commits are pushed to the master branch (i.e. after merged pull request).

#### Continuous Integration (`pipelines/infra/ci.yml`)

Runs Terraform plan against your environment, but will not apply the changes. The pipeline will be triggered for infra-related pull requests on GitHub or BitBucket. For Azure DevOps repos, you need to setup a build validation from the repo settings.

### API pipeline templates

#### Continuous Delivery (`pipelines/api/cd.yml`)

Builds a Docker image from the API source code, pushes it to the container registry and triggers deployment for the app using `az webapp create` command. The pipeline will be triggered when new API-related commits are pushed to the master branch (i.e. after merged pull request).

#### Continuous Integration (`pipelines/api/ci.yml`)

Builds a Docker image from the API source code. The pipeline will be triggered for API-related pull requests on GitHub or BitBucket. For Azure DevOps repos, you need to setup a build validation from the repo settings.

### Functions pipeline templates

#### Continuous Delivery (`pipelines/functions/cd.yml`)

Builds a zip archive from the functions source code and deploys a new version of the functions app using `az functionapp deployment` command. The pipeline will be triggered when new functions-related commits are pushed to the master branch (i.e. after merged pull request).

#### Continuous Integration (`pipelines/functions/ci.yml`)

Builds a Docker image from the API source code. The pipeline will be triggered for API-related pull requests on GitHub or BitBucket. For Azure DevOps repos, you need to setup a build validation from the repo settings.

## Example Azure resources

The included Terraform configuration creates the following Azure resources:

- **storage.tf**
  - Storage account
  - Storage container for logs
  - SAS token
- **db.tf**
  - CosmosDB account
  - MongoDB database
- **api.tf**
  - Container registry
  - Linux app service plan
  - Dockerized Node.js app with database connection
- **functions.tf**
  - Linux functions app service plan
  - Application insights
  - Python functions app with database connection


## Terraform installation tricks

on WSL , update hashicorp.gpg with latest signature to get > 1.6
```
curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg
sudo cp ./hashicorp.gpg   /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo apt update
sudo install terraform

```