output "azure-vm-public-ip " {
  value = azurerm_linux_virtual_machine.linux-vm.public_ip_address
}

output "azure-vm-private-ip " {
  value = azurerm_linux_virtual_machine.linux-vm.private_ip_address
}

output "aws-vm-public-ip" {
  value = aws_instance.aws-vm.public_ip
}

output "aws-vm-private-ip" {
  value = aws_instance.aws-vm.private_ip
}
