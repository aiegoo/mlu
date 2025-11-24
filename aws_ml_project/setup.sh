#!/bin/bash
# setup.sh: Minimal-cost AWS real-time streaming pipeline setup (ap-southeast-2)
# Resources: S3, Kinesis, DynamoDB, IAM roles, Kinesis Data Analytics (Flink SQL)
# Usage: bash setup.sh

set -e
REGION="ap-southeast-2"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# 1. S3 bucket for raw/processed data
BUCKET="oreumi-streaming-lab"
echo "[+] Creating S3 bucket: $BUCKET"
aws s3api create-bucket --bucket $BUCKET --region $REGION --create-bucket-configuration LocationConstraint=$REGION

# Add lifecycle rule: transition to GLACIER after 7 days
cat > s3-lifecycle.json <<EOF
{
  "Rules": [
    {
      "ID": "GlacierAfter7Days",
      "Prefix": "",
      "Status": "Enabled",
      "Transitions": [
        { "Days": 7, "StorageClass": "GLACIER" }
      ]
    }
  ]
}
EOF
aws s3api put-bucket-lifecycle-configuration --bucket $BUCKET --lifecycle-configuration file://s3-lifecycle.json

# 2. Kinesis Data Stream (1 shard, 24h retention, no enhanced monitoring)
STREAM="oreumi-naver-review-stream"
echo "[+] Creating Kinesis stream: $STREAM"
aws kinesis create-stream --stream-name $STREAM --shard-count 1 --region $REGION
aws kinesis update-stream --stream-name $STREAM --retention-period-hours 24 --region $REGION

# 3. DynamoDB table for aggregation
TABLE="oreumi-naver-review-agg"
echo "[+] Creating DynamoDB table: $TABLE"
aws dynamodb create-table --table-name $TABLE \
  --attribute-definitions AttributeName=pk,AttributeType=S AttributeName=sk,AttributeType=S \
  --key-schema AttributeName=pk,KeyType=HASH AttributeName=sk,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST --region $REGION
# Enable TTL (expire after 30 days)
aws dynamodb update-time-to-live --table-name $TABLE --time-to-live-specification Enabled=true,AttributeName=ttl

# 4. IAM Role for Kinesis Data Analytics (KDA)
KDA_ROLE="oreumi-kda-role"
cat > kda-trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "kinesisanalytics.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
