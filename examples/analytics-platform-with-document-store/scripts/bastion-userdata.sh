#!/bin/bash
# Analytics Platform with DocumentDB Bastion Host Setup Script
# Environment: ${environment}

# Update system packages
yum update -y

# Install essential tools for analytics and document database management
yum install -y \
    wget \
    curl \
    telnet \
    netcat \
    bind-utils \
    traceroute \
    tcpdump \
    htop \
    tree \
    jq \
    git \
    vim \
    python3 \
    python3-pip

# Install AWS CLI v2
cd /tmp || exit 1
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf /tmp/aws /tmp/awscliv2.zip

# Install Session Manager plugin
yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

# Install MongoDB client for DocumentDB
cat > /etc/yum.repos.d/mongodb-org-4.4.repo << 'EOF'
[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOF

yum install -y mongodb-org-shell mongodb-org-tools

# Download RDS CA certificate for DocumentDB SSL connections
cd /opt || exit 1
wget https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem
chmod 644 rds-ca-2019-root.pem

# Install Kafka tools for stream processing
cd /opt || exit 1
wget https://archive.apache.org/dist/kafka/2.8.1/kafka_2.13-2.8.1.tgz
tar -xzf kafka_2.13-2.8.1.tgz
mv kafka_2.13-2.8.1 kafka
rm kafka_2.13-2.8.1.tgz
echo 'export PATH=$PATH:/opt/kafka/bin' >> /etc/bashrc

# Install Python packages for analytics and document processing
pip3 install --upgrade pip
pip3 install \
    boto3 \
    pandas \
    pyarrow \
    pymongo \
    kafka-python \
    awswrangler \
    great-expectations \
    jsonlines \
    elasticsearch \
    requests \
    numpy \
    matplotlib \
    seaborn

# Configure environment
echo 'export ENVIRONMENT="${environment}"' >> /etc/bashrc
echo 'export PROJECT_NAME="${project_name}"' >> /etc/bashrc
echo 'export DOCDB_ENDPOINT="${docdb_endpoint}"' >> /etc/bashrc
echo 'export KAFKA_BOOTSTRAP="${kafka_bootstrap}"' >> /etc/bashrc
echo 'export DATA_LAKE_BUCKET="${data_lake_bucket}"' >> /etc/bashrc
echo 'export DOCUMENTS_BUCKET="${documents_bucket}"' >> /etc/bashrc
echo 'export PS1="[\u@\h-analytics \\W]\\$ "' >> /etc/bashrc

# Create analytics platform environment information
cat > /etc/analytics-platform-info.json << EOF
{
  "environment": "${environment}",
  "project_name": "${project_name}",
  "docdb_endpoint": "${docdb_endpoint}",
  "kafka_bootstrap": "${kafka_bootstrap}",
  "data_lake_bucket": "${data_lake_bucket}",
  "documents_bucket": "${documents_bucket}",
  "region": "$(curl -s http://169.254.169.254/latest/meta-data/placement/region)"
}
EOF

# Create analytics platform aliases
cat > /etc/profile.d/analytics-platform-aliases.sh << 'EOF'
#!/bin/bash
# Analytics Platform Aliases

# Basic aliases
alias ll='ls -la'
alias la='ls -la'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Python aliases
alias python='python3'
alias pip='pip3'

# AWS aliases
alias aws-whoami='aws sts get-caller-identity'
alias aws-region='curl -s http://169.254.169.254/latest/meta-data/placement/region'

# DocumentDB aliases
alias docdb-connect='mongo --host $DOCDB_ENDPOINT --ssl --sslCAFile /opt/rds-ca-2019-root.pem'
alias docdb-test='mongo --host $DOCDB_ENDPOINT --ssl --sslCAFile /opt/rds-ca-2019-root.pem --eval "db.adminCommand({\"ismaster\":true})"'

# S3 aliases for analytics platform
alias s3-list-documents='aws s3 ls s3://$DOCUMENTS_BUCKET/ --recursive'
alias s3-list-data-lake='aws s3 ls s3://$DATA_LAKE_BUCKET/ --recursive'
alias s3-upload-document='aws s3 cp sample-document.json s3://$DOCUMENTS_BUCKET/'

# Glue aliases
alias glue-list-jobs='aws glue list-jobs'
alias glue-list-crawlers='aws glue list-crawlers'
alias glue-start-crawler='aws glue start-crawler --name'

# Kafka aliases (if enabled)
if [ ! -z "$KAFKA_BOOTSTRAP" ]; then
    alias kafka-topics='kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP'
    alias kafka-console-producer='kafka-console-producer.sh --bootstrap-server $KAFKA_BOOTSTRAP'
    alias kafka-console-consumer='kafka-console-consumer.sh --bootstrap-server $KAFKA_BOOTSTRAP'
fi

# Analytics helpers
alias show-platform='cat /etc/analytics-platform-info.json | jq .'
alias check-connectivity='ping -c 2 8.8.8.8 && aws sts get-caller-identity'
EOF

# Create analytics platform tools script
cat > /usr/local/bin/analytics-platform-tools << 'EOF'
#!/bin/bash
# Analytics Platform Tools Information Script

echo "=== Analytics Platform with Document Store - Tool Status ==="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "Environment: $ENVIRONMENT"
echo ""

echo "=== Platform Configuration ==="
cat /etc/analytics-platform-info.json | jq .

echo ""
echo "=== Installed Tools ==="
echo "AWS CLI: $(aws --version 2>&1 | head -1)"
echo "Python: $(python3 --version)"
echo "MongoDB Shell: $(mongo --version | head -1)"
echo "Kafka Tools: $(ls /opt/kafka/bin/ | wc -l) tools available"

echo ""
echo "=== Python Analytics Libraries ==="
python3 -c "
import sys
libraries = ['boto3', 'pandas', 'pyarrow', 'pymongo', 'kafka-python', 'awswrangler']
for lib in libraries:
    try:
        __import__(lib)
        print(f'✓ {lib}: Available')
    except ImportError:
        print(f'✗ {lib}: Not available')
"

echo ""
echo "=== Connectivity Tests ==="
ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Internet connectivity: OK"
else
    echo "✗ Internet connectivity: FAILED"
fi

aws sts get-caller-identity > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ AWS API connectivity: OK"
    echo "AWS Account: $(aws sts get-caller-identity --query Account --output text 2>/dev/null)"
    echo "AWS Region: $(aws configure get region 2>/dev/null || curl -s http://169.254.169.254/latest/meta-data/placement/region)"
else
    echo "✗ AWS API connectivity: FAILED"
fi

# Test DocumentDB connectivity
if [ ! -z "$DOCDB_ENDPOINT" ]; then
    echo ""
    echo "=== DocumentDB Connectivity ==="
    echo "DocumentDB Endpoint: $DOCDB_ENDPOINT"
    timeout 5 mongo --host $DOCDB_ENDPOINT --ssl --sslCAFile /opt/rds-ca-2019-root.pem --eval "db.adminCommand({'ismaster':true})" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✓ DocumentDB connectivity: OK"
    else
        echo "ℹ  DocumentDB connectivity: Test timeout (may require credentials)"
    fi
fi

# Test Kafka connectivity
if [ ! -z "$KAFKA_BOOTSTRAP" ]; then
    echo ""
    echo "=== Kafka Connectivity ==="
    echo "Bootstrap Servers: $KAFKA_BOOTSTRAP"
    echo "ℹ  Use 'kafka-topics --list' to test Kafka connectivity"
fi
EOF

chmod +x /usr/local/bin/analytics-platform-tools

# Create DocumentDB connection helper script
cat > /usr/local/bin/connect-docdb << 'EOF'
#!/bin/bash
# DocumentDB Connection Helper

if [ -z "$DOCDB_ENDPOINT" ]; then
    echo "Error: DOCDB_ENDPOINT environment variable not set"
    exit 1
fi

echo "Connecting to DocumentDB at: $DOCDB_ENDPOINT"
echo "Note: You may need to authenticate with username/password"
echo ""

# Connect with SSL
mongo --host "$DOCDB_ENDPOINT" --ssl --sslCAFile /opt/rds-ca-2019-root.pem
EOF

chmod +x /usr/local/bin/connect-docdb

# Create document processing helper script
cat > /usr/local/bin/process-documents << 'EOF'
#!/bin/bash
# Document Processing Helper Script

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory-with-json-files>"
    echo "Example: $0 /tmp/documents/"
    exit 1
fi

DOCS_DIR=$1

if [ ! -d "$DOCS_DIR" ]; then
    echo "Error: Directory $DOCS_DIR not found"
    exit 1
fi

echo "Processing documents from: $DOCS_DIR"
echo "Uploading to S3 bucket: $DOCUMENTS_BUCKET"

# Upload all JSON files to documents bucket
for file in "$DOCS_DIR"*.json; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo "Uploading: $filename"
        aws s3 cp "$file" "s3://$DOCUMENTS_BUCKET/raw/$filename"
    fi
done

echo "Upload complete. Monitor processing with:"
echo "aws glue get-job-runs --job-name document-processor"
EOF

chmod +x /usr/local/bin/process-documents

# Create analytics query helper script
cat > /usr/local/bin/run-analytics-query << 'EOF'
#!/bin/bash
# Analytics Query Helper Script

if [ $# -ne 1 ]; then
    echo "Usage: $0 <query-file.js>"
    echo "Example: $0 /tmp/analytics-query.js"
    exit 1
fi

QUERY_FILE=$1

if [ ! -f "$QUERY_FILE" ]; then
    echo "Error: Query file $QUERY_FILE not found"
    exit 1
fi

if [ -z "$DOCDB_ENDPOINT" ]; then
    echo "Error: DOCDB_ENDPOINT environment variable not set"
    exit 1
fi

echo "Running analytics query from: $QUERY_FILE"
echo "Against DocumentDB at: $DOCDB_ENDPOINT"
echo ""

# Execute the query file
mongo --host "$DOCDB_ENDPOINT" --ssl --sslCAFile /opt/rds-ca-2019-root.pem < "$QUERY_FILE"
EOF

chmod +x /usr/local/bin/run-analytics-query

# Create sample query templates
mkdir -p /opt/analytics-queries

cat > /opt/analytics-queries/sample-document-stats.js << 'EOF'
// Sample DocumentDB Analytics Query - Document Statistics

// Switch to analytics database
use analytics;

// Count total documents by type
print("=== Document Counts by Type ===");
db.documents.aggregate([
    { $group: { _id: "$type", count: { $sum: 1 } } },
    { $sort: { count: -1 } }
]).forEach(printjson);

// Average document size by category
print("\n=== Average Document Metrics ===");
db.documents.aggregate([
    {
        $group: {
            _id: "$category",
            avg_size: { $avg: { $strLenCP: "$content" } },
            count: { $sum: 1 }
        }
    },
    { $sort: { avg_size: -1 } }
]).forEach(printjson);

// Recent documents (last 24 hours)
print("\n=== Recent Documents (Last 24 Hours) ===");
var yesterday = new Date();
yesterday.setDate(yesterday.getDate() - 1);

db.documents.find({
    "created_at": { $gte: yesterday }
}).count();
EOF

cat > /opt/analytics-queries/sample-real-time-analytics.js << 'EOF'
// Sample Real-Time Analytics Query

// Switch to analytics database
use analytics;

// Real-time metrics aggregation
print("=== Real-Time Analytics Dashboard ===");

// Events in the last hour
var oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);

db.events.aggregate([
    { $match: { "timestamp": { $gte: oneHourAgo } } },
    {
        $group: {
            _id: {
                event_type: "$event_type",
                hour: { $hour: "$timestamp" }
            },
            count: { $sum: 1 },
            avg_duration: { $avg: "$duration_ms" }
        }
    },
    { $sort: { "_id.hour": -1, "count": -1 } }
]).forEach(printjson);

// Top active users
print("\n=== Top Active Users (Last Hour) ===");
db.events.aggregate([
    { $match: { "timestamp": { $gte: oneHourAgo } } },
    { $group: { _id: "$user_id", event_count: { $sum: 1 } } },
    { $sort: { event_count: -1 } },
    { $limit: 10 }
]).forEach(printjson);
EOF

# Create startup message
cat > /etc/motd << 'EOF'

 █████╗ ███╗   ██╗ █████╗ ██╗  ██╗   ██╗████████╗██╗ ██████╗███████╗
██╔══██╗████╗  ██║██╔══██╗██║  ╚██╗ ██╔╝╚══██╔══╝██║██╔════╝██╔════╝
███████║██╔██╗ ██║███████║██║   ╚████╔╝    ██║   ██║██║     ███████╗
██╔══██║██║╚██╗██║██╔══██║██║    ╚██╔╝     ██║   ██║██║     ╚════██║
██║  ██║██║ ╚████║██║  ██║███████╗██║      ██║   ██║╚██████╗███████║
╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝      ╚═╝   ╚═╝ ╚═════╝╚══════╝

🔍 Analytics Platform with Document Store Bastion Host

🛠️  Available Tools:
   • AWS CLI, Python 3, MongoDB client, Kafka tools
   • Analytics libraries: pandas, pymongo, awswrangler
   • Document processing and query utilities

📊 Platform Commands:
   • analytics-platform-tools - Show platform status and configuration
   • connect-docdb           - Connect to DocumentDB cluster
   • process-documents       - Upload and process document files
   • run-analytics-query     - Execute DocumentDB analytics queries

🚀 Quick Start:
   1. Check platform: analytics-platform-tools
   2. Connect to DocumentDB: connect-docdb
   3. Process documents: process-documents /path/to/docs/
   4. Run queries: run-analytics-query /opt/analytics-queries/sample-document-stats.js

💡 Platform Information:
   • DocumentDB: ${docdb_endpoint}
   • Data Lake: ${data_lake_bucket}
   • Documents: ${documents_bucket}
   • Environment: ${environment}

📁 Sample Queries: /opt/analytics-queries/

⚡ Quick Status: analytics-platform-tools

EOF

# Set up log rotation
cat > /etc/logrotate.d/analytics-platform-bastion << 'EOF'
/var/log/analytics-platform-bastion.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
EOF

# Log completion
echo "$(date): Analytics platform bastion setup completed" >> /var/log/analytics-platform-bastion.log

# Run initial platform check
/usr/local/bin/analytics-platform-tools >> /var/log/analytics-platform-bastion.log 2>&1
