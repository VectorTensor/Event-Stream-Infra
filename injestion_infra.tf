resource "aws_kinesis_stream" "data_stream"{

  name = "my-data-stream-p64"
  shard_count = 1
  retention_period = 24
  tags = {
    owner = var.owner

  }

}
