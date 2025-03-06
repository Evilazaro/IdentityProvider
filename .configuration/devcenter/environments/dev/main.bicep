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

@description('Module for Log Analytics and Application Insights')
module monitoring 'monitoring/monitoring.bicep' = {
  name: 'monitoring'
  scope: subscription()
  params: {
    workloadName: workloadName
    environment: environment
    location: location
  }
}

module security 'security/security.bicep' = {
  scope: subscription()
  name: 'security'
  params: {
    location: location
    logAnalyticsWorkspaceId: monitoring.outputs.workspaceId
    workloadName: workloadName
  }
}

@description('Module for App Service')
module webapp 'core/webapp.bicep' = {
  name: 'webapp'
  scope: subscription()
  params: {
    workloadName: workloadName
    location: location
    environment: environment
    keyVaultName: security.outputs.keyVaultName
    instrumentationKey: monitoring.outputs.instrumentationKey
    connectionString: monitoring.outputs.connectionString
    logAnalyticsWorkspaceId: monitoring.outputs.workspaceId
  }
}

@description('Output the name of the web app')
output resourceName string = webapp.outputs.webAppName

@description('Output the URL of the web app')
output webAppUrl string = webapp.outputs.webAppUrl
