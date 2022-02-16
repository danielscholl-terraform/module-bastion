# Module Azure Bastion

Module for creating and managing Azure Bastion.

## Usage

```
module "resource_group" {
  source = "git::https://github.com/danielscholl-terraform/module-resource-group?ref=v1.0.0"

  name     = "iac-terraform"
  location = "eastus2"

  resource_tags          = {
    environment = "test-environment"
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
  source     = "git::https://github.com/danielscholl-terraform/module-bastion?ref=v1.0.0"
  depends_on          = [module.virtual_network]
  
  name                = "iac-terraform-bastion-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
  vnet_subnet_id      = module.virtual_network.subnets["AzureBastionSubnet"].id

  # Tags
  resource_tags = {
    iac = "terraform"
  }
}
```

<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.90.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| domain\_name\_label | Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system | `any` | n/a | yes |
| name | The name of the Resource Group. | `string` | n/a | yes |
| names | Names to be applied to resources (inclusive) | <pre>object({<br>    environment = string<br>    location    = string<br>    product     = string<br>  })</pre> | <pre>{<br>  "environment": "tf",<br>  "location": "eastus2",<br>  "product": "iac"<br>}</pre> | no |
| public\_ip\_address\_allocation | Defines how an IP address is assigned. Options are Static or Dynamic. | `string` | `"Static"` | no |
| resource\_group\_name | The name of an existing resource group. | `string` | n/a | yes |
| resource\_tags | Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in | `map(string)` | `{}` | no |
| sku | Defines the service SKU to use for the Bastion Host. Options are Basic or Standard. | `string` | `"Basic"` | no |
| vnet\_subnet\_id | The subnet id of the virtual network where the virtual machines will reside. | `string` | n/a | yes |

## Outputs

No output.
<!--- END_TF_DOCS --->
