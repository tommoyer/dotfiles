#!/bin/bash
#
# Quick start script for deploying dotfiles with Ansible
#

set -e

echo "=========================================="
echo "Dotfiles Deployment with Ansible"
echo "=========================================="
echo ""

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible is not installed!"
    echo ""
    echo "Please install Ansible first:"
    echo "  - macOS:        brew install ansible"
    echo "  - Ubuntu/Debian: sudo apt install ansible"
    echo "  - Fedora/RHEL:  sudo dnf install ansible"
    echo ""
    exit 1
fi

echo "✓ Ansible is installed ($(ansible --version | head -n1))"
echo ""

# Check if secrets file exists
if [ ! -f "vars/secrets.yml.local" ]; then
    echo "⚠️  No local secrets file found!"
    echo ""
    echo "Creating vars/secrets.yml.local from example..."
    cp vars/secrets.yml.example vars/secrets.yml.local
    echo ""
    echo "✓ Created vars/secrets.yml.local"
    echo ""
    echo "⚠️  IMPORTANT: Edit vars/secrets.yml.local and add your actual secrets!"
    echo ""
    read -p "Press Enter after you've edited the secrets file, or Ctrl+C to exit..."
    echo ""
fi

# Ask if user wants to encrypt secrets
read -p "Do you want to encrypt the secrets file with Ansible Vault? (y/N) " -n 1 -r
echo ""

VAULT_ARGS=""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ ! -f ".vault_pass" ]; then
        echo ""
        echo "Creating vault password file..."
        read -s -p "Enter vault password: " VAULT_PASS
        echo ""
        read -s -p "Confirm vault password: " VAULT_PASS_CONFIRM
        echo ""
        
        if [ "$VAULT_PASS" != "$VAULT_PASS_CONFIRM" ]; then
            echo "❌ Passwords don't match!"
            exit 1
        fi
        
        echo "$VAULT_PASS" > .vault_pass
        chmod 600 .vault_pass
        echo "✓ Created .vault_pass"
    fi
    
    # Encrypt the secrets file if not already encrypted
    if ! grep -q "\$ANSIBLE_VAULT" vars/secrets.yml.local 2>/dev/null; then
        echo "Encrypting secrets file..."
        ansible-vault encrypt vars/secrets.yml.local --vault-password-file .vault_pass
        echo "✓ Secrets file encrypted"
    else
        echo "✓ Secrets file is already encrypted"
    fi
    
    VAULT_ARGS="--vault-password-file .vault_pass"
fi

echo ""
echo "=========================================="
echo "Running Ansible Playbook"
echo "=========================================="
echo ""

# Run the playbook
if [ -z "$VAULT_ARGS" ]; then
    ansible-playbook playbook.yml -e @vars/secrets.yml.local
else
    ansible-playbook playbook.yml -e @vars/secrets.yml.local $VAULT_ARGS
fi

echo ""
echo "=========================================="
echo "✓ Deployment Complete!"
echo "=========================================="
echo ""
echo "Your dotfiles have been deployed."
echo ""
echo "To update in the future:"
echo "  1. git pull"
echo "  2. ./deploy.sh"
echo ""
