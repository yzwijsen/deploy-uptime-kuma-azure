// Parameters
param appServicePlanName string = 'asp-${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param sku string = 'B1'
param tier string = 'Basic'

// Resources
resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
    tier: tier
  }
  kind: 'linux'
}

// Output
output appServicePlanId string = appServicePlan.id
