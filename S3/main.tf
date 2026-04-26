resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-opensentinel"

  tags = {
    Name        = "OpenSentinel"
    Environment = "Dev"
  }
}