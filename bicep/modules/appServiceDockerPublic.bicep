// Scope
targetScope = 'resourceGroup'

// Parameters
param webAppName string = 'wapp-${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param appServicePlanId string
param dockerRegistryHost string = 'mcr.microsoft.com' // use 'docker.io' for Docker hub
param linuxFxVersion string = 'DOCKER|azuredocs/containerapps-helloworld:latest'

//Resources
resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${dockerRegistryHost}'
        }
        {
          name: 'DOCKER_ENABLE_CI'
          value: 'true'
        }
      ]
    }
  }
}

output webAppName string = appService.name
