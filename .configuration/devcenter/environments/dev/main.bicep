@description('The name of the workload')
var workloadName = 'identityProvider'

@description('The environment for the deployment')
@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

@description('Module for Log Analytics and Application Insights')
module monitoring './monitoring/logAnalyticsResource.bicep' = {
  name: 'monitoring'
  scope: resourceGroup()
  params: {
    name: '${workloadName}-loganalytics'
    tags: {
      environment: environment
      name: workloadName
    }
  }
}

module security 'security/security.bicep'= {
  scope: resourceGroup()
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
  scope: resourceGroup()
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
