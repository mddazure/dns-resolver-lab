param vnetName string
param location string

param vnetaddressrange string
param subnet1name string
param subnet1range string
param subnet2name string
param subnet2range string
param subnet3name string
param subnet3range string

param delegation string

resource vnetdel 'Microsoft.Network/virtualNetworks@2022-01-01' = if (!empty(delegation)) {
  name: vnetName
  location: location
  properties:{
    addressSpace:{
      addressPrefixes:[
        vnetaddressrange       
      ]
    }
    subnets:[
      {
      name: subnet1name
      properties:{
        addressPrefix: subnet1range
        delegations: [
          {
          name: 'delegation'
          properties: {
            serviceName: delegation
            }
          }
        ]
        }
      }
      {
        name: subnet2name
        properties:{
          addressPrefix: subnet2range
          delegations: [
            {
            name: 'delegation'
            properties: {
              serviceName: delegation
              }
            }
          ]
        }
      }
      {
        name: subnet3name
        properties:{
          addressPrefix: subnet3range
        }
      }
    ]
  }
}
output vnetid string = vnetdel.id
output subnet1id string = vnetdel.properties.subnets[0].id
output subnet2id string = vnetdel.properties.subnets[1].id
output subnet3id string = vnetdel.properties.subnets[2].id
