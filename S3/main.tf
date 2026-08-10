resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-opensentinel"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "OpenSentinel"
    Environment = "Dev"
  }
}