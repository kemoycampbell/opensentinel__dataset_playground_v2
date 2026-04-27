variable "network" {
  description = "The network configuration"
  type = object({
    vpc_id = string
    subnets = map(object({
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = optional(bool, false)
      tags                    = optional(map(string))
    }))

    internet_gateway = object({
      tags = optional(map(string))
    })

    route = object({
      cidr_block         = string
      tags               = optional(map(string))
      public_subnet_key  = string
      private_subnet_key = string
    })

    ec2_security_group = object({
      name        = string
      description = string
      tags        = optional(map(string))
      ingress_rules = map(object({
        from_port       = number
        to_port         = number
        protocol        = optional(string, "tcp")
        cidr_blocks     = optional(list(string))
        description     = optional(string)
        security_groups = optional(list(string), [])
      }))
      enable_egress = optional(bool, true)
      egress_rules = map(object({
        from_port   = number
        to_port     = number
        protocol    = optional(string, "tcp")
        cidr_blocks = optional(list(string), [""])
        description = optional(string)
      }))
    })


  })
}