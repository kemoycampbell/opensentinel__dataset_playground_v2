# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "AWS_Key_office-EAST-1"   # SSH key pair name for EC2 instance access
}

#we will need to make the http and ssh ports open 
# to do that we need to create a security group.
# for simplicy,I am just using the default vpc id and map it to the security group
#then assigned that security group the the instance

#get the default vpc id
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_ssh_and_http" {
  name        = "allow_ssh_and_http_security_group"

  #we want to use the default vpc
  vpc_id = data.aws_vpc.default.id

  #inbound for ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]

  }

  #inbound for http
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]

  }

  #outbound for all
  #per aws terraform doc, terraform automatically remove the default egress rule so this added it back
  #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

locals{
  user = "ec2-user"
  owner = "root:root"

  file_1 = "Dockerfile.wp"
  file_2 = "Dockerfile.mysql"

  //files that we want to run
  files = [
    {
      name = local.file_1
      user = local.user
      owner = local.owner
      permissions = "0755"
      content = file("${path.module}/${local.file_1}")
    },
    {
      name = local.file_2
      user = local.user
      owner = local.owner
      permissions = "0755"
      content = file("${path.module}/${local.file_2}")
    }
  ]

  //commands to run
  commands = [
    " docker build -t custom-mysql -f /home/${local.user}/${local.file_2} .",
    " docker build -t custom-wordpress -f /home/${local.user}/${local.file_1} .",

    "docker run -d --name wordpress-db -e MYSQL_ROOT_PASSWORD=rootpassword -e MYSQL_DATABASE=blog -e MYSQL_USER=wp_user -e MYSQL_PASSWORD=wordpress custom-mysql",
    " docker run -d --name wordpress-app --link wordpress-db:mysql -p 80:80 custom-wordpress"
  ]

  //generate the cloud_init.yaml
  docker = templatefile("${path.module}/cloud_init.yaml.tpl",{
    files = local.files
    commands = local.commands
  })
}



# EC2 instance resource definition
resource "aws_instance" "my_server" {
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name

    # Associate the EC2 instance with the security group
    vpc_security_group_ids = [aws_security_group.allow_ssh_and_http.id]
  
   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }  

  #install wordpress by running the install script
  user_data = local.docker
  
  
  #wait for the security group creation before starting to create the instance
  depends_on = [aws_security_group.allow_ssh_and_http]                
}

# output to display the public ip. I originally had this in output.tf 
# but the instruction only asked to submit main.tf so I add it here
# for visibility
output "instance_ip_addr_public" {
  value = aws_instance.my_server[*].public_ip
  
}

output "docker_content" {
  value = local.docker
}

# output "vpc_id" {
#   value = data.aws_vpc.default.id
# }

