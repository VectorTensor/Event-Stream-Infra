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


resource "aws_iam_role_policy_attachment" "firehose_policy_attach"{
  role = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose-policy.arn
}

resource "aws_iam_role" "lambda-role"{
  name = "lambda-role-transformation"
  assume_role_policy = file("configs/lambda_role_config.json")

}
resource "aws_iam_role_policy_attachment" "lambda-transformation-role-attach"{
  role = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.firehose-policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda-transformation-role-awslambdabasic-attach"{
  role = aws_iam_role.lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_lambda_function" "transform_lambda_function"{
  filename = "lambda/transform_job.zip"
  source_code_hash = filebase64sha256("lambda/transform_job.zip")
  handler = "transform_job.lambda_handler"
  function_name = "transform_function_firehose_p64"
  runtime = "python3.9"
  role = aws_iam_role.lambda-role.arn
  timeout = 120

  tags = {
    Name = var.owner
  }
}


resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  destination = "extended_s3"
  name        = "firehose-stream"

  extended_s3_configuration{
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.data_bucket.arn
    buffer_interval = 60
    processing_configuration {
      enabled = "true"
      processors {
        type = "Lambda"
        parameters {

          parameter_name  = "LambdaArn"
          parameter_value = aws_lambda_function.transform_lambda_function.arn

        }

      }
    }
  }

  kinesis_source_configuration {
    role_arn = aws_iam_role.firehose_role.arn

    kinesis_stream_arn = aws_kinesis_stream.data_stream.arn
  }
}
