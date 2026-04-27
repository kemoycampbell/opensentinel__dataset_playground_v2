# Create the subnets both public and private
module "subnets" {
  source  = "../subnet"
  subnets = var.network.subnets
  vpc_id  = var.network.vpc_id
}

# Create the internet gateway for public access
resource "aws_internet_gateway" "this" {
  vpc_id = var.network.vpc_id
  tags   = var.network.internet_gateway.tags

}

#Create the public route table
resource "aws_route_table" "this" {
  vpc_id = var.network.vpc_id
  route {
    cidr_block = var.network.route.cidr_block
    gateway_id = aws_internet_gateway.this.id
  }

  tags       = var.network.route.tags
  depends_on = [aws_internet_gateway.this]
}

#Associate the public subnet with the public route table
resource "aws_route_table_association" "this" {
  subnet_id      = module.subnets.subnet_full_info[var.network.route.public_subnet_key].id
  route_table_id = aws_route_table.this.id
  depends_on     = [aws_route_table.this]
}

#Create the security group
module "security_group" {
  source        = "../security_group"
  name          = var.network.ec2_security_group.name
  description   = var.network.ec2_security_group.description
  vpc_id        = var.network.vpc_id
  enable_egress = var.network.ec2_security_group.enable_egress
  ingress_rules = var.network.ec2_security_group.ingress_rules
  egress_rules  = var.network.ec2_security_group.egress_rules
  tags          = var.network.ec2_security_group.tags
}