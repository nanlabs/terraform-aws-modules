#!/bin/bash
# shellcheck disable=SC2016 # Single quotes are intentional: ${var} tokens are
# operator-substituted placeholders, not shell variables.
# Staging Bastion Host Setup Script
# Environment: ${environment}

# Update system packages
yum update -y

# Install essential tools (more conservative than dev)
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
    vim

# Install AWS CLI v2
cd /tmp || exit 1
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Install Session Manager plugin
yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

# Configure environment
echo 'export ENVIRONMENT="${environment}"' >> /etc/bashrc
echo 'export PS1="[\u@\h-staging \W]\$ "' >> /etc/bashrc

# Create staging-specific aliases
cat > /etc/profile.d/staging-aliases.sh << 'EOF'
#!/bin/bash
# Staging Bastion Aliases

# Basic aliases
alias ll='ls -la'
alias la='ls -la'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Staging-specific aliases
alias aws-whoami='aws sts get-caller-identity'
alias aws-region='curl -s http://169.254.169.254/latest/meta-data/placement/region'

# Network testing
alias ping-google='ping -c 4 8.8.8.8'
alias check-connectivity='ping -c 2 8.8.8.8 && aws sts get-caller-identity'

# Staging environment helpers
alias staging-status='echo "Staging Environment - Use with caution"'
EOF

# Create staging environment status script
cat > /usr/local/bin/staging-status << 'EOF'
#!/bin/bash
# Staging Environment Status Script

echo "=== Staging Bastion - Environment Status ==="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "IP: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
echo ""

echo "=== Environment Information ==="
echo "Environment: Staging"
echo "Purpose: Pre-production validation and testing"
echo "Security Level: Medium"
echo ""

echo "=== Connectivity Tests ==="
ping -c 3 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Internet connectivity: OK"
else
    echo "✗ Internet connectivity: FAILED"
fi

aws sts get-caller-identity > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ AWS API connectivity: OK"
else
    echo "✗ AWS API connectivity: FAILED"
fi

echo ""
echo "=== AWS Identity ==="
aws sts get-caller-identity 2>/dev/null || echo "AWS credentials not configured"

echo ""
echo "=== System Resources ==="
echo "CPU: $(nproc) cores"
echo "Memory: $(free -h | awk '/^Mem:/ {print $2}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $4" available"}')"
echo "Uptime: $(uptime -p)"
EOF

chmod +x /usr/local/bin/staging-status

# Create startup message for staging
cat > /etc/motd << 'EOF'

███████╗████████╗ █████╗  ██████╗ ██╗███╗   ██╗ ██████╗     ██████╗  █████╗ ███████╗████████╗██╗ ██████╗ ███████╗
██╔════╝╚══██╔══╝██╔══██╗██╔════╝ ██║████╗  ██║██╔════╝     ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗██╔════╝
███████╗   ██║   ███████║██║  ███╗██║██╔██╗ ██║██║  ███╗    ██████╔╝███████║███████╗   ██║   ██║██║   ██║███████╗
╚════██║   ██║   ██╔══██║██║   ██║██║██║╚██╗██║██║   ██║    ██╔══██╗██╔══██║╚════██║   ██║   ██║██║   ██║╚════██║
███████║   ██║   ██║  ██║╚██████╔╝██║██║ ╚████║╚██████╔╝    ██████╔╝██║  ██║███████║   ██║   ██║╚██████╔╝███████║
╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚══════╝

🧪 Staging Environment Bastion Host

📋 Available Commands:
   • staging-status       - Show environment and connectivity status
   • aws-whoami          - Show current AWS identity
   • check-connectivity  - Quick connectivity test

⚡ Quick Status Check: staging-status

⚠️  Staging Environment Notice:
   • This environment mirrors production configuration
   • Use for pre-production validation and testing
   • Changes here may affect staging workloads
   • Follow change management procedures

🔐 Security Reminders:
   • All activities are logged and monitored
   • Use staging data only - no production data
   • Test thoroughly before promoting to production

EOF

# Set up enhanced logging for staging
cat > /etc/logrotate.d/staging-bastion << 'EOF'
/var/log/staging-bastion.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
EOF

# Log completion
echo "$(date): Staging bastion setup completed" >> /var/log/staging-bastion.log

# Run initial status check
/usr/local/bin/staging-status >> /var/log/staging-bastion.log 2>&1

