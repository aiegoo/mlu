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
<<<<<<< HEAD
=======
aws iam create-role --role-name $KDA_ROLE --assume-role-policy-document file://kda-trust-policy.json
cat > kda-inline-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetRecords",
        "kinesis:GetShardIterator",
        "kinesis:ListStreams",
        "kinesis:ListShards"
      ],
      "Resource": "arn:aws:kinesis:$REGION:$ACCOUNT_ID:stream/$STREAM"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::$BUCKET",
        "arn:aws:s3:::$BUCKET/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:GetItem"],
      "Resource": "arn:aws:dynamodb:$REGION:$ACCOUNT_ID:table/$TABLE"
    }
  ]
}
EOF
aws iam put-role-policy --role-name $KDA_ROLE --policy-name kda-inline-policy --policy-document file://kda-inline-policy.json

# 5. IAM Role for Producer (PutRecord only)
PRODUCER_ROLE="oreumi-producer-role"
cat > producer-trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::$ACCOUNT_ID:root" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
aws iam create-role --role-name $PRODUCER_ROLE --assume-role-policy-document file://producer-trust-policy.json
cat > producer-inline-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["kinesis:PutRecord", "kinesis:PutRecords"],
      "Resource": "arn:aws:kinesis:$REGION:$ACCOUNT_ID:stream/$STREAM"
    }
  ]
}
EOF
aws iam put-role-policy --role-name $PRODUCER_ROLE --policy-name producer-inline-policy --policy-document file://producer-inline-policy.json

# 6. Kinesis Data Analytics (Flink SQL) app
KDA_APP="oreumi-naver-review-flink-app"
echo "[+] Creating Kinesis Data Analytics Flink SQL app: $KDA_APP"
cat > flink-app.sql <<EOF
-- Example Flink SQL: Read from Kinesis, aggregate, write to S3 and DynamoDB
CREATE TABLE source_stream (
  review_id STRING,
  review_text STRING,
  label STRING,
  ts TIMESTAMP(3),
  WATERMARK FOR ts AS ts - INTERVAL '5' SECOND
) WITH (
  'connector' = 'kinesis',
  'stream' = '$STREAM',
  'aws.region' = '$REGION',
  'format' = 'json',
  'scan.stream.initpos' = 'LATEST'
);

CREATE TABLE s3_sink (
  review_id STRING,
  label STRING,
  ts TIMESTAMP(3)
) WITH (
  'connector' = 'filesystem',
  'path' = 's3a://$BUCKET/processed/',
  'format' = 'json'
);

CREATE TABLE dynamodb_sink (
  pk STRING,
  sk STRING,
  label STRING,
  ttl BIGINT
) WITH (
  'connector' = 'dynamodb',
  'table-name' = '$TABLE',
  'aws.region' = '$REGION'
);

INSERT INTO s3_sink SELECT review_id, label, ts FROM source_stream;
INSERT INTO dynamodb_sink SELECT review_id, CAST(ts AS STRING), label, UNIX_TIMESTAMP(ts) + 2592000 FROM source_stream;
EOF
aws kinesisanalyticsv2 create-application \
  --region $REGION \
  --application-name $KDA_APP \
  --runtime-environment FLINK-1_15 \
  --service-execution-role arn:aws:iam::$ACCOUNT_ID:role/$KDA_ROLE \
  --application-configuration '{
    "SqlApplicationConfiguration": {"Inputs": []},
    "ApplicationCodeConfiguration": {"CodeContent": {"TextContent": "$(cat flink-app.sql | sed 's/\"/\\\"/g')"}, "CodeContentType": "PLAINTEXT"}
  }'
echo "[+] Setup complete."
>>>>>>> 5fa6555 (Save all local and AWS pipeline scripts, notebooks, and infra changes. Sensitive files are now ignored.)
