#!/bin/bash
# destroy.sh: Cleanup all AWS resources for oreumi streaming pipeline
# Usage: bash destroy.sh

set -e
REGION="ap-southeast-2"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET="oreumi-streaming-lab"
STREAM="oreumi-naver-review-stream"
TABLE="oreumi-naver-review-agg"
KDA_ROLE="oreumi-kda-role"
PRODUCER_ROLE="oreumi-producer-role"
KDA_APP="oreumi-naver-review-flink-app"

# 1. Delete Kinesis Data Analytics app
aws kinesisanalyticsv2 delete-application --application-name $KDA_APP --region $REGION --create-timestamp $(aws kinesisanalyticsv2 describe-application --application-name $KDA_APP --region $REGION --query 'ApplicationDetail.CreateTimestamp' --output text) || true

# 2. Delete Kinesis stream
aws kinesis delete-stream --stream-name $STREAM --region $REGION --enforce-consumer-deletion || true

# 3. Delete DynamoDB table
aws dynamodb delete-table --table-name $TABLE --region $REGION || true

# 4. Delete S3 bucket and all contents
aws s3 rm s3://$BUCKET --recursive || true
aws s3api delete-bucket --bucket $BUCKET --region $REGION || true

# 5. Delete IAM roles and policies
aws iam delete-role-policy --role-name $KDA_ROLE --policy-name kda-inline-policy || true
aws iam delete-role --role-name $KDA_ROLE || true
aws iam delete-role-policy --role-name $PRODUCER_ROLE --policy-name producer-inline-policy || true
aws iam delete-role --role-name $PRODUCER_ROLE || true

# 6. Remove local policy/trust files
rm -f s3-lifecycle.json kda-trust-policy.json kda-inline-policy.json producer-trust-policy.json producer-inline-policy.json flink-app.sql

echo "[+] All resources deleted."
