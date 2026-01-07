# Cleaning Up Original Chezmoi Files

After verifying that the Ansible playbook works correctly for your needs, you may want to clean up the original chezmoi files to avoid confusion.

## Original Chezmoi Files

The following files and directories are from the original chezmoi setup and are no longer needed:

### Template Files (now in `templates/`)
- `dot_gitconfig.tmpl` → `templates/gitconfig.j2`
- `dot_local_profile.tmpl` → `templates/local_profile.j2`
- `Applications/executable_disable-pihole.sh.tmpl` → `templates/disable-pihole.sh.j2`
- `dot_config/neomutt/accounts/*.tmpl` → `templates/neomutt_accounts/*.j2`

### Dotfiles (now in `files/`)
- `dot_ansible.cfg` → `files/ansible.cfg`
- `dot_aspell.en.prepl` → `files/aspell.en.prepl`
- `dot_aspell.en.pws` → `files/aspell.en.pws`
- `dot_gitignore` → `files/gitignore`
- `dot_latexmkrc` → `files/latexmkrc`
- `dot_mrconfig` → `files/mrconfig`
- `dot_mrtrust` → `files/mrtrust`
- `dot_sops.yaml` → `files/sops.yaml`
- `dot_streamdeck_ui.json` → `files/streamdeck_ui.json`
- `dot_tmux.conf` → `files/tmux.conf`
- `dot_zimrc` → `files/zimrc`
- `dot_zshenv` → `files/zshenv`
- `dot_zshrc` → `files/zshrc`

### Directories (now in `files/`)
- `dot_config/` → `files/config/`
- `dot_local/` → `files/local/`
- `dot_ssh/` → `files/ssh/`
- `private_dot_gnupg/` → `files/gnupg/`

### Other Directories (now in `files/`)
- `Applications/` (scripts) → `files/Applications/`
- `Music/` → `files/Music/`
- `Pictures/` → `files/Pictures/`

## Verification Steps

Before removing the original files, verify that:

1. ✅ The Ansible playbook runs successfully:
   ```bash
   ansible-playbook playbook.yml --check
   ```

2. ✅ All your dotfiles are in the correct locations after deployment

3. ✅ All templates are properly rendering with your secrets

4. ✅ File permissions are correct (especially for SSH and GnuPG files)

5. ✅ All symlinks are working (if any)

## Cleanup Commands

Once verified, you can remove the original chezmoi files:

```bash
# WARNING: This will permanently delete the original chezmoi files!
# Make sure you have a backup and have verified the Ansible setup works!

# Remove template files
rm -f dot_gitconfig.tmpl
rm -f dot_local_profile.tmpl
rm -f Applications/executable_disable-pihole.sh.tmpl

# Remove old dotfiles with dot_ prefix
rm -f dot_ansible.cfg
rm -f dot_aspell.en.prepl
rm -f dot_aspell.en.pws
rm -f dot_gitignore
rm -f dot_latexmkrc
rm -f dot_mrconfig
rm -f dot_mrtrust
rm -f dot_sops.yaml
rm -f dot_streamdeck_ui.json
rm -f dot_tmux.conf
rm -f dot_zimrc
rm -f dot_zshenv
rm -f dot_zshrc

# Remove old directories
rm -rf dot_config/
rm -rf dot_local/
rm -rf dot_ssh/
rm -rf private_dot_gnupg/

# Remove old Applications directory (after backing up non-template files)
# Verify these scripts are in files/Applications/ first!
rm -f Applications/executable_newproj
rm -f Applications/executable_incus-vm-iso.sh
rmdir Applications/

# Remove Music and Pictures if they're now in files/
rm -rf Music/
rm -rf Pictures/
```

## Alternative: Keep for Reference

If you prefer to keep the original files for reference but want to prevent confusion:

1. Move them to a reference directory:
   ```bash
   mkdir -p .chezmoi-reference
   mv dot_* .chezmoi-reference/
   mv private_dot_gnupg .chezmoi-reference/
   mv Applications .chezmoi-reference/
   # etc.
   ```

2. Add to `.gitignore`:
   ```bash
   echo ".chezmoi-reference/" >> .gitignore
   ```

## Commit the Cleanup

After removing the old files:

```bash
git add -A
git commit -m "Remove original chezmoi files after successful migration"
git push
```

## Rollback

If you need to rollback to chezmoi after cleanup, you can recover the files from git history:

```bash
# List deleted files
git log --diff-filter=D --summary | grep delete

# Restore a specific file
git checkout <commit-before-deletion> -- path/to/file

# Or restore all files from a specific commit
git checkout <commit-before-deletion> -- .
```
