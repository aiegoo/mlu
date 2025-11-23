#!/usr/bin/env python3
"""
aws_manual_shutdown.py

This script lists and (optionally) stops/terminates major AWS resources to help prevent unexpected costs.
- Works with IAM user credentials (must be configured via environment or ~/.aws/credentials)
- Only lists by default; set ACTION_MODE = True to actually stop/terminate resources
"""

import boto3
import botocore
import sys

# DEBUG: Print which credentials are being used
from botocore.session import get_session
import os

def print_aws_creds():
    session = get_session()
    creds = session.get_credentials()
    print("\n[DEBUG] AWS credentials in use:")
    if creds:
        frozen = creds.get_frozen_credentials()
        print(f"  Access Key: {frozen.access_key}")
        print(f"  Secret Key: {frozen.secret_key[:4]}... (hidden)")
    else:
        print("  No credentials found.")
    print(f"  AWS_PROFILE: {os.environ.get('AWS_PROFILE')}")
    print(f"  AWS config/credentials path: {os.path.expanduser('~/.aws/credentials')}")

print_aws_creds()

# Set to True to actually stop/terminate resources, False to only list
ACTION_MODE = True 

# Helper to print and optionally perform an action
def safe_action(desc, func, *args, **kwargs):
    try:
        print(f"Checking {desc}...")
        result = func(*args, **kwargs)
        return result
    except botocore.exceptions.ClientError as e:
        print(f"[ERROR] {desc}: {e}")
        return None

# EC2
try:
    ec2 = boto3.client('ec2')
    instances = safe_action('EC2 instances', ec2.describe_instances)
    if instances:
        running = [i['InstanceId'] for r in instances['Reservations'] for i in r['Instances'] if i['State']['Name'] == 'running']
        print(f"Running EC2 instances: {running}")
        if ACTION_MODE and running:
            print("Stopping EC2 instances...")
            ec2.stop_instances(InstanceIds=running)
except Exception as e:
    print(f"EC2 error: {e}")

# SageMaker Endpoints
try:
    sm = boto3.client('sagemaker')
    endpoints = safe_action('SageMaker endpoints', sm.list_endpoints)
    if endpoints:
        active = [e['EndpointName'] for e in endpoints['Endpoints'] if e['EndpointStatus'] == 'InService']
        print(f"Active SageMaker endpoints: {active}")
        if ACTION_MODE and active:
            for ep in active:
                print(f"Deleting SageMaker endpoint: {ep}")
                sm.delete_endpoint(EndpointName=ep)
except Exception as e:
    print(f"SageMaker error: {e}")

# SageMaker Notebook Instances
try:
    notebooks = safe_action('SageMaker notebook instances', sm.list_notebook_instances)
    if notebooks:
        running = [n['NotebookInstanceName'] for n in notebooks['NotebookInstances'] if n['NotebookInstanceStatus'] == 'InService']
        print(f"Running SageMaker notebooks: {running}")
        if ACTION_MODE and running:
            for nb in running:
                print(f"Stopping notebook: {nb}")
                sm.stop_notebook_instance(NotebookInstanceName=nb)
except Exception as e:
    print(f"SageMaker notebook error: {e}")

# Lambda
try:
    lam = boto3.client('lambda')
    funcs = safe_action('Lambda functions', lam.list_functions)
    if funcs:
        print(f"Lambda functions: {[f['FunctionName'] for f in funcs['Functions']]}")
except Exception as e:
    print(f"Lambda error: {e}")

# RDS
try:
    rds = boto3.client('rds')
    dbs = safe_action('RDS instances', rds.describe_db_instances)
    if dbs:
        running = [db['DBInstanceIdentifier'] for db in dbs['DBInstances'] if db['DBInstanceStatus'] == 'available']
        print(f"Available RDS instances: {running}")
        if ACTION_MODE and running:
            for dbid in running:
                print(f"Stopping RDS instance: {dbid}")
                rds.stop_db_instance(DBInstanceIdentifier=dbid)
except Exception as e:
    print(f"RDS error: {e}")

# S3 (just list, do not delete)
try:
    s3 = boto3.client('s3')
    buckets = safe_action('S3 buckets', s3.list_buckets)
    if buckets:
        print(f"S3 buckets: {[b['Name'] for b in buckets['Buckets']]}")
except Exception as e:
    print(f"S3 error: {e}")

# Elastic IPs
try:
    eips = safe_action('Elastic IPs', ec2.describe_addresses)
    if eips:
        unattached = [e['PublicIp'] for e in eips['Addresses'] if 'InstanceId' not in e]
        print(f"Unattached Elastic IPs: {unattached}")
        if ACTION_MODE and unattached:
            for ip in unattached:
                print(f"Releasing Elastic IP: {ip}")
                ec2.release_address(PublicIp=ip)
except Exception as e:
    print(f"Elastic IP error: {e}")

print("\nDone. Set ACTION_MODE = True to actually stop/terminate resources.")
