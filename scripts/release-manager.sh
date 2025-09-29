#!/bin/bash

##
##     Terraform Modules Release Script v1.0
##     Copyright (c) 2025 NaNLABS
##
## This script helps manage releases for the terraform-aws-modules repository.
## It can create releases, update changelogs, and validate module changes.
##
## Usage:
##     @script.name [options] <command>
##
## Commands:
##     create-release      Create a new release
##     validate-modules    Validate changed modules
##     update-changelog    Update changelog with unreleased changes
##     list-modules        List all available modules
##
## Options:
##     -h, --help          Show this help message
##     -v, --version       Show script version
##     -t, --type=TYPE     Release type (major, minor, patch) [default: minor]
##     -m, --modules=LIST  Comma-separated list of modules to validate
##     -f, --force         Force operation without confirmation
##     -d, --dry-run       Show what would be done without executing
##

# Source easy-options for argument parsing
source "$(dirname "$0")/easy-options/easyoptions.sh" || {
    echo "Error: Could not source easyoptions.sh"
    exit 1
}

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MODULES_DIR="$REPO_ROOT/modules"
CHANGELOG_FILE="$REPO_ROOT/CHANGELOG.md"

# Default values
DEFAULT_RELEASE_TYPE="minor"
release_type="${type:-$DEFAULT_RELEASE_TYPE}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validation functions
check_dependencies() {
    local deps=("git" "terraform")
    local missing=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        log_info "Please install the missing dependencies and try again."
        exit 1
    fi
}

check_git_status() {
    if [[ ! -d "$REPO_ROOT/.git" ]]; then
        log_error "Not in a git repository"
        exit 1
    fi

    if [[ -n $(git status --porcelain) ]]; then
        log_warning "Working directory has uncommitted changes"
        if [[ "$force" != "yes" ]]; then
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    fi
}

