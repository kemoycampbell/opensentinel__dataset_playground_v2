network = {
  subnets = {
    public = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
      tags = {
        Name = "OpenIACSentinel"
      }
    }
    private = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      tags = {
        Name = "OpenIACSentinel"
      }
    }
  }

  internet_gateway = {
    tags = {
      Name = "OpenIACSentinel Internet Gateway"
    }
  }

  route = {
    cidr_block = "0.0.0.0/0"
    tags = {
      Name = "OpenIACSentinel Public Route"
    }
    public_subnet_key  = "public"
    private_subnet_key = "private"
  }

  ec2_security_group = {
    name        = "OpenIACSentinel"
    description = "Security group for WordPress EC2 instance"

    ingress_rules = {
      http = {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

      ssh = {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }

    egress_rules = {
      all = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }
}
