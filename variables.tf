variable "location" {
  type    = string
  description = "azure resources location"
  default = "eastus"
}

resource "random_string" "random" {
  length           = 15
  special          = false
  upper            = false
  numeric          = true
}

variable "domain" {
  type = string
  description = "(Mandatory) ARO Domain Name. example - jfrog-poc. without the domain suffix"
  default = "jfrog443poc"
  
}