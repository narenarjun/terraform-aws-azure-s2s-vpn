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

# 2 tunnels for aws connection1
resource "azurerm_local_network_gateway" "local-network-gateway-1-tunnel1" {
  name                = "local-network-gateway-1-tunnel1"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  gateway_address     = aws_vpn_connection.vpn-connection-1.tunnel1_address
  address_space       = [aws_vpc.vpc-main.cidr_block]
}

resource "azurerm_virtual_network_gateway_connection" "virtual-network-gateway-connection-1-tunnel1" {
  name                       = "virtual-network-gateway-connection-1-tunnel1"
  location                   = azurerm_resource_group.az-resource-group.location
  resource_group_name        = azurerm_resource_group.az-resource-group.name
  type                       = "IPSec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.az-virtual-network-gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.local-network-gateway-1-tunnel1.id
  shared_key                 = aws_vpn_connection.vpn-connection-1.tunnel1_preshared_key
}

resource "azurerm_local_network_gateway" "local-network-gateway-1-tunnel2" {
  name                = "local-network-gateway-1-tunnel2"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  gateway_address     = aws_vpn_connection.vpn-connection-1.tunnel2_address
  address_space       = [aws_vpc.vpc-main.cidr_block]
}

resource "azurerm_virtual_network_gateway_connection" "virtual-network-gateway-connection-1-tunnel2" {
  name                       = "virtual-network-gateway-connection-1-tunnel2"
  location                   = azurerm_resource_group.az-resource-group.location
  resource_group_name        = azurerm_resource_group.az-resource-group.name
  type                       = "IPSec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.az-virtual-network-gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.local-network-gateway-1-tunnel2.id
  shared_key                 = aws_vpn_connection.vpn-connection-1.tunnel2_preshared_key
}


# 2 tunnels for aws connection2
resource "azurerm_local_network_gateway" "local-network-gateway-2-tunnel1" {
  name                = "local-network-gateway-2-tunnel1"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  gateway_address     = aws_vpn_connection.vpn-connection-2.tunnel1_address
  address_space       = [aws_vpc.vpc-main.cidr_block]
}

resource "azurerm_virtual_network_gateway_connection" "virtual-network-gateway-connection-2-tunnel1" {
  name                       = "virtual-network-gateway-connection-2-tunnel1"
  location                   = azurerm_resource_group.az-resource-group.location
  resource_group_name        = azurerm_resource_group.az-resource-group.name
  type                       = "IPSec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.az-virtual-network-gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.local-network-gateway-2-tunnel1.id
  shared_key                 = aws_vpn_connection.vpn-connection-2.tunnel1_preshared_key
}

resource "azurerm_local_network_gateway" "local-network-gateway-2-tunnel2" {
  name                = "local-network-gateway-2-tunnel2"
  location            = azurerm_resource_group.az-resource-group.location
  resource_group_name = azurerm_resource_group.az-resource-group.name
  gateway_address     = aws_vpn_connection.vpn-connection-2.tunnel2_address
  address_space       = [aws_vpc.vpc-main.cidr_block]
}

resource "azurerm_virtual_network_gateway_connection" "virtual-network-gateway-connection-2-tunnel2" {
  name                       = "virtual-network-gateway-connection-2-tunnel2"
  location                   = azurerm_resource_group.az-resource-group.location
  resource_group_name        = azurerm_resource_group.az-resource-group.name
  type                       = "IPSec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.az-virtual-network-gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.local-network-gateway-2-tunnel2.id
  shared_key                 = aws_vpn_connection.vpn-connection-2.tunnel2_preshared_key
}
