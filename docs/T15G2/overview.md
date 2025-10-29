# ThinkPad T15g Gen 2i - Overview

## Quick Reference

**Machine:** Lenovo ThinkPad T15g Gen 2i (Model: 20YTS0EV00)
**Role:** High-Performance Developer Workstation with Gaming Capabilities
**OS:** NixOS with Hyprland Wayland Compositor

## At a Glance

| Component    | Specification                                                     |
|--------------|-------------------------------------------------------------------|
| **CPU**      | Intel Core i7-11800H (8C/16T @ 2.3-4.6GHz)                        |
| **GPU**      | NVIDIA RTX 3080 Laptop (16GB VRAM) + Intel UHD                    |
| **RAM**      | 64GB DDR4-3200                                                    |
| **Storage**  | 1TB Samsung PM9A1 NVMe (ZFS)                                      |
| **Display**  | 15.6" FHD (1920x1080) + LG 49" Ultrawide (5120x2160@72Hz)        |
| **Dock**     | Lenovo ThinkPad Thunderbolt 4 Dock (40B0, 100W PD)                |
| **Kernel**   | Linux 6.12.54                                                     |

## Purpose

This machine serves as a **no-compromise mobile workstation** optimized for:

- **Professional Software Development** - Terminal-first workflow with Helix, modern Git tooling, LSP integration
- **Container-Based Workflows** - Docker with NVIDIA GPU passthrough for ML/AI development
- **Modern Tiling Desktop** - Hyprland with dual-display productivity setup
- **Gaming & Entertainment** - Steam with Proton, RTX ray tracing, GameMode optimization
- **System Reliability** - ZFS storage with snapshots, intelligent power management, battery preservation

## Key Features

### Development Environment
- **Editors:** Helix (primary), VS Code (secondary with remote dev)
- **Terminal:** Ghostty, Kitty, Wezterm with Zellij multiplexer
- **Shell:** Zsh with starship, atuin, modern CLI tools (bat, eza, yazi, ripgrep)
- **VCS:** Git with difftastic, GitHub CLI, worktree workflows

### Desktop Environment
- **WM:** Hyprland (Wayland) with UWSM session management
- **Display Setup:** Dual workspace allocation (1-5 internal, 6-10 ultrawide)
- **Lock/Auth:** hyprlock with PAM, GNOME Keyring
- **Panel:** Waybar status bar

### Storage Architecture
- **Filesystem:** ZFS with separate pools (root, nix, var, home)
- **Boot:** systemd-boot (UEFI)
- **Swap:** 4GB encrypted (LUKS)

### GPU Configuration
- **Mode:** PRIME synchronized (Intel iGPU + NVIDIA dGPU)
- **Driver:** NVIDIA proprietary (580.95.05)
- **Features:** VRAM preservation, Docker GPU support, Wayland native

### Power Management
- **AC Mode:** 100% CPU, 1450MHz GPU (performance)
- **Battery Mode:** 80% CPU cap (efficiency)
- **Charging:** 90-100% thresholds (battery preservation)
- **Current Battery Health:** ~82% (77.3Wh / 94Wh design)

### Gaming Setup
- Steam with Proton
- UMU Launcher (Universal Wine/Proton)
- GameMode performance optimizer
- RTX 3080 with 16GB VRAM for AAA gaming

## Design Philosophy

This configuration represents a **developer workstation optimized for 2025 workflows**:

1. **Terminal-centric** - Fast, keyboard-driven development
2. **Container-first** - GPU-accelerated ML/AI in isolated environments
3. **Wayland-native** - Modern display protocol with NVIDIA optimizations
4. **Reliability-focused** - ZFS for data integrity, battery preservation for longevity
5. **Gaming-capable** - First-class citizen, not an afterthought

## Documentation

- [Hardware Specifications](./hardware-specifications.md) - Complete hardware inventory
- [Configuration Goals](./configuration-goals.md) - Design rationale and trade-offs
- [Dock Configuration](./dock-configuration.md) - ThinkPad Thunderbolt 4 Dock setup and topology

## Quick Commands

```bash
# Apply Home Manager changes
nix run path:${HOME}/.config/nixpkgs#install

# Deploy to T15g2 (if remote)
deploy .#t15g2

# Format Nix files
nix fmt

# Update flake inputs
nix flake update

# Check GPU status
nvidia-smi

# Check ZFS pools
zpool status

# Monitor system resources
btop
```

## Host Configuration Location

- **NixOS Config:** `host/t15g2/nixosConfiguration.nix`
- **Home Manager:** `host/t15g2/home.nix`
- **Hyprland Settings:** `home/programs/wayland/hyprland/`
