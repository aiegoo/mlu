# AWS ML Mini Projects: Data Processing & Analytics
## Based on Data Engineering Lesson 2 - Free Tier Compatible

This document provides hands-on mini projects designed for AWS ML certification preparation, focusing on **data extraction, processing, and real-time analytics**. All projects are designed to work within AWS Free Tier limits to avoid unexpected costs.

---

## Project 1: Smart S3 Data Extraction Pipeline

### Overview
Build an intelligent data extraction system that uses S3 Select to query large datasets without downloading entire files, implementing cost-effective data processing patterns.

### Learning Objectives
- Master S3 Select for serverless querying
- Implement selective data extraction patterns
- Build automated data filtering pipelines
- Practice cost optimization techniques

### Architecture (Free Tier)
```
CSV/JSON Files (S3) → Lambda (S3 Select) → Filtered Data (S3) → CloudWatch Logs
```

### Implementation Guide

#### Phase 1: Data Setup
**Copilot Prompt:**
```
Create a Python script that generates sample e-commerce transaction data with the following structure:
- transaction_id, customer_id, product_category, amount, timestamp, region
- Generate 10,000 records in CSV format
- Include realistic data patterns (seasonal trends, regional differences)
- Save to a file named 'ecommerce_transactions.csv'
- Include data quality issues (missing values, outliers) for realistic processing
```

#### Phase 2: S3 Select Implementation
**Copilot Prompt:**
```
Create a Lambda function that uses S3 Select to extract data based on criteria:
1. Query transactions above $100 from the last 30 days
2. Extract transactions by specific product categories
3. Filter by region and date range
4. Return only required columns to minimize data transfer
5. Handle S3 Select syntax for CSV and JSON formats
6. Include error handling for malformed queries
7. Log query performance metrics to CloudWatch
```

#### Phase 3: Automated Extraction Pipeline
**Copilot Prompt:**
```
Create an automated pipeline that:
1. Triggers when new data files are uploaded to S3
2. Automatically runs S3 Select queries based on file metadata
3. Saves extracted results to different S3 prefixes based on criteria
4. Sends success/failure notifications
5. Tracks processing costs and query performance
6. Includes retry logic for failed extractions
```

### Free Tier Resource Usage
- **S3**: 5GB storage, 20,000 GET requests
- **Lambda**: 1M requests, 400,000 GB-seconds
- **CloudWatch**: 10 custom metrics, 5GB log ingestion
- **Estimated Monthly Cost**: $0.00 within free tier

### Success Metrics
- Query response time < 5 seconds
- 99% successful extractions
- Cost per query under $0.001
- Data extraction accuracy > 99%

---

## Project 2: Real-Time Data Anomaly Detection System

### Overview
Build a real-time anomaly detection system using Lambda and DynamoDB to identify unusual patterns in streaming data, simulating production monitoring scenarios.

### Learning Objectives
- Implement real-time data processing patterns
- Build anomaly detection algorithms
- Practice streaming data simulation
- Master serverless monitoring architecture

### Architecture (Free Tier)
```
Simulated Stream (Lambda Timer) → Processing Lambda → DynamoDB → Alert Lambda → CloudWatch
```

### Implementation Guide

#### Phase 1: Data Stream Simulation
**Copilot Prompt:**
```
Create a Lambda function that simulates real-time IoT sensor data:
1. Generate temperature, humidity, and pressure readings every minute
2. Include normal patterns (daily cycles, seasonal trends)
3. Randomly inject anomalies (sensor failures, extreme values)
4. Store readings in DynamoDB with timestamps
5. Include device metadata (location, sensor_type, device_id)
6. Simulate different types of anomalies: spikes, flatlines, gradual drift
```

#### Phase 2: Anomaly Detection Engine
**Copilot Prompt:**
```
Create an anomaly detection Lambda that:
1. Implements statistical anomaly detection (Z-score, moving averages)
2. Detects patterns: sudden spikes, flatlines, gradual drift
3. Maintains rolling statistics for each sensor
4. Adapts thresholds based on historical patterns
5. Stores anomaly events with confidence scores
6. Handles multiple sensor types with different normal ranges
7. Implements time-window based analysis (1-hour, 24-hour patterns)
```

#### Phase 3: Real-Time Alerting System
**Copilot Prompt:**
```
Build a real-time alerting system that:
1. Monitors anomaly detection results
2. Implements alert severity levels (low, medium, high, critical)
3. Prevents alert fatigue with intelligent suppression
4. Creates detailed anomaly reports with context
5. Tracks system health and detection accuracy
6. Implements escalation rules for critical anomalies
7. Provides dashboard-ready metrics for visualization
```

### Free Tier Resource Usage
- **DynamoDB**: 25GB storage, 25 RCU/WCU
- **Lambda**: 1M requests, 400,000 GB-seconds
- **CloudWatch**: 10 custom metrics, 1,000 API requests
- **Estimated Monthly Cost**: $0.00 within free tier

### Success Metrics
- Anomaly detection accuracy > 95%
- False positive rate < 5%
- Alert response time < 30 seconds
- System availability > 99.9%

---

## Project 3: Multi-Format Data Transformation Pipeline

### Overview
Create a serverless data transformation pipeline that converts between different data formats (CSV, JSON, Parquet) while optimizing for storage and query performance.

### Learning Objectives
- Master data format conversions
- Implement ETL processing patterns
- Optimize data storage formats
- Practice batch processing with Lambda

### Architecture (Free Tier)
```
Source Data (S3) → Transform Lambda → Optimized Data (S3) → Validation Lambda → CloudWatch
```

### Implementation Guide

