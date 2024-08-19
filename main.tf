# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_resource_group" "webserver_rg" {
  name     = "noor-webserver-rg"
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "webserver_vnet" {
  name                = "noor-webserver-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.webserver_rg.location
  resource_group_name = azurerm_resource_group.webserver_rg.name
  tags                = local.tags
}

resource "azurerm_subnet" "webserver_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.webserver_rg.name
  virtual_network_name = azurerm_virtual_network.webserver_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create the Public IP Address
resource "azurerm_public_ip" "webserver_pip" {
  name                = "noor-webserver-pip"
  location            = azurerm_resource_group.webserver_rg.location
  resource_group_name = azurerm_resource_group.webserver_rg.name
  allocation_method   = "Dynamic"
  tags                = local.tags
}

resource "azurerm_network_interface" "webserver_nic" {
  name                = "noor-webserver-nic"
  location            = azurerm_resource_group.webserver_rg.location
  resource_group_name = azurerm_resource_group.webserver_rg.name
  tags                = local.tags
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.webserver_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.webserver_pip.id
  }
}

# Define the Network Security Group (NSG)
resource "azurerm_network_security_group" "webserver_nsg" {
  name                = "noor-webserver-nsg"
  location            = azurerm_resource_group.webserver_rg.location
  resource_group_name = azurerm_resource_group.webserver_rg.name
  tags                = local.tags
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the NSG with the Network Interface
resource "azurerm_network_interface_security_group_association" "webserver_nic_sg_assoc" {
  network_interface_id      = azurerm_network_interface.webserver_nic.id
  network_security_group_id = azurerm_network_security_group.webserver_nsg.id
}

resource "azurerm_linux_virtual_machine" "webserver_vm" {
  name                = "noor-webserver-machine"
  resource_group_name = azurerm_resource_group.webserver_rg.name
  location            = azurerm_resource_group.webserver_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  tags                = local.tags
  network_interface_ids = [
    azurerm_network_interface.webserver_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.vm_ssh_public_key #file("~/.ssh/id_rsa.pub")
  }

  os_disk { 
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Provision a script to install Nginx directly in custom_data
  custom_data = base64encode(<<-EOT
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
  EOT
  )

}

variable "vm_ssh_public_key" {
  description = "The public SSH key to use for the virtual machine."
  type        = string
}