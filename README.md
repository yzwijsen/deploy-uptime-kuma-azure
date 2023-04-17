# :rocket: Deploy Uptime Kuma on Azure App Service
Bicep script to automatically deploy [Uptime Kuma](https://github.com/louislam/uptime-kuma) on Azure app service with persistent storage

## About

This bicep deployment will create and configure the following resources:
- App Service Plan
- App Service
- Storage Account with file share

see the full diagram [below.](https://github.com/yzwijsen/deploy-uptime-kuma-azure/blob/main/README.md#azure-resource-diagram)

> Note: The fileshare will be setup as a **persistent volume** on the app service (mounted at /app/data in the docker container, which is where uptime kuma stores all it's files).  

> Note: **Continuous Integration** is turned on so whenever you restart the app service the latest uptime kuma build will be fetched automatically.

## How to deploy

1. **Clone** repo  
  *(or download manually but make sure you have all the bicep modules and keep the same folder structure)*
  
2. **Deploy** the main.bicep file (bicep/deploy/main.bicep)  
   - **Using VS Code:**  
   add the bicep extension and then right click the bicep file inside VS Code and choose **Deploy Bicep File**.  
   ![deploy using vs code](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/media/quickstart-create-bicep-use-visual-studio-code/vscode-bicep-deploy.png)  
   VS Code will then authenticate you with Azure (if needed) and show a prompt for each parameter.

   - **Using Azure CLI:**  
     
     bash:
     ```bash
     az deployment sub create --template-file main.bicep --parameters \
      location="westeurope" \
      resourceGroupName="rg-uptime-kuma" \
      appServicePlanName="asp-uptime-kuma" \
      appServicePlanSku="B1" \
      appServicePlanTier="Basic" \
      webAppName="wapp-uptime-kuma-$(openssl rand -hex 4)" \
      fileShareName="fs-uptime-kuma" \
      storageName="stuk$(openssl rand -hex 5)"
     ```
     
     powershell:
     ```powershell
     $RandomSuffix = -join ((65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object { [char]$_ })
     
     az deployment sub create --template-file main.bicep --parameters `
      location="westeurope" `
      resourceGroupName="rg-uptime-kuma" `
      appServicePlanName="asp-uptime-kuma" `
      appServicePlanSku="B1" `
      appServicePlanTier="Basic" `
      webAppName="wapp-uptime-kuma-$RandomSuffix" `
      fileShareName="fs-uptime-kuma" `
      storageName="stuk$RandomSuffix"
     ```

3. A few minutes after the deployment finishes you should be able to access your uptime kuma instance at https://***{webAppName}***.azurewebsites.net

## Parameters

| **Parameter** | **Default Value** | **Description** |
|---|---|---|
| location | westeurope | Location where all resources will be deployed |
| resourceGroupName | rg-uptime-kuma | Name of the resource group to put all resources under |
| appServicePlanName | asp-uptime-kuma | Name of the app service plan |
| appServicePlanSku | B1 | App service plan sku |
| appServicePlanTier | Basic | App service plan tier |
| webAppName | wapp-${uniqueString(subscription().id)} | Name of the web app. This will also become the hostname of your web app so it needs to be globally unique |
| fileShareName | fs-uptime-kuma | Name of the file share |
| storageName | stuk${uniqueString(subscription().id)} | Name of the storage account (needs to be globally unique) |

## Azure Resource Diagram

![2023-02-28 14_30_09-Visualize main bicep - deploy-uptime-kuma-azure - Visual Studio Code](https://user-images.githubusercontent.com/1075201/228477660-2cae6e48-c7bc-4159-9466-16f3fa6a2848.png)
