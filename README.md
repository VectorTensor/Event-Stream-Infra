# Kinesis Data Stream Pipeline (Terraform)

## Overview
This project provisions an AWS Kinesis Data Stream pipeline using Terraform. The pipeline consists of the following components:

- **Kinesis Data Stream**: Ingests real-time streaming data.
- **Kinesis Firehose**: Delivers transformed data to an S3 bucket.
- **Lambda Function**: Transforms the incoming data before forwarding it.
- **S3 Bucket**: Stores the processed data.
- **IAM Policies**: Manages access control for the services.

## Architecture
```
[ Producer ] → [ Kinesis Data Stream ] → [ Kinesis Firehose ] → [ Lambda (Transformation) ] → [ S3 ]
```

## Prerequisites
- Terraform installed
- AWS CLI configured with necessary permissions

## Transformation
The stream transformation is done using lambda function hello.py modify the function to use the transformation you need.

## Usage
1. Initialize Terraform:
   ```sh
   terraform init
   ```

2. Plan the deployment:
   ```sh
   terraform plan
   ```

3. Zip the lambda function and Apply the configuration:
   ```sh
   ./infra-build.sh
   terraform apply
   ```

4. To destroy the resources:
   ```sh
   terraform destroy
   ```