# Module functions
list_modules() {
    log_info "Available modules:"
    for module_dir in "$MODULES_DIR"/*; do
        if [[ -d "$module_dir" && "$(basename "$module_dir")" != "__template__" ]]; then
            module_name=$(basename "$module_dir")
            echo "  - $module_name"
        fi
    done
}

get_changed_modules() {
    local base_ref="${1:-HEAD~1}"
    local head_ref="${2:-HEAD}"

    git diff --name-only "$base_ref" "$head_ref" | \
        grep "^modules/" | \
        grep -v "__template__" | \
        cut -d'/' -f2 | \
        sort -u
}

validate_module() {
    local module_name="$1"
    local module_path="$MODULES_DIR/$module_name"

    if [[ ! -d "$module_path" ]]; then
        log_error "Module '$module_name' not found"
        return 1
    fi

    log_info "Validating module: $module_name"

    # Change to module directory
    cd "$module_path" || return 1

    # Check Terraform format
    if ! terraform fmt -check -recursive; then
        log_error "Terraform format check failed for $module_name"
        return 1
    fi

    # Initialize and validate
    if ! terraform init -backend=false > /dev/null; then
        log_error "Terraform init failed for $module_name"
        return 1
    fi

    if ! terraform validate > /dev/null; then
        log_error "Terraform validate failed for $module_name"
        return 1
    fi

    log_success "Module $module_name validation passed"
    return 0
}

validate_modules() {
    local modules_to_validate=()

    if [[ -n "$modules" ]]; then
        # Use specified modules
        IFS=',' read -ra modules_to_validate <<< "$modules"
    else
        # Auto-detect changed modules
        mapfile -t modules_to_validate < <(get_changed_modules)

        if [[ ${#modules_to_validate[@]} -eq 0 ]]; then
            log_info "No changed modules detected. Validating all modules."
            mapfile -t modules_to_validate < <(
                find "$MODULES_DIR" -mindepth 1 -maxdepth 1 -type d \
                    -not -name "__template__" -exec basename {} \;
            )
        fi
    fi

    if [[ ${#modules_to_validate[@]} -eq 0 ]]; then
        log_warning "No modules to validate"
        return 0
    fi

    log_info "Validating ${#modules_to_validate[@]} modules"

    local failed_modules=()
    for module in "${modules_to_validate[@]}"; do
        if [[ "$dry_run" == "yes" ]]; then
            log_info "[DRY RUN] Would validate module: $module"
        else
            if ! validate_module "$module"; then
                failed_modules+=("$module")
            fi
        fi
    done

    if [[ ${#failed_modules[@]} -gt 0 ]]; then
        log_error "Validation failed for modules: ${failed_modules[*]}"
        return 1
    fi

    log_success "All module validations passed"
    return 0
}

# Release functions
get_latest_version() {
    git tag -l "v*" | sort -V | tail -n1
}

bump_version() {
    local current_version="$1"
    local bump_type="$2"

    if [[ -z "$current_version" ]]; then
        case "$bump_type" in
            major) echo "v1.0.0" ;;
            minor) echo "v0.1.0" ;;
            patch) echo "v0.0.1" ;;
        esac
        return
    fi

    # Remove 'v' prefix
    local version_num="${current_version#v}"

    # Split version into components
    IFS='.' read -ra VERSION_PARTS <<< "$version_num"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}

    # Bump version based on type
    case "$bump_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            log_error "Invalid release type: $bump_type"
            exit 1
            ;;
    esac

    echo "v${major}.${minor}.${patch}"
}

update_changelog() {
    local new_version="$1"
    local current_date
    current_date=$(date +%Y-%m-%d)

    log_info "Updating changelog for version $new_version"

    if [[ "$dry_run" == "yes" ]]; then
        log_info "[DRY RUN] Would update CHANGELOG.md with version $new_version"
        return 0
    fi

    # Create backup
    cp "$CHANGELOG_FILE" "$CHANGELOG_FILE.bak"

    # Update changelog
    awk -v version="$new_version" -v date="$current_date" '
    /^## \[Unreleased\]/ {
        print $0
        print ""
        getline
        print $0
        print ""
        print "## [" substr(version, 2) "] - " date
        found_unreleased = 1
        next
    }
    found_unreleased && /^## \[/ {
        print ""
        print $0
        found_unreleased = 0
        next
    }
    { print $0 }
    ' "$CHANGELOG_FILE.bak" > "$CHANGELOG_FILE"

    rm "$CHANGELOG_FILE.bak"
    log_success "Changelog updated"
}

create_release() {
    local current_version
    local new_version

    current_version=$(get_latest_version)
    new_version=$(bump_version "$current_version" "$release_type")

    log_info "Creating release: $current_version -> $new_version"

    if [[ "$dry_run" == "yes" ]]; then
        log_info "[DRY RUN] Would create release $new_version"
        log_info "[DRY RUN] Would update changelog"
        log_info "[DRY RUN] Would create git tag"
        return 0
    fi

    # Update changelog
    update_changelog "$new_version"

    # Commit changes
    git add "$CHANGELOG_FILE"
    git commit -m "chore: bump version to $new_version"

    # Create tag
    git tag "$new_version"

    log_success "Release $new_version created successfully"
    log_info "Push changes with: git push origin main && git push origin $new_version"
}

# Main command handler
main() {
    check_dependencies

    case "${arguments[0]:-}" in
        "create-release")
            check_git_status
            create_release
            ;;
        "validate-modules")
            validate_modules
            ;;
        "update-changelog")
            if [[ ${#arguments[@]} -lt 2 ]]; then
                log_error "Usage: update-changelog <version>"
                exit 1
            fi
            update_changelog "${arguments[1]}"
            ;;
        "list-modules")
            list_modules
            ;;
        "")
            log_error "No command specified. Use --help for usage information."
            exit 1
            ;;
        *)
            log_error "Unknown command: ${arguments[0]}"
            log_info "Use --help for usage information."
            exit 1
            ;;
    esac
}

# Handle version flag
if [[ "$version" == "yes" ]]; then
    echo "Terraform Modules Release Script v1.0"
    exit 0
fi

# Run main function
main "$@"
