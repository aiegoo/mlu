#!/bin/bash
# AWS Resource Cleanup Script - STOP ALL CHARGES

echo "🚨 AWS Cost Investigation and Cleanup Script"
echo "============================================"

# 1. Check SageMaker endpoints (EXPENSIVE!)
echo "Checking SageMaker endpoints..."
aws sagemaker list-endpoints --output table

# 2. Check SageMaker models and configurations
echo "Checking SageMaker models..."
aws sagemaker list-models --output table

echo "Checking endpoint configurations..."
aws sagemaker list-endpoint-configs --output table

# 3. Check EC2 instances (might be hidden)
echo "Checking EC2 instances..."
aws ec2 describe-instances --query 'Reservations[].Instances[?State.Name!=`terminated`].[InstanceId,InstanceType,State.Name,LaunchTime]' --output table

# 4. Check EBS volumes (storage costs)
echo "Checking EBS volumes..."
aws ec2 describe-volumes --filters "Name=state,Values=available,in-use" --query 'Volumes[*].[VolumeId,Size,VolumeType,State,CreateTime]' --output table

# 5. Check S3 buckets and sizes
echo "Checking S3 storage..."
aws s3 ls

# 6. Check CloudWatch logs (can be expensive)
echo "Checking CloudWatch log groups..."
aws logs describe-log-groups --query 'logGroups[*].[logGroupName,storedBytes]' --output table

# 7. Check Lambda functions
echo "Checking Lambda functions..."
aws lambda list-functions --query 'Functions[*].[FunctionName,Runtime,LastModified]' --output table

# 8. Check Application Load Balancers
echo "Checking Load Balancers..."
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerName,State.Code,Type,CreatedTime]' --output table

# 9. Check NAT Gateways (EXPENSIVE!)
echo "Checking NAT Gateways..."
aws ec2 describe-nat-gateways --query 'NatGateways[?State!=`deleted`].[NatGatewayId,State,CreateTime,SubnetId]' --output table

# 10. Check Elastic IPs
echo "Checking Elastic IPs..."
aws ec2 describe-addresses --query 'Addresses[*].[PublicIp,AssociationId,AllocationId]' --output table

echo "============================================"
echo "✅ Investigation complete!"
echo "Review the output above for any running resources."