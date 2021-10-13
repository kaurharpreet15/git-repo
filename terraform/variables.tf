variable "rg_name"{
    type = string
    default = "terraform_module"
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
