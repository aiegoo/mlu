# 🔐 MFA Setup Guide for Oreumi/MLU Admin User

## Overview
All admin users (e.g., `oreumi-admin`, `mlu-admin`) must use Multi-Factor Authentication (MFA) for secure AWS access. This guide follows our new naming conventions and security practices.

## Step-by-Step MFA Setup

### 1. Install an Authenticator App
Download one of these apps on your mobile device:
- Google Authenticator (Recommended)
- Authy
- Microsoft Authenticator

### 2. Login to AWS Console
- URL: https://819556863188.signin.aws.amazon.com/console
- Username: `oreumi-admin` (or your assigned admin username)
- Use the temporary password provided by your AWS administrator

### 3. Setup MFA Device
1. Go to **IAM Console** → **Users** → select your admin user (e.g., `oreumi-admin`)
2. Click **Security credentials** tab
3. Click **Assign MFA device**
4. Choose **Authenticator app**
5. Scan QR code with your MFA app
6. Enter two consecutive MFA codes
7. Click **Assign MFA**

### 4. Verify MFA Works
- Logout and login again
- You should be prompted for an MFA code
- Enter the 6-digit code from your app

## AWS CLI with MFA

To use AWS CLI with MFA, you'll need to get temporary credentials:

```bash
# Get MFA session token (replace with your MFA device ARN and code)
aws sts get-session-token \
    --serial-number arn:aws:iam::819556863188:mfa/oreumi-admin \
    --token-code 123456

# Use the returned credentials in your CLI configuration
export AWS_ACCESS_KEY_ID=<AccessKeyId>
export AWS_SECRET_ACCESS_KEY=<SecretAccessKey>
export AWS_SESSION_TOKEN=<SessionToken>