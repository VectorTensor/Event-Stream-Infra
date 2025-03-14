resource "aws_s3_bucket" "data_bucket" {
  bucket        = "processed-data-p64"
  force_destroy = true
  tags = {
    owner = var.owner
  }

}
