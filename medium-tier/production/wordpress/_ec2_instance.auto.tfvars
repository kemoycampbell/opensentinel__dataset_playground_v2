ec2_instance = {
  machine = {
    instance_type = "t3.micro"
    tags = {
      Name = "OpenIACSentinel"
    }
  }

  ami = {
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
        values = ["ebs"] # EBS-backed instances only
        }, {
        name   = "architecture"
        values = ["x86_64"] # 64-bit x86 architecture only
      }
    ]
  }
}