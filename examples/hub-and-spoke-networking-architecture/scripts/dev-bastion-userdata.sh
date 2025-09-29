#!/bin/bash
# Development Bastion Host Setup Script
# Environment: ${environment}

# Update system packages
yum update -y

# Install development tools and utilities
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
    nano \
    python3 \
    python3-pip \
    nodejs \
    npm

# Install AWS CLI v2
cd /tmp || exit 1
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Install Session Manager plugin
yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

# Install Docker (for development)
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -a -G docker ec2-user

# Install kubectl (for EKS development)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Terraform (for infrastructure development)
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

# Configure environment
echo 'export ENVIRONMENT="${environment}"' >> /etc/bashrc
echo 'export PS1="[\u@\h-dev \W]\$ "' >> /etc/bashrc

# Create development-specific aliases
cat > /etc/profile.d/dev-aliases.sh << 'EOF'
#!/bin/bash
# Development Bastion Aliases

# Basic aliases
alias ll='ls -la'
alias la='ls -la'
alias l='ls -l'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Development aliases
alias python='python3'
alias pip='pip3'
alias tf='terraform'
alias k='kubectl'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# AWS aliases
alias aws-whoami='aws sts get-caller-identity'
alias aws-region='curl -s http://169.254.169.254/latest/meta-data/placement/region'

# Network testing
alias ping-google='ping -c 4 8.8.8.8'
EOF

# Create development tools script
cat > /usr/local/bin/dev-tools-info << 'EOF'
#!/bin/bash
# Development Tools Information Script

echo "=== Development Bastion - Tool Versions ==="
echo "Date: $(date)"
echo "Host: $(hostname)"
echo ""

echo "=== Installed Tools ==="
echo "AWS CLI: $(aws --version 2>&1 | head -1)"
echo "Python: $(python3 --version)"
echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
echo "npm: $(npm --version 2>/dev/null || echo 'Not installed')"
echo "Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
echo "kubectl: $(kubectl version --client --short 2>/dev/null || echo 'Not installed')"
echo "Terraform: $(terraform version | head -1 2>/dev/null || echo 'Not installed')"
echo "Git: $(git --version)"

echo ""
echo "=== Development Environment Status ==="
echo "Environment: Development"
echo "Purpose: Application development and testing"
echo "Docker Status: $(systemctl is-active docker)"

echo ""
echo "=== Quick Start Commands ==="
echo "• aws configure          - Setup AWS credentials"
echo "• docker run hello-world - Test Docker"
echo "• kubectl cluster-info   - Check Kubernetes connectivity"
echo "• terraform version      - Verify Terraform installation"
EOF

chmod +x /usr/local/bin/dev-tools-info

# Create startup message for development
cat > /etc/motd << 'EOF'

██████╗ ███████╗██╗   ██╗    ██████╗  █████╗ ███████╗████████╗██╗ ██████╗ ███████╗
██╔══██╗██╔════╝██║   ██║    ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║██╔═══██╗██╔════╝
██║  ██║█████╗  ██║   ██║    ██████╔╝███████║███████╗   ██║   ██║██║   ██║███████╗
██║  ██║██╔══╝  ╚██╗ ██╔╝    ██╔══██╗██╔══██║╚════██║   ██║   ██║██║   ██║╚════██║
██████╔╝███████╗ ╚████╔╝     ██████╔╝██║  ██║███████║   ██║   ██║╚██████╔╝███████║
╚═════╝ ╚══════╝  ╚═══╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝ ╚═════╝ ╚══════╝

🚀 Development Environment Bastion Host

🛠️  Installed Development Tools:
   • AWS CLI, Python 3, Node.js, npm
   • Docker, kubectl, Terraform, Git
   • Standard networking and debugging tools

📋 Available Commands:
   • dev-tools-info      - Show tool versions and status
   • aws configure       - Setup AWS credentials
   • docker run hello-world - Test Docker

💡 Quick Start:
   1. Configure AWS: aws configure
   2. Test Docker: docker run hello-world
   3. Check tools: dev-tools-info

⚠️  Development Environment:
   • This environment is for development and testing only
   • Resources may be automatically cleaned up
   • Do not store production data here

EOF

# Log completion
echo "$(date): Development bastion setup completed" >> /var/log/dev-bastion.log

# Run initial tools check
/usr/local/bin/dev-tools-info >> /var/log/dev-bastion.log 2>&1

