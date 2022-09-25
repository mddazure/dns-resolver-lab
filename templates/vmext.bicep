param vmname string
param location string


resource ext 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  name: '${vmname}/dnsext'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    settings: 'commandToExecute: powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name DNS -IncludeManagementTools; powershell -ExecutionPolicy Unrestricted Add-DnsServerPrimaryZone -Name fwd.test; powershell -ExecutionPolicy Unrestricted Add-DnsServerResourceRecordA -Name test -IPv4Address 10.0.1.1 -ZoneName fwd.test -TimeToLive 01:00:00'  

  }



}
