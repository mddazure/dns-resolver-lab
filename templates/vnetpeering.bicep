param vnet1Name string
param vnet2Name string
param vnet1id string
param vnet2id string

resource vnetpeer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-01-01' = {
  name: '${vnet1Name}/${vnet1Name}-${vnet2Name}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: true
    remoteVirtualNetwork: {
      id: vnet2id
    }
    useRemoteGateways: false
  }
}
