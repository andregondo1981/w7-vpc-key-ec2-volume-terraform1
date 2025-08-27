# Generates a secure private k ey and encodes it as PEM
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
# Create the Key Pair
resource "aws_key_pair" "key1" {
  key_name   = "terraform-key"  
  public_key = tls_private_key.key.public_key_openssh
}
# Download the key localy 
resource "local_file" "ssh_key" {
  filename = "terraform-key.pem"
  content  = tls_private_key.key.private_key_openssh
  file_permission = 0400
}