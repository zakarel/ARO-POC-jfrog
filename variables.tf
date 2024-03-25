variable "location" {
  type    = string
  description = "azure resources location"
  default = "eastus"
}
variable "domain" {
  type = string
  nullable = false
  description = "(Mandatory) ARO Domain Name"
  
}