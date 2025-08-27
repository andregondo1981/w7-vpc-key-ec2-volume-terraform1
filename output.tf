output "public-ip" {
  value = aws_instance.server1.public_ip
}
output "vpc_id" {
  value = aws_vpc.my-vpc.id
}