resource "azurerm_resource_group" "az-resource-group" {
  name     = "az-resource-group"
  location = var.location
}

resource "azurerm_virtual_network" "az-vnet" {
  name                = "az-vnet"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "az-subnet-1" {
  name                = "az-subnet-1"
  resource_group_name = azurerm_resource_group.az-resource-group.name
  address_prefixes    = "10.0.1.0/24"

}

resource "azurerm_subnet" "az-subnet-gateway" {
  name                 = "az-GatewaySubnet"
  resource_group_name  = azurerm_resource_group.az-resource-group.name
  virtual_network_name = azurerm_virtual_network.az-vnet.name
  address_prefixes     = "10.0.2.0/24"

}

resource "azurerm_public_ip" "az-public-ip-1" {
  name                = "az-virtual-network-gateway-public-ip-1"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "az-public-ip-2" {
  name                = "az-virtual-network-gateway-public-ip-2"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "az-virtual-network-gateway" {
  name                = "az-virtual-network-gateway"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = true
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = azurerm_public_ip.az-public-ip-1.name
    public_ip_address_id          = azurerm_public_ip.az-public-ip-1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.az-subnet-gateway.id
  }

    ip_configuration {
    name                          = azurerm_public_ip.az-public-ip-2.name
    public_ip_address_id          = azurerm_public_ip.az-public-ip-2.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.az-subnet-gateway.id
  }
}
