output "subnet1_id" {
  value = aws_subnet.public_subnet1.id
}
output "subnet2_id" {
  value = aws_subnet.public_subnet2.id
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}