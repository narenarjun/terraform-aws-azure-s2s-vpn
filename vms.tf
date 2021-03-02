# Creating Virtual Machine in Azure

resource "azurerm_public_ip" "public-ip-vm" {
  name                = "public-ip-vm"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "network-interface-vm" {
  name                = "network-interface-vm"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.subnet-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ip-vm.id
  }
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
  name                = "linux-vm"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  size                = "Standard_F2"
  admin_username      = "ubuntu"

  network_interface_ids = [azurerm_network_interface.network-interface-vm.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("mykey.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Creating VM in AWS

resource "aws_security_group" "ssh" {
  vpc_id = aws_vpc.vpc-main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "security-group-ssh"
  }

}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = file("awskey.pub")
}

resource "aws_instance" "aws-vm" {
  ami           = "ami-04bf6dcdc9ab498ca"
  instance_type = "t2.micro"

  vpc_security_group_ids      = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.subnet-1.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.name

}
