@minLength(3)
@maxLength(20)
param fileShareName string = 'fs-default'
param storageName string

var fileSharePath = '${storageName}/default/${fileShareName}'

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-09-01' = {
  name: fileSharePath
}

output fileShareName string = fileShareName
output fileSharePath string = fileSharePath
