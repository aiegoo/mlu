#!/usr/bin/env python3
"""
AWS Credentials Diagnostic Tool
Helps diagnose AWS authentication issues
"""

import os
import subprocess
import json
import boto3
from botocore.exceptions import NoCredentialsError, ClientError
import urllib.request

def check_environment_variables():
    """Check AWS environment variables"""
    print("🔧 Environment Variables:")
    print("-" * 40)
    
    aws_vars = [
        'AWS_ACCESS_KEY_ID',
        'AWS_SECRET_ACCESS_KEY', 
        'AWS_DEFAULT_REGION',
        'AWS_REGION',
        'AWS_PROFILE',
        'AWS_ROLE_ARN',
        'AWS_WEB_IDENTITY_TOKEN_FILE'
    ]
    
    found_vars = {}
    for var in aws_vars:
        value = os.getenv(var)
        if value:
            if 'SECRET' in var:
                masked_value = '*' * (len(value) - 4) + value[-4:] if len(value) > 4 else '*' * len(value)
                found_vars[var] = masked_value
            else:
                found_vars[var] = value
    
    if found_vars:
        for var, value in found_vars.items():
            print(f"  ✅ {var}: {value}")
        return True
    else:
        print("  ❌ No AWS environment variables found")
        return False

def check_aws_cli():
    """Check AWS CLI configuration"""
    print("\n🔧 AWS CLI Configuration:")
    print("-" * 40)
    
    try:
        # Check if AWS CLI is installed
        result = subprocess.run(['aws', '--version'], capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            print(f"  ✅ AWS CLI installed: {result.stdout.strip()}")
        else:
            print(f"  ❌ AWS CLI version check failed")
            return False
            
        # Check configuration
        result = subprocess.run(['aws', 'configure', 'list'], capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            print(f"  ✅ AWS CLI configured:")
            for line in result.stdout.strip().split('\n'):
                if line.strip():
                    print(f"    {line}")
            return True
        else:
            print(f"  ❌ AWS CLI not configured: {result.stderr}")
            return False
            
    except FileNotFoundError:
        print("  ❌ AWS CLI not found - install with: pip install awscli")
        return False
    except subprocess.TimeoutExpired:
        print("  ❌ AWS CLI timeout")
        return False
    except Exception as e:
        print(f"  ❌ AWS CLI error: {e}")
        return False

def check_iam_role():
    """Check for IAM role (EC2 instance metadata)"""
    print("\n🔧 IAM Role Check:")
    print("-" * 40)
    
    try:
        # Try IMDSv2 first
        try:
            token_request = urllib.request.Request(
                'http://169.254.169.254/latest/api/token',
                headers={'X-aws-ec2-metadata-token-ttl-seconds': '21600'}
            )
            token_request.get_method = lambda: 'PUT'
            token_response = urllib.request.urlopen(token_request, timeout=2)
            token = token_response.read().decode('utf-8')
            
            role_request = urllib.request.Request(
                'http://169.254.169.254/latest/meta-data/iam/security-credentials/',
                headers={'X-aws-ec2-metadata-token': token}
            )
            role_response = urllib.request.urlopen(role_request, timeout=2)
            role_name = role_response.read().decode('utf-8').strip()
            
            if role_name:
                print(f"  ✅ IAM Role (IMDSv2): {role_name}")
                return True, role_name
                
        except Exception:
            # Fallback to IMDSv1
            role_response = urllib.request.urlopen(
                'http://169.254.169.254/latest/meta-data/iam/security-credentials/', 
                timeout=2
            )
            role_name = role_response.read().decode('utf-8').strip()
            if role_name:
                print(f"  ✅ IAM Role (IMDSv1): {role_name}")
                return True, role_name
                
    except Exception as e:
        print(f"  ❌ No IAM role detected (not on EC2): {e}")
    
    return False, None

def check_credentials_file():
    """Check AWS credentials file"""
    print("\n🔧 AWS Credentials File:")
    print("-" * 40)
    
    creds_file = os.path.expanduser('~/.aws/credentials')
    config_file = os.path.expanduser('~/.aws/config')
    
    if os.path.exists(creds_file):
        print(f"  ✅ Credentials file exists: {creds_file}")
        try:
            with open(creds_file, 'r') as f:
                content = f.read()
                profiles = [line.strip()[1:-1] for line in content.split('\n') if line.startswith('[') and line.endswith(']')]
                print(f"  📋 Profiles found: {profiles}")
        except Exception as e:
            print(f"  ⚠️ Error reading credentials file: {e}")
    else:
        print(f"  ❌ No credentials file found at {creds_file}")
    
    if os.path.exists(config_file):
        print(f"  ✅ Config file exists: {config_file}")
    else:
        print(f"  ❌ No config file found at {config_file}")
    
    return os.path.exists(creds_file)

def test_boto3_connection():
    """Test boto3 connection"""
    print("\n🔧 Boto3 Connection Test:")
    print("-" * 40)
    
    try:
        # Test STS (AWS Security Token Service)
        sts = boto3.client('sts')
        identity = sts.get_caller_identity()
        print(f"  ✅ AWS Identity confirmed:")
        print(f"    Account: {identity.get('Account')}")
        print(f"    User/Role: {identity.get('Arn')}")
        print(f"    User ID: {identity.get('UserId')}")
        
        # Test S3 access
        s3 = boto3.client('s3')
        buckets = s3.list_buckets()
        print(f"  ✅ S3 access confirmed:")
        print(f"    Buckets found: {len(buckets['Buckets'])}")
        
        # Test specific bucket
        try:
            s3.head_bucket(Bucket='elbee-ai')
            print(f"    ✅ elbee-ai bucket accessible")
            
            # Test list objects
            response = s3.list_objects_v2(Bucket='elbee-ai', MaxKeys=3)
            if 'Contents' in response:
                print(f"    📁 Sample objects:")
                for obj in response['Contents'][:3]:
                    print(f"      {obj['Key']}")
            else:
                print(f"    📁 Bucket is empty")
                
        except ClientError as e:
            error_code = e.response['Error']['Code']
            print(f"    ❌ elbee-ai bucket error: {error_code}")
            
        return True
        
    except NoCredentialsError:
        print(f"  ❌ No AWS credentials found")
        return False
    except ClientError as e:
        print(f"  ❌ AWS API error: {e}")
        return False
    except Exception as e:
        print(f"  ❌ Connection error: {e}")
        return False

def main():
    """Run complete AWS credentials diagnostic"""
    print("🔍 AWS Credentials Diagnostic Tool")
    print("=" * 50)
    
    # Run all checks
    env_vars = check_environment_variables()
    aws_cli = check_aws_cli()
    iam_role, role_name = check_iam_role()
    creds_file = check_credentials_file()
    boto3_works = test_boto3_connection()
    
    # Summary
    print("\n📊 Summary:")
    print("=" * 50)
    print(f"Environment Variables: {'✅' if env_vars else '❌'}")
    print(f"AWS CLI Configured: {'✅' if aws_cli else '❌'}")
    print(f"IAM Role Available: {'✅' if iam_role else '❌'}")
    print(f"Credentials File: {'✅' if creds_file else '❌'}")
    print(f"Boto3 Connection: {'✅' if boto3_works else '❌'}")
    
    print(f"\n💡 Recommendations:")
    if boto3_works:
        print(f"  🎉 Everything is working! You're ready to use AWS services.")
        if iam_role:
            print(f"  🔒 Using IAM role ({role_name}) - Most secure setup!")
        elif aws_cli:
            print(f"  🔧 Using AWS CLI credentials")
        elif env_vars:
            print(f"  🔧 Using environment variables")
    else:
        print(f"  🚨 AWS credentials not working. Try:")
        print(f"    1. aws configure")
        print(f"    2. Set environment variables")
        print(f"    3. Create ~/.aws/credentials file")
        print(f"    4. Use IAM role (if on EC2)")

if __name__ == "__main__":
    main()