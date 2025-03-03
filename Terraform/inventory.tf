resource "local_file" "inventory" {
  content  = <<EOT
[ALL]
${azurerm_public_ip.public_ip[0].ip_address} ansible_ssh_user=VladKuliavets
EOT
  filename = "./inventory"
}
