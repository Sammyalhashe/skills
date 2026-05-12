---
name: cloudflared
description: Use this skill when managing Cloudflare Tunnels (Argo Tunnels), checking tunnel status, or configuring new ingress rules. It replaces older Wireguard/VPN skills for remote access.
effort: medium
context: inline
---

# Cloudflared (Cloudflare Tunnels) Skill

This skill helps agents manage secure tunnels to Cloudflare.

## Core Concepts

- **Tunnels**: Persistent connections between the local machine and Cloudflare edge.
- **Ingress Rules**: Mapping between public hostnames and local services (e.g., `app.example.com` -> `localhost:8080`).
- **Credentials**: Stored in a JSON file (e.g., `~/.cloudflared/<tunnel-id>.json`).

## Common Commands

### Status & Info

```bash
# List active tunnels
cloudflared tunnel list

# Check status of a specific tunnel
cloudflared tunnel info <tunnel-name-or-id>

# View logs for the tunnel service
journalctl -u cloudflared -f
```

### Tunnel Management

```bash
# Create a new tunnel
cloudflared tunnel create <name>

# Route a hostname to a tunnel
cloudflared tunnel route dns <tunnel> <hostname>
```

## NixOS Configuration

In this project, `cloudflared` is typically configured in Nix:

```nix
services.cloudflared = {
  enable = true;
  tunnels = {
    "tunnel-id" = {
      credentialsFile = "/path/to/creds.json";
      default = "http_status:404";
      ingress = {
        "app.example.com" = "http://localhost:8080";
      };
    };
  };
};
```

## Tool Guidelines for Agents

1. **Verify Connectivity**: If a service is unreachable, check if the `cloudflared` service is running: `systemctl status cloudflared`.
2. **DNS Propagation**: Remember that routing changes in Cloudflare dashboard might take a few minutes.
3. **Local Firewalls**: Ensure local ports are accessible to the `cloudflared` user.
