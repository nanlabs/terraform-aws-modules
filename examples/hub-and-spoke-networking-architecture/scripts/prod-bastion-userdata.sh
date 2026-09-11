#!/bin/bash
# shellcheck disable=SC2016 # Single quotes are intentional: ${var} tokens are
# operator-substituted placeholders, not shell variables.
# Production Bastion Host Setup Script
# Environment: ${environment}
# SECURITY: This is a production bastion - minimal tools only

# Update system packages
yum update -y

# Install only essential tools for production
yum install -y \
    wget \
    curl \
    bind-utils \
    jq \
    vim

# Install AWS CLI v2 (required for management)
cd /tmp || exit 1
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf /tmp/aws /tmp/awscliv2.zip

# Install Session Manager plugin (secure access)
yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

# Configure environment with security notice
{
  echo 'export ENVIRONMENT="${environment}"'
  echo 'export PS1="[\u@\h-PROD \W]\$ "'
  echo 'echo "⚠️  PRODUCTION ENVIRONMENT - USE WITH EXTREME CAUTION"'
} >> /etc/bashrc

# Create minimal production aliases
cat > /etc/profile.d/prod-aliases.sh << 'EOF'
#!/bin/bash
# Production Bastion Aliases - Minimal set for security

# Basic aliases only
alias ll='ls -la'
alias la='ls -la'
alias l='ls -l'

# Essential AWS aliases
alias aws-whoami='aws sts get-caller-identity'
alias aws-region='curl -s http://169.254.169.254/latest/meta-data/placement/region'

# Network testing (minimal)
alias ping-test='ping -c 2 8.8.8.8'

# Production safety reminder
alias prod-warning='echo "⚠️  PRODUCTION ENVIRONMENT - ALL ACTIONS ARE LOGGED AND MONITORED"'
EOF

# Create production status script
cat > /usr/local/bin/prod-status << 'EOF'
#!/bin/bash
# Production Environment Status Script

echo "=== PRODUCTION Bastion - System Status ==="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "IP: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
echo ""

echo "⚠️  PRODUCTION ENVIRONMENT WARNING ⚠️"
echo "• All activities are logged and monitored"
echo "• Follow all change management procedures"
echo "• Use this access only for approved operations"
echo ""

echo "=== Environment Information ==="
echo "Environment: PRODUCTION"
echo "Security Level: HIGH"
echo "Compliance: Required"
echo "Change Management: Required"
echo ""

echo "=== System Health ==="
echo "Uptime: $(uptime -p)"
echo "Load: $(uptime | awk -F'load average:' '{ print $2 }')"
echo "Memory: $(free -h | awk '/^Mem:/ {print $3"/"$2" used"}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $5" used"}')"
echo ""

echo "=== Connectivity Status ==="
# Quick connectivity test
ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Internet connectivity: OK"
else
    echo "✗ Internet connectivity: FAILED"
fi

# AWS API test
aws sts get-caller-identity > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ AWS API connectivity: OK"
    echo "AWS Account: $(aws sts get-caller-identity --query Account --output text 2>/dev/null)"
    echo "AWS Region: $(aws configure get region 2>/dev/null || curl -s http://169.254.169.254/latest/meta-data/placement/region)"
else
    echo "✗ AWS API connectivity: FAILED"
fi
EOF

chmod +x /usr/local/bin/prod-status

# Create production security audit log
cat > /usr/local/bin/audit-log << 'EOF'
#!/bin/bash
# Production Audit Logging

LOG_FILE="/var/log/prod-bastion-audit.log"
USER=$(whoami)
COMMAND="$@"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S UTC')
IP=$(who am i | awk '{print $5}' | tr -d '()')

echo "[$TIMESTAMP] USER=$USER IP=$IP COMMAND=$COMMAND" >> $LOG_FILE
EOF

chmod +x /usr/local/bin/audit-log

# Create highly restrictive startup message
cat > /etc/motd << 'EOF'

██████╗ ██████╗  ██████╗ ██████╗ ██╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗
██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██║   ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║
██████╔╝██████╔╝██║   ██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██╔██╗ ██║
██╔═══╝ ██╔══██╗██║   ██║██║  ██║██║   ██║██║        ██║   ██║██║   ██║██║╚██╗██║
██║     ██║  ██║╚██████╔╝██████╔╝╚██████╔╝╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║
╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝  ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝

🏭 PRODUCTION ENVIRONMENT BASTION HOST

🚨 SECURITY NOTICE 🚨
   ⚠️  THIS IS A PRODUCTION ENVIRONMENT
   ⚠️  ALL ACTIVITIES ARE LOGGED AND MONITORED
   ⚠️  UNAUTHORIZED ACCESS IS PROHIBITED
   ⚠️  FOLLOW ALL CHANGE MANAGEMENT PROCEDURES

📋 Available Commands:
   • prod-status         - Show system and connectivity status
   • aws-whoami          - Show current AWS identity
   • audit-log <command> - Log administrative actions

🔒 Security Requirements:
   • Use this access only for approved operations
   • Follow principle of least privilege
   • Document all changes in change management system
   • Report any suspicious activity immediately

📞 Support:
   • Emergency: Contact NOC immediately
   • Change Requests: Use approved change management process
   • Questions: Consult runbooks and documentation first

⚡ Quick Status: prod-status

By proceeding, you acknowledge that you are authorized to access this system
and agree to comply with all applicable security policies and procedures.

EOF

# Set up comprehensive logging for production
cat > /etc/logrotate.d/prod-bastion << 'EOF'
/var/log/prod-bastion*.log {
    daily
    rotate 90
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
EOF

# Enable detailed bash history with timestamps
{
  echo 'export HISTTIMEFORMAT="%F %T "'
  echo 'export HISTSIZE=10000'
  echo 'export HISTFILESIZE=10000'
  echo 'shopt -s histappend'
} >> /etc/bashrc

# Configure rsyslog for centralized logging (if needed)
cat >> /etc/rsyslog.conf << 'EOF'
# Production bastion logging
local0.* /var/log/prod-bastion-activity.log
EOF

# Restart rsyslog
systemctl restart rsyslog

# Create initial audit entry
echo "$(date '+%Y-%m-%d %H:%M:%S UTC') SYSTEM=prod-bastion EVENT=startup STATUS=completed" >> /var/log/prod-bastion-audit.log

# Log completion with security notice
# shellcheck disable=SC2129 # Keep separate from the status-check append below:
# distinct commands sharing a log file read clearer as individual redirects.
echo "$(date): PRODUCTION bastion setup completed - ALL ACTIVITIES MONITORED" >> /var/log/prod-bastion.log

# Run initial status check
/usr/local/bin/prod-status >> /var/log/prod-bastion.log 2>&1

# Display immediate security warning
echo "🚨 PRODUCTION ENVIRONMENT INITIALIZED 🚨" >> /var/log/prod-bastion.log
echo "Security monitoring active. Compliance logging enabled." >> /var/log/prod-bastion.log

