@description('The name of the workload')
var workloadName = 'identityProvider'

@description('Location for the resources')
param location string = resourceGroup().location

@description('The environment for the deployment')
@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' existing = {
  name: resourceGroup().name
  scope: subscription()
}

@description('Module for Log Analytics and Application Insights')
module monitoring 'monitoring/monitoring.bicep' = {
  name: 'monitoring'
  scope: subscription()
  params: {
    workloadName : workloadName
    environment: environment
    location: location
  }
}

module security 'security/security.bicep' = {
  scope: rg
  name: 'security'
  params: {
    tags: {}
    keyVaultName: 'kv'
    secretName: 'gha'
    secretValue: 'example-secret-value'
    logAnalyticsWorkspaceId: monitoring.outputs.workspaceId
  }
}

@description('Module for App Service')
module webapp './core/appServiceResource.bicep' = {
  name: 'webapp'
  scope: rg
  params: {
    name: workloadName
    environment: environment
    keyVaultName: security.outputs.keyVaultName
    connectionString: monitoring.outputs.connectionString
    instrumentationKey: monitoring.outputs.instrumentationKey
    logAnalyticsWorkspaceId: monitoring.outputs.workspaceId
  }
}

@description('Output the name of the web app')
output resourceName string = webapp.outputs.webAppName

@description('Output the URL of the web app')
output webAppUrl string = webapp.outputs.webAppUrl
