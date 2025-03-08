resource "aws_iam_role" "firehose_role" {
  name = "firehose-role"
  assume_role_policy = file("configs/firehose_role_config.json")

}

resource "aws_iam_policy" "firehose-policy" {
  name = "firehose-policy-p64"
  description = "Policy for AWS firehose"
  policy = jsonencode({
  Version   = "2012-10-17"
  Statement = [
    {
      Effect   = "Allow"
      Action   = [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListShards"
      ]
      Resource = aws_kinesis_stream.data_stream.arn
    },
    {
      Effect   = "Allow"
      Action   = [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ]
      Resource = "arn:aws:s3:::my-kinesis-data-bucket/*"
    },
    {
      Effect   = "Allow"
      Action   = [
        "logs:PutLogEvents",
        "logs:CreateLogStream",
        "logs:CreateLogGroup"
      ]
      Resource = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/kinesisfirehose/my-firehose:*"
    }
  ]
})

}

