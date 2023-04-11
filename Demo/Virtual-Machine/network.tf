resource "azurerm_virtual_network" "example" {
  name                = "vnet-ksu-vgs-vm-demo"
  address_space       = var.vnet_address_space
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  tags = local.tags
}

resource "azurerm_subnet" "example" {
  name                 = "snet-example"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space[0], 8, 0)]
  service_endpoints = [
    "Microsoft.KeyVault"
  ]
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-ksu-vgs-vm-demo"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_security_rule" "in_deny_all" {
  name                        = "in_deny_all"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_security_rule" "in_allow_rdp" {
  name                    = "in_allow_rdp"
  priority                = 3000
  direction               = "Inbound"
  access                  = "Allow"
  protocol                = "Tcp"
  source_port_range       = "*"
  destination_port_range  = "3389"
  source_address_prefixes = var.allowed_rdp_ip_addresses
  destination_application_security_group_ids = [
    azurerm_application_security_group.example.id
  ]
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}