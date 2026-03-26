#!/usr/bin/env bash

set -euo pipefail

# Function to confirm destroy and apply actions
confirm_action() {
    local message="$1"
    read -rp "$message (y/n) " confirm
    if [[ "$confirm" != "y" ]]; then
        echo "Aborting..."
        exit 1
    fi
}

echo "=== Terraform Wrapper ==="

# Help flag to show usage instructions
if [[ "${1:-}" == "--help" ]]; then
    echo "Usage: tf_wrapper.sh [fmt|validate|plan|apply|destroy|--help] [directory]"
    echo ""
    echo "Commands:"
    echo "  fmt        Format Terraform files"
    echo "  validate   Check configuration syntax"
    echo "  plan       Preview infrastructure changes"
    echo "  apply      Apply infrastructure changes"
    echo "  destroy    Destroy all managed resources"
    echo ""
    echo "Options:"
    echo "  [directory]  Optional path to directory containing .tf files"
    exit 0
fi

# Prereq checks
# Check if terraform is installed
if command -v terraform > /dev/null 2>&1; then
    echo "Terraform found: $(terraform --version | head -n 1)"
else
    echo "Terraform not found. Please install Terraform to use this wrapper."
    exit 1
fi

# Check for second argument and change to that directory if provided
if [[ -n "${2:-}" ]]; then
    if [[ -d "$2" ]]; then
        echo "Changing to directory: $2"
        cd "$2"
    else
        echo "Directory $2 does not exist."
        exit 1
    fi
fi

# Check for terraform files in the current directory
if ls ./*.tf > /dev/null 2>&1; then
    echo "Terraform configuration files found."
else
    echo "No Terraform configuration files (.tf) found in the current directory."
    exit 1
fi

# Log the command to log file with timestamp in the root of the repo
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
echo "$(date) - ran: ${1:-}" >> "$REPO_ROOT/tf_wrapper.log"

# Run terraform command based on first argument
case "${1:-}" in 
    fmt)
        echo "Running terraform fmt -diff..."
        terraform fmt -diff
        ;;
    validate)
        echo "Running terraform validate..."
        terraform validate
        ;;
    plan)
        # -out saves plan to a file so apply can use exact same plan
        echo "Running terraform plan -out=terraform.tfplan..."
        # terraform plan -out=terraform.tfplan
        ;;
    apply)
        confirm_action "Are you sure you want to apply?"

        echo "Running terraform apply..."
        # terraform apply terraform.tfplan
        ;;
    destroy)
        if [[ "${TF_ENV:-}" == "production" ]]; then
            echo "ERROR: Cannot run destroy in production environment."
            exit 1
        fi

        confirm_action "Are you sure you want to destroy? This will delete all resources!"

        echo "Running terraform destroy..."
        # terraform destroy
        ;;
    *)
        echo "Usage: tf_wrapper.sh [fmt|validate|plan|apply|destroy|--help] [directory]"
        ;;
esac
