#output the id of the vpc
output "vpc_id" {
  value = aws_vpc.this.id
}