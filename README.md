# deploy-uptime-kuma-azure
bicep script to deploy Uptime Kuma on Azure app service with persistent storage

## About

This bicep deployment will create and configure the following resources:
- App Service Plan
- App Service
- Storage Account with file share

> The fileshare will be setup as a **persistent volume** on the app service (mounted at /app/data in the docker container, which is where uptime kuma stores all it's files).  

> **Continuous Integration** is turned on so whenever you restart the app service the latest uptime kuma build will be fetched automatically.

## How to deploy

1. **Clone** repo  
  *(or download manually but make sure you have all the bicep modules and keep the same folder structure)*
  
2. **Deploy** the main.bicep file (bicep/deploy/main.bicep)  
  - **Using VS Code:**  
  add the bicep extension and then right click the bicep file inside VS Code and choose **Deploy Bicep File**.  
  ![deploy using vs code](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/media/quickstart-create-bicep-use-visual-studio-code/vscode-bicep-deploy.png)  
  VS Code will then authenticate you with Azure (if needed) and show a prompt for each parameter.
  
  - **Using Azure CLI:**  
  `az deployment sub create --template-file main.bicep`  
  
3. A few minutes after the deployment finishes you should be able to access your uptime kuma instance at https://***{webAppName}***.azurewebsites.net
