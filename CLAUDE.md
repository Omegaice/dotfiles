# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS/Home Manager configuration repository that manages system and user configurations declaratively using Nix Flakes. It supports multiple hosts including physical machines (t15g2) and WSL environments (crc-49).

## Common Development Commands

### Local Home Manager Updates
```bash
# Apply Home Manager configuration changes
nix run path:${HOME}/.config/nixpkgs#install
```

### Remote NixOS Deployment
```bash
# Deploy to t15g2 host (requires network access to 10.42.1.224)
deploy .#t15g2
```

### Code Formatting
```bash
# Format all Nix files with Alejandra
nix fmt
```

### Development Shell
```bash
# Enter development environment with deploy-rs
nix develop
```

### Flake Management
```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show flake structure
nix flake show
```

## Architecture Overview

### Directory Structure
- **`flake.nix`** - Main entry point defining inputs, outputs, and development environment
- **`home/`** - User-level configurations managed by Home Manager
  - `editor/` - Helix editor configuration
  - `terminal/` - Terminal emulators (kitty, alacritty), shells (zsh), and tools
  - `programs/` - User applications (browsers, media players, development tools)
  - `services/` - User services (bluetooth, etc.)
- **`host/`** - Machine-specific configurations
  - `t15g2/` - ThinkPad T15 Gen2 laptop (NixOS)
  - `crc-49/` - WSL environment (Home Manager only)
- **`system/`** - NixOS system-level configurations (only used by NixOS hosts)
  - `core/` - Base system settings
  - `nix/` - Nix daemon and related settings
  - `services/` - System services
- **`packages/`** - Custom package definitions (PDM, Yazi plugins)

### Key Design Patterns

1. **Modular Configuration**: Each component (program, service) has its own module that can be enabled/disabled
2. **Host-specific Overrides**: Base configurations in modules, host-specific customizations in host directories
3. **Flake Inputs**: All dependencies pinned via flake inputs for reproducibility
4. **Home Manager Integration**: User environments managed separately from system configuration

### Adding New Configurations

When adding new programs or services:
1. Create a new module file in the appropriate directory (`home/programs/`, `system/services/`, etc.)
2. Add the module to the imports in `default.nix` of that directory
3. Enable and configure in the relevant host configuration
4. Test locally with `nix run path:${HOME}/.config/nixpkgs#install` before deploying

### Testing Changes

Always test configuration changes locally before deploying:
1. For Home Manager: The install script shows diffs before applying
2. For NixOS: Build the configuration first with `nix build .#nixosConfigurations.t15g2.config.system.build.toplevel`
3. Check for evaluation errors with `nix flake check`