resource "azurerm_resource_group" "az-resource-group" {
  name     = "az-resource-group"
  location = var.azure-location
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
