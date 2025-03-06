targetScope = 'subscription'

@description('The name of the workload')
param workloadName string

@description('App Service Environment')
@allowed([
  'dev'
  'prod'
])
param environment string

@description('App Service Location')
param location string

param keyVaultName string

@secure()
@description('Instrumentation Key for Application Insights')
param instrumentationKey string

@secure()
@description('Connection String for Application Insights')
param connectionString string

param logAnalyticsWorkspaceId string

resource webappRg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: '${workloadName}-webapp-RG'
  location: location
}

module webapp 'appServiceResource.bicep' = {
  name: 'webapp'
  scope: webappRg
  params: {
    name: workloadName
    environment: environment
    keyVaultName: keyVaultName
    instrumentationKey: instrumentationKey
    connectionString: connectionString
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}


output webAppName string = webapp.outputs.webAppName
output webAppUrl string = webapp.outputs.webAppUrl
