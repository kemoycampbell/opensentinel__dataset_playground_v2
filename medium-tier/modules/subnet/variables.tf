#The variable to create a map of subnets with the VPC ID, CIDR block, availability zone, and tags
#user can define as many subnet as see fits. Key for the subnet can be of any name

variable "subnets" {
  description = "The subnets to create"
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = optional(bool, false)
    tags                    = optional(map(string))
  }))
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string

}