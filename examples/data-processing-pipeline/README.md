# Data Processing Pipeline

This example demonstrates a comprehensive data processing pipeline using AWS managed services for batch and stream processing workloads.

## Architecture Overview

This example provisions:

### Core Infrastructure
- **VPC**: Private networking with public/private subnets
- **S3 Buckets**: Raw data ingestion, processed data storage, and logs
- **AWS Glue**: ETL jobs for data transformation and catalog management
- **MSK (Managed Streaming for Kafka)**: Real-time data streaming
- **Bastion Host**: Secure access for administration and monitoring

### Data Processing Components
- **Batch Processing**: Scheduled Glue jobs for daily/hourly data processing
- **Stream Processing**: Kafka topics for real-time data ingestion
- **Data Catalog**: Automated schema discovery and metadata management
- **Workflow Orchestration**: Glue workflows with conditional triggers

### Security Features
- **Encryption**: Data at rest and in transit
- **IAM Roles**: Least-privilege access for services
- **VPC Endpoints**: Private connectivity to AWS services
- **Security Groups**: Network-level access controls

## Use Cases

This architecture is ideal for:
- **Log Processing**: Application and infrastructure log analysis
- **IoT Data Pipeline**: Sensor data collection and processing
- **Financial Data**: Transaction processing and fraud detection
- **E-commerce Analytics**: User behavior and sales data analysis
- **Media Processing**: Video/image processing workflows

## Components

### S3 Storage
```
data-pipeline-bucket/
├── raw/              # Incoming raw data
├── processed/        # Transformed data
├── failed/           # Failed processing records
└── logs/             # Processing logs
```

### Glue Jobs
- **Raw Data Processor**: Cleans and validates incoming data
- **Data Transformer**: Applies business logic transformations
- **Data Aggregator**: Creates summary statistics and reports
- **Schema Validator**: Ensures data quality and consistency

### Kafka Topics
- **raw-events**: Incoming event stream
- **processed-events**: Transformed events
- **failed-events**: Processing failures
- **monitoring-events**: System health metrics

## Quick Start

1. **Configure Variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Deploy Infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Test Data Processing**:
   ```bash
   # Upload sample data to raw bucket
   aws s3 cp sample-data.json s3://your-bucket/raw/

   # Monitor Glue job execution
   aws glue get-job-runs --job-name raw-data-processor

   # Check Kafka topics
   aws kafka list-clusters
   ```

## Configuration

### Required Variables

| Variable | Description | Example |
|----------|-------------|----------|
| `project_name` | Project identifier | `"data-pipeline"` |
| `environment` | Environment name | `"prod"` |
| `region` | AWS region | `"us-east-1"` |

### Optional Customization

| Variable | Description | Default |
|----------|-------------|----------|
| `enable_streaming` | Enable Kafka streaming | `true` |
| `glue_job_schedule` | Cron schedule for jobs | `"0 2 * * *"` |
| `data_retention_days` | S3 lifecycle policy | `90` |
| `kafka_instance_type` | MSK instance type | `"kafka.m5.large"` |

## Data Flow

```
Data Sources → S3 Raw → Glue Jobs → S3 Processed
     ↓              ↓           ↓
   Kafka ←-------- Stream ----→ Analytics
```

### Batch Processing Flow
1. **Data Ingestion**: Files uploaded to S3 raw bucket
2. **Event Trigger**: S3 event triggers Glue workflow
3. **Validation**: Schema and data quality checks
4. **Transformation**: Business logic application
5. **Storage**: Results stored in processed bucket
6. **Notification**: Success/failure notifications

### Stream Processing Flow
1. **Event Ingestion**: Real-time events to Kafka
2. **Stream Processing**: Consumer applications process events
3. **Transformation**: Real-time data enrichment
4. **Sink**: Results to databases or other systems
5. **Monitoring**: Health metrics and alerts

## Monitoring and Operations

### CloudWatch Metrics
- Glue job success/failure rates
- S3 bucket object counts and sizes
- Kafka topic throughput and lag
- Lambda function duration and errors

### Logging
- Glue job logs in CloudWatch Logs
- Kafka broker and client logs
- S3 access logs
- VPC Flow Logs

### Alerting
- Failed job notifications via SNS
- High error rate alarms
- Resource utilization alerts
- Data quality threshold breaches

## Cost Optimization

### S3 Storage Classes
- **Standard**: Active data processing
- **IA (Infrequent Access)**: Older processed data
- **Glacier**: Long-term archival
- **Intelligent Tiering**: Automated optimization

### Glue Job Optimization
- **DPU Scaling**: Right-sized processing units
- **Job Bookmarks**: Incremental processing
- **Columnar Formats**: Parquet for analytics
- **Partitioning**: Efficient data organization

### Kafka Optimization
- **Instance Right-sizing**: Match throughput needs
- **Auto Scaling**: Dynamic capacity adjustment
- **Compression**: Reduce storage and transfer costs
- **Retention Policies**: Automatic data cleanup

## Security Best Practices

### Data Protection
- **Encryption**: AES-256 for S3, TLS for Kafka
- **Access Control**: IAM roles and policies
- **Network Security**: VPC and security groups
- **Audit Logging**: CloudTrail for API calls

### Compliance
- **Data Classification**: Tag sensitive data
- **Access Monitoring**: Regular access reviews
- **Encryption Keys**: KMS key management
- **Data Retention**: Automated lifecycle policies

## Troubleshooting

### Common Issues

1. **Glue Job Failures**:
   - Check CloudWatch Logs for error details
   - Verify IAM permissions for data access
   - Validate input data schema

2. **Kafka Connectivity**:
   - Verify security group rules
   - Check VPC endpoint configuration
   - Validate bootstrap servers

3. **S3 Access Issues**:
   - Confirm bucket policies
   - Check VPC endpoint routes
   - Verify IAM role permissions

### Debug Commands

```bash
# Check Glue job status
aws glue get-job --job-name raw-data-processor

# List Kafka clusters
aws kafka list-clusters --region us-east-1

# Check S3 bucket contents
aws s3 ls s3://your-bucket/raw/ --recursive

# View CloudWatch logs
aws logs describe-log-groups --log-group-name-prefix "/aws-glue/"
```

## Estimated Monthly Cost

| Service | Configuration | Monthly Cost |
|---------|---------------|-------------|
| VPC + NAT Gateway | 2 AZs | $45 |
| S3 Storage | 1TB Standard | $25 |
| Glue Jobs | 10 DPU-hours/day | $80 |
| MSK Kafka | 2x m5.large | $280 |
| Bastion Host | t3.micro | $8 |
| CloudWatch Logs | 10GB/month | $5 |
| **Total** | | **~$443/month** |

*Costs may vary based on actual usage, region, and data volumes.*

## Advanced Configuration

### Custom Glue Job

Add your own ETL logic by modifying the Glue job scripts:

```python
# custom-transformation.py
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext

# Your custom transformation logic here
```

### Kafka Configuration

Customize Kafka settings:

```hcl
kafka_configuration = {
  "auto.create.topics.enable" = "true"
  "default.replication.factor" = "2"
  "min.insync.replicas" = "2"
  "num.partitions" = "8"
}
```

### Integration Examples

```hcl
# Add Lambda functions for event processing
module "event_processor" {
  source = "../../modules/aws-lambda"

  name = "${var.project_name}-event-processor"
  runtime = "python3.9"
  handler = "index.handler"
}

# Add RDS for processed data storage
module "analytics_db" {
  source = "../../modules/aws-rds"

  name = "${var.project_name}-analytics"
  engine = "postgres"
  instance_class = "db.t3.medium"
}
```

## Next Steps

1. **Scale Up**: Add more Glue jobs for additional data sources
2. **Real-time Analytics**: Integrate with Kinesis Analytics
3. **Machine Learning**: Add SageMaker for predictive analytics
4. **Visualization**: Connect to QuickSight or Grafana
5. **Monitoring**: Implement comprehensive observability

## References

- [AWS Glue Developer Guide](https://docs.aws.amazon.com/glue/)
- [Amazon MSK Documentation](https://docs.aws.amazon.com/msk/)
- [S3 Storage Classes Guide](https://aws.amazon.com/s3/storage-classes/)
- [Data Processing Best Practices](https://aws.amazon.com/big-data/datalakes-and-analytics/)
