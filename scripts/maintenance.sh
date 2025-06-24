#!/bin/bash

# Terraform Modules Maintenance Script
# This script helps maintain the repository with common tasks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Help function
show_help() {
    cat << EOF
🚀 Terraform Modules Maintenance Script

Usage: $0 [COMMAND]

Commands:
    format          Format all Terraform files
    validate        Validate all Terraform configurations
    docs            Generate documentation for all modules
    lint            Run linting checks
    examples        Validate all example configurations
    check-versions  Check for outdated module versions
    full-check      Run all checks (format, validate, lint, docs)
    help            Show this help message

Examples:
    $0 format           # Format all .tf files
    $0 validate         # Validate all Terraform configurations
    $0 full-check       # Run complete maintenance check
EOF
}

# Format all Terraform files
format_terraform() {
    print_status "Formatting Terraform files..."

    if ! command -v terraform &> /dev/null; then
        print_error "Terraform CLI not found. Please install Terraform."
        return 1
    fi

    find . -name "*.tf" -exec dirname {} \; | sort -u | while read dir; do
        print_status "Formatting files in $dir"
        (cd "$dir" && terraform fmt)
    done

    print_success "Terraform formatting completed"
}

# Validate all Terraform configurations
validate_terraform() {
    print_status "Validating Terraform configurations..."

    if ! command -v terraform &> /dev/null; then
        print_error "Terraform CLI not found. Please install Terraform."
        return 1
    fi

    find . -name "*.tf" -exec dirname {} \; | sort -u | while read dir; do
        print_status "Validating configuration in $dir"
        (cd "$dir" && terraform init -backend=false &>/dev/null && terraform validate)
    done

    print_success "Terraform validation completed"
}

# Generate documentation
generate_docs() {
    print_status "Generating module documentation..."

    if ! command -v terraform-docs &> /dev/null; then
        print_warning "terraform-docs not found. Install with: brew install terraform-docs"
        return 1
    fi

    find modules -maxdepth 1 -type d ! -path modules | while read module; do
        if [ -f "$module/main.tf" ]; then
            print_status "Generating docs for $module"
            terraform-docs markdown table --output-file README.md "$module"
        fi
    done

    print_success "Documentation generation completed"
}

# Run linting checks
run_lint() {
    print_status "Running linting checks..."

    # Check for tflint
    if command -v tflint &> /dev/null; then
        find . -name "*.tf" -exec dirname {} \; | sort -u | while read dir; do
            print_status "Linting $dir"
            (cd "$dir" && tflint)
        done
    else
        print_warning "tflint not found. Install with: brew install tflint"
    fi

    # Check for tfsec
    if command -v tfsec &> /dev/null; then
        print_status "Running security checks..."
        tfsec .
    else
        print_warning "tfsec not found. Install with: brew install tfsec"
    fi

    print_success "Linting checks completed"
}

# Validate examples
validate_examples() {
    print_status "Validating example configurations..."

    if ! command -v terraform &> /dev/null; then
        print_error "Terraform CLI not found. Please install Terraform."
        return 1
    fi

    find examples -maxdepth 1 -type d ! -path examples | while read example; do
        if [ -f "$example/main.tf" ]; then
            print_status "Validating example: $example"
            (cd "$example" && terraform init -backend=false &>/dev/null && terraform validate)
        fi
    done

    print_success "Example validation completed"
}

# Check for outdated versions
check_versions() {
    print_status "Checking for potentially outdated module versions..."

    print_warning "Manual check required - review these version constraints:"
    echo ""
    echo "AWS Provider versions found:"
    grep -r "required_version\|version.*=" modules/*/versions.tf | head -20
    echo ""
    echo "Module source versions found:"
    grep -r "source.*=" modules/*/main.tf | head -20

    print_warning "Please verify these versions against latest releases"
}

# Run full maintenance check
full_check() {
    print_status "Running full maintenance check..."

    format_terraform
    validate_terraform
    run_lint
    validate_examples
    generate_docs
    check_versions

    print_success "Full maintenance check completed!"
}

# Main script logic
case "${1:-help}" in
    format)
        format_terraform
        ;;
    validate)
        validate_terraform
        ;;
    docs)
        generate_docs
        ;;
    lint)
        run_lint
        ;;
    examples)
        validate_examples
        ;;
    check-versions)
        check_versions
        ;;
    full-check)
        full_check
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
