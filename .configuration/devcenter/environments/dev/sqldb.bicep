@secure()
param sqlpass string = '123#@!qweEWQ'

resource sqlServer 'Microsoft.Sql/servers@2014-04-01' = {
  name: 'identityPoviderServer'
  location: resourceGroup().location
  properties: {
    administratorLogin: 'saadmin'
    administratorLoginPassword: sqlpass
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2024-05-01-preview' = {
  name: 'identityProviderDB'
  location: resourceGroup().location
  parent: sqlServer
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

output sqlServerName string = sqlServer.name
output sqlServerDatabaseName string = sqlServerDatabase.name
