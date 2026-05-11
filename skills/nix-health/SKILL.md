---
name: nix-health
description: Use this skill when the system is low on disk space, the bootloader is full, or when performing general Nix maintenance. It covers garbage collection, store verification, and boot partition management.
---

# Nix Health & Maintenance Skill

This skill provides procedures for maintaining a healthy NixOS system and freeing up disk space.

## Disk Space Management

### Garbage Collection

```bash
# Remove old generations and unreferenced store paths
nix-collect-garbage -d

# Only remove generations older than 7 days
nix-collect-garbage --delete-older-than 7d
```

### Optimizing the Store

```bash
# Hardlink duplicate files in the store to save space
nix-store --optimize
```

## Bootloader Maintenance

### Clearing Boot Partition

If `/boot` is full, you likely have too many NixOS generations.

1. **Check Generations**: `nix-env --list-generations --profile /nix/var/nix/profiles/system`
2. **Delete Old Generations**: `sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system` (keeps the 5 most recent)
3. **Reinstall Bootloader**: `sudo nixos-rebuild switch` (this triggers the bootloader update)

### Manual Cleanup

Identify large files in `/boot`:
```bash
sudo du -ah /boot | sort -rh | head -n 20
```

## Store Integrity

```bash
# Verify the integrity of the Nix store
nix-store --verify --check-contents --repair
```

## Tool Guidelines for Agents

1. **Check Disk Space First**: Before any major build, check `/` and `/boot` using `df -h`.
2. **Automatic GC**: Remind the user if `nix.gc.automatic` is not enabled in their configuration.
3. **Safe Deletion**: Never manually `rm -rf /nix/store/...`. Always use `nix-collect-garbage`.
