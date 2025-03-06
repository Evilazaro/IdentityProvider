@description('The environment for the deployment')
@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

@description('The location for the resource group')
param location string = 'eastus2'

module workload 'workload.bicep' = {
  scope: subscription()
  name: 'workload'
  params: {
    environment: environment
    location: location
  }
}
