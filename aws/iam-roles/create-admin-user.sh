#!/bin/bash

echo "👤 Creating MLA-C01 Admin User with MFA Configuration"
echo "===================================================="

# Set AWS region
export AWS_DEFAULT_REGION=ap-southeast-2

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "success") echo -e "${GREEN}✅ $message${NC}" ;;
        "warning") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "error") echo -e "${RED}❌ $message${NC}" ;;
        "info") echo -e "${BLUE}ℹ️  $message${NC}" ;;
    esac
}

# Function to create admin user
create_admin_user() {
    local username="mla-admin-$(whoami)"
    
    print_status "info" "Creating admin user: $username"
    
    # Create user
    aws iam create-user \
        --user-name "$username" \
        --path "/mla-admin/" \
        --tags Key=Purpose,Value=MLA-C01-Admin Key=Environment,Value=Study 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "success" "Admin user created: $username"
    else
        print_status "warning" "User might already exist: $username"
    fi
    
    echo "$username"
}

# Function to create admin group
create_admin_group() {
    local group_name="MLA-Administrators"
    
    print_status "info" "Creating admin group: $group_name"
    
    # Create group
    aws iam create-group \
        --group-name "$group_name" \
        --path "/mla-admin/" 2>/dev/null || true
    
    # Attach administrator policy
    aws iam attach-group-policy \
        --group-name "$group_name" \
        --policy-arn "arn:aws:iam::aws:policy/AdministratorAccess"
    
    # Create and attach MFA enforcement policy
    local mfa_policy_name="MLA-Admin-MFA-Enforcement"
    aws iam create-policy \
        --policy-name "$mfa_policy_name" \
        --path "/mla-admin/" \
        --policy-document "file://iam-roles/MLA-Admin-MFA-Policy.json" \
        --description "MFA enforcement policy for MLA-C01 admin users" 2>/dev/null || true
    
    local account_id=$(aws sts get-caller-identity --query Account --output text)
    aws iam attach-group-policy \
        --group-name "$group_name" \
        --policy-arn "arn:aws:iam::$account_id:policy/mla-admin/$mfa_policy_name"
    
    print_status "success" "Admin group created with MFA enforcement"
    echo "$group_name"
}

# Function to add user to admin group
add_user_to_group() {
    local username=$1
    local group_name=$2
    
    print_status "info" "Adding user to admin group..."
    
    aws iam add-user-to-group \
        --user-name "$username" \
        --group-name "$group_name"
    
    print_status "success" "User added to admin group"
}

# Function to create access keys
create_access_keys() {
    local username=$1
    
    print_status "info" "Creating access keys for user..."
    
    local access_key_output=$(aws iam create-access-key --user-name "$username" --output json)
    
    if [ $? -eq 0 ]; then
        local access_key_id=$(echo "$access_key_output" | grep -o '"AccessKeyId"[^,]*' | cut -d'"' -f4)
        local secret_key=$(echo "$access_key_output" | grep -o '"SecretAccessKey"[^,]*' | cut -d'"' -f4)
        
        print_status "success" "Access keys created successfully"
        
        # Save credentials to file (temporarily)
        local creds_file="mla-admin-credentials-$(date +%Y%m%d-%H%M%S).txt"
        cat > "$creds_file" << EOF
# MLA-C01 Admin User Credentials
# Generated: $(date)
# IMPORTANT: Set up MFA immediately after first login!

AWS_ACCESS_KEY_ID=$access_key_id
AWS_SECRET_ACCESS_KEY=$secret_key
AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION

# Console Login URL: https://819556863188.signin.aws.amazon.com/console
# Username: $username
# Note: You MUST set up MFA to access most AWS services
EOF
        
        print_status "warning" "Credentials saved to: $creds_file"
        print_status "warning" "SECURE THESE CREDENTIALS IMMEDIATELY!"
        
        return 0
    else
        print_status "error" "Failed to create access keys"
        return 1
    fi
}

# Function to setup login profile (console access)
create_login_profile() {
    local username=$1
    local temp_password="MLA-TempPass-$(date +%s)"
    
    print_status "info" "Creating console login profile..."
    
    aws iam create-login-profile \
        --user-name "$username" \
        --password "$temp_password" \
        --password-reset-required 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "success" "Console login profile created"
        
        # Save login info
        local login_file="mla-admin-console-login-$(date +%Y%m%d-%H%M%S).txt"
        cat > "$login_file" << EOF
# MLA-C01 Admin Console Login
# Generated: $(date)

Console URL: https://819556863188.signin.aws.amazon.com/console
Username: $username
Temporary Password: $temp_password

IMPORTANT NEXT STEPS:
1. Login with above credentials
2. Change password immediately (required)
3. Set up MFA device (required for most access)
4. Download MFA app (Google Authenticator, Authy, etc.)
5. Scan QR code to register MFA device

Note: Most AWS services will be blocked until MFA is configured
EOF
        
        print_status "warning" "Console login info saved to: $login_file"
    else
        print_status "warning" "Login profile might already exist"
    fi
}

# Function to provide MFA setup instructions
provide_mfa_instructions() {
    local username=$1
    
    print_status "info" "Creating MFA setup instructions..."
    
    local mfa_guide="mla-admin-mfa-setup-guide.md"
    cat > "$mfa_guide" << EOF
# 🔐 MFA Setup Guide for MLA-C01 Admin User

## Overview
Your admin user **$username** has been created with MFA (Multi-Factor Authentication) enforcement for security.

## Step-by-Step MFA Setup

### 1. Install MFA App
Download one of these apps on your mobile device:
- **Google Authenticator** (Recommended)
- **Authy** 
- **Microsoft Authenticator**

### 2. Login to AWS Console
- URL: https://819556863188.signin.aws.amazon.com/console
- Username: **$username**
- Use temporary password provided

### 3. Setup MFA Device
1. Go to **IAM Console** → **Users** → **$username**
2. Click **Security credentials** tab
3. Click **Assign MFA device**
4. Choose **Authenticator app**
5. Scan QR code with your MFA app
6. Enter two consecutive MFA codes
7. Click **Assign MFA**

### 4. Verify MFA Works
- Logout and login again
- You should be prompted for MFA code
- Enter 6-digit code from your app

## AWS CLI with MFA

To use AWS CLI with MFA, you'll need to get temporary credentials:

\`\`\`bash
# Get MFA session token (replace with your MFA device ARN and code)
aws sts get-session-token \\
    --serial-number arn:aws:iam::819556863188:mfa/$username \\
    --token-code 123456

# Use the returned credentials in your CLI configuration
export AWS_ACCESS_KEY_ID=<temp-access-key>
export AWS_SECRET_ACCESS_KEY=<temp-secret-key>
export AWS_SESSION_TOKEN=<session-token>
\`\`\`

## Security Best Practices

✅ **Change temporary password immediately**
✅ **Enable MFA on first login**
✅ **Store backup codes securely**
✅ **Don't share MFA device**
✅ **Regularly rotate access keys**

## Troubleshooting

**Problem**: Can't access AWS services after login
**Solution**: Make sure MFA is properly configured

**Problem**: Lost MFA device
**Solution**: Contact root account owner to reset MFA

## MLA-C01 Study Benefits

This secure admin setup provides:
- ✅ **Security best practices** experience
- ✅ **IAM policy** understanding  
- ✅ **MFA implementation** knowledge
- ✅ **Access control** practical experience

---
Generated: $(date)
Account: 819556863188
Region: $AWS_DEFAULT_REGION
EOF

    print_status "success" "MFA setup guide created: $mfa_guide"
}

# Main execution
main() {
    print_status "info" "Creating secure admin user for MLA-C01 studies..."
    echo ""
    
    # Create admin user
    local username=$(create_admin_user)
    echo ""
    
    # Create admin group with policies
    local group_name=$(create_admin_group)
    echo ""
    
    # Add user to group
    add_user_to_group "$username" "$group_name"
    echo ""
    
    # Create access keys
    create_access_keys "$username"
    echo ""
    
    # Create console login
    create_login_profile "$username"
    echo ""
    
    # Provide MFA instructions
    provide_mfa_instructions "$username"
    echo ""
    
    print_status "success" "🎯 Admin user setup complete!"
    echo ""
    echo "📋 **NEXT STEPS (CRITICAL):**"
    echo "  1. Check generated credential files"
    echo "  2. Login to AWS Console immediately"
    echo "  3. Change temporary password"
    echo "  4. Set up MFA device (REQUIRED)"
    echo "  5. Test access with MFA"
    echo ""
    echo "⚠️  **SECURITY NOTICE:**"
    echo "  • Credential files contain sensitive information"
    echo "  • Set up MFA immediately - most services blocked without it"
    echo "  • Delete credential files after secure storage"
    echo ""
    echo "===================================================="
}

# Run main function
main