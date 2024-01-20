# DevNet Expert Lab on Cisco Modeling Labs

This is a very basic DevNet Expert Lab on Cisco Modeling Labs managed by Terraform CML2 provider.

## Overview

| Device | Type | OS | Ext. Mgmt IP | Int. Mgmt IP | Description |
| ------ | ----------- | -- | ------------ | ------------ | ----------- |
| UMS    | Unmanaged Switch | Linux Bridge | - | - | Unmanaged switch for OOB mgmt |
| CWS    | CWS | Ubuntu | 192.168.1.101 | 192.168.255.2 | DevNet Expert Candidate Workstation |
| Router1 | CAT8000V | IOS-XE | - | 192.168.255.51 | - |
| Router2 | CAT8000V | IOS-XE | - | 192.168.255.52 | - |
| Nexus1 | NX-OS 9000 | NX-OS | - | 192.168.255.53 | - |

This lab was tested with the following software versions:

- Terraform v1.7.0
- Terraform provider registry.terraform.io/ciscodevnet/cml2 v0.7.0
- Cisco Modeling Labs Version 2.6.0+build.5 (Personal license)

## Lab Prerequesites

### Cisco Modeling Labs and Software Images

For this lab to run you need to purchase [Cisco Modeling Labs](https://www.cisco.com/c/en/us/products/cloud-systems-management/modeling-labs/index.html#~overview) with a Personal license. Please refer to the [Cisco Modeling Labs documentation](https://developer.cisco.com/docs/modeling-labs/) for system requirements and installation guide.

Make sure you have all software images specified above available in your Cisco Modeling Labs, especially the DevNet Expert Candidate Workstation. For more information about the Cisco Certified DevNet Expert (v1.0) Equipment and Software List and how to install CWS in CML check the [Cisco Learning Network](https://learningnetwork.cisco.com/s/article/devnet-expert-equipment-and-software-list).

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
