output "subnet_public_id" {
    value = module.subnets.subnet_full_info[var.network.route.public_subnet_key].id
}

output "subnet_private_id" {
    value = module.subnets.subnet_full_info[var.network.route.private_subnet_key].id
}

output "security_group"{
    value = module.security_group.security_group_id
}