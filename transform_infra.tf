
resource "aws_lambda_function" "transform_lambda_function"{
  filename = "transform_job.zip"
  source_code_hash = filebase64sha256("transform_job.zip")
  handler = "hello.lambda_handler"
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
