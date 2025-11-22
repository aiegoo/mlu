#!/bin/bash

echo "🔧 Setting Up AWS Config Service for MLA-C01 Compliance"
echo "======================================================"

# Set AWS region
export AWS_DEFAULT_REGION=ap-southeast-2

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "success") echo -e "${GREEN}✅ $message${NC}" ;;
        "warning") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "error") echo -e "${RED}❌ $message${NC}" ;;
        "info") echo -e "ℹ️  $message" ;;
    esac
}

# Function to create S3 bucket for Config
create_config_bucket() {
    local bucket_name="mla-aws-config-bucket-$(aws sts get-caller-identity --query Account --output text)"
    
    print_status "info" "Creating S3 bucket for AWS Config: $bucket_name"
    
    # Create bucket
    aws s3api create-bucket \
        --bucket "$bucket_name" \
        --region "$AWS_DEFAULT_REGION" \
        --create-bucket-configuration LocationConstraint="$AWS_DEFAULT_REGION" 2>/dev/null
    
    # Enable versioning
    aws s3api put-bucket-versioning \
        --bucket "$bucket_name" \
        --versioning-configuration Status=Enabled
    
    # Set bucket policy for Config service
    local bucket_policy="{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Sid\": \"AWSConfigBucketPermissionsCheck\",
                \"Effect\": \"Allow\",
                \"Principal\": {
                    \"Service\": \"config.amazonaws.com\"
                },
                \"Action\": \"s3:GetBucketAcl\",
                \"Resource\": \"arn:aws:s3:::$bucket_name\",
                \"Condition\": {
                    \"StringEquals\": {
                        \"AWS:SourceAccount\": \"$(aws sts get-caller-identity --query Account --output text)\"
                    }
                }
            },
            {
                \"Sid\": \"AWSConfigBucketExistenceCheck\",
                \"Effect\": \"Allow\",
                \"Principal\": {
                    \"Service\": \"config.amazonaws.com\"
                },
                \"Action\": \"s3:ListBucket\",
                \"Resource\": \"arn:aws:s3:::$bucket_name\",
                \"Condition\": {
                    \"StringEquals\": {
                        \"AWS:SourceAccount\": \"$(aws sts get-caller-identity --query Account --output text)\"
                    }
                }
            },
            {
                \"Sid\": \"AWSConfigBucketDelivery\",
                \"Effect\": \"Allow\",
                \"Principal\": {
                    \"Service\": \"config.amazonaws.com\"
                },
                \"Action\": \"s3:PutObject\",
                \"Resource\": \"arn:aws:s3:::$bucket_name/*\",
                \"Condition\": {
                    \"StringEquals\": {
                        \"s3:x-amz-acl\": \"bucket-owner-full-control\",
                        \"AWS:SourceAccount\": \"$(aws sts get-caller-identity --query Account --output text)\"
                    }
                }
            }
        ]
    }"
    
    echo "$bucket_policy" | aws s3api put-bucket-policy --bucket "$bucket_name" --policy file:///dev/stdin
    
    echo "$bucket_name"
}

# Function to create Config service role
create_config_role() {
    local role_name="MLA-Config-Service-Role"
    
    print_status "info" "Creating AWS Config service role: $role_name"
    
    # Trust policy for Config service
    local trust_policy='{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "config.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }'
    
    # Create role
    echo "$trust_policy" | aws iam create-role \
        --role-name "$role_name" \
        --assume-role-policy-document file:///dev/stdin \
        --description "Service role for AWS Config in MLA-C01 environment" 2>/dev/null || true
    
    # Attach managed policy
    aws iam attach-role-policy \
        --role-name "$role_name" \
        --policy-arn "arn:aws:iam::aws:policy/service-role/AWS_ConfigServiceRole"
    
    echo "arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/$role_name"
}

# Function to create configuration recorder
create_configuration_recorder() {
    local role_arn=$1
    local recorder_name="MLA-Config-Recorder"
    
    print_status "info" "Creating AWS Config recorder: $recorder_name"
    
    # Configuration recorder settings
    local recorder_config="{
        \"name\": \"$recorder_name\",
        \"roleARN\": \"$role_arn\",
        \"recordingGroup\": {
            \"allSupported\": true,
            \"includeGlobalResourceTypes\": true
        }
    }"
    
    echo "$recorder_config" | aws configservice put-configuration-recorder \
        --configuration-recorder file:///dev/stdin
    
    print_status "success" "Configuration recorder created successfully"
}

# Function to create delivery channel
create_delivery_channel() {
    local bucket_name=$1
    local channel_name="MLA-Config-DeliveryChannel"
    
    print_status "info" "Creating AWS Config delivery channel: $channel_name"
    
    local delivery_config="{
        \"name\": \"$channel_name\",
        \"s3BucketName\": \"$bucket_name\",
        \"configSnapshotDeliveryProperties\": {
            \"deliveryFrequency\": \"TwentyFour_Hours\"
        }
    }"
    
    echo "$delivery_config" | aws configservice put-delivery-channel \
        --delivery-channel file:///dev/stdin
    
    print_status "success" "Delivery channel created successfully"
}

# Function to start configuration recorder
start_recorder() {
    local recorder_name="MLA-Config-Recorder"
    
    print_status "info" "Starting AWS Config recorder..."
    
    aws configservice start-configuration-recorder \
        --configuration-recorder-name "$recorder_name"
    
    print_status "success" "Configuration recorder started successfully"
}

# Main execution
main() {
    print_status "info" "Setting up AWS Config for MLA-C01 compliance monitoring..."
    echo ""
    
    # Create S3 bucket for Config
    local bucket_name=$(create_config_bucket)
    print_status "success" "Config bucket created: $bucket_name"
    echo ""
    
    # Create Config service role
    local role_arn=$(create_config_role)
    print_status "success" "Config service role created: $role_arn"
    echo ""
    
    # Create configuration recorder
    create_configuration_recorder "$role_arn"
    echo ""
    
    # Create delivery channel
    create_delivery_channel "$bucket_name"
    echo ""
    
    # Start the recorder
    start_recorder
    echo ""
    
    print_status "success" "🎯 AWS Config setup complete!"
    echo ""
    echo "✅ Configuration recorder is now active"
    echo "✅ Config rules can now be created"
    echo "✅ Compliance monitoring enabled"
    echo ""
    echo "Next: Run create-config-rules.sh to deploy compliance rules"
    echo "======================================================"
}

# Run main function
main