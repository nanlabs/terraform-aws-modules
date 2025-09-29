# Analytics Platform with Document Store

This example demonstrates a comprehensive analytics platform combining traditional data lake architecture with modern document database capabilities for real-time analytics and flexible data models.

## Architecture Overview

### Core Components

- **Data Lake**: S3-based data lake with Bronze/Silver/Gold layers
- **Document Store**: Amazon DocumentDB for flexible, JSON-based analytics
- **Stream Processing**: Apache Kafka for real-time data ingestion
- **Batch Processing**: AWS Glue for ETL workflows and data transformation
- **Analytics Layer**: Combined SQL and NoSQL query capabilities

### Integration Architecture

```
Data Sources → Kafka → Stream Processing → Document Store
     ↓              ↓                           ↑
   S3 Raw → Glue ETL → S3 Processed ←----------┘
     ↓              ↓
Data Lake Analytics ←┘
```

### Use Cases

- **Content Analytics**: Document analysis, content classification, and search
- **IoT Analytics**: Sensor data with flexible schemas and real-time processing
- **Customer Analytics**: User behavior analysis with both structured and unstructured data
- **Financial Analytics**: Transaction analysis with document-based risk models
- **Healthcare Analytics**: Patient records with flexible data models and compliance

## Features

### Document Database Capabilities

- **MongoDB Compatibility**: Amazon DocumentDB with MongoDB API
- **Flexible Schemas**: Schema-less document storage for evolving data models
- **Full-Text Search**: Built-in search capabilities for document content
- **ACID Transactions**: Multi-document ACID transactions for consistency
- **Automatic Scaling**: Read replicas and automatic failover

### Analytics Features

- **Hybrid Queries**: Combine document queries with data lake analytics
- **Real-Time Processing**: Stream processing with immediate document updates
- **Historical Analysis**: Long-term trend analysis with data lake integration
- **Machine Learning**: Feature engineering from both structured and document data
- **Data Lineage**: Track data flow from sources to analytics outputs

### Security and Compliance

- **Encryption**: End-to-end encryption for documents and data lake
- **Access Control**: Fine-grained access control for different data types
- **Audit Logging**: Comprehensive audit trail for all data access
- **Network Isolation**: VPC-based network security and private endpoints

## Architecture Components

### Document Store Setup

```
DocumentDB Cluster
├── Primary Instance (Write)
├── Read Replica 1
├── Read Replica 2 (Optional)
└── Automatic Backup
```

### Data Lake Integration

```
S3 Data Lake
├── Bronze (Raw Data)
│   ├── document-exports/
│   ├── stream-data/
│   └── batch-uploads/
├── Silver (Processed)
│   ├── enriched-documents/
│   ├── aggregated-metrics/
│   └── cleaned-data/
└── Gold (Analytics Ready)
    ├── business-reports/
    ├── ml-features/
    └── dashboard-data/
```

### Stream Processing Pipeline

1. **Data Ingestion**: Kafka topics for different data types
2. **Stream Processing**: Real-time enrichment and validation
3. **Dual Write**: Updates both DocumentDB and S3 data lake
4. **Event Sourcing**: Complete event history in data lake
5. **Real-Time Analytics**: Immediate insights from document queries

## Quick Start

1. **Configure Variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your configuration
   ```

2. **Deploy Infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Connect to DocumentDB**:
   ```bash
   # Connect via bastion host
   aws ssm start-session --target <bastion-instance-id>

   # From bastion, connect to DocumentDB
   mongo --host <docdb-cluster-endpoint> --ssl --sslCAFile rds-ca-2019-root.pem
   ```

4. **Test Data Pipeline**:
   ```bash
   # Upload sample documents
   aws s3 cp sample-documents.json s3://your-bucket/raw/documents/

   # Check Glue job processing
   aws glue get-job-runs --job-name document-processor

   # Query DocumentDB
   mongo --host <endpoint> --eval "db.analytics.find().limit(5)"
   ```

## Configuration

### Required Variables

| Variable | Description | Example |
|----------|-------------|-------------|
| `project_name` | Project identifier | `"analytics-platform"` |
| `environment` | Environment name | `"prod"` |
| `region` | AWS region | `"us-east-1"` |

### DocumentDB Configuration

| Variable | Description | Default |
|----------|-------------|-------------|
| `docdb_instance_class` | DocumentDB instance type | `"db.t3.medium"` |
| `docdb_cluster_size` | Number of instances | `2` |
| `docdb_backup_retention_period` | Backup retention days | `7` |
| `docdb_preferred_backup_window` | Backup time window | `"03:00-04:00"` |

### Advanced Features

| Variable | Description | Default |
|----------|-------------|-------------|
| `enable_document_search` | Enable full-text search | `true` |
| `enable_ml_integration` | Enable ML feature extraction | `true` |
| `enable_real_time_sync` | Enable real-time sync to data lake | `true` |

## Data Processing Patterns

### Document-First Pattern

```python
# Stream processing example
def process_document_stream(document):
    # 1. Validate and enrich document
    enriched_doc = enrich_document(document)

    # 2. Store in DocumentDB for immediate queries
    docdb.collection.insert_one(enriched_doc)

    # 3. Also store in S3 for long-term analytics
    s3.put_object(
        Bucket='data-lake-bucket',
        Key=f'bronze/documents/{document["id"]}.json',
        Body=json.dumps(enriched_doc)
    )

    return enriched_doc
```

### Analytics-First Pattern

```python
# Batch processing example
def process_analytics_batch():
    # 1. Read from S3 data lake
    documents = read_s3_documents('silver/enriched-documents/')

    # 2. Perform analytics computations
    analytics_results = compute_analytics(documents)

    # 3. Update DocumentDB with results
    for result in analytics_results:
        docdb.analytics.update_one(
            {"_id": result["document_id"]},
            {"$set": {"analytics": result}},
            upsert=True
        )
```

### Hybrid Query Pattern

```javascript
// DocumentDB aggregation with S3 integration
db.documents.aggregate([
  // Local document processing
  { $match: { "category": "analytics" } },
  { $group: { _id: "$type", count: { $sum: 1 } } },

  // Integration point for S3 data
  { $lookup: {
      from: "s3_metadata",
      localField: "_id",
      foreignField: "document_type",
      as: "historical_data"
  }}
])
```

## Monitoring and Operations

### DocumentDB Monitoring

- **Performance Insights**: Query performance monitoring
- **CloudWatch Metrics**: Connection count, CPU utilization
- **Slow Query Logs**: Performance optimization insights
- **Replication Lag**: Multi-AZ replication monitoring

### Data Pipeline Monitoring

- **Glue Job Metrics**: Success rates and processing times
- **Kafka Lag**: Stream processing latency
- **S3 Object Counts**: Data lake growth monitoring
- **Document Sync Status**: Real-time sync health

### Alerting Configuration

```yaml
alerts:
  high_cpu_usage:
    metric: "CPUUtilization"
    threshold: 80
    evaluation_periods: 2

  replication_lag:
    metric: "DatabaseConnections"
    threshold: 100
    evaluation_periods: 1

  failed_glue_jobs:
    metric: "glue.job.failure"
    threshold: 1
    evaluation_periods: 1
```

## Security Implementation

### Document-Level Security

```javascript
// Role-based access control in DocumentDB
use admin
db.createRole({
    role: "analyticsReader",
    privileges: [
        {
            resource: { db: "analytics", collection: "" },
            actions: ["find", "listCollections"]
        }
    ],
    roles: []
})

// User creation with specific roles
db.createUser({
    user: "analytics_user",
    pwd: "secure_password",
    roles: ["analyticsReader"]
})
```

### Network Security

- **VPC Isolation**: DocumentDB in private subnets only
- **Security Groups**: Restrictive access rules
- **TLS Encryption**: All connections encrypted in transit
- **VPC Endpoints**: Private connectivity to AWS services

## Performance Optimization

### DocumentDB Optimization

```javascript
// Index strategies for analytics queries
db.documents.createIndex({ "timestamp": 1, "category": 1 })
db.documents.createIndex({ "user_id": 1, "action": 1 })
db.analytics.createIndex({ "computed_at": -1 })

// Compound indexes for complex queries
db.documents.createIndex({
    "category": 1,
    "timestamp": 1,
    "priority": 1
})
```

### Data Lake Optimization

- **Partitioning**: Partition by date and document type
- **Columnar Formats**: Use Parquet for analytics queries
- **Compression**: GZIP compression for document storage
- **Lifecycle Policies**: Automatic archiving to Glacier

## Cost Optimization

### DocumentDB Cost Management

- **Instance Rightsizing**: Monitor CPU and memory usage
- **Read Replicas**: Add replicas only when needed
- **Backup Retention**: Optimize backup retention period
- **Reserved Instances**: Use RIs for predictable workloads

### Data Lake Cost Management

- **Storage Classes**: Leverage Intelligent Tiering
- **Lifecycle Policies**: Automatic data archiving
- **Query Optimization**: Efficient Glue job scheduling
- **Spot Instances**: Use spot instances for batch processing

## Use Case Examples

### Content Management System

```python
# Document structure for CMS
document = {
    "_id": ObjectId(),
    "title": "Analytics Platform Guide",
    "content": "Full text content...",
    "metadata": {
        "author": "data-team",
        "created_at": datetime.utcnow(),
        "tags": ["analytics", "platform", "guide"],
        "category": "documentation"
    },
    "analytics": {
        "views": 0,
        "last_accessed": None,
        "popularity_score": 0.0
    }
}
```

### IoT Sensor Data

```python
# Flexible schema for IoT data
sensor_reading = {
    "_id": ObjectId(),
    "device_id": "sensor-001",
    "timestamp": datetime.utcnow(),
    "location": {
        "building": "HQ",
        "floor": 3,
        "room": "conference-a"
    },
    "readings": {
        "temperature": 22.5,
        "humidity": 45.2,
        "co2": 400,
        # Dynamic fields based on sensor type
        "light_level": 750,  # Only for certain sensors
        "motion": True       # Only for motion sensors
    },
    "metadata": {
        "sensor_type": "environmental",
        "firmware_version": "1.2.3",
        "battery_level": 85
    }
}
```

### Customer Analytics

```python
# Customer behavior documents
customer_event = {
    "_id": ObjectId(),
    "customer_id": "cust-12345",
    "session_id": "sess-abc123",
    "timestamp": datetime.utcnow(),
    "event_type": "page_view",
    "page_data": {
        "url": "/products/analytics-platform",
        "title": "Analytics Platform",
        "duration_seconds": 45
    },
    "user_agent": {
        "browser": "Chrome",
        "version": "91.0",
        "device_type": "desktop"
    },
    "analytics": {
        "session_number": 3,
        "customer_segment": "enterprise",
        "predicted_conversion": 0.75
    }
}
```

## Integration Patterns

### Real-Time Dashboard

```python
# Real-time analytics aggregation
pipeline = [
    {"$match": {"timestamp": {"$gte": datetime.utcnow() - timedelta(hours=1)}}},
    {"$group": {
        "_id": {
            "hour": {"$hour": "$timestamp"},
            "event_type": "$event_type"
        },
        "count": {"$sum": 1},
        "avg_duration": {"$avg": "$duration_seconds"}
    }},
    {"$sort": {"_id.hour": -1}}
]

