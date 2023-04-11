resource "azurerm_public_ip" "example" {
  name                = "IP-example01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"

  tags = local.tags
}

resource "azurerm_network_interface" "example" {
  name                = "nic-example01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_application_security_group" "example" {
  name                = "asg-example01"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = local.tags
}

resource "azurerm_network_interface_application_security_group_association" "example" {
  network_interface_id          = azurerm_network_interface.example.id
  application_security_group_id = azurerm_application_security_group.example.id
}

resource "random_integer" "storage_account_postfix" {
  min = 101
  max = 999
}

resource "azurerm_storage_account" "example" {
  name                     = "saksuvgsdemo${random_integer.storage_account_postfix.result}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}

resource "random_password" "local_administrator_account" {
  length           = 30
  override_special = "!@#%&*()-_=+<>:?"
}

resource "azurerm_key_vault_secret" "local_administrator_account" {
  name         = "vm-example01"
  value        = random_password.local_administrator_account.result
  key_vault_id = azurerm_key_vault.example.id

  depends_on = [
    azurerm_key_vault_access_policy.admin
  ]
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "vm-example01"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.vm_size
  admin_username      = "demo"
  admin_password      = random_password.local_administrator_account.result
  network_interface_ids = [
    azurerm_network_interface.example.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.example.primary_blob_endpoint
  }

  tags = local.tags
}