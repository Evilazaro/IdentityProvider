@description('The name of the workload')
var workloadName = 'identityProvider'

@description('The environment for the deployment')
@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

module security 'security/security.bicep'= {
  scope: resourceGroup()
  name: 'security'
  params: {
    tags: {}
    keyVaultName: 'keyvault'	 
    secretName: 'gha-secret'
    secretValue: 'example-secret-value'
  }
}
  
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
  dependsOn: [
    security
  ]
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
  }
}

@description('Output the name of the web app')
output resourceName string = webapp.outputs.webAppName

@description('Output the URL of the web app')
output webAppUrl string = webapp.outputs.webAppUrl
