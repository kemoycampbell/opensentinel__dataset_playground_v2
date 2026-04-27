#Create the DB subnet group
#RD Security group
module "aws_security_group" {
  source      = "../security_group"
  name        = var.rds_security_group.name
  vpc_id      = var.rds_security_group.vpc_id
  description = var.rds_security_group.description
  tags        = var.rds_security_group.tags
  ingress_rules = {
    dbs = {
      from_port       = var.rds_security_group.ingress.from_port
      to_port         = var.rds_security_group.ingress.to_port
      protocol        = var.rds_security_group.ingress.protocol
      security_groups = var.rds_security_group.ingress.security_groups
    }
  }

  enable_egress = false
}

resource "aws_db_subnet_group" "this" {
  name       = var.subnet_group.name
  subnet_ids = var.subnet_group.subnet_ids
  tags       = var.subnet_group.tags
}

resource "aws_db_instance" "this" {
  tags                   = var.tags
  identifier             = var.database_config.identifier                # Unique identifier for the RDS instance
  allocated_storage      = var.database_config.allocated_storage         # 20GB of storage
  storage_type           = var.database_config.storage_type              # General Purpose SSD
  engine                 = var.database_config.engine                    # MySQL database engine
  engine_version         = var.database_config.engine_version            # MySQL version 8.0
  instance_class         = var.database_config.instance_class            # Free tier eligible instance type
  db_name                = var.database_config.db_name                   # Name of the WordPress database
  username               = var.credential.username                       # Database admin username
  password               = var.credential.password                       # Replace with a secure password
  parameter_group_name   = var.database_config.parameter_group_name      # Default parameter group for MySQL 8.0
  skip_final_snapshot    = var.database_config.skip_final_snapshot       # Skip final snapshot when destroying the database
  vpc_security_group_ids = [module.aws_security_group.security_group_id] # Attach the RDS security group
  db_subnet_group_name   = aws_db_subnet_group.this.name                 # Use the created subnet group 
}