#### Phase 1: Multi-Format Data Generator
**Copilot Prompt:**
```
Create a data generation system that produces:
1. Customer data in CSV format (demographics, preferences)
2. Transaction logs in JSON format (nested structures, arrays)
3. Product catalog in XML format (hierarchical data)
4. Include data quality challenges: inconsistent schemas, missing fields, special characters
5. Generate sample files of varying sizes (1KB to 100MB)
6. Include realistic business scenarios and edge cases
```

#### Phase 2: Intelligent Format Converter
**Copilot Prompt:**
```
Build a Lambda-based conversion system that:
1. Auto-detects input data format and schema
2. Converts between CSV, JSON, Parquet, and XML formats
3. Optimizes output format based on intended use case
4. Handles schema evolution and data type inference
5. Implements data validation during transformation
6. Compresses output files for storage optimization
7. Maintains conversion audit logs and performance metrics
```

#### Phase 3: Optimization and Quality Checker
**Copilot Prompt:**
```
Create a data quality and optimization system that:
1. Analyzes converted files for compression ratios and query performance
2. Validates data integrity after format conversion
3. Generates data quality reports (completeness, accuracy, consistency)
4. Recommends optimal formats for different use cases
5. Implements automated quality checks and validation rules
6. Tracks processing costs and performance improvements
7. Provides format-specific optimization recommendations
```

### Free Tier Resource Usage
- **S3**: 5GB storage, 20,000 PUT/GET requests
- **Lambda**: 1M requests, 400,000 GB-seconds
- **CloudWatch**: 10 custom metrics, 5GB logs
- **Estimated Monthly Cost**: $0.00 within free tier

### Success Metrics
- Conversion success rate > 99%
- Average compression ratio > 60%
- Processing time < 2 minutes per 100MB
- Data quality score > 95%

---

## Project 4: Advanced Troubleshooting and Performance Monitoring

### Overview
Build a comprehensive monitoring and troubleshooting system that identifies performance bottlenecks and system issues in data processing pipelines.

### Learning Objectives
- Implement advanced monitoring patterns
- Build performance analysis tools
- Practice troubleshooting methodologies
- Master observability in serverless architectures

### Architecture (Free Tier)
```
Application Metrics → CloudWatch → Analysis Lambda → Performance DB (DynamoDB) → Alert System
```

### Implementation Guide

#### Phase 1: Performance Metrics Collection
**Copilot Prompt:**
```
Create a comprehensive metrics collection system that:
1. Monitors Lambda execution times, memory usage, and errors
2. Tracks S3 request patterns and access frequencies
3. Monitors DynamoDB read/write capacity utilization
4. Collects custom application metrics (processing rates, queue depths)
5. Implements distributed tracing for request flows
6. Captures performance baselines and trends
7. Stores metrics in time-series format for analysis
```

#### Phase 2: Intelligent Issue Detection
**Copilot Prompt:**
```
Build an automated issue detection system that:
1. Identifies performance degradation patterns
2. Detects resource utilization anomalies
3. Monitors error rates and failure patterns
4. Analyzes trends for proactive issue identification
5. Correlates issues across different AWS services
6. Implements intelligent alerting with context
7. Provides root cause analysis suggestions
```

#### Phase 3: Advanced Troubleshooting Dashboard
**Copilot Prompt:**
```
Create a troubleshooting and analysis system that:
1. Generates performance reports with actionable insights
2. Provides cost analysis and optimization recommendations
3. Implements automated performance tuning suggestions
4. Creates system health scorecards
5. Tracks SLA compliance and performance targets
6. Provides detailed error analysis and resolution guides
7. Implements predictive analysis for capacity planning
```

### Free Tier Resource Usage
- **CloudWatch**: 10 custom metrics, 1,000 API requests
- **DynamoDB**: 25GB storage, 25 RCU/WCU
- **Lambda**: 1M requests, 400,000 GB-seconds
- **Estimated Monthly Cost**: $0.00 within free tier

### Success Metrics
- Issue detection time < 5 minutes
- False positive rate < 3%
- Resolution time improvement > 50%
- System uptime > 99.95%

---

## Implementation Best Practices

### Cost Management
1. **Monitor Usage**: Set up billing alerts for each service
2. **Resource Cleanup**: Implement automated cleanup for test resources
3. **Optimize Triggers**: Use CloudWatch Events efficiently to avoid excessive Lambda invocations
4. **Data Lifecycle**: Implement S3 lifecycle policies to manage storage costs

### Security Considerations
1. **IAM Policies**: Use least-privilege principles for all Lambda functions
2. **Data Encryption**: Enable encryption at rest for S3 and DynamoDB
3. **Access Logging**: Enable CloudTrail for audit trails
4. **Secure Communications**: Use HTTPS for all API communications

### Testing Strategy
1. **Unit Testing**: Test each Lambda function independently
2. **Integration Testing**: Test complete workflows end-to-end
3. **Load Testing**: Simulate realistic data volumes and processing loads
4. **Error Testing**: Test failure scenarios and recovery mechanisms

---

## Learning Resources

### AWS Documentation
- [S3 Select User Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/selecting-content-from-objects.html)
- [Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/)
- [CloudWatch User Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/)

### GitHub Copilot Tips
- Be specific about error handling requirements
- Request code comments and documentation
- Ask for test cases and validation logic
- Specify performance and security requirements

### Certification Alignment
These projects directly support AWS ML certification objectives:
- Data Engineering Domain (40% of exam)
- Security and Compliance (10-15% of exam)
- Monitoring and Troubleshooting (15-20% of exam)
- Cost Optimization (10-15% of exam)

---

**Note**: All projects are designed to work within AWS Free Tier limits. Always monitor your usage and set up billing alerts to avoid unexpected charges. The estimated costs assume staying within free tier limits and may vary based on actual usage patterns.