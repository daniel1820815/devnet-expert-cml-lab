# DevNet Expert Lab on Cisco Modeling Labs

This is a very basic DevNet Expert Lab on Cisco Modeling Labs managed by Terraform CML2 provider.

This lab was tested with the following software versions:

- Terraform v1.7.0
- Terraform provider registry.terraform.io/ciscodevnet/cml2 v0.7.0
- Cisco Modeling Labs Version 2.6.0+build.5 (Personal license)

## Overview

| Device | Type | OS | Ext. Mgmt IP | Int. Mgmt IP | Description |
| ------ | ----------- | -- | ------------ | ------------ | ----------- |
| Internet | External Connector | - | - | - | External connector in bridge mode |
| NAT    | IOSv | IOS | 192.168.1.100 | 192.168.255.1 | NAT router for external connectivity |
| UMS    | Unmanaged Switch | Linux Bridge | - | - | Unmanaged switch for OOB mgmt |
| Router1 | CAT8000V | IOS-XE | - | 192.168.255.51 | - |
| Router2 | CAT8000V | IOS-XE | - | 192.168.255.52 | - |
| Nexus1 | NX-OS 9000 | NX-OS | - | 192.168.255.53 | - |
| CWS    | CWS | Ubuntu | 192.168.1.101 | - | DevNet Expert Candidate Workstation |

The DevNet Expert Candidate Workstation (CWS) was previously within CML but is now a virtual machine on VMWare ESXi Hypervisor and external to the CML lab because of performance reasons. The following network configuration was applied to connect to the lab devices directly:

1. Edit ```/etc/netplan/00-cws-dhcp-config.yaml``` with your favorite editor as *sudo* and safe it:

    ```bash
    network:
        version: 2
        renderer: networkd
        ethernets:
            ens160:
                addresses:
                    - 192.168.1.101/24
                nameservers:
                    search: [lab.local]
                    addresses: [192.168.1.1]
                routes:
                    - to: default
                    via: 192.168.1.1
                    - to: 192.168.255.0/24
                    via: 192.168.1.100
    ```

2. Run ```sudo netplan apply``` for the changes to be applied.

## Lab Prerequesites

### Cisco Modeling Labs and Software Images

For this lab to run you need to purchase [Cisco Modeling Labs](https://www.cisco.com/c/en/us/products/cloud-systems-management/modeling-labs/index.html#~overview) with a Personal license. Please refer to the [Cisco Modeling Labs documentation](https://developer.cisco.com/docs/modeling-labs/) for system requirements and installation guide.

Make sure you have all software images specified above available in your Cisco Modeling Labs. The DevNet Expert Candidate Workstation can be downloaded from the Cisco Certified DevNet Expert (v1.0) Equipment and Software List and how to install CWS as VM check the [Cisco Learning Network](https://learningnetwork.cisco.com/s/article/devnet-expert-equipment-and-software-list).

### Terraform

Download and install the [latest version of Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform) on your local machine.

[Terraform CML2 provider](https://registry.terraform.io/providers/CiscoDevNet/cml2/latest/docs) will be downloaded during the Terraform initialization as it reads it from the Terraform main.tf file.

### Customize the Lab Files

Clone this repository to your local machine and customize the lab files.

1. Add your Cisco Modeling Labs details to the environment source file which will be used by Terraform:

    ```bash
    TF_VAR_address="https://cml"    # Your CML IP address or hostname
    TF_VAR_username="admin"         # Your CML username
    TF_VAR_password="password"      # Your CML password

    export TF_VAR_username TF_VAR_password TF_VAR_address 
    ```

2. Edit all IP addresses of the device configuration files starting with ```192.168.``` in the configs folder and replace it with your own home or lab IP network and appropriate subnet mask.

## Start the Lab

1. Run ```source .envrc``` to load the CML environment variables.

2. Initialize Terraform using ```terraform init```

3. Run ```terraform plan``` and review the plan before applying.

4. Apply the Terraform plan with ```terraform apply``` and wait until the lab is online.

## Stop (Destroy) the Lab

Run ```terraform destroy``` to destroy the lab again. Be aware that the lab is fully removed and all configurations on the devices are lost.
