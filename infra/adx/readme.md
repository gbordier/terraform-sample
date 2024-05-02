For eventgrid data connection creation, the pipeline account or the one reunning terraform needs to have 
- Storage.Account/listKeys access on the source storage account
- EventGris Subscription Contributor on the resource group

> Note !!! **if an existing system topic exists for the storage account we will not be able to create the system topic and need only to create the event subscription**
