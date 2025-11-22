# 🔐 MFA Setup Guide for MLA-C01 Admin User

## Overview
Your admin user **[0;34mℹ️  Creating admin user: mla-admin-hsyyu[0m
[1;33m⚠️  User might already exist: mla-admin-hsyyu[0m
mla-admin-hsyyu** has been created with MFA (Multi-Factor Authentication) enforcement for security.

## Step-by-Step MFA Setup

### 1. Install MFA App
Download one of these apps on your mobile device:
- **Google Authenticator** (Recommended)
- **Authy** 
- **Microsoft Authenticator**

### 2. Login to AWS Console
- URL: https://819556863188.signin.aws.amazon.com/console
- Username: **[0;34mℹ️  Creating admin user: mla-admin-hsyyu[0m
[1;33m⚠️  User might already exist: mla-admin-hsyyu[0m
mla-admin-hsyyu**
- Use temporary password provided

### 3. Setup MFA Device
1. Go to **IAM Console** → **Users** → **[0;34mℹ️  Creating admin user: mla-admin-hsyyu[0m
[1;33m⚠️  User might already exist: mla-admin-hsyyu[0m
mla-admin-hsyyu**
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

```bash
# Get MFA session token (replace with your MFA device ARN and code)
aws sts get-session-token \
    --serial-number arn:aws:iam::819556863188:mfa/[0;34mℹ️  Creating admin user: mla-admin-hsyyu[0m
[1;33m⚠️  User might already exist: mla-admin-hsyyu[0m
mla-admin-hsyyu \
    --token-code 123456

# Use the returned credentials in your CLI configuration
export AWS_ACCESS_KEY_ID=<temp-access-key>
export AWS_SECRET_ACCESS_KEY=<temp-secret-key>
export AWS_SESSION_TOKEN=<session-token>
```

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
Generated: Sat, Nov 22, 2025 11:17:29 AM
Account: 819556863188
Region: ap-southeast-2
