terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data_bucket"{
  bucket = "processed-data-p64"
  force_destroy = true
  tags = {
    owner = var.owner
  }

}

resource "aws_kinesis_stream" "data_stream"{

  name = "my-data-stream-p64"
  shard_count = 1
  retention_period = 24
  tags = {
    owner = var.owner

  }

}
resource "aws_iam_role" "firehose_role" {
  name = "firehose-role"
  assume_role_policy = file("configs/firehose_role_config.json")

}

resource "aws_iam_role_policy_attachment" "firehose_policy_attach_S3"{
  role = aws_iam_role.firehose_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attach_kinesis"{
  role = aws_iam_role.firehose_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSKinesisExecutionRole"
}
