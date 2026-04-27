output "subnet_ids" {
  value = values(aws_subnet.this)[*].id

}


output "subnet_full_info" {
  value = aws_subnet.this
}
