
# VPC and Networking Resources
# Create a VPC, subnets, and related networking infrastructure for WordPress.

# VPC
module "vpc" {
  source = "../../modules/vpc"
  vpc    = var.vpc
}

#Create the networking infrastructure
module "network" {
  source = "../../modules/networking"

  network = merge(var.network, {
    vpc_id = module.vpc.vpc_id
    subnets = {
      public  = merge(var.network.subnets.public, { vpc_id = module.vpc.vpc_id })
      private = merge(var.network.subnets.private, { vpc_id = module.vpc.vpc_id })
    }
  })
}


#create the RDs instance
module "rds" {
  source = "../../modules/rds"
  tags   = var.rds.tags
  subnet_group = {
    name       = var.rds.subnet_group.name
    subnet_ids = [module.network.subnet_public_id, module.network.subnet_private_id]
    tags       = var.rds.subnet_group.tags
  }

  rds_security_group = {
    vpc_id      = module.vpc.vpc_id
    name        = var.rds.rds_security_group.name
    description = var.rds.rds_security_group.description

    ingress = {
      from_port       = var.rds.rds_security_group.ingress.from_port
      to_port         = var.rds.rds_security_group.ingress.to_port
      protocol        = var.rds.rds_security_group.ingress.protocol
      security_groups = [module.network.security_group]
    }
  }

  credential = {
    username = var.credentials.db_username
    password = var.credentials.db_password
  }

  database_config = var.rds.db_config


}


#Create the EC2 instance
module "ec2" {
  source       = "../../modules/ec2"
  ssh_key_name = var.credentials.ssh_key_name
  ec2_config = {
    instance_type          = var.ec2_instance.machine.instance_type
    vpc_security_group_ids = [module.network.security_group]
    subnet_id              = module.network.subnet_public_id
    tags                   = var.ec2_instance.machine.tags

    user_data = templatefile("${path.module}/../../modules/wordpress/wp_rds_install.sh.tpl", {
      host     = module.rds.rds_endpoint
      username = var.credentials.db_username
      password = var.credentials.db_password
      db_name  = var.rds.db_config.db_name

      wp_username = var.credentials.wp_username
      wp_password = var.credentials.wp_password

      email = var.wordpress.email
      title = var.wordpress.title
    })

  }


  ami_config = var.ec2_instance.ami

}
