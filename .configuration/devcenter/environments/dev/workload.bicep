targetScope = 'subscription'

@description('The name of the workload')
var workloadName = 'identityProvider'

@description('The environment for the deployment')
@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

@description('The location for the resource group')
param location string = 'eastus2'

@description('Resource group for the deployment')
resource securityRg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: '${workloadName}-security-RG'
  location: location
}

module security 'security/security.bicep'= {
  scope: securityRg
  name: 'security'
  params: {
    tags: {}
    keyVaultName: '${workloadName}-kv'	 
    secretName: 'gha-secret'
    secretValue: 'example-secret-value'
  }
}
  
@description('Resource group for the deployment')
resource monitoringRg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: '${workloadName}-monitoring-RG'
  location: location
}

@description('Module for Log Analytics and Application Insights')
module monitoring 'logAnalyticsResource.bicep' = {
  name: 'monitoring'
  scope: monitoringRg
  params: {
    name: '${workloadName}-loganalytics'
    tags: {
      environment: environment
      name: workloadName
    }
  }
}

@description('Resource group for the deployment')
resource workloadRg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: '${workloadName}-workload-RG'
  location: location
}

@description('Module for App Service')
module webapp 'appServiceResource.bicep' = {
  name: 'webapp'
  scope: workloadRg
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
