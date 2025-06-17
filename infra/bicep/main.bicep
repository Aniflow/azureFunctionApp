targetScope = 'subscription'

param environmentName string
param location string
param dtap string

var dtapInitial = string(first(toLower(dtap)))
var abbrs = loadJsonContent('abbreviations.json')

var storageAccountName = string('${environmentName}${abbrs.storageStorageAccounts}${dtapInitial}')
var hostingPlanName = string('${environmentName}-${abbrs.hostingPlan}${dtapInitial}')
var functionAppName = string('${environmentName}-${abbrs.functionApp}${dtapInitial}')


resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: '${environmentName}-${abbrs.resourcesResourceGroups}${dtapInitial}'
  location: location
}

module storageAccount 'storage/storage-account.bicep' = {
  name: 'storageAccountDeployment'
  scope: resourceGroup
  params: {
    storageAccountName: storageAccountName
  }
}

module hostingPlan 'hosting/hosting-plan.bicep' = {
  name: 'hostingPlanDeployment'
  scope: resourceGroup
  params: {
    hostingPlanName: hostingPlanName
  }
}

module functionApp 'functionapp/function-app.bicep' = {
  name: 'functionAppDeployment'
  scope: resourceGroup
  params: {
    functionAppName: functionAppName
    hostingPlanId: hostingPlan.outputs.hostingPlanId
    storageAccountName: storageAccountName
    packageUri: '1' 
  }
  dependsOn: [
    storageAccount
  ]
}
