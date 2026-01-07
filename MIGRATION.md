# Migration from chezmoi to Ansible

This document describes the migration process from chezmoi to Ansible for managing dotfiles.

## Overview

The repository was previously managed using [chezmoi](https://www.chezmoi.io/), which uses special naming conventions and its own templating system integrated with bitwarden for secrets management. The repository has been converted to use Ansible for a more standard and flexible approach to configuration management.

## What Changed

### File Organization

**Before (chezmoi):**
```
.
├── dot_gitconfig.tmpl          # Dotfiles with 'dot_' prefix
├── dot_zshrc
├── private_dot_gnupg/          # Private files with 'private_' prefix
├── executable_script.sh        # Executable with 'executable_' prefix
└── .chezmoi.toml.tmpl         # Chezmoi config
```

**After (Ansible):**
```
.
├── playbook.yml                # Main Ansible playbook
├── inventory.ini               # Ansible inventory
├── ansible.cfg                 # Ansible configuration
├── vars/
│   └── secrets.yml             # Variables and secrets
├── templates/                  # Jinja2 templates
│   ├── gitconfig.j2
│   └── ...
└── files/                      # Static files
    ├── zshrc
    ├── gnupg/
    └── ...
```

### Templating System

**Before (chezmoi):**
```
# .gitconfig.tmpl with bitwarden integration
[url "https://user:{{ (bitwarden "item" "GitHub Token").notes }}@github.com"]
    insteadOf = https://github.com
```

**After (Ansible):**
```jinja2
# templates/gitconfig.j2 with Jinja2 templating
[url "https://user:{{ github_token }}@github.com"]
    insteadOf = https://github.com
```

### Secrets Management

**Before:** Chezmoi integrated directly with bitwarden CLI to fetch secrets at template time.

**After:** Secrets are stored in Ansible variables (`vars/secrets.yml`) and can be encrypted using Ansible Vault.

## Conversion Process

### 1. Naming Convention Changes

- `dot_filename` → `filename` (stored in `files/`)
- `dot_filename.tmpl` → `filename.j2` (stored in `templates/`)
- `private_dot_directory` → `directory` (stored in `files/` with appropriate permissions)
- `executable_script.sh` → `script.sh` (permissions set via Ansible)
- `symlink_name` → handled via Ansible `file` module

### 2. Template Conversion

All chezmoi templates (`.tmpl` files) were converted to Jinja2 templates (`.j2` files):

```bash
# Example conversions:
dot_gitconfig.tmpl              → templates/gitconfig.j2
dot_local_profile.tmpl          → templates/local_profile.j2
Applications/disable-pihole.sh.tmpl → templates/disable-pihole.sh.j2
dot_config/neomutt/accounts/*.tmpl  → templates/neomutt_accounts/*.j2
```

### 3. Secret References

All bitwarden secret references were replaced with Ansible variables:

| Chezmoi Reference | Ansible Variable |
|------------------|------------------|
| `{{ (bitwarden "item" "GitHub Token").notes }}` | `{{ github_token }}` |
| `{{ (bitwarden "item" "gmail-app-password").notes }}` | `{{ gmail_app_password }}` |
| `{{ (bitwarden "item" "TailScale OAuth Client").login.username }}` | `{{ tailscale_oauth_client_id }}` |
| `{{ (bitwarden "item" "PiHole API Key").notes }}` | `{{ pihole_api_key }}` |

### 4. File Permissions

- Chezmoi's `executable_` prefix is replaced with Ansible's `mode: '0755'` parameter
- Chezmoi's `private_` prefix is replaced with Ansible's `mode: '0600'` or `mode: '0700'` as appropriate

## Benefits of Ansible

1. **Industry Standard**: Ansible is widely used and has extensive documentation and community support
2. **Flexibility**: Can manage more than just dotfiles (packages, services, etc.)
3. **Idempotent**: Can be run multiple times safely
4. **Built-in Vault**: Ansible Vault provides secure secrets management
5. **No Special Tools**: Works with standard file naming conventions
6. **Extensible**: Easy to add more tasks, roles, and functionality

## Running the Migrated Configuration

### First Time Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/tommoyer/dotfiles.git
   cd dotfiles
   ```

2. Create your secrets file:
   ```bash
   cp vars/secrets.yml.example vars/secrets.yml.local
   # Edit vars/secrets.yml.local with your actual values
   ```

3. Encrypt your secrets (optional but recommended):
   ```bash
   ansible-vault encrypt vars/secrets.yml.local
   ```

4. Run the playbook:
   ```bash
   ansible-playbook playbook.yml -e @vars/secrets.yml.local --ask-vault-pass
   ```

### Updating Configuration

1. Make changes to files in `files/` or `templates/`
2. Commit and push changes
3. Pull on target machine
4. Re-run the playbook:
   ```bash
   ansible-playbook playbook.yml -e @vars/secrets.yml.local --ask-vault-pass
   ```

## Original Chezmoi Files

The original chezmoi files are still present in the repository root for reference:
- `dot_*` files
- `private_dot_*` directories
- `executable_*` scripts
- Template files with `.tmpl` extension

These files are preserved for historical reference and can be removed once you've verified the Ansible playbook works correctly for your needs.

## Differences and Considerations

### What Works the Same
- All dotfiles are deployed to the same locations
- Templates are processed with variables
- File permissions are preserved
- Directory structures are maintained

### What's Different
- **Secret Management**: Must manually populate `secrets.yml` instead of automatic bitwarden integration
- **Execution**: Run `ansible-playbook` instead of `chezmoi apply`
- **Updates**: Use `git pull` + `ansible-playbook` instead of `chezmoi update`
- **File Organization**: Files are organized in `files/` and `templates/` directories instead of in root

### Integrating with Bitwarden (Optional)

If you want to maintain bitwarden integration, you can:

1. Use the `bitwarden` lookup plugin (requires `bw` CLI):
   ```yaml
   github_token: "{{ lookup('community.general.bitwarden', 'GitHub Token', field='notes') }}"
   ```

2. Or use a pre-task to fetch secrets from bitwarden and set them as facts

## Rollback

If you need to rollback to chezmoi:

1. The original chezmoi files are still in the repository
2. Reinstall chezmoi
3. Run `chezmoi init` and `chezmoi apply`

## Future Enhancements

Potential improvements to consider:

- [ ] Add role-based organization for better modularity
- [ ] Add tags to run only specific parts of the playbook
- [ ] Create separate playbooks for different environments (work, home, etc.)
- [ ] Add package installation tasks
- [ ] Add OS-specific conditionals for cross-platform support
- [ ] Integrate with CI/CD for automated testing
- [ ] Add handlers for services that need restarting after config changes

## Questions or Issues?

If you encounter any issues during migration or have questions, please open an issue on GitHub.
