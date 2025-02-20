param workloadName string

module sp 'appServicePlanResource.bicep' = {
  name: 'appServicePlanResource'
  params:{
    name: '${workloadName}-${uniqueString(workloadName,resourceGroup().id)}'
    location: resourceGroup().location
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
    name: '${workloadName}-${uniqueString(workloadName,resourceGroup().id)}'
    appServicePlanId: sp.outputs.appServicePlanId 
  }
}

