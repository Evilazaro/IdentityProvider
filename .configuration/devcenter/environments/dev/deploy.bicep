param name string 

module sp '../AppServicePlan/appServicePlanResource.bicep' = {
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


module ws '../appServiceResource.bicep'= {
  name: 'appServiceResource'
  params: {
    name: name
    appServicePlanId: sp.outputs.appServicePlanId 
  }
}
