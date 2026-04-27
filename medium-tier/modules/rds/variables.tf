variable "credential" {
  type = object({
    username = string
    password = string
  })
}

variable "subnet_group" {
  type = object({
    name       = string
    subnet_ids = list(string)
    tags       = optional(map(string))
  })
}

variable "rds_security_group" {
  type = object({
    name        = string
    description = string
    vpc_id      = string
    tags        = optional(map(string))

    ingress = object({
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string), [])
      security_groups = list(string)
    })
  })
}

variable "tags" {
  description = "The tags for the RDS instance"
  type        = map(string)
}

variable "database_config" {
  description = "The configuration for the RDS instance"
  type = object({
    identifier           = string
    allocated_storage    = number
    storage_type         = string
    engine               = string
    engine_version       = string
    instance_class       = string
    db_name              = string
    parameter_group_name = string
    skip_final_snapshot  = optional(bool, true)
  })

  default = {
    identifier           = "wordpress-db"
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t3.micro"
    db_name              = "wordpressdb"
    parameter_group_name = "default.mysql8.0"
  }
}