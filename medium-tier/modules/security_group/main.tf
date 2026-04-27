resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags = {
    Name = "OpenIACSentinel"
  }

  #apply rules for the ingress
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      description     = coalesce(ingress.value.description, "${ingress.key} ingress rule managed by terraform")
      security_groups = ingress.value.security_groups
    }
  }

  #apply the rules for the egress
  dynamic "egress" {
    for_each = var.enable_egress ? var.egress_rules : {} #if the egress is enabled then we pass the rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = coalesce(egress.value.description, "${egress.key} egress rule managed by terraform")
    }
  }
}