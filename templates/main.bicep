param rgName string ='dns-fwding-lab-20220928T062234Z'
//param rgName string = 'dns-fwding-lab-${utcNow()}'
param location string = 'uksouth'

param bastionVnetName string = 'bastionvnet'
param bastionVnetRange string = '172.16.100.0/24'
param bastionSubnetName string = 'AzureBastionSubnet'
param bastionSubnetRange string = '172.16.100.0/25'
param bastionSubnet2Name string = 'subnet2'
param bastionSubnet2Range string = '172.16.100.128/27'
param bastionSubnet3Name string = 'subnet3'
param bastionSubnet3Range string = '172.16.100.160/27'
var bastionVnetId = bastionvnet.outputs.vnetid
var bastionSubnetid = bastionvnet.outputs.subnet1id

param vnet1Name string = 'vnet1'
param vnet1Range string = '172.16.1.0/24'
param vnet1Subnet1Name string = 'subnet1'
param vnet1Subnet1Range string = '172.16.1.0/26'
param vnet1Subnet2Name string = 'subnet2'
param vnet1Subnet2Range string = '172.16.1.64/26'
param vnet1Subnet3Name string = 'subnet3'
param vnet1Subnet3Range string = '172.16.1.128/26'
var vnet1Id = vnet1.outputs.vnetid
var vnet1Subnet1id = vnet1.outputs.subnet1id
var vnet1Subnet2id = vnet1.outputs.subnet2id
var vnet1Subnet3id = vnet1.outputs.subnet3id

param vnet2Name string = 'vnet2'
param vnet2Range string = '172.16.2.0/24'
param vnet2Subnet1Name string = 'subnet1'
param vnet2Subnet1Range string = '172.16.2.0/26'
param vnet2Subnet2Name string = 'subnet2'
param vnet2Subnet2Range string = '172.16.2.64/26'
param vnet2Subnet3Name string = 'subnet3'
param vnet2Subnet3Range string = '172.16.2.128/26'
var vnet2Id = vnet2.outputs.vnetid
var vnet2Subnet1id = vnet2.outputs.subnet1id
var vnet2Subnet2id = vnet2.outputs.subnet2id
var vnet2Subnet3id = vnet2.outputs.subnet3id

param dnsVnetName string = 'dnsvnet'
param dnsVnetRange string = '192.168.0.0/24'
param dnsinboundSubnetName string = 'inboundsubnet'
param dnsinboundSubnetRange string = '192.168.0.0/27'
param dnsoutboundSubnetName string = 'outboundsubnet'
param dnsoutboundSubnetRange string = '192.168.0.32/27'
param dnsVMSubnetName string = 'vmsubnet'
param dnsVMSubnetRange string = '192.168.0.128/26'
var dnsVnetid = dnsvnet.outputs.vnetid
var dnsinboundSubnetid = dnsvnet.outputs.subnet1id
var dnsoutboundSubnetid = dnsvnet.outputs.subnet2id
var dnsVMSubnetidid = dnsvnet.outputs.subnet3id

param dnsresolverdelegation string = 'Microsoft.Network/dnsResolvers'

param dnsresolverName string = 'dnsresolver'

param vm1Name string = 'vm1'
param vm2Name string = 'vm2'
param dnsName string = 'dns'

targetScope = 'subscription'

param adminUsername string = 'AzureAdmin'

param adminPassword string = 'Privatedns-2022'

resource dnsrg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module vnet1 'vnet.bicep' = {
  name: 'vnet1'
  scope: dnsrg
  params: {
    location: location
    vnetName: vnet1Name
    vnetaddressrange: vnet1Range
    subnet1name: vnet1Subnet1Name
    subnet1range:vnet1Subnet1Range
    subnet2name:vnet1Subnet2Name
    subnet2range: vnet1Subnet2Range
    subnet3name: vnet1Subnet3Name
    subnet3range: vnet1Subnet3Range
  }
}

module vnet2 'vnet.bicep' = {
  name: 'vnet2'
  scope: dnsrg
  params: {
    location: location
    vnetName: vnet2Name
    vnetaddressrange: vnet2Range
    subnet1name: vnet2Subnet1Name
    subnet1range:vnet2Subnet1Range
    subnet2name:vnet2Subnet2Name
    subnet2range: vnet2Subnet2Range
    subnet3name: vnet2Subnet3Name
    subnet3range: vnet2Subnet3Range
  }
}

module bastionvnet 'vnet.bicep' = {
  name: 'bastionvnet'
  scope: dnsrg
  params: {
    location: location
    vnetName: bastionVnetName
    vnetaddressrange: bastionVnetRange
    subnet1name: bastionSubnetName
    subnet1range:bastionSubnetRange
    subnet2name:bastionSubnet2Name
    subnet2range: bastionSubnet2Range
    subnet3name: bastionSubnet3Name
    subnet3range: bastionSubnet3Range
  }
}
module dnsvnet 'vnetdns.bicep' = {
  name: 'dnsvnet'
  scope: dnsrg
  params: {
    location: location
    vnetName: dnsVnetName
    vnetaddressrange: dnsVnetRange
    subnet1name: dnsinboundSubnetName
    subnet1range:dnsinboundSubnetRange
    subnet2name: dnsoutboundSubnetName
    subnet2range: dnsoutboundSubnetRange
    subnet3name: dnsVMSubnetName
    subnet3range: dnsVMSubnetRange
    delegation: dnsresolverdelegation
  }
}

module vm1 'vm.bicep' = {
  name: 'vm1'
  scope: dnsrg
  params: {
    location: location
    vmName: vm1Name
    adminUser: adminUsername
    adminPw: adminPassword
    subnetId: vnet1Subnet1id
  }
}
module iisextvm1 'iisvmext.bicep' = {
  name: 'iisextvm1'
  scope: dnsrg
  dependsOn: [
    vm1
  ]
  params: {
    vmname: vm1Name
    location: location
  }
}
module vm2 'vm.bicep' = {
  name: 'vm2'
  scope: dnsrg
  params: {
    location: location
    vmName: vm2Name
    adminUser: adminUsername
    adminPw: adminPassword
    subnetId: vnet2Subnet1id
  }
}
module iisextvm2 'iisvmext.bicep' = {
  name: 'iisextvm2'
  scope: dnsrg
  dependsOn: [
    vm2
  ]
  params: {
    vmname: vm2Name
    location: location
  }
}
module dnsvm 'vm.bicep' = {
  name: 'dnsvm2'
  scope: dnsrg
  params: {
    location: location
    vmName: dnsName
    adminUser: adminUsername
    adminPw: adminPassword
    subnetId: dnsVMSubnetidid
    }
}
module dnsext 'dnsvmext.bicep' ={
  name: 'dnsext'
  scope: dnsrg
  dependsOn:[
    dnsvm
  ]
  params: {
    vmname: dnsName
    location: location
  }
}

module bastion 'bastion.bicep' = {
  scope: dnsrg
  name: 'bastion'
  dependsOn: [
    bastionvnet
  ]
  params: {
    bastionSubnetid: bastionSubnetid
    location: location
  }
}

module dnsresolver 'dnsresolver.bicep' = {
  scope: dnsrg
  name: 'dnsresolver'
  dependsOn: [
    dnsvnet
  ]
  params: {
    location: location
    dnsResolverinbsubid: dnsinboundSubnetid
    dnsResolveroutbsubid: dnsoutboundSubnetid
    dnsResolverVnetid: dnsVnetid
    dnsresolverName: dnsresolverName
    vnet1id: vnet1Id
    vnet2id: vnet2Id
  }
}

module peerb1 'vnetpeering.bicep' ={
  scope: dnsrg
  name: 'peerb1'
  dependsOn: [
    bastionvnet
    vnet1
  ]
  params: {
    vnet1Name: vnet1Name
    vnet2Name: bastionVnetName
    vnet1id: vnet1Id
    vnet2id: bastionVnetId
  }
}

module peer1b 'vnetpeering.bicep' ={
  scope: dnsrg
  name: 'peer1b'
  dependsOn: [
    bastionvnet
    vnet1
  ]
  params: {
    vnet2Name: vnet1Name
    vnet1Name: bastionVnetName
    vnet2id: vnet1Id
    vnet1id: bastionVnetId
  }
}

module peerb2 'vnetpeering.bicep' ={
  scope: dnsrg
  name: 'peerb2'
  dependsOn: [
    bastionvnet
    vnet2
  ]
  params: {
    vnet1Name: vnet2Name
    vnet2Name: bastionVnetName
    vnet1id: vnet2Id
    vnet2id: bastionVnetId
  }
}
module peer2b 'vnetpeering.bicep' ={
  scope: dnsrg
  name: 'peer2b'
  dependsOn: [
    bastionvnet
    vnet2
  ]
  params: {
    vnet2Name: vnet2Name
    vnet1Name: bastionVnetName
    vnet2id: vnet2Id
    vnet1id: bastionVnetId
  }
}

module peerbdns 'vnetpeering.bicep' ={
  scope: dnsrg
  name: 'peerbdns'
  dependsOn: [
    bastionvnet
    dnsvnet
  ]
  params: {
    vnet1Name: dnsVnetName
    vnet2Name: bastionVnetName
    vnet1id: dnsVnetid
    vnet2id: bastionVnetId
  }
}
module peerdnsb 'vnetpeering.bicep' ={
  scope: dnsrg
  name: 'peerdnsb'
  dependsOn: [
    bastionvnet
    dnsvnet
  ]
  params: {
    vnet2Name: dnsVnetName
    vnet1Name: bastionVnetName
    vnet2id: dnsVnetid
    vnet1id: bastionVnetId
  }
}
