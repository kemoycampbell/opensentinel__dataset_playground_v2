
# Define the input variables for the subnet module
variable "vpc" {
    type = object({
      cidr_block = string
      enable_dns_hostnames = optional(bool, true)
      enable_dns_support = optional(bool, true)
      tags = optional(map(string))
    })
}