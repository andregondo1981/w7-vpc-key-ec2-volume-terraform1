// ec2 instance code 
resource "aws_instance" "server1" {
  availability_zone = "us-east-1a"
  ami = "ami-045269a1f5c90a6a0"
  associate_public_ip_address = true
  instance_type = "t3.micro"
  vpc_security_group_ids = [ aws_security_group.web_sg.id ]
  key_name = aws_key_pair.key1.key_name
  user_data = file("setup.sh")
  subnet_id = aws_subnet.public1.id

  tags = {
    Name = "Terraform-project-server"
    env = "Dev"
  }
}
// volume code
resource "aws_ebs_volume" "ebs" {
  availability_zone = aws_instance.server1.availability_zone
  size              = 20
  tags = {
    Name = "terraform-volume"
  }
}
// attach volume to instance
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.ebs.id
  instance_id = aws_instance.server1.id
 
}
