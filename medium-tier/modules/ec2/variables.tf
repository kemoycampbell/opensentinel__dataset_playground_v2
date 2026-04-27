variable "ssh_key_name" {
  description = "The name of the SSH key pair to use for the EC2 instances"
  type        = string
  sensitive   = true
}

variable "ec2_config" {
  description = "The configuration for the EC2 instances"
  type = object({
    instance_type          = optional(string, "t2.micro")
    vpc_security_group_ids = list(string)
    subnet_id              = string
    tags                   = map(string)
    user_data              = optional(string)
  })
}

variable "ami_config" {
  description = "The configuration for the AMI"
  type = object({
    most_recent = optional(bool, true)
    owners      = list(string)
    filters = list(object({
      name   = string
      values = list(string)
    }))

  })

  default = {
    most_recent = true
    owners      = ["amazon"]
    filters = [
      {
        name   = "name"
        values = ["al2023-ami-2023*"] # Filter for Amazon Linux 2023 AMIs
      },
      {
        "name"   = "virtualization-type"
        "values" = ["hvm"]

      },
      {
        name   = "root-device-type"
        values = ["ebs"]
      },
      {
        name   = "architecture"
        values = ["x86_64"]
      }
    ]
  }

}
