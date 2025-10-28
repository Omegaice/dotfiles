# NixOS Configuration

Personal NixOS and Home Manager configuration using Nix Flakes. Manages system and user configurations declaratively across multiple machines.

## Features

- **Multiple Host Support**: Physical machines (t15g2) and WSL environments (crc-49)
- **Modular Architecture**: Clean separation between system, host, and user configurations
- **Home Manager Integration**: User environments managed independently from system
- **Hardware Optimization**: Machine-specific configurations for ThinkPad T15g Gen 2
- **Remote Deployment**: Deploy configurations via deploy-rs
- **Reproducible**: All dependencies pinned via flake inputs

## Hosts

| Host       | Type  | Description                                              |
| ---------- | ----- | -------------------------------------------------------- |
| **t15g2**  | NixOS | ThinkPad T15g Gen 2 (Intel i7-11800H, RTX 3080, 64GB)   |
| **crc-49** | WSL   | Windows Subsystem for Linux environment                 |

See `docs/T15G2/` for detailed hardware specifications and configuration notes.

## Quick Start

### Prerequisites

- NixOS with flakes enabled, or
- Home Manager with flakes support (for non-NixOS systems)
- Git

### Making Changes

1. **Edit configuration files**
   ```bash
   cd ~/.config/nixpkgs
   # Edit files in home/, system/, or host/ as needed
   ```

2. **Build and review changes** (no sudo required)
   ```bash
   nh os build ~/.config/nixpkgs
   ```
   This shows a diff of what will change without applying.

3. **Apply changes**
   ```bash
   # For NixOS (requires sudo)
   nh os switch ~/.config/nixpkgs

   # For Home Manager only
   nix run path:${HOME}/.config/nixpkgs#install
   ```

4. **Deploy to remote machine**
   ```bash
   deploy .#t15g2
   ```

### Testing Risky Changes

Use `nh os test` to apply changes temporarily - they will revert on reboot:

```bash
nh os test ~/.config/nixpkgs
```

## Repository Structure

```
.
├── flake.nix          # Main flake configuration
├── home/              # User-level configs (works on all machines)
│   ├── editor/        # Text editor configuration
│   ├── programs/      # GUI applications
│   ├── services/      # User services
│   └── terminal/      # Terminal emulators, shells, CLI tools
├── host/              # Machine-specific configuration
│   ├── t15g2/         # ThinkPad T15 Gen2 configuration
│   └── crc-49/        # WSL environment
├── system/            # NixOS system-level modules (reusable)
│   ├── core/          # Base system settings
│   ├── hardware/      # Hardware subsystems (GPU, Bluetooth, monitoring)
│   ├── programs/      # System programs
│   └── services/      # System services
├── packages/          # Custom package definitions
└── docs/              # Documentation
```

### Organization Philosophy

- **`home/`**: User preferences that should work everywhere (NixOS + WSL)
- **`system/`**: Reusable NixOS modules for other machines
- **`host/`**: Machine-specific overrides (hostname, unique hardware)

## Tools & Utilities

### nh (nix-helper)

This configuration uses `nh` instead of raw `nixos-rebuild` commands:

**Benefits:**
- Clean, colorful diff showing exactly what will change
- Shorter, more intuitive commands
- Better error messages and build feedback
- Configured automatically in this repository

**Common commands:**
```bash
nh os build ~/.config/nixpkgs   # Build and show diff (no sudo)
nh os switch ~/.config/nixpkgs  # Apply changes (requires sudo)
nh os test ~/.config/nixpkgs    # Temporary test (reverts on reboot)
```

### direnv

The repository uses `direnv` to automatically load the development environment:

- When you `cd` into the repository, the flake's devShell is loaded automatically
- Includes tools like `deploy-rs` without manual `nix develop`
- Configuration in `.envrc` (`use flake`)

If direnv is not installed, manually enter the dev shell:
```bash
nix develop
```

### nix-locate

Quickly find which package provides a specific binary or file:

```bash
nix-locate 'bin/glxinfo'    # Find package for a binary
nix-locate 'lib/libva.so'   # Find package for a library
```

Pre-configured and indexed via Home Manager (`home/terminal/shell/nix-index.nix`).

## Common Tasks

### Update Flake Inputs

```bash
nix flake update           # Update all inputs
nix flake lock --update-input nixpkgs  # Update specific input
```

### Format Nix Files

```bash
nix fmt
```

### Check Configuration

```bash
nix flake check
```

### Remote Deployment

Deploy to t15g2 from another machine:

```bash
deploy .#t15g2
```

Requires network access to the machine (configured in `host/t15g2/deploy.nix`).

## Documentation

- **Hardware Specifications**: `docs/T15G2/hardware-specifications.md`
- **Dock Configuration**: `docs/T15G2/dock-configuration.md`
- **AI Assistant Guide**: `CLAUDE.md` (for AI tools like Claude Code)

## Hardware Highlights (t15g2)

- **CPU**: Intel Core i7-11800H (8C/16T, 2.3-4.6 GHz)
- **GPU**: NVIDIA RTX 3080 Mobile (16GB) + Intel UHD (PRIME Sync)
- **Memory**: 64GB DDR4 @ 3200 MT/s
- **Storage**: 1TB Samsung PM9A1 NVMe (ZFS)
- **Display**: 15.6" 1080p + LG 49" Ultrawide (5120x2160 @ 72Hz)
- **Connectivity**: WiFi 6E, 2.5GbE, Thunderbolt 4

See full specs in `docs/T15G2/hardware-specifications.md`.

## Contributing

### Adding New Configuration

1. Determine the appropriate location:
   - User preference → `home/`
   - Reusable NixOS module → `system/`
   - Machine-specific → `host/<hostname>/`

2. Create module file with descriptive comments

3. Import in parent `default.nix` or host configuration

4. Test with `nh os build` before applying

### Module Guidelines

- Keep modules focused on a single subsystem
- Group related configuration (service + tools + settings)
- Write comments explaining **why**, not just what
- Follow existing patterns in the repository

## Troubleshooting

### Build Errors

**"path does not exist"**
- Flakes only see git-tracked files
- Solution: `git add <file>` before building

**"option does not exist"**
- Check option path at https://search.nixos.org/options
- Example: `services.bolt` vs `services.hardware.bolt`

**"undefined variable"**
- Package might be namespaced (e.g., `nvtopPackages.full`)
- Check with: `nix search nixpkgs <package> --json | jq`

### Getting Help

- Check existing modules for patterns
- Search NixOS options: https://search.nixos.org/options
- Search packages: `nix search nixpkgs <name>`
- Find binary's package: `nix-locate 'bin/<name>'`

## License

Personal configuration - use as reference or inspiration for your own setup.
