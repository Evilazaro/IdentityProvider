var workloadName = 'identityProvider'

@allowed([
  'dev'
  'prod'
])
param environment string = 'dev'

module monitoring 'logAnalyticsResource.bicep' = {
  name: 'monitoring'
  scope: resourceGroup()
  params: {
    name: '${workloadName}-monitoring'
    tags: {
      environment: 'dev'
      name: workloadName
    }
  }
}

module webapp 'appServiceResource.bicep' = {
  name: 'webapp'
  scope: resourceGroup()
  params: {
    name: workloadName
    environment: environment
    ConnectionString: monitoring.outputs.ConnectionString
    InstrumentationKey: monitoring.outputs.InstrumentationKey
  }
}

output RESOURCE_NAME string = webapp.outputs.webappName
output WEB_APP_URL string = webapp.outputs.webappUrl
