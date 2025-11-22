#!/usr/bin/env python3
"""
AWS Cost Optimization Toolkit
Created from real-world $100→$3 cost reduction experience

This toolkit helps identify and eliminate AWS cost waste
Author: AWS Cost Optimization Expert
"""

import boto3
import json
from datetime import datetime, timezone, timedelta
import argparse

class AWSCostOptimizer:
    def __init__(self):
        self.sagemaker = boto3.client('sagemaker')
        self.ec2 = boto3.client('ec2')
        self.ce = boto3.client('ce')
        self.cloudwatch = boto3.client('cloudwatch')
        
    def check_expensive_endpoints(self):
        """Find running SageMaker endpoints and their cost impact"""
        print("🔍 Checking SageMaker Endpoints...")
        
        endpoints = self.sagemaker.list_endpoints()
        total_hourly_cost = 0
        
        for endpoint in endpoints['Endpoints']:
            config_name = endpoint['EndpointConfigName']
            config = self.sagemaker.describe_endpoint_config(
                EndpointConfigName=config_name
            )
            
            for variant in config['ProductionVariants']:
                instance_type = variant['InstanceType']
                instance_count = variant['InitialInstanceCount']
                
                # Cost mapping (approximate)
                cost_map = {
                    'ml.t2.medium': 0.056,
                    'ml.t3.medium': 0.0464,
                    'ml.m5.large': 0.115,
                    'ml.c5.xlarge': 0.17,
                    'ml.c5.4xlarge': 0.68,
                    'ml.p3.2xlarge': 3.06
                }
                
                hourly_cost = cost_map.get(instance_type, 0.10) * instance_count
                total_hourly_cost += hourly_cost
                
                print(f"⚠️  Endpoint: {endpoint['EndpointName']}")
                print(f"   Instance: {instance_type} x{instance_count}")
                print(f"   Cost: ${hourly_cost:.2f}/hour (${hourly_cost * 24:.2f}/day)")
                
                if hourly_cost > 0.10:
                    print(f"   💰 Potential savings: Switch to ml.t3.medium")
                    print(f"      New cost: ${0.0464 * instance_count:.2f}/hour")
                    print(f"      Monthly savings: ${(hourly_cost - 0.0464) * 24 * 30:.2f}")
        
        if total_hourly_cost == 0:
            print("✅ No running endpoints found")
        else:
            print(f"\n💸 Total endpoint cost: ${total_hourly_cost:.2f}/hour")
            print(f"💸 Monthly cost: ${total_hourly_cost * 24 * 30:.2f}")
        
        return total_hourly_cost
    
    def check_training_jobs(self):
        """Check for long-running training jobs"""
        print("\n🔍 Checking Training Jobs...")
        
        jobs = self.sagemaker.list_training_jobs(StatusEquals='InProgress')
        
        if not jobs['TrainingJobSummaries']:
            print("✅ No running training jobs")
            return
        
        for job in jobs['TrainingJobSummaries']:
            creation_time = job['CreationTime']
            runtime_hours = (datetime.now(timezone.utc) - creation_time).total_seconds() / 3600
            
            print(f"⚠️  Training Job: {job['TrainingJobName']}")
            print(f"   Running for: {runtime_hours:.1f} hours")
            
            if runtime_hours > 1:
                print(f"   🚨 Consider stopping - potential runaway job")
    
    def check_ec2_resources(self):
        """Check for expensive EC2 resources"""
        print("\n🔍 Checking EC2 Resources...")
        
        # Check NAT Gateways
        nat_gateways = self.ec2.describe_nat_gateways()
        active_nats = [ng for ng in nat_gateways['NatGateways'] if ng['State'] != 'deleted']
        
        if active_nats:
            for nat in active_nats:
                print(f"💰 NAT Gateway: {nat['NatGatewayId']}")
                print(f"   Cost: $0.045/hour ($32.40/month)")
                print(f"   💡 Consider: Do you really need this for learning?")
        
        # Check Elastic IPs
        addresses = self.ec2.describe_addresses()
        unassociated = [addr for addr in addresses['Addresses'] if 'AssociationId' not in addr]
        
        if unassociated:
            for addr in unassociated:
                print(f"💰 Unassociated Elastic IP: {addr['PublicIp']}")
                print(f"   Cost: $0.005/hour ($3.60/month)")
                print(f"   💡 Release if not needed")
    
    def get_monthly_costs(self):
        """Get current month cost breakdown"""
        print("\n📊 Monthly Cost Analysis...")
        
        end_date = datetime.now().strftime('%Y-%m-%d')
        start_date = datetime.now().replace(day=1).strftime('%Y-%m-%d')
        
        try:
            response = self.ce.get_cost_and_usage(
                TimePeriod={'Start': start_date, 'End': end_date},
                Granularity='MONTHLY',
                Metrics=['BlendedCost'],
                GroupBy=[{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
            )
            
            costs = response['ResultsByTime'][0]['Groups']
            total_cost = 0
            
            print(f"Costs from {start_date} to {end_date}:")
            
            for cost in costs:
                service = cost['Keys'][0]
                amount = float(cost['Metrics']['BlendedCost']['Amount'])
                if amount > 0.01:  # Only show significant costs
                    total_cost += amount
                    print(f"  {service}: ${amount:.2f}")
            
            print(f"\n💰 Total month-to-date: ${total_cost:.2f}")
            
            # Projection
            days_in_month = datetime.now().day
            projected_monthly = total_cost * (30 / days_in_month)
            print(f"📈 Projected monthly total: ${projected_monthly:.2f}")
            
            if projected_monthly > 10:
                print("🚨 WARNING: Projected monthly cost > $10")
                print("💡 Consider optimization strategies")
            
        except Exception as e:
            print(f"❌ Could not retrieve cost data: {e}")
    
    def create_billing_alarm(self, threshold=10):
        """Create CloudWatch billing alarm"""
        print(f"\n🔔 Creating Billing Alarm for ${threshold}...")
        
        try:
            self.cloudwatch.put_metric_alarm(
                AlarmName=f'AWS-Billing-Alert-{threshold}USD',
                ComparisonOperator='GreaterThanThreshold',
                EvaluationPeriods=1,
                MetricName='EstimatedCharges',
                Namespace='AWS/Billing',
                Period=86400,
                Statistic='Maximum',
                Threshold=threshold,
                ActionsEnabled=False,  # Set to True and add SNS topic for notifications
                AlarmDescription=f'Alarm when AWS bill exceeds ${threshold}',
                Dimensions=[
                    {
                        'Name': 'Currency',
                        'Value': 'USD'
                    },
                ],
                Unit='Count'
            )
            print(f"✅ Billing alarm created for ${threshold}")
        except Exception as e:
            print(f"❌ Could not create billing alarm: {e}")
    
    def emergency_cleanup(self, confirm=False):
        """Emergency cleanup of expensive resources"""
        if not confirm:
            print("\n🚨 EMERGENCY CLEANUP MODE")
            print("This will DELETE expensive resources!")
            print("Run with --confirm to execute")
            return
        
        print("\n🚨 Executing Emergency Cleanup...")
        
        # Stop training jobs
        jobs = self.sagemaker.list_training_jobs(StatusEquals='InProgress')
        for job in jobs['TrainingJobSummaries']:
            print(f"🛑 Stopping training job: {job['TrainingJobName']}")
            self.sagemaker.stop_training_job(TrainingJobName=job['TrainingJobName'])
        
        # Delete endpoints
        endpoints = self.sagemaker.list_endpoints()
        for endpoint in endpoints['Endpoints']:
            print(f"🗑️  Deleting endpoint: {endpoint['EndpointName']}")
            self.sagemaker.delete_endpoint(EndpointName=endpoint['EndpointName'])
    
    def generate_cost_report(self):
        """Generate comprehensive cost optimization report"""
        print("\n📋 AWS Cost Optimization Report")
        print("=" * 50)
        
        endpoint_cost = self.check_expensive_endpoints()
        self.check_training_jobs()
        self.check_ec2_resources()
        self.get_monthly_costs()
        
        print("\n💡 Optimization Recommendations:")
        print("1. Use ml.t3.medium for learning ($0.0464/hour)")
        print("2. Enable spot instances (70% discount)")
        print("3. Set 1-hour time limits on training jobs")
        print("4. Delete endpoints after testing")
        print("5. Monitor costs daily")
        
        if endpoint_cost > 0:
            potential_savings = endpoint_cost * 24 * 30 * 0.9  # 90% savings possible
            print(f"\n💰 Potential monthly savings: ${potential_savings:.2f}")

def main():
    parser = argparse.ArgumentParser(description='AWS Cost Optimization Toolkit')
    parser.add_argument('--cleanup', action='store_true', help='Show cleanup actions')
    parser.add_argument('--confirm', action='store_true', help='Confirm cleanup execution')
    parser.add_argument('--alarm', type=int, default=10, help='Billing alarm threshold')
    
    args = parser.parse_args()
    
    optimizer = AWSCostOptimizer()
    
    if args.cleanup:
        optimizer.emergency_cleanup(args.confirm)
    else:
        optimizer.generate_cost_report()
        optimizer.create_billing_alarm(args.alarm)

if __name__ == '__main__':
    main()