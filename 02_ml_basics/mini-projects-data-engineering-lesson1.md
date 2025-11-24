# AWS ML Data Engineering Mini Projects & Copilot Prompts (Free Tier Compatible)

Based on the content in `data-engieering.md`, here are focused mini projects designed for AWS Free Tier accounts with corresponding GitHub Copilot prompts for hands-on implementation:

## Mini Project 1: Simple Data Processing Pipeline with Lambda and S3

### Project Statement
Create a basic data processing pipeline using only free-tier services (Lambda, S3, CloudWatch) that processes JSON data files, performs transformations, and stores results for analysis. This project demonstrates core data engineering concepts without requiring premium services.

### Learning Objectives
- Implement data ingestion using S3 event triggers
- Create data transformation logic with Lambda functions
- Handle different data formats (JSON, CSV)
- Set up basic monitoring and logging

### Free Tier Resources Used
- **Lambda**: 1M free requests/month, 400,000 GB-seconds compute
- **S3**: 5GB storage, 20,000 GET requests, 2,000 PUT requests
- **CloudWatch**: Basic monitoring included

### Copilot Prompt for Implementation
```
I need to build a simple data processing pipeline using only AWS Free Tier services:

1. **S3 Data Storage Setup**: Create S3 buckets for:
   - Raw data input (JSON files)
   - Processed data output (CSV format)
   - Configure S3 event notifications to trigger processing

2. **Lambda Data Processor**: Write a Python Lambda function that:
   - Triggers on S3 PUT events
   - Reads JSON data files from S3
   - Performs basic transformations (cleaning, filtering, aggregation)
   - Saves processed data as CSV to output S3 bucket
   - Includes error handling and logging

3. **Data Format Conversion**: Implement functions to:
   - Parse JSON data with nested structures
   - Convert to tabular CSV format
   - Handle missing values and data validation
   - Compress output files for storage efficiency

4. **Basic Monitoring**: Set up CloudWatch to:
   - Monitor Lambda execution metrics
   - Log processing errors and success rates
   - Track data processing volume

Please provide code for a complete pipeline that processes sample customer data, stays within free tier limits, and includes proper error handling.
```

## Mini Project 2: Data Lake Simulation with S3 and Local Tools

### Project Statement
Build a simulated data lake using S3 free tier storage that handles multiple data formats, with local processing tools to demonstrate data lake concepts without requiring expensive AWS services like EMR or Glue.

### Learning Objectives
- Design basic data lake architecture using S3
- Work with different data formats (CSV, JSON, Parquet)
- Implement data cataloging concepts
- Use boto3 for programmatic S3 access

### Free Tier Resources Used
- **S3**: 5GB storage for multiple data formats
- **Lambda**: For lightweight data processing tasks
- **Local Python**: For data format conversion and analysis

### Copilot Prompt for Implementation
```
I need to build a data lake simulation using AWS Free Tier and local tools:

1. **S3 Data Lake Structure**: Design S3 bucket organization for:
   - Raw data folder (JSON, CSV files)
   - Processed data folder (Parquet format)
   - Metadata folder (schema definitions)
   - Use S3 prefixes to simulate partitioning by date/type

2. **Local Data Processing Scripts**: Create Python scripts that:
   - Connect to S3 using boto3
   - Download data files for local processing
   - Convert between formats (JSON to CSV, CSV to Parquet)
   - Upload processed results back to S3
   - Generate basic data quality reports

3. **Data Catalog Simulation**: Build a simple catalog system that:
   - Tracks data schemas and locations
   - Stores metadata in JSON format on S3
   - Provides search functionality for datasets
   - Validates data format compliance

4. **Query Interface**: Create a local Python application that:
   - Connects to S3 data lake
   - Downloads and queries data using pandas
   - Simulates basic analytics queries
   - Generates summary statistics and reports

Please provide scripts for data lake setup, format conversion, and basic querying that work within free tier limits.
```

## Mini Project 3: Simple Feature Engineering with S3 and Lambda

### Project Statement
Create a basic feature engineering system using S3 for storage and Lambda for processing, simulating feature store concepts without requiring SageMaker Feature Store (which may have costs beyond free tier).

### Learning Objectives
- Implement feature engineering workflows
- Create reusable feature transformations
- Store and version feature datasets
- Build feature discovery mechanisms

### Free Tier Resources Used
- **S3**: Feature data storage and versioning
- **Lambda**: Feature computation and transformation
- **DynamoDB**: Feature metadata catalog (25GB free storage)

### Copilot Prompt for Implementation
```
I need to build a simple feature engineering system using free tier services:

1. **S3 Feature Storage**: Design storage structure for:
   - Raw feature data (CSV/JSON format)
   - Computed features (organized by feature type)
   - Feature versions with timestamp-based naming
   - Feature metadata and documentation

2. **Lambda Feature Processing**: Create functions that:
   - Read raw data from S3
   - Apply feature engineering transformations (scaling, encoding, aggregation)
   - Store computed features back to S3
   - Update feature metadata in DynamoDB

3. **DynamoDB Feature Catalog**: Build a catalog that tracks:
   - Feature definitions and schemas
   - Data lineage and transformation logic
   - Feature usage statistics
   - Quality metrics and validation rules

4. **Feature Discovery Interface**: Create a local Python tool that:
   - Queries the DynamoDB feature catalog
   - Downloads feature datasets from S3
   - Provides feature selection and joining capabilities
   - Generates feature documentation

5. **Batch Feature Pipeline**: Implement scheduled processing using:
   - CloudWatch Events (free) to trigger Lambda
   - Batch processing of feature updates
   - Error handling and retry logic
   - Basic monitoring and alerting

Please provide code for feature engineering functions, catalog management, and a simple discovery interface.
```

## Mini Project 4: Local Database to S3 Migration Simulation

### Project Statement
Create a simplified database migration workflow that moves data from a local SQLite database to S3, demonstrating migration concepts without requiring AWS DMS (which may incur costs) or complex database setups.

### Learning Objectives
- Understand database migration patterns
- Implement data format optimization
- Create automated data transfer workflows
- Handle data validation and quality checks

### Free Tier Resources Used
- **S3**: Target storage for migrated data
- **Lambda**: Data processing and validation
- **Local SQLite**: Source database (no AWS costs)
- **CloudWatch**: Basic monitoring

### Copilot Prompt for Implementation
```
I need to build a database migration simulation using free tier services:

1. **Local Database Setup**: Create SQLite database with:
   - Sample customer and order tables
   - Different data types and relationships
   - Some data quality issues to handle
   - Scripts to generate test data

2. **Migration Script**: Build Python script that:
   - Connects to SQLite database
   - Extracts data in batches to avoid memory issues
   - Converts data to CSV and Parquet formats
   - Uploads to S3 using boto3
   - Implements resumable transfer for large datasets

3. **Data Validation Pipeline**: Create Lambda function that:
   - Triggers on S3 upload completion
   - Validates data integrity and format
   - Checks for missing or corrupted records
   - Generates data quality reports
   - Sends notifications for any issues

4. **Format Optimization**: Implement conversion logic for:
   - CSV to Parquet transformation
   - Data compression for storage efficiency
   - Schema validation and type conversion
   - Handling of null values and special characters

5. **Incremental Update Simulation**: Create process for:
   - Tracking last migration timestamp
   - Identifying new and changed records
   - Implementing upsert logic
   - Maintaining data consistency

6. **Simple Monitoring Dashboard**: Build local Python dashboard that:
   - Shows migration progress and statistics
   - Displays data quality metrics
   - Tracks S3 storage usage
   - Provides error reporting

Please provide complete migration scripts, validation logic, and monitoring tools that demonstrate real-world migration concepts.
```

## Implementation Notes for Free Tier Projects

### ⚠️ Free Tier Limitations to Consider:
- **Lambda**: 1M requests/month, 400,000 GB-seconds compute time
- **S3**: 5GB storage, 20,000 GET requests, 2,000 PUT requests
- **DynamoDB**: 25GB storage, 25 read/write capacity units
- **CloudWatch**: Basic monitoring included, custom metrics limited

### 💡 Cost-Saving Strategies:
- Use local development and testing to minimize AWS resource usage
- Implement data sampling to work with smaller datasets
- Use S3 lifecycle policies to automatically delete test data
- Monitor usage through AWS Cost Explorer

### 🚀 Recommended Development Approach:
1. **Local Development**: Test all logic locally before deploying to AWS
2. **Small Datasets**: Use sample data files < 1MB for testing
3. **Resource Cleanup**: Always clean up test resources after experiments
4. **Monitoring**: Track free tier usage to avoid unexpected charges

### 📋 Prerequisites for All Free Tier Projects:
- AWS Free Tier account with basic IAM permissions
- Python 3.8+ with boto3, pandas, sqlite3 libraries
- Local development environment (VS Code recommended)
- Basic understanding of SQL and JSON data formats

### 🛠️ Recommended Free Tools:
- **Local IDE**: VS Code with AWS extensions
- **Database**: SQLite for local testing
- **Data Processing**: pandas, numpy (local processing)
- **Version Control**: Git (free)
- **Monitoring**: AWS CloudWatch basic tier

### ✅ Success Metrics for Mini Projects:
- **Functionality**: All pipelines process data successfully
- **Cost**: Stay within free tier limits ($0 cost)
- **Learning**: Understand core data engineering concepts
- **Portfolio**: Deployable code examples for interviews

### 🎯 Learning Path Progression:
1. **Project 1**: Basic automation and event-driven processing
2. **Project 2**: Data lake concepts and format optimization  
3. **Project 3**: Feature engineering and metadata management
4. **Project 4**: Migration patterns and data validation

These mini projects provide practical experience with AWS data engineering concepts while respecting free tier limitations and focusing on core skills transferable to larger, production environments!