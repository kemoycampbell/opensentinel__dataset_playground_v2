#AWS region
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

#THE VPC
variable "vpc" {
  type = object({
    cidr_block           = string
    enable_dns_hostnames = optional(bool, true)
    enable_dns_support   = optional(bool, true)
    tags                 = optional(map(string))
  })
}


#Networking
variable "network" {
  description = "The network configuration"
  type = object({
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

#credentials
variable "credentials" {
  type = object({
    db_username  = string
    db_password  = string
    ssh_key_name = string

    wp_username = string
    wp_password = string
  })

  sensitive = true
}

variable "wordpress" {
  type = object({
    title = string
    email = string
  })


}



#rds
variable "rds" {
  type = object({
    subnet_group = object({
      name = string
      tags = map(string)
    })

    tags = map(string)

    rds_security_group = object({
      tags        = map(string)
      name        = string
      description = string
      ingress = object({
        from_port = number
        to_port   = number
        protocol  = string
      })
    })

    db_config = object({
      identifier           = string
      allocated_storage    = number
      storage_type         = string
      engine               = string
      engine_version       = string
      instance_class       = string
      db_name              = string
      skip_final_snapshot  = bool
      parameter_group_name = string
    })

  })

}

#EC2

variable "ec2_instance" {
  type = object({
    machine = object({
      instance_type = string
      tags          = map(string)
      user_data     = optional(string)
    })

    ami = object({
      most_recent = optional(bool, true)
      owners      = list(string)
      filters = list(object({
        name   = string
        values = list(string)
      }))
    })
  })
}




