import json
with open ('../pipelines/adx/tf-vars/dev.json') as f:
        data = json.load(f)

for i, (key , value) in enumerate (data.items()):
        if "-rg" in key and not "terraform" in key and not "pipeline" in key:
                print (f"terraform import -var=\"tenant_id=$TENANT_ID\" -var-file=./environments/${{ENV}}.tfvars  azurerm_resource_group.{key} " + value )