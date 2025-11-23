#!/bin/bash

echo "📊 Creating AWS Config Rules for MLA-C01 Compliance Monitoring"
echo "=============================================================="

# Set AWS region (adjust if needed)
export AWS_DEFAULT_REGION=ap-southeast-2

# Function to create a config rule
create_config_rule() {
    local rule_file=$1
    
    # Extract rule name without jq dependency
    local rule_name=$(grep -o '"ConfigRuleName"[^,]*' "config-rules/$rule_file" | cut -d'"' -f4)
    
    echo "Creating Config rule: $rule_name"
    
    # Create the config rule
    aws configservice put-config-rule \
        --config-rule "file://config-rules/$rule_file"
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully created $rule_name"
    else
        echo "❌ Failed to create $rule_name"
    fi
    echo ""
}

# Check if AWS Config is enabled
echo "Checking AWS Config service status..."
aws configservice describe-configuration-recorders --region $AWS_DEFAULT_REGION > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "⚠️  AWS Config is not enabled in this region."
    echo "   Please enable AWS Config first using the AWS Console or CLI."
    echo "   This is required for compliance monitoring."
    echo ""
    exit 1
fi

echo "✅ AWS Config is enabled. Proceeding with rule creation..."
echo ""

# Create all MLA-C01 compliance rules
create_config_rule "s3-encryption-rule.json"
create_config_rule "iam-role-policy-rule.json"
create_config_rule "s3-public-access-rule.json"
create_config_rule "sagemaker-encryption-rule.json"

echo "🎯 AWS Config Rules Creation Complete!"
echo "Compliance monitoring is now active for MLA-C01 resources"
echo "=============================================================="