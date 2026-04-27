resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = var.ec2_config.instance_type
  subnet_id              = var.ec2_config.subnet_id
  key_name               = var.ssh_key_name
  vpc_security_group_ids = var.ec2_config.vpc_security_group_ids
  tags                   = var.ec2_config.tags
  user_data              = var.ec2_config.user_data
  disable_api_termination = true
}
