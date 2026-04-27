variable "name" {
  description = "The name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "tags" {
  description = "the tags for the security group"
  type        = map(string)
}

variable "description" {
  description = "The description of the security group"
  type        = string
}

variable "enable_egress" {
  description = "Enable egress rules"
  type        = bool
  default     = true
}

#This variable allow one to ingress rules for the security group
#Since this is a map, it is recommend that the service name is used as the key. For example "http" or "https", ssh, etc
variable "ingress_rules" {
  description = "The ingress rules for the security group"
  type = map(object({
    from_port       = number
    to_port         = number
    protocol        = optional(string, "tcp")
    cidr_blocks     = optional(list(string))
    description     = optional(string)
    security_groups = optional(list(string), [])
  }))
}

#This variable allow one to egress rules for the security group
#there will be a default map with the key "all" that will allow all traffic
variable "egress_rules" {
  description = "The egress rules for the security group"
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = optional(string, "tcp")
    cidr_blocks = optional(list(string), [""])
    description = optional(string)
  }))

  default = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
    }
  }
}