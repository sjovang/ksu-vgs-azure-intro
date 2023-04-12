# App Service

Deploy an app service by using Bicep

## Usage

1. Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
2. Login to Azure: `az login`
3. Create a new resource group: `az group create --name rg-ksu-vgs-appservice-demo --location "westeurope"`
3. Deploy the Bicep template: `az deployment group create --resource-group rg-ksu-vgs-appservice-demo --template-file main.bicep`

To delete the resource group and all resources, run: `az group delete --name rg-ksu-vgs-appservice-demo --yes`