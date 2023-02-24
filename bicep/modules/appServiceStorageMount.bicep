// Parameters
param webAppName string
param storageName string
param shareName string
param mountPath string

// Resources
resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: storageName
}

resource storageSetting 'Microsoft.Web/sites/config@2021-01-15' = {
  name: '${webAppName}/azurestorageaccounts'
  properties: {
    '${shareName}': {
      type: 'AzureFiles'
      shareName: shareName
      mountPath: mountPath
      accountName: storageAccount.name      
      accessKey: listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value
    }
  }
}
