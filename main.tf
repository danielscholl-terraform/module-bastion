##############################################################
# This module allows the creation of an Azure Bastion
##############################################################

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_public_ip" "pip" {
  name                = (var.name == null ? "${local.name}-ip" : lower(var.name))
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  allocation_method   = var.public_ip_address_allocation
  sku                 = "Standard"
  domain_name_label   = var.domain_name_label != null ? var.domain_name_label : format("gw%s%s", lower(replace(local.name, "/[[:^alnum:]]/", "")), random_string.random.result)

  tags = var.resource_tags
}

resource "azurerm_bastion_host" "main" {
  name                = (var.name == null) ? "${local.name}-bastion" : lower(var.name)
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  sku                 = var.sku

  ip_configuration {
    name                 = "${local.name}-bastion"
    subnet_id            = var.vnet_subnet_id
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = var.resource_tags
}
