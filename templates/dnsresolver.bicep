param location string
param dnsResolverVnetid string
param dnsResolverinbsubid string
param dnsResolveroutbsubid string
param dnsresolverName string
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