results = db.events.aggregate(pipeline)
```

### Machine Learning Pipeline

```python
# Feature extraction for ML
def extract_document_features(document_id):
    # Get document from DocumentDB
    doc = db.documents.find_one({"_id": document_id})

    # Extract features
    features = {
        'text_length': len(doc['content']),
        'tag_count': len(doc['metadata']['tags']),
        'view_count': doc['analytics']['views'],
        'recency_days': (datetime.utcnow() - doc['metadata']['created_at']).days
    }

    # Store features in S3 for ML training
    s3_key = f"gold/ml-features/{document_id}.json"
    s3.put_object(Bucket='ml-bucket', Key=s3_key, Body=json.dumps(features))

    return features
```

## Estimated Monthly Cost

### DocumentDB Cluster

| Component | Configuration | Monthly Cost |
|-----------|---------------|---------------|
| Primary Instance | db.t3.medium | $58 |
| Read Replica | db.t3.medium | $58 |
| Storage | 100GB | $10 |
| Backup Storage | 100GB | $9 |
| **Subtotal** | | **$135** |

### Supporting Infrastructure

| Component | Configuration | Monthly Cost |
|-----------|---------------|---------------|
| VPC + NAT Gateway | Multi-AZ | $45 |
| S3 Storage | 500GB Standard | $12 |
| Glue Jobs | 50 DPU-hours | $25 |
| Kafka (MSK) | 2x m5.large | $280 |
| Bastion Host | t3.small | $15 |
| CloudWatch Logs | 5GB | $3 |
| **Subtotal** | | **$380** |

**Total Estimated Cost**: ~$515/month

## Advanced Configuration

### Multi-Region Setup

```hcl
# Primary region DocumentDB
module "primary_docdb" {
  source = "../../modules/aws-docdb"

  cluster_identifier = "${var.project_name}-primary"
  instance_class = var.docdb_instance_class

  # Enable global clusters for multi-region
  global_cluster_identifier = "${var.project_name}-global"
}

# Secondary region DocumentDB (read-only)
module "secondary_docdb" {
  source = "../../modules/aws-docdb"
  providers = {
    aws = aws.secondary
  }

  cluster_identifier = "${var.project_name}-secondary"
  global_cluster_identifier = module.primary_docdb.global_cluster_id
}
```

### Custom Analytics Functions

```javascript
// Custom aggregation functions in DocumentDB
db.system.js.save({
    _id: "calculateDocumentScore",
    value: function(doc) {
        var viewWeight = 0.3;
        var recencyWeight = 0.4;
        var tagWeight = 0.3;

        var daysSinceCreated = (new Date() - doc.metadata.created_at) / (1000 * 60 * 60 * 24);
        var recencyScore = Math.max(0, 1 - (daysSinceCreated / 365));

        return (doc.analytics.views * viewWeight) +
               (recencyScore * recencyWeight) +
               (doc.metadata.tags.length * tagWeight);
    }
});
```

## Troubleshooting

### Common Issues

1. **DocumentDB Connection Issues**:
   ```bash
   # Check security group rules
   aws ec2 describe-security-groups --group-ids sg-xxxxx

   # Test connectivity from bastion
   telnet docdb-cluster-endpoint 27017
   ```

2. **Slow Query Performance**:
   ```javascript
   // Enable profiler for slow queries
   db.setProfilingLevel(2, { slowms: 100 })

   // View slow operations
   db.system.profile.find().sort({ts: -1}).limit(5)
   ```

3. **Data Sync Issues**:
   ```python
   # Check Glue job logs
   aws logs describe-log-streams --log-group-name /aws-glue/jobs/output

   # Verify S3 object counts
   aws s3api list-objects-v2 --bucket data-lake-bucket --prefix bronze/documents/
   ```

## References

- [Amazon DocumentDB Documentation](https://docs.aws.amazon.com/documentdb/)
- [MongoDB Query Language](https://docs.mongodb.com/manual/tutorial/query-documents/)
- [AWS Glue Best Practices](https://docs.aws.amazon.com/glue/latest/dg/best-practices.html)
- [Data Lake Analytics Patterns](https://aws.amazon.com/big-data/datalakes-and-analytics/)
