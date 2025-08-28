resource "aws_s3_bucket" "b" {
  bucket = "w7-andre-terr-bucket"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}