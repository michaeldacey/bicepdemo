targetScope = 'resourceGroup'

param storageNamePrefix string
param containerRegistryName string
param serviceBusName string
param appName string
param appServicePlanName string = 'appSrvName-${appName}'
param location string = resourceGroup().location


resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: '${storageNamePrefix}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: '${containerRegistryName}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
  }
}

/*
  Service Bus is a cloud messaging service provided by Azure. It enables communication between applications and services, 
  even if they are running on different platforms or in different locations. Service Bus supports various messaging patterns 
  such as publish/subscribe, request/response, and message queues. It provides reliable message delivery, scalability, and 
  advanced features like message ordering, duplicate detection, and dead-lettering. Service Bus can be used for building 
  decoupled and scalable architectures, implementing event-driven systems, and integrating distributed applications.
*/

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: '${serviceBusName}${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${appServicePlanName}${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'linux'
  sku: {
    name: 'B1'
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: '${appName}${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    clientAffinityEnabled: false
    httpsOnly: true
  }
}



