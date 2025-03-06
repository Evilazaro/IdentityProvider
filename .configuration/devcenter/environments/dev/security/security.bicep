targetScope = 'subscription'

@description('The name of the workload')
param workloadName string

@description('Key Vault Location')
param location string

@description('Log Analytics Workspace')
param logAnalyticsWorkspaceId string

resource securityRg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: '${workloadName}-security-RG'
  location: location
}

module keyvault 'keyvault.bicep' = {
  scope: securityRg
  name: 'keyvault'
  params: {
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}

@description('The name of the Key Vault')
output keyVaultName string = keyvault.outputs.keyVaultName

@description('The identifier of the secret')
output secretIdentifier string = keyvault.outputs.secretIdentifier

@description('The endpoint URI of the Key Vault.')
output endpoint string = keyvault.outputs.endpoint
