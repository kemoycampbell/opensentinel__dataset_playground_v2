output "database_endpoint" {
  value = module.rds.rds_endpoint
}

output "instance_public_ip" {
  value = module.ec2.ec2_public_ip
}