provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "git::https://github.com/danielscholl-terraform/module-resource-group?ref=v1.0.0"

  name     = "iac-terraform"
  location = "eastus2"

  resource_tags = {
    iac = "terraform"
  }
}

module "virtual_network" {
  source     = "git::https://github.com/danielscholl-terraform/module-virtual-network?ref=v1.0.1"
  depends_on = [module.resource_group]

  name                = "iac-terraform-vnet-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  address_space = ["192.168.1.0/24"]
  subnets = {
    AzureBastionSubnet = {
      cidrs = ["192.168.1.224/27"]

      configure_nsg_rules = true
    }
  }

  # Tags
  resource_tags = {
    iac = "terraform"
  }
}


module "bastion_host" {
  source              = "../"
  depends_on          = [module.virtual_network]
  name                = "iac-terraform-bastion-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
  vnet_subnet_id      = module.virtual_network.subnets["AzureBastionSubnet"].id

  # Tags
  resource_tags = {
    iac = "terraform"
  }
}
