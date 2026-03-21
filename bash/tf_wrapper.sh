#!/usr/bin/env bash

set -euo pipefail

# Functions
confirm_action() {
    local message="$1"
    read -p "$message (y/n) " confirm
    if [[ "$confirm" != "y" ]]; then
        echo "Aborting..."
        exit 1
    fi
}

echo "=== Terraform Wrapper ==="

# Help
if [[ "${1:-}" == "--help" ]]; then
    echo "Usage: tf_wrapper.sh [fmt|validate|plan|apply|destroy|--help]"
    echo ""
    echo "Commands:"
    echo "  fmt        Format Terraform files"
    echo "  validate   Check configuration syntax"
    echo "  plan       Preview infrastructure changes"
    echo "  apply      Apply infrastructure changes"
    echo "  destroy    Destroy all managed resources"
    exit 0
fi

# Prereq checks
if command -v terraform > /dev/null 2>&1; then
    echo "Terraform found: $(terraform --version | head -n 1)"
else
    echo "Terraform not found. Please install Terraform to use this wrapper."
    exit 1
fi

if ls *.tf > /dev/null 2>&1; then
    echo "Terraform configuration files found."
else
    echo "No Terraform configuration files (.tf) found in the current directory."
    exit 1
fi

# Logging
echo "$(date) - ran: ${1:-}" >> tf_wrapper.log

# Commands
case "${1:-}" in 
    fmt)
        echo "Running terraform fmt -diff..."
        # terraform fmt -diff
        ;;
    validate)
        echo "Running terraform validate..."
        # terraform validate
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
        echo "Usage: tf_wrapper.sh [fmt|validate|plan|apply|destroy]"
        ;;
esac
