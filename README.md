# **Private DNS Resolver with Forwarding Rules**
#Introduction
This lab demonstrates use of [DNS Forwarding Rulesets](https://learn.microsoft.com/en-us/azure/dns/private-resolver-endpoints-rulesets#dns-forwarding-rulesets) to forward DNS requests from VNETs to a DNS server, either in a VNET or on-premise, *without* network connectivity between VNETs.

The lab consists of:
- Two Client VNETs each containing a client VM.
- A DNS VNET containing:
  - A Private DNS Resolver instance with inbound and outbound endpoints.
  - A DNS Server VM containing zone and A record entry for the FQDN `test.fwd.test`.
- DNS Forwarding Ruleset linked to the Client VNETs and the Private DNS Resolver.
- A Bastion VNET containing a Bastion instance, peered to all three VNETs.
 
There is no network connectivity between the Client and DNS VNETs; they are not directly peered and VMs in these VNETs cannot reach one another.

![image](images/dns-resolver-lab.png)

 
# Deploy
Log in to Azure Cloud Shell at https://shell.azure.com/ and select Bash.

Ensure Azure CLI and extensions are up to date:
  
      az upgrade --yes
  
If necessary select your target subscription:
  
      az account set --subscription <Name or ID of subscription>
  
Clone the  GitHub repository:
  
      git clone https://github.com/mddazure/dns-resolver-lab/
  
Change directory:
  
      cd ./dns-resolver-lab

Deploy the Bicep template:

      az deployment sub create --location westeurope --template-file templates/main.bicep

Verify that all components in the diagram above have been deployed to a resourcegroup named `dns-fwding-lab-<date>T<time>Z` and are healthy. 

VM login credentials:

username: `AzureAdmin`

password: `Privatedns-2022`

# Explore
Locate the DNS Private Resolver named `dnsresolver` and note that this has an outbound endpoint named `outbep` in the VNET `dnsvnet`.

Locate the DNS Forwarding Ruleset named `fwdruleset`. Verify that this is tied to the endpoint `outbep` of Resolver `dnsresolver`, and linked to `vnet1` and `vnet2`. Under Rules, note `rule1` is set to forward requests for Domain `fwd.test.` to address `192.168.0.132:53`. This is the address of VM `dnsvm` in VNET `dnsvnet`.

Log on to `dnsvm`. Open DNS Manager from the Tools menu in Server Manager.



# Test

Log on to vm1 or vm2 through Bastion.

Open a command prompt 