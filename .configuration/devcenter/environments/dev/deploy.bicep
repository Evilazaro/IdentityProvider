param workloadName string = 'identityServer'

module sp 'appServicePlanResource.bicep' = {
  name: 'appServicePlanResource'
  params:{
    name: workloadName
    kind: 'app,linux'
    tags: {
      environment: 'dev'
      name: workloadName
    }
  }
}

module ws 'appServiceResource.bicep'= {
  name: 'appServiceResource'
  params: {
    name: workloadName
    appServicePlanId: sp.outputs.appServicePlanId 
  }
}
