variable "rg_name"{
    type = string
}
variable "location" {
    type = string
    default = "eastus"
}
variable "vnet_name"{
    type = string
    default = "363-gr-vnet"
}
variable "vnet_rg_name"{
    type = string
    default = "cs-connectedVNET"
}
variable "rt_name"{
    type = string
    default = "rt-Private"
}
variable "nsg_name"{
    type = string
}
variable "subnet_name"{
    type = string
}
variable "address_prefix"{
    type = string
}
variable "appvm_name"{
    type = string
}
variable "webvm_name"{
    type = string
}
variable "dbvm_name"{
    type = string
}
variable "loadbalancer_name"{
    type = string
}
variable "environment"{
    type = string
}
variable "application"{
    type = string
}
variable "owner"{
    type = string
}
variable "uai"{
    type = string
}