#!/bin/bash
# Data Processing Pipeline Bastion Host Setup Script
# Environment: ${environment}

# Update system packages
yum update -y

# Install essential tools for data processing
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

# Install Kafka tools
cd /opt || exit 1
wget https://archive.apache.org/dist/kafka/2.8.1/kafka_2.13-2.8.1.tgz
tar -xzf kafka_2.13-2.8.1.tgz
mv kafka_2.13-2.8.1 kafka
rm kafka_2.13-2.8.1.tgz
echo 'export PATH=$PATH:/opt/kafka/bin' >> /etc/bashrc

# Install Python data processing libraries
pip3 install --upgrade pip
pip3 install \
    boto3 \
    pandas \
    pyarrow \
    kafka-python \
    awswrangler \
    great-expectations \
    jsonlines

# Configure environment
echo 'export ENVIRONMENT="${environment}"' >> /etc/bashrc
echo 'export PROJECT_NAME="${project_name}"' >> /etc/bashrc
echo 'export KAFKA_BOOTSTRAP="${kafka_bootstrap}"' >> /etc/bashrc
echo 'export GLUE_DATABASE="${glue_database}"' >> /etc/bashrc
echo 'export S3_BUCKET="${s3_bucket}"' >> /etc/bashrc
echo 'export PS1="[\u@\h-data-pipeline \W]\$ "' >> /etc/bashrc

# Create data processing environment information
cat > /etc/data-pipeline-info.json << EOF
{
  "environment": "${environment}",
  "project_name": "${project_name}",
  "kafka_bootstrap": "${kafka_bootstrap}",
  "glue_database": "${glue_database}",
  "s3_bucket": "${s3_bucket}",
  "region": "$(curl -s http://169.254.169.254/latest/meta-data/placement/region)"
}
EOF

# Create data processing aliases
cat > /etc/profile.d/data-pipeline-aliases.sh << 'EOF'
#!/bin/bash
# Data Processing Pipeline Aliases

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

# S3 aliases for data pipeline
alias s3-list-raw='aws s3 ls s3://$S3_BUCKET/raw/ --recursive'
alias s3-list-processed='aws s3 ls s3://$S3_BUCKET/processed/ --recursive'
alias s3-upload-sample='aws s3 cp sample-data.json s3://$S3_BUCKET/raw/'

# Glue aliases
alias glue-list-jobs='aws glue list-jobs'
alias glue-list-crawlers='aws glue list-crawlers'
alias glue-start-crawler='aws glue start-crawler --name'
alias glue-get-database='aws glue get-database --name $GLUE_DATABASE'

# Kafka aliases (if enabled)
alias kafka-topics='kafka-topics.sh --bootstrap-server $KAFKA_BOOTSTRAP'
alias kafka-console-producer='kafka-console-producer.sh --bootstrap-server $KAFKA_BOOTSTRAP'
alias kafka-console-consumer='kafka-console-consumer.sh --bootstrap-server $KAFKA_BOOTSTRAP'

# Data processing helpers
alias show-pipeline='cat /etc/data-pipeline-info.json | jq .'
alias check-connectivity='ping -c 2 8.8.8.8 && aws sts get-caller-identity'
EOF

# Create data pipeline tools script
cat > /usr/local/bin/data-pipeline-tools << 'EOF'
#!/bin/bash
# Data Pipeline Tools Information Script

echo "=== Data Processing Pipeline - Tool Status ==="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "Environment: $ENVIRONMENT"
echo ""

echo "=== Pipeline Configuration ==="
cat /etc/data-pipeline-info.json | jq .

echo ""
echo "=== Installed Tools ==="
echo "AWS CLI: $(aws --version 2>&1 | head -1)"
echo "Python: $(python3 --version)"
echo "Kafka Tools: $(ls /opt/kafka/bin/ | wc -l) tools available"

echo ""
echo "=== Python Data Libraries ==="
python3 -c "
import sys
libraries = ['boto3', 'pandas', 'pyarrow', 'kafka-python', 'awswrangler']
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

if [ ! -z "$KAFKA_BOOTSTRAP" ]; then
    echo ""
    echo "=== Kafka Connectivity ==="
    echo "Bootstrap Servers: $KAFKA_BOOTSTRAP"
    # Note: Kafka connectivity test would require network access to MSK cluster
    echo "ℹ  Use 'kafka-topics --list' to test Kafka connectivity"
fi
EOF

chmod +x /usr/local/bin/data-pipeline-tools

# Create data processing helper scripts
cat > /usr/local/bin/upload-sample-data << 'EOF'
#!/bin/bash
# Upload sample data to S3 raw bucket

if [ $# -ne 1 ]; then
    echo "Usage: $0 <file-path>"
    echo "Example: $0 /tmp/sample-data.json"
    exit 1
fi

FILE_PATH=$1

if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File $FILE_PATH not found"
    exit 1
fi

echo "Uploading $FILE_PATH to s3://$S3_BUCKET/raw/"
aws s3 cp "$FILE_PATH" "s3://$S3_BUCKET/raw/"

if [ $? -eq 0 ]; then
    echo "✓ Upload successful"
    echo "Monitor processing with: aws glue get-job-runs --job-name raw-data-processor"
else
    echo "✗ Upload failed"
fi
EOF

chmod +x /usr/local/bin/upload-sample-data

cat > /usr/local/bin/monitor-glue-job << 'EOF'
#!/bin/bash
# Monitor Glue job execution

if [ $# -ne 1 ]; then
    echo "Usage: $0 <job-name>"
    echo "Available jobs:"
    aws glue list-jobs --query 'JobNames' --output table
    exit 1
fi

JOB_NAME=$1

echo "Monitoring Glue job: $JOB_NAME"
echo "Getting recent job runs..."

aws glue get-job-runs --job-name "$JOB_NAME" \
    --query 'JobRuns[0:5].{JobName:JobName,JobRunState:JobRunState,StartedOn:StartedOn,CompletedOn:CompletedOn,ExecutionTime:ExecutionTime}' \
    --output table

echo ""
echo "To view logs:"
echo "aws logs describe-log-streams --log-group-name /aws-glue/jobs/output"
EOF

chmod +x /usr/local/bin/monitor-glue-job

# Create startup message
cat > /etc/motd << 'EOF'

████████╗ █████╗ ████████╗ █████╗     ██████╗ ██╗██████╗ ███████╗██╗     ██╗███╗   ██╗███████╗
██╔══██║██╔══██╗╚══██╔══╝██╔══██╗    ██╔══██╗██║██╔══██╗██╔════╝██║     ██║████╗  ██║██╔════╝
██║  ██║███████║   ██║   ███████║    ██████╔╝██║██████╔╝█████╗  ██║     ██║██╔██╗ ██║█████╗
██║  ██║██╔══██║   ██║   ██╔══██║    ██╔═══╝ ██║██╔═══╝ ██╔══╝  ██║     ██║██║╚██╗██║██╔══╝
██████╔╝██║  ██║   ██║   ██║  ██║    ██║     ██║██║     ███████╗███████╗██║██║ ╚████║███████╗
╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝

🔄 Data Processing Pipeline Bastion Host

🛠️  Available Tools:
   • AWS CLI, Python 3, Kafka tools
   • Data libraries: boto3, pandas, pyarrow, awswrangler
   • Glue and S3 management utilities

📊 Pipeline Commands:
   • data-pipeline-tools  - Show tool status and configuration
   • upload-sample-data    - Upload sample data to S3 raw bucket
   • monitor-glue-job      - Monitor Glue job execution
   • show-pipeline         - Display pipeline configuration

🚀 Quick Start:
   1. Check tools: data-pipeline-tools
   2. Upload data: upload-sample-data /path/to/file.json
   3. Monitor jobs: monitor-glue-job <job-name>

💡 Pipeline Information:
   • S3 Bucket: ${s3_bucket}
   • Glue Database: ${glue_database}
   • Environment: ${environment}

⚡ Quick Status: data-pipeline-tools

EOF

# Set up log rotation
cat > /etc/logrotate.d/data-pipeline-bastion << 'EOF'
/var/log/data-pipeline-bastion.log {
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
echo "$(date): Data pipeline bastion setup completed" >> /var/log/data-pipeline-bastion.log

# Run initial tools check
/usr/local/bin/data-pipeline-tools >> /var/log/data-pipeline-bastion.log 2>&1
