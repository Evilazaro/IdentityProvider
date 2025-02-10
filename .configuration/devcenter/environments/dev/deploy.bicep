param name string = 'identityServerApp'

module monitoring 'logAnalyticsResource.bicep' = {
  name: 'logAnalyticsResource'
  params: {
    name: name
    tags: {
      environment: 'dev'
      name: name
    }
  }
}

module sp 'appServicePlanResource.bicep' = {
  name: 'appServicePlanResource'
  params:{
    name: name
    kind: 'app,linux'
    tags: {
      environment: 'dev'
      name: name
    }
  }
}

module ws 'appServiceResource.bicep'= {
  name: 'appServiceResource'
  params: {
    name: name
    appServicePlanId: sp.outputs.appServicePlanId 
    instrumentationKey: monitoring.outputs.InstrumentationKey
  }
}
