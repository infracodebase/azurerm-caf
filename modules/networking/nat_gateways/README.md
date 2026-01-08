# NAT Gateway Module

This module creates an Azure NAT Gateway with optional subnet and public IP associations.

## Features

- Creates Azure NAT Gateway with CAF naming conventions
- Optional subnet association for outbound traffic
- Optional public IP association
- Configurable idle timeout
- Zone redundancy support
- Tag management

## Usage

```hcl
module "nat_gateway" {
  source = "./modules/networking/nat_gateways"

  name                    = "my-nat-gateway"
  location               = "East US"
  resource_group_name    = "my-rg"
  idle_timeout_in_minutes = 10

  settings = {
    zones = ["1", "2", "3"]  # Optional: Availability zones
    subnet_key = "my-subnet-key"  # Optional: For subnet association
    public_ip_key = "my-pip-key"  # Optional: For public IP association
  }

  # Required for subnet association (when subnet_key is specified)
  subnet_id = azurerm_subnet.example.id

  # Required for public IP association (when public_ip_key is specified)
  public_ip_address_id = azurerm_public_ip.example.id

  global_settings = var.global_settings
}
```

## Variables

### Required
- `name`: Name of the NAT Gateway
- `location`: Azure region
- `resource_group_name`: Resource group name
- `global_settings`: Global CAF settings for naming

### Optional
- `idle_timeout_in_minutes`: TCP idle timeout (4-120 minutes, default: 4)
- `settings`: Configuration object containing:
  - `zones`: Array of availability zones
  - `subnet_key`: Key for subnet association module
  - `public_ip_key`: Key for public IP association module
- `subnet_id`: Subnet ID for association (required if subnet_key is set)
- `public_ip_address_id`: Public IP ID for association (required if public_ip_key is set)

## Outputs

- `id`: NAT Gateway resource ID
- `name`: NAT Gateway name
- `resource_group_name`: Resource group name

## Notes

- The NAT Gateway provides outbound internet connectivity for resources in associated subnets
- Public IP association is required for internet access
- Idle timeout controls how long TCP connections remain open when inactive
- Zone redundancy provides high availability across availability zones

## Example with Full Configuration

```hcl
module "nat_gateway_complete" {
  source = "./modules/networking/nat_gateways"

  name                    = "prod-nat-gateway"
  location               = "East US 2"
  resource_group_name    = "networking-rg"
  idle_timeout_in_minutes = 30

  settings = {
    zones = ["1", "2", "3"]
    subnet_key = "web-subnet"
    public_ip_key = "nat-public-ip"
  }

  subnet_id            = module.virtual_network.subnets["web-subnet"].id
  public_ip_address_id = module.public_ip.id

  global_settings = var.global_settings
}
```