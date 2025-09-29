#!/bin/bash
# Hub Bastion Host Setup Script
# Environment: ${environment}

# Update system packages
yum update -y

# Install essential tools
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
echo 'export PS1="[\u@\h-${environment} \W]\$ "' >> /etc/bashrc

# Create network information file
cat > /etc/network-info.json << 'EOF'
${vpc_cidrs}
EOF

# Create useful aliases
cat > /etc/profile.d/hub-aliases.sh << 'EOF'
#!/bin/bash
# Hub Bastion Aliases

alias ll='ls -la'
alias la='ls -la'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Network testing aliases
alias ping-google='ping -c 4 8.8.8.8'
alias ping-aws='ping -c 4 169.254.169.254'
alias check-dns='nslookup google.com'

# AWS aliases
alias aws-whoami='aws sts get-caller-identity'
alias aws-region='curl -s http://169.254.169.254/latest/meta-data/placement/region'
alias aws-az='curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone'

# Network information
alias show-network='cat /etc/network-info.json | jq .'
alias show-routes='ip route'
alias show-interfaces='ip addr show'
EOF

# Create network testing script
cat > /usr/local/bin/network-test << 'EOF'
#!/bin/bash
# Network Connectivity Test Script

echo "=== Hub Bastion Network Connectivity Test ==="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "IP: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
echo ""

echo "=== Internet Connectivity ==="
ping -c 3 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Internet connectivity: OK"
else
    echo "✗ Internet connectivity: FAILED"
fi

echo ""
echo "=== AWS API Connectivity ==="
aws sts get-caller-identity > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ AWS API connectivity: OK"
else
    echo "✗ AWS API connectivity: FAILED"
fi

echo ""
echo "=== VPC CIDR Blocks ==="
cat /etc/network-info.json | jq -r 'to_entries[] | "\(.key): \(.value)"'

echo ""
echo "=== Route Table ==="
ip route | head -20

echo ""
echo "=== Network Interfaces ==="
ip addr show | grep -E '^[0-9]+:|inet ' | head -20
EOF

chmod +x /usr/local/bin/network-test

# Create SSH connection helper script
cat > /usr/local/bin/connect-to-spoke << 'EOF'
#!/bin/bash
# Helper script to connect to spoke VPCs

if [ $# -ne 2 ]; then
    echo "Usage: $0 <environment> <private-ip>"
    echo "Example: $0 dev 10.10.101.10"
    echo "Available environments: dev, staging, prod"
    exit 1
fi

ENV=$1
IP=$2

echo "Connecting to $ENV environment at $IP..."
echo "Note: Ensure the target instance allows SSH from this bastion's security group"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ec2-user@$IP
EOF

chmod +x /usr/local/bin/connect-to-spoke

# Set up log rotation for custom logs
cat > /etc/logrotate.d/hub-bastion << 'EOF'
/var/log/hub-bastion.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
EOF

# Create startup message
cat > /etc/motd << 'EOF'

██╗  ██╗██╗   ██╗██████╗     ██████╗  █████╗ ███████╗████████╗██╗ ██████╗ ███████╗
██║  ██║██║   ██║██╔══██╗    ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗██╔════╝
███████║██║   ██║██████╔╝    ██████╔╝███████║███████╗   ██║   ██║██║   ██║███████╗
██╔══██║██║   ██║██╔══██╗    ██╔══██╗██╔══██║╚════██║   ██║   ██║██║   ██║╚════██║
██║  ██║╚██████╔╝██████╔╝    ██████╔╝██║  ██║███████║   ██║   ██║╚██████╔╝███████║
╚═╝  ╚═╝ ╚═════╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚══════╝

🌐 Hub Bastion Host - Environment: ${environment}

📋 Available Commands:
   • network-test         - Test network connectivity
   • connect-to-spoke     - Connect to spoke VPC instances
   • show-network         - Display VPC CIDR information
   • aws-whoami          - Show current AWS identity

⚡ Quick Network Test: network-test
💡 Connect to spoke: connect-to-spoke <env> <private-ip>

⚠️  Security Notice:
   • This bastion provides access to multiple environments
   • All activities are logged and monitored
   • Use appropriate security practices

EOF

# Log completion
echo "$(date): Hub bastion setup completed" >> /var/log/hub-bastion.log

# Run initial network test
/usr/local/bin/network-test >> /var/log/hub-bastion.log 2>&1

