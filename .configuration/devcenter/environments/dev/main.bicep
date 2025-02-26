var workloadName = 'identityProvider'

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
    ConnectionString: monitoring.outputs.ConnectionString
    InstrumentationKey: monitoring.outputs.InstrumentationKey
  }
}

output RESOURCE_NAME string = webapp.outputs.webappName
output webappURL string = webapp.outputs.webappUrl
