param location string = resourceGroup().location
param hostingPlanName string


resource hostingPlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: hostingPlanName 
  location: location
  kind: 'Linux'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

output hostingPlanId string = hostingPlan.id
