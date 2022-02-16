##############################################################
# This module allows the creation of an Azure Bastion
##############################################################

variable "name" {
  description = "The name of the Resource Group."
  type        = string
  default     = null
}

variable "names" {
  description = "Names to be applied to resources (inclusive)"
  type = object({
    environment = string
    location    = string
    product     = string
  })
  default = {
    location    = "eastus2"
    product     = "iac"
    environment = "tf"
  }
}

variable "resource_group_name" {
  description = "The name of an existing resource group."
  type        = string
}

variable "public_ip_address_allocation" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "Defines the service SKU to use for the Bastion Host. Options are Basic or Standard."
  type        = string
  default     = "Basic"

  validation {
    condition     = (contains(["basic", "standard"], lower(var.sku)))
    error_message = "The sku must be either \"Basic\" or \"Standard\"."
  }
}

variable "domain_name_label" {
  description = "Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system"
  default     = null
}

variable "vnet_subnet_id" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type        = string
}
