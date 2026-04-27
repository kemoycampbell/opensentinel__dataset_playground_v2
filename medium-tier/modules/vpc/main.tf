resource "aws_vpc" "this" {
    cidr_block           = var.vpc.cidr_block
    enable_dns_hostnames = var.vpc.enable_dns_hostnames
    enable_dns_support   = var.vpc.enable_dns_support
    tags                 = var.vpc.tags
}