resource "azurerm_resource_group" "Lab4_AIC" {
  name     = "Kul_lab4-group"
  location = "West Europe"
}

resource "azurerm_virtual_network" "Lab4_AIC" {
  name                = "Kul_lab4-network"
  location            = azurerm_resource_group.Lab4_AIC.location
  resource_group_name = azurerm_resource_group.Lab4_AIC.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "Lab4_AIC" {
  name                 = "Kul_lab4-subnet"
  resource_group_name  = azurerm_resource_group.Lab4_AIC.name
  virtual_network_name = azurerm_virtual_network.Lab4_AIC.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "Lab4_AIC" {
  name                = "Kul_lab4-nic"
  location            = azurerm_resource_group.Lab4_AIC.location
  resource_group_name = azurerm_resource_group.Lab4_AIC.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Lab4_AIC.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "Lab4_AIC" {
  name                = "Kullab4machine"
  resource_group_name = azurerm_resource_group.Lab4_AIC.name
  location            = azurerm_resource_group.Lab4_AIC.location
  size                = "Standard_B1s"
  admin_username      = "Vladusla-Kuliavets"

  network_interface_ids = [azurerm_network_interface.Lab4_AIC.id]

  admin_ssh_key {
    username   = "Vladusla-Kuliavets"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}