// Scope
targetScope = 'subscription'

// Parameters
param location string = 'westeurope'
param resourceGroupName string = 'rg-uptime-kuma'
param appServicePlanName string = 'asp-uptime-kuma'
param webAppName string = 'wapp-${uniqueString(subscription().id)}'
param fileShareName string = 'fs-uptime-kuma'
param storageName string = 'stuk${uniqueString(subscription().id)}'

// Variables
var dockerRegistryHost = 'docker.io'
var linuxFxVersion = 'DOCKER|louislam/uptime-kuma:latest'
var fsMountPath = '/app/data'

// create resource group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// create storage account
module stg '../modules/storageAccount.bicep' = {
  scope: rg
  name: 'storage'
  params: {
    storageName: storageName
    location: location
  }  
}

// create file share to use as persistent storage for docker container
module fs '../modules/fileShare.bicep' = {
  scope: rg
  name: 'fileShare'
  params: {
    fileShareName: fileShareName
    storageName: stg.outputs.storageName
  }
}

// create app service plan
module asp '../modules/appServicePlan.bicep' = {
  scope: rg
  name: 'appServicePlan'
  params: {
    appServicePlanName: appServicePlanName
    location: location
  }
}

// create app service
module wapp '../modules/appServiceDockerPublic.bicep' = {
  scope: rg
  name: 'appService'
  params: {
    webAppName: webAppName
    appServicePlanId: asp.outputs.appServicePlanId
    dockerRegistryHost: dockerRegistryHost
    linuxFxVersion: linuxFxVersion
    location: location
  }
}

// mount fileshare as persistent storage
module mnt '../modules/appServiceStorageMount.bicep' = {
  scope: rg
  name: 'storageMount'
  params: {
    mountPath: fsMountPath
    shareName: fs.outputs.fileShareName
    storageName: stg.outputs.storageName
    webAppName: wapp.outputs.webAppName
  }
}
