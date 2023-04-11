# Common
variable "location" {
  type        = string
  default     = "norwayeast"
  description = "Region in Azure where resources will be created"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags to apply to all resources"
}

# Network
variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.42.0.0/16"]
  description = "Address space for Virtual Network"
}

# Security rules
variable "allowed_rdp_ip_addresses" {
  type        = list(string)
  default     = []
  description = "List of IP addresses allowed to connect to the VM over RDP"
}

# Virtual Machine
variable "vm_size" {
  type        = string
  default     = "Standard_B2ms"
  description = "Size of VM. Get available SKUs with az vm list-sizes --location <region>"
}