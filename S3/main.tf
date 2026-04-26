resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-opensentinel"

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "OpenSentinel"
    Environment = "Dev"
  }
}