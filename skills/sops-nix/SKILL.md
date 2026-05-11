---
name: sops-nix
description: Use this skill when managing encrypted secrets, editing secrets.yaml files, or troubleshooting sops-nix issues. It provides guidance on safe secret management and common sops commands.
---

# sops-nix Skill

This skill helps agents manage encrypted secrets using `sops-nix`. It focuses on safe editing and configuration.

## Core Concepts

- **Encrypted Files**: Secrets are stored in `.yaml` or `.json` files encrypted with `sops`.
- **Public Keys**: Defined in `.sops.yaml` at the root of the repo.
- **Private Keys**: Stored in `/etc/ssh/ssh_host_ed25519_key` or `~/.config/sops/age/keys.txt`.

## Common Commands

### Editing Secrets

**NEVER** edit an encrypted file directly with a standard text editor. Always use the `sops` command or the agent's `write_file` tool if the file is decrypted in memory.

```bash
# Edit a secret file interactively
sops secrets.yaml

# Set the editor to use (e.g., for non-interactive agents)
EDITOR=cat sops secrets.yaml
```

### Decrypting for Inspection

```bash
# Decrypt to stdout
sops -d secrets.yaml

# Decrypt to a specific format
sops -d --output-format json secrets.yaml
```

### Rotating Keys

```bash
# Re-encrypt with new keys defined in .sops.yaml
sops updatekeys secrets.yaml
```

## Tool Guidelines for Agents

1. **Verify `.sops.yaml`**: Before adding a new secret file, ensure it's covered by a creation rule in the root `.sops.yaml`.
2. **Key Access**: If decryption fails, check if the agent has access to the private key (usually via `SOPS_AGE_KEY_FILE` environment variable).
3. **Nix Integration**: In NixOS, secrets are typically referenced via `config.sops.secrets."secret-name".path`.

## Common Pitfalls

- **Direct Commits**: Accidentally committing a decrypted secret file. Always check `git status` or `jj status` before pushing.
- **Invalid YAML**: `sops` requires valid YAML/JSON. Ensure the structure is correct before saving.
- **Missing Fingerprints**: If using GPG, ensure the public key fingerprint is in `.sops.yaml`.
