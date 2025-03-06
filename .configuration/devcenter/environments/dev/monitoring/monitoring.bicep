targetScope = 'subscription'

@description('The name of the workload')
param workloadName string

@description('Location for the resources')
param location string

@description('The environment for the deployment')
@allowed([
  'dev'
  'prod'
])
param environment string

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

output workspaceId string = monitoring.outputs.workspaceId
output connectionString string = monitoring.outputs.connectionString
output instrumentationKey string = monitoring.outputs.instrumentationKey
