resource "aws_vpc" "vpc-main" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "aws-vpc-main"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.vpc-main.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "route-table"
  }
}

resource "aws_route" "subnet-1-exit-route" {
  route_table_id         = aws_route_table.route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gateway.id
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route-table.id
}

# collecting azure data to connect with aws

data "azurerm_public_ip" "azure-public-ip-1" {
  name                = "${azurerm_virtual_network_gateway.az-virtual-network-gateway.name}-public-ip-1"
  resource_group_name = azurerm_resource_group.az-resource-group.name
}

data "azurerm_public_ip" "azure-public-ip-2" {
  name                = "${azurerm_virtual_network_gateway.az-virtual-network-gateway.name}-public-ip-2"
  resource_group_name = azurerm_resource_group.az-resource-group.name
}

resource "aws_customer_gateway" "customer-gateway-1" {
  bgp_asn    = 65000
  ip_address = data.azurerm_public_ip.azure-public-ip-1.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "customer-gateway-1"
  }
}


resource "aws_customer_gateway" "customer-gateway-2" {
  bgp_asn    = 65000
  ip_address = data.azurerm_public_ip.azure-public-ip-2.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "customer-gateway-2"
  }
}


resource "aws_vpn_gateway" "vpn-gateway" {
  vpc_id = aws_vpc.vpc-main.id

  tags = {
    Name = "vpn-gateway"
  }
}

resource "aws_vpn_connection" "vpn-connection-1" {
  vpn_gateway_id      = aws_vpn_gateway.vpn-gateway.id
  customer_gateway_id = aws_customer_gateway.customer-gateway-1.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "vpn-connection-1"
  }
}

resource "aws_vpn_connection" "vpn-connection-2" {
  vpn_gateway_id      = aws_vpn_gateway.vpn-gateway.id
  customer_gateway_id = aws_customer_gateway.customer-gateway-2.id
  type                = "ipsec.1"
  static_routes_only  = true
  tags = {
    Name = "vpn-connection-2"
  }
}

resource "aws_vpn_connection_route" "vpn-connection-route-1" {
  destination_cidr_block = azurerm_virtual_network.az-vnet.address_space[0]
  vpn_connection_id      = aws_vpn_connection.vpn-connection-1.id
}


resource "aws_vpn_connection_route" "vpn-connection-route-2" {
  destination_cidr_block = azurerm_virtual_network.az-vnet.address_space[0]
  vpn_connection_id      = aws_vpn_connection.vpn-connection-2.id
}

resource "aws_route" "route-to-azure" {
  route_table_id         = aws_route_table.route-table.id
  destination_cidr_block = azurerm_virtual_network.az-vnet.address_space[0]
  gateway_id             = aws_vpn_gateway.vpn-gateway.id

}
