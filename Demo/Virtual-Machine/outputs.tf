output "public_ip" {
  value = azurerm_public_ip.example.ip_address
  description = "Public IP address of the created VM"
}