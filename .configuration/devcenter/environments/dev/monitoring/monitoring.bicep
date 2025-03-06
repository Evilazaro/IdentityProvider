@description('The name of the workload')
param workloadName string

@description('The environment for the deployment')
@allowed([
  'dev'
  'prod'
])
param environment string

@description('Module for Log Analytics and Application Insights')
module monitoring 'logAnalyticsResource.bicep' = {
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

output workspaceId string = monitoring.outputs.workspaceId
output connectionString string = monitoring.outputs.connectionString
output instrumentationKey string = monitoring.outputs.instrumentationKey
