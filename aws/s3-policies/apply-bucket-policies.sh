#!/bin/bash

echo "🔐 Applying MLA-C01 S3 Bucket Policies for Governance Framework"
echo "============================================================="

# Set AWS region (adjust if needed)
export AWS_DEFAULT_REGION=ap-southeast-2

# Function to apply bucket policy
apply_bucket_policy() {
    local bucket_name=$1
    local policy_file=$2
    
    echo "Applying policy to bucket: $bucket_name"
    
    # Check if bucket exists
    if aws s3api head-bucket --bucket "$bucket_name" 2>/dev/null; then
        # Apply the policy
        aws s3api put-bucket-policy \
            --bucket "$bucket_name" \
            --policy "file://s3-policies/$policy_file"
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully applied policy to $bucket_name"
        else
            echo "❌ Failed to apply policy to $bucket_name"
        fi
    else
        echo "⚠️  Bucket $bucket_name does not exist - skipping policy application"
        echo "   (This bucket will be created during the renaming process)"
    fi
    echo ""
}

# Apply policies to all strategic buckets
echo "Applying S3 bucket policies for MLA-C01 strategic buckets..."
echo ""

apply_bucket_policy "mla-data-ingestion-hub" "mla-data-ingestion-hub-policy.json"
apply_bucket_policy "mla-feature-store-registry" "mla-feature-store-registry-policy.json"
apply_bucket_policy "mla-model-artifact-vault" "mla-model-artifact-vault-policy.json"
apply_bucket_policy "mla-experiment-tracking-lab" "mla-experiment-tracking-lab-policy.json"
apply_bucket_policy "mla-deployment-pipeline-config" "mla-deployment-pipeline-config-policy.json"

echo "🎯 S3 Bucket Policies Application Complete!"
echo "Note: Policies will be applied during bucket renaming process"
echo "Next: Implement AWS Config rules for compliance monitoring"
echo "============================================================="