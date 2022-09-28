param vmname string
param location string



resource iisext 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
    name: '${vmname}/iisext'
    location: location
    properties:{
      publisher: 'Microsoft.Compute'
      type: 'CustomScriptExtension'
      typeHandlerVersion: '1.10'
      autoUpgradeMinorVersion: false
      protectedSettings:{}
      settings: {
          commandToExecute: 'powershell -ExecutionPolicy Unrestricted Add-WindowsFeature Web-Server; powershell -ExecutionPolicy Unrestricted Add-Content -Path "C:\\inetpub\\wwwroot\\Default.htm" -Value $($env:computername)'
      }
    }  
  }
