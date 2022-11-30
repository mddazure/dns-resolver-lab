param location string
param dnsResolverVnetid string
param dnsResolverinbsubid string
param dnsResolveroutbsubid string
param dnsresolverName string
param vnet1id string
param vnet2id string
var outbepName = '${dnsresolverName}/outbep'
var inbepName = '${dnsresolverName}/inbep'

resource dnsresolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: dnsresolverName
  location: location
  properties: {
    virtualNetwork: {
      id: dnsResolverVnetid
    }
  }
}

resource outbep 'Microsoft.Network/dnsResolvers/outboundEndpoints@2022-07-01' = {
  name: outbepName
  location: location
  dependsOn:[
    dnsresolver
  ]
  properties: {
    subnet: {
      id: dnsResolveroutbsubid
    }
  }
}

resource inbep 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  name: inbepName
  location: location
  dependsOn: [
    dnsresolver
  ]
  properties: {
    ipConfigurations: [
      {    
      subnet: {
        id: dnsResolverinbsubid
          }
        }
      ]
    }
  }
resource fwdruleset 'Microsoft.Network/dnsForwardingRulesets@2022-07-01' = {
  name: 'fwdruleset'
  location: location
  dependsOn: [
    outbep
  ]
  properties: {
    dnsResolverOutboundEndpoints: [
      {
      id: outbep.id
      }
    ]
  }
}
resource fwdrule1 'Microsoft.Network/dnsForwardingRulesets/forwardingRules@2022-07-01' ={
  name: '${fwdruleset.name}/rule1'
  dependsOn: [
    fwdruleset
  ]
  properties:{
    domainName: 'fwd.test.'
    targetDnsServers: [
      {
        ipAddress: '192.168.0.132'
        port: 53
      }
    ]
    forwardingRuleState: 'Enabled'
  }
}
resource vnetlink1 'Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks@2022-07-01' = {
  name: 'fwdruleset/vnetlink1'
  dependsOn:[
    fwdruleset
  ]
  properties: {
    virtualNetwork: {
      id: vnet1id
    }
  }
}
resource vnetlink2 'Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks@2022-07-01' = {
  name: 'fwdruleset/vnetlink2'
  dependsOn:[
    fwdruleset
  ]
  properties: {
    virtualNetwork: {
      id: vnet2id
    }
  }
}
