rds = {
  subnet_group = {
    name = "opensentinel subnet group"
    tags = {
      Name = "OpenIACSentinel"
    }
  }
  tags = {
    Name = "OpenIACSentinel"
  }

  rds_security_group = {
    name = "OpenIACSentinel RDS SG"
    tags = {
      Name = "OpenIACSentinel"
    }
    description = "security group for wordpress RDS instance"
    ingress = {
      from_port = 3306
      to_port   = 3306
      protocol  = "tcp"
    }


  }

  db_config = {
    identifier           = "wordpress-db"
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    db_name              = "wordpressdb"
    skip_final_snapshot  = true
    parameter_group_name = "default.mysql8.0"
  }
}
