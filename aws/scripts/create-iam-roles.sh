#!/bin/bash
# MLA-C01 IAM Roles Creation Script

echo "🎭 Creating MLA-C01 IAM Roles for Exam Preparation"
echo "=================================================="

# Set variables
ACCOUNT_ID="819556863188"
REGION="ap-southeast-2"

# Create MLA-DataEngineer-Role
echo "📝 Creating MLA-DataEngineer-Role..."
aws iam create-role \
    --role-name MLA-DataEngineer-Role \
    --assume-role-policy-document file://aws/iam-roles/MLA-DataEngineer-Role-trust-policy.json \
    --description "Data engineering permissions for ML pipelines - MLA-C01 Exam Prep"

aws iam put-role-policy \
    --role-name MLA-DataEngineer-Role \
    --policy-name MLA-DataEngineer-Policy \
    --policy-document file://aws/iam-roles/MLA-DataEngineer-Role-permissions.json

echo "✅ MLA-DataEngineer-Role created successfully"

# Create MLA-DataScientist-Role
echo "📝 Creating MLA-DataScientist-Role..."
aws iam create-role \
    --role-name MLA-DataScientist-Role \
    --assume-role-policy-document file://aws/iam-roles/MLA-DataScientist-Role-trust-policy.json \
    --description "Data scientist permissions for experimentation - MLA-C01 Exam Prep"

aws iam put-role-policy \
    --role-name MLA-DataScientist-Role \
    --policy-name MLA-DataScientist-Policy \
    --policy-document file://aws/iam-roles/MLA-DataScientist-Role-permissions.json

echo "✅ MLA-DataScientist-Role created successfully"

# Create MLA-MLOps-Role  
echo "📝 Creating MLA-MLOps-Role..."
aws iam create-role \
    --role-name MLA-MLOps-Role \
    --assume-role-policy-document file://aws/iam-roles/MLA-MLOps-Role-trust-policy.json \
    --description "MLOps permissions for deployment and monitoring - MLA-C01 Exam Prep"

aws iam put-role-policy \
    --role-name MLA-MLOps-Role \
    --policy-name MLA-MLOps-Policy \
    --policy-document file://aws/iam-roles/MLA-MLOps-Role-permissions.json

echo "✅ MLA-MLOps-Role created successfully"

# Create MLA-Auditor-Role
echo "📝 Creating MLA-Auditor-Role..."
aws iam create-role \
    --role-name MLA-Auditor-Role \
    --assume-role-policy-document file://aws/iam-roles/MLA-Auditor-Role-trust-policy.json \
    --description "Read-only access for auditing and compliance - MLA-C01 Exam Prep"

aws iam put-role-policy \
    --role-name MLA-Auditor-Role \
    --policy-name MLA-Auditor-Policy \
    --policy-document file://aws/iam-roles/MLA-Auditor-Role-permissions.json

echo "✅ MLA-Auditor-Role created successfully"

echo ""
echo "🎯 ALL IAM ROLES CREATED SUCCESSFULLY!"
echo "📋 Roles created:"
echo "   • MLA-DataEngineer-Role"
echo "   • MLA-DataScientist-Role" 
echo "   • MLA-MLOps-Role"
echo "   • MLA-Auditor-Role"
echo ""
echo "🔍 Verify roles with: aws iam list-roles --query 'Roles[?contains(RoleName, \`MLA\`)].RoleName'"