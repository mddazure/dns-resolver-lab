param bastionSubnetid string
param location string

resource bastionpip 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'bastionpip'
  location: location
  sku: {
    name: 'Standard'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    publicIPAllocationMethod: 'Static' 
    publicIPAddressVersion: 'IPv4'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2022-01-01' ={
  name: 'bastion'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConf'
        properties: {
          subnet: {
            id: bastionSubnetid
          }
          publicIPAddress: {
            id: bastionpip.id
          }
        }
      }
    ]
    enableIpConnect: true

  }


}
