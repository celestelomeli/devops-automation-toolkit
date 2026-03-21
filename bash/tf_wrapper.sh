#!/usr/bin/env bash

set -euo pipefail

echo "=== Terraform Wrapper ==="

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


if command -v terraform > /dev/null 2>&1; then
    echo "Terraform found: $(terraform --version | head -n 1)"
else
    echo "Terraform not found. Please install Terraform to use this wrapper."
    exit 1
fi

case "${1:-}" in 
    fmt)
        echo "Running terraform fmt..."
        ;;
    validate)
        echo "Running terraform validate..."
        ;;
    plan)
        echo "Running terraform plan..."
        ;;
    apply)
        read -p "Are you sure you want to apply? (y/n) " confirm
        if [[ "$confirm" != "y" ]]; then
            echo "Aborting..."
            exit 1
        #else
           # echo "Running terraform apply..."
           # exit 0
        fi
        echo "Running terraform apply..."
        ;;
    destroy)
        read -p "Are you sure you want to destroy? This will delete all resources! (y/n) " confirm
        if [[ "$confirm" != "y" ]]; then
            echo "Aborting..."
            exit 1
        fi
        echo "Running terraform destroy..."
        ;;
    *)
        echo "Usage: tf_wrapper.sh [fmt|validate|plan|apply|destroy]"
        ;;
esac
