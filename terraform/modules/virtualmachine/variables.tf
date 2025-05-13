variable "rg_name" {
    type = string
    default = "terraform_module"
}

variable "subnet_name"{
    type = string
}
variable "vnet_name"{
    type = string
    default = "364-gr-vnet"
}
variable "vnet_rg_name"{
    type = string
    default = "cs-connectedVNET"
}
variable "key_vault_name"{
    type = string
 }
variable "vm_name"{
    type = string
}
