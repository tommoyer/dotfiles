# Dotfiles - Ansible Playbook

This repository contains my personal dotfiles managed by Ansible. Previously managed with [chezmoi](https://www.chezmoi.io/), this repository has been converted to use Ansible for configuration management.

## Overview

This Ansible playbook deploys and manages dotfiles across your system, including:

- Shell configurations (zsh, tmux)
- Application configurations (neomutt, watson, fontconfig, etc.)
- SSH configurations
- GnuPG configurations
- Custom scripts and applications
- Fonts, media files, and pictures

## Prerequisites

- Ansible 2.9 or higher
- Python 3.x

### Installing Ansible

**On macOS:**
```bash
brew install ansible
```

**On Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install ansible
```

**On Fedora/RHEL:**
```bash
sudo dnf install ansible
```

## Quick Start

### Option 1: Using the Deploy Script (Recommended)

1. Clone this repository:
   ```bash
   git clone https://github.com/tommoyer/dotfiles.git
   cd dotfiles
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

   The script will:
   - Check if Ansible is installed
   - Create a secrets file from the example if needed
   - Optionally encrypt the secrets file with Ansible Vault
   - Run the playbook to deploy your dotfiles

### Option 2: Manual Deployment

1. Clone this repository:
   ```bash
   git clone https://github.com/tommoyer/dotfiles.git
   cd dotfiles
   ```

2. Copy and edit the secrets file with your actual values:
   ```bash
   cp vars/secrets.yml.example vars/secrets.yml.local
   # Edit vars/secrets.yml.local with your actual credentials
   ```

3. Run the playbook:
   ```bash
   ansible-playbook playbook.yml -e @vars/secrets.yml.local
   ```

## Configuration

### Secrets Management

The playbook uses variables defined in `vars/secrets.yml`. You should create a copy and update it with your actual values:

- `github_token`: Your GitHub personal access token
- `tailscale_oauth_client_id`: Tailscale OAuth client ID
- `tailscale_oauth_client_secret`: Tailscale OAuth client secret
- `gmail_app_password`: Gmail application password
- `terrablue_password`: TerraBlue email password
- `uncc_password`: UNCC email password
- `pihole_api_key`: Pi-hole API key

### Using Ansible Vault

For better security, you can encrypt your secrets file using Ansible Vault:

```bash
# Encrypt the secrets file
ansible-vault encrypt vars/secrets.yml.local

# Run the playbook with vault
ansible-playbook playbook.yml -e @vars/secrets.yml.local --ask-vault-pass
```

Or create a vault password file:
```bash
echo "your-vault-password" > .vault_pass
chmod 600 .vault_pass

# Add to .gitignore
echo ".vault_pass" >> .gitignore

# Run with vault password file
ansible-playbook playbook.yml -e @vars/secrets.yml.local --vault-password-file .vault_pass
```

## File Structure

```
.
├── ansible.cfg              # Ansible configuration
├── inventory.ini            # Inventory file (localhost)
├── playbook.yml            # Main Ansible playbook
├── vars/
│   └── secrets.yml         # Variables and secrets (template)
├── templates/              # Jinja2 templates for dotfiles
│   ├── gitconfig.j2
│   ├── local_profile.j2
│   ├── disable-pihole.sh.j2
│   └── neomutt_accounts/
│       ├── gmail.j2
│       ├── terrablue.j2
│       └── uncc.j2
└── files/                  # Static files to be copied
    ├── config/
    ├── local/
    ├── ssh/
    ├── gnupg/
    ├── Applications/
    ├── Music/
    └── Pictures/
```

## What Gets Deployed

### Dotfiles
- `.gitconfig` (templated with GitHub token)
- `.gitignore`
- `.local_profile` (templated with secrets)
- `.tmux.conf`
- `.zshrc`, `.zshenv`, `.zimrc`
- `.ansible.cfg`
- Various application-specific configs

### Configuration Directories
- `.config/neomutt/` - Email client configuration
- `.config/watson/` - Time tracking tool
- `.config/fontconfig/` - Font configuration
- `.config/mr/` - Repository manager
- `.config/zsh-completions/` - ZSH completions

### SSH Configuration
- `.ssh/config`
- `.ssh/authorized_keys`
- `.ssh/id_rsa.pub`

### GnuPG Configuration
- `.gnupg/gpg.conf`
- `.gnupg/gpg-agent.conf`

### Fonts
- Source Code Pro fonts
- Nerd Fonts symbols

### Scripts and Applications
- Custom scripts in `~/Applications/`

### Media Files
- Music files (notification sounds)
- Pictures and wallpapers

## Running Specific Tasks

You can run specific parts of the playbook using tags (if implemented) or by commenting out tasks you don't need.

## Updating Dotfiles

To update your dotfiles:

1. Make changes to the files in this repository
2. Commit and push your changes
3. Pull the changes on your target machine
4. Re-run the playbook:
   ```bash
   ansible-playbook playbook.yml
   ```

## Customization

To customize for your own use:

1. Fork this repository
2. Update `vars/secrets.yml` with your own values
3. Modify the files in `files/` and `templates/` directories
4. Update the `playbook.yml` if you add or remove files
5. Run the playbook on your system

## Migration from chezmoi

This repository was previously managed using chezmoi. The conversion involved:

- Converting chezmoi naming conventions (`dot_`, `private_`, `executable_`) to standard names
- Converting chezmoi templates (`.tmpl` with bitwarden integration) to Jinja2 templates (`.j2`)
- Organizing files into Ansible-standard structure (`files/`, `templates/`, `vars/`)
- Replacing bitwarden secret lookups with Ansible variables

**Note:** The original chezmoi files (`dot_*`, `private_dot_*`, etc.) are still present in the repository root for reference. Once you've verified the Ansible playbook works correctly, you may optionally remove them. See [MIGRATION.md](MIGRATION.md) for detailed migration information.

## Troubleshooting

### Playbook fails on font cache refresh
This is usually safe to ignore if `fc-cache` is not installed. The fonts will still be copied.

### SSH permissions errors
Ensure the SSH files have correct permissions (600 for private keys, 644 for public keys).

### GnuPG directory permissions
The `.gnupg` directory should have 700 permissions, which the playbook sets automatically.

## License

Personal dotfiles - use at your own discretion.

## Author

Tom Moyer (tommoyer@gmail.com)
