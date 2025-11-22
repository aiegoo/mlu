#!/bin/bash

echo "🚀 Creating MLA-C01 IAM Roles for Governance Framework"
echo "======================================================"

# Set AWS region (adjust if needed)
export AWS_DEFAULT_REGION=ap-southeast-2

# Function to create an IAM role
create_role() {
    local role_name=$1
    local description=$2
    
    echo "Creating role: $role_name"
    
    # Create the role
    aws iam create-role \
        --role-name "$role_name" \
        --assume-role-policy-document "file://iam-roles/${role_name}-trust-policy.json" \
        --description "$description"
    
    # Attach the permission policy
    aws iam put-role-policy \
        --role-name "$role_name" \
        --policy-name "${role_name}-Policy" \
        --policy-document "file://iam-roles/${role_name}-permissions.json"
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully created $role_name"
    else
        echo "❌ Failed to create $role_name"
    fi
    echo ""
}

# Create all MLA-C01 roles
create_role "MLA-DataEngineer-Role" "Role for data engineers working with ML data pipelines"
create_role "MLA-DataScientist-Role" "Role for data scientists developing ML models"
create_role "MLA-MLOps-Role" "Role for MLOps engineers managing ML infrastructure"
create_role "MLA-Auditor-Role" "Role for compliance auditing and monitoring"

echo "🎯 IAM Roles Creation Complete!"
echo "Next: Implement S3 bucket policies"
echo "======================================================"