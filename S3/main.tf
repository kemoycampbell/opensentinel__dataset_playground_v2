resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-opensentinel"

  tags = {
    Name        = "OpenSentinel"
    Environment = "Dev"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }

      bucket_key_enabled = true
    }
  }
}