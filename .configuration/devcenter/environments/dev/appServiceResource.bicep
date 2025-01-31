@description('App Service Name')
param name string

@description('App Service Location')
param location string = resourceGroup().location

@description('App Service Plan Id')
param appServicePlanId string

@description('App Service Kind')
@allowed([
  'app'
  'app,linux'
  'app,linux,container'
  'hyperV'
  'app,container,windows'
  'app,linux,kubernetes'
  'app,linux,container,kubernetes'
  'functionapp'
  'functionapp,linux'
  'functionapp,linux,container,kubernetes'
  'functionapp,linux,kubernetes'
])
param kind string = 'app,linux'

@description('App Service Current Stack')
@allowed([
  'dotnetcore'
  'java'
  'node'
  'php'
])
param currentStack string = 'dotnetcore'

@description('netFrameworkVersion')
@allowed([
  '7.0'
  '8.0'
  '9.0'
  ''
])
param dotnetcoreVersion string = '9.0'

@description('App Settings')
param appSettings array = []

@description('Tags')
param tags object = {}

@description('LinuxFxVersion')
var linuxFxVersion = (contains(kind, 'linux')) ? '${toUpper(currentStack)}|${dotnetcoreVersion}' : null

@description('App Service Resource')
resource appService 'Microsoft.Web/sites@2024-04-01' = {
  name: '${name}-${uniqueString(resourceGroup().id,name)}-appsvc'
  location: location
  kind: kind
  tags: tags
  properties: {
    serverFarmId: appServicePlanId
    enabled: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      alwaysOn: true
      minimumElasticInstanceCount: 1
      http20Enabled: true
      appSettings: [
        {
          name: 'ConnectionStrings__DefaultConnection'
          value: 'Data Source=IdentityServer.db;'
        }
      ]
    }
  }
}
