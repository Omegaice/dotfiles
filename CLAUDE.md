# CLAUDE.md

AI assistant guidance for working with this NixOS/Home Manager configuration repository.

## Repository Architecture

### Directory Structure
```
.
├── flake.nix          # Main entry point, inputs/outputs
├── home/              # User configs (works on NixOS + WSL)
│   ├── editor/        # Helix configuration
│   ├── programs/      # GUI apps (browsers, media players)
│   ├── services/      # User services
│   └── terminal/      # Terminal emulators, shells, CLI tools
├── host/              # Machine-specific configuration
│   ├── t15g2/         # ThinkPad T15 Gen2 (NixOS)
│   └── crc-49/        # WSL environment (Home Manager only)
├── system/            # Reusable NixOS modules
│   ├── core/          # Base system settings
│   ├── hardware/      # Hardware subsystems (GPU, Bluetooth, etc.)
│   ├── nix/           # Nix daemon configuration
│   ├── programs/      # System-wide programs
│   └── services/      # System services
├── packages/          # Custom package definitions
└── docs/              # Documentation (hardware specs, notes)
```

### Directory Decision Tree

**Where to put new configuration:**

```
Is it user-level config (shell, editor, CLI tools)?
└─ YES → home/
   └─ Would I want this on WSL too?
      └─ YES → home/terminal/programs/ or home/programs/

Is it specific to THIS machine only?
└─ YES → host/<hostname>/nixosConfiguration.nix
   └─ Examples: hostname, brightnessctl (laptop-only)

Is it reusable on other NixOS machines?
└─ YES → system/
   └─ Hardware subsystem? → system/hardware/
   └─ System service? → system/services/
   └─ System program? → system/programs/
```

### Module Creation Pattern

```nix
{pkgs, ...}: {
  # Comment: WHY this is needed, not WHAT it is
  services.hardware.bolt.enable = true;

  environment.systemPackages = with pkgs; [
    bolt # What this tool does in THIS context
  ];
}
```

**Rules:**
1. Start modular - create `system/hardware/foo.nix`, not inline in host config
2. Group related: service + tools + config in same file
3. Comments explain context and purpose

## Critical: Git + Flakes

⚠️ **Flakes only see git-tracked files**

```bash
# This WILL fail:
touch system/hardware/new.nix
nix build  # Error: path does not exist

# MUST do this first:
git add system/hardware/new.nix
# OR
git add --intent-to-add system/hardware/new.nix
```

## NixOS Patterns

### Finding NixOS Options

Don't guess paths. Search first:
- https://search.nixos.org/options
- https://mynixos.com

Example: `services.bolt` (wrong) vs `services.hardware.bolt` (correct)

### Package Scoping

Some packages are namespaced:

```nix
# ❌ WRONG
environment.systemPackages = with pkgs; [
  nvtop  # Error: undefined variable
];

# ✅ CORRECT
environment.systemPackages = with pkgs; [
  nvtopPackages.full  # Check variants: .nvidia, .intel, .amd, .full
];
```

Check package structure:
```bash
nix search nixpkgs nvtop --json | jq -r 'keys[]'
```

### Finding Packages by Binary

Use `nix-locate` (configured in this repo):

```bash
nix-locate 'bin/glxinfo'        # Find package providing binary
nix-locate --whole-name 'bin/nvtop'  # Exact match
nix-locate --minimal 'bin/sensors'   # Just package names
nix-locate --package mesa-demos      # All files in package
```

### List Merging

NixOS **merges** lists from multiple modules:

```nix
# system/hardware/nvidia.nix
boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

# nixos-hardware module
boot.kernelParams = ["nvidia-drm.modeset=1"];

# Result: Both included, not overridden
```

Safe to split config across modules - they combine.

## Workflow

### Standard Development Flow

1. Create/edit files
2. **Stage new files**: `git add <file>` (required!)
3. Build: `nh os build ~/.config/nixpkgs` (no sudo)
4. Apply: `nh os switch ~/.config/nixpkgs` (requires sudo)

**Note:** Repository uses direnv (`.envrc`) - dev environment auto-loads on `cd`

### Commands

| Task               | Command                                           | Sudo? |
| ------------------ | ------------------------------------------------- | ----- |
| Build NixOS        | `nh os build ~/.config/nixpkgs`                   | No    |
| Switch NixOS       | `nh os switch ~/.config/nixpkgs`                  | Yes   |
| Test NixOS (temp)  | `nh os test ~/.config/nixpkgs`                    | Yes   |
| Home Manager       | `nix run path:${HOME}/.config/nixpkgs#install`    | No    |
| Format             | `nix fmt`                                         | No    |
| Update inputs      | `nix flake update`                                | No    |
| Check eval         | `nix flake check`                                 | No    |

**nh alternatives (for debugging):**
```bash
nix build .#nixosConfigurations.t15g2.config.system.build.toplevel  # = nh os build
sudo nixos-rebuild switch --flake .  # = nh os switch
nix build --show-trace  # Full error trace
```

## Troubleshooting

| Error                                     | Cause                        | Fix                                       |
| ----------------------------------------- | ---------------------------- | ----------------------------------------- |
| `path '.../foo.nix' does not exist`       | Not git-tracked              | `git add <file>`                          |
| `option 'services.foo' does not exist`    | Wrong path                   | Search https://search.nixos.org/options   |
| `undefined variable 'pkg'`                | Wrong package name or scope  | `nix search nixpkgs pkg`                  |
| Deprecated warning                        | Old syntax                   | Check warning for new option              |

## Quick Reference

### Package Discovery
```bash
nix search nixpkgs <name>                    # Search packages
nix-locate 'bin/<binary>'                    # Find package by binary
nix search nixpkgs <name> --json | jq       # Check variants
```

### Build Commands
```bash
nh os build ~/.config/nixpkgs               # Build, show diff (no sudo)
nh os switch ~/.config/nixpkgs              # Apply (needs sudo)
nh os test ~/.config/nixpkgs                # Temporary test (needs sudo)
nix run path:${HOME}/.config/nixpkgs#install # Home Manager (no sudo)
```

### Git + Nix
```bash
git add <file>              # Stage for flake
git add -N <file>           # Track without committing
git ls-files                # Show tracked files
nix flake check             # Validate flake
nix fmt                     # Format Nix files
```

### Debugging
```bash
nix build --show-trace      # Full error trace
git ls-files --error-unmatch <file>  # Check if tracked
nix flake show              # Show flake structure
```

## Repository-Specific Notes

- **nh** is used instead of raw `nixos-rebuild` (shows diffs, better UX)
- **direnv** auto-loads dev environment from `.envrc` (`use flake`)
- **Hardware docs** in `docs/T15G2/` (comprehensive specs)
- **Remote deploy** via `deploy .#t15g2` (deploy-rs)
- **Multiple hosts**: t15g2 (NixOS laptop), crc-49 (WSL)
