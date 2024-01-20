terraform {
  required_providers {
    cml2 = {
      source = "CiscoDevNet/cml2"
      version = "0.7.0"
    }
  }
}

provider "cml2" {
  address     = var.address
  username    = var.username
  password    = var.password
  skip_verify = true
} 

variable "address" {
  description = "CML controller address"
  type        = string
  default     = "https://cml-controller.cml.lab"
}

variable "username" {
  description = "cml2 username"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "cml2 password"
  type        = string
  sensitive   = true
} 

# Define lab

resource "cml2_lab" "devnet-expert" {
  title       = "DevNet Expert Lab"
  description = "This is the DevNet Expert Lab for study"
}

# Define nodes

resource "cml2_node" "ext" {
  lab_id         = cml2_lab.devnet-expert.id
  nodedefinition = "external_connector"
  label          = "Internet"
  configuration  = "System Bridge"
  x              = -600
  y              = 0
}

resource "cml2_node" "nat1" {
  lab_id         = cml2_lab.devnet-expert.id
  label          = "NAT"
  nodedefinition = "iosv"
  x              = -400
  y              = 0
}

resource "cml2_node" "ums1" {
  lab_id         = cml2_lab.devnet-expert.id
  label          = "UMS"
  nodedefinition = "unmanaged_switch"
  x              = -200
  y              = 0
}

resource "cml2_node" "cws1" {
  lab_id         = cml2_lab.devnet-expert.id
  label          = "CWS"
  nodedefinition = "cws"
  x              = -200
  y              = -150
}

resource "cml2_node" "nxos1" {
  lab_id         = cml2_lab.devnet-expert.id
  label          = "Nexus1"
  nodedefinition = "nxosv9000"
  x              = -200
  y              = 250
}

resource "cml2_node" "iosxe1" {
  lab_id         = cml2_lab.devnet-expert.id
  label          = "Router1"
  nodedefinition = "cat8000v"
  x              = -300
  y              = 100
}

resource "cml2_node" "iosxe2" {
  lab_id         = cml2_lab.devnet-expert.id
  label          = "Router2"
  nodedefinition = "cat8000v"
  x              = -100
  y              = 100
}

# Define links

resource "cml2_link" "l0" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.ext.id
  node_b = cml2_node.nat1.id
  slot_b = 0
}

resource "cml2_link" "l1" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.nat1.id
  node_b = cml2_node.ums1.id
  slot_a = 1
  slot_b = 0
}

resource "cml2_link" "l2" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.ums1.id
  node_b = cml2_node.cws1.id
  slot_a = 1
}

resource "cml2_link" "l3" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.ums1.id
  node_b = cml2_node.nxos1.id
  slot_a = 2
}

resource "cml2_link" "l4" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.ums1.id
  node_b = cml2_node.iosxe1.id
  slot_a = 3
  slot_b = 0
}

resource "cml2_link" "l5" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.ums1.id
  node_b = cml2_node.iosxe2.id
  slot_a = 4
  slot_b = 0
}

resource "cml2_link" "l6" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.iosxe1.id
  node_b = cml2_node.iosxe2.id
  slot_a = 1
  slot_b = 1
}

resource "cml2_link" "l7" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.iosxe1.id
  node_b = cml2_node.iosxe2.id
  slot_a = 2
  slot_b = 2
}

resource "cml2_link" "l8" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.iosxe1.id
  node_b = cml2_node.nxos1.id
  slot_a = 3
  slot_b = 1
}

resource "cml2_link" "l9" {
  lab_id = cml2_lab.devnet-expert.id
  node_a = cml2_node.iosxe2.id
  node_b = cml2_node.nxos1.id
  slot_a = 3
  slot_b = 2
}

# Define lifecycle resource

resource "cml2_lifecycle" "top" {
  lab_id = cml2_lab.devnet-expert.id
  elements = [
    cml2_node.ext.id,
    cml2_node.nat1.id,
    cml2_node.ums1.id,
    cml2_node.cws1.id,
    cml2_node.nxos1.id,
    cml2_node.iosxe1.id,
    cml2_node.iosxe2.id,
    cml2_link.l0.id,
    cml2_link.l1.id,
    cml2_link.l2.id,
    cml2_link.l3.id,
    cml2_link.l4.id,
    cml2_link.l5.id,
    cml2_link.l6.id,
    cml2_link.l7.id,
    cml2_link.l8.id,
    cml2_link.l9.id
  ]
  configs = {
    "NAT": file("configs/nat.conf"),
    "Router1": file("configs/router1.conf"),
    "Router2": file("configs/router2.conf"),
    "Nexus1": file("configs/nexus1.conf")
  }
}
