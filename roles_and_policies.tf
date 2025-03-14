resource "aws_iam_role" "firehose_role" {
  name               = "firehose-role"
  assume_role_policy = file("configs/firehose_role_config.json")

}

resource "aws_iam_policy" "firehose-policy" {
  name        = "firehose-policy-p64"
  description = "Policy for AWS firehose"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ]
        Resource = aws_kinesis_stream.data_stream.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "s3-object-lambda:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = "*"
      }
    ]
  })

}


resource "aws_iam_role_policy_attachment" "firehose_policy_attach" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose-policy.arn
}

resource "aws_iam_role" "lambda-role" {
  name               = "lambda-role-transformation"
  assume_role_policy = file("configs/lambda_role_config.json")

}
resource "aws_iam_role_policy_attachment" "lambda-transformation-role-attach" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = aws_iam_policy.firehose-policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda-transformation-role-awslambdabasic-attach" {
  role       = aws_iam_role.lambda-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

