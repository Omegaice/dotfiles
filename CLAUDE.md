# CLAUDE.md

AI assistant guidance for working with this NixOS/Home Manager configuration repository.

## Repository Architecture

### Directory Structure

```
.
├── flake.nix          # Main entry point (uses flake-parts)
├── modules/           # Custom module definitions
│   └── home/          # Custom Home Manager modules
├── home/              # Home Manager configurations
│   ├── programs/      # GUI apps (per-host selection, no default.nix)
│   └── terminal/      # CLI tools (universal, has default.nix)
├── host/              # Machine-specific configuration
├── system/            # NixOS modules
└── packages/          # Custom packages (exported via easyOverlay)
```

### Hosts

- **t15g2** - ThinkPad T15 Gen2 (NixOS + Home Manager)
- **crc-49** - WSL environment (Home Manager only)

### Custom Home Manager Modules

Located in `modules/home/programs/`:
- **programs.duf** - Better df with shell integration
- **programs.bitwarden-cli** - Bitwarden CLI configuration

### Key Pattern: home/programs/ Has NO default.nix

This is **intentional** for per-host selection:
- `home/programs/` - GUI apps, explicitly imported per host (no `default.nix`)
- `home/terminal/` - CLI tools, universal across all hosts (has `default.nix`)

This allows different hosts to pick different GUI applications while sharing terminal tooling.

### Where to Put New Configuration

```
Creating new module option?
└─ modules/home/programs/

User-level config (shell, editor, CLI tools)?
└─ home/
   ├─ Universal CLI tool? → home/terminal/programs/
   └─ GUI/desktop app? → home/programs/

Machine-specific (hostname, laptop-only tools)?
└─ host/<hostname>/

Reusable across NixOS machines?
└─ system/
   ├─ Hardware? → system/hardware/
   ├─ Service? → system/services/
   └─ Program? → system/programs/

Custom package?
└─ packages/ (auto-exported via easyOverlay)
```

**Important:** Some functionality spans both system and home levels. Example:
- `system/programs/gaming/` - System packages (heroic, gamemode, steam)
- `home/programs/mangohud.nix` - Home-level config (user preferences)
- Check both when verifying "is X installed?"

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

## Important Tooling

### Finding Packages by File/Binary

**Use `nix-locate` (configured in this repo via nix-index-db)**:
```bash
nix-locate 'bin/glxinfo'              # Find package providing binary
nix-locate --whole-name 'bin/nvtop'   # Exact match
nix-locate 'lib/libfoo.so'            # Find library providers
```

**⚠️ DO NOT use `find /nix/store`** - millions of files, extremely slow. `nix-locate` uses a pre-built index.

### Verifying What's Actually Installed

**Code is truth** - Tracking docs (like `functionality-checklist.md`) can lag behind implementation.

**List all installed system packages:**
```bash
# All packages (195 on t15g2)
nix eval .#nixosConfigurations.t15g2.config.environment.systemPackages \
  --apply 'pkgs: map (p: p.pname or p.name or "?") pkgs' \
  --json | jq -r '.[]' | sort

# Search for specific packages
nix eval .#nixosConfigurations.t15g2.config.environment.systemPackages \
  --apply 'pkgs: map (p: p.pname or p.name or "?") pkgs' \
  --json | jq -r '.[]' | grep -i game
# Output: gamemode, heroic, steam, steam-gamescope, steam-run
```

**Find where configuration is set** (`.definitionsWithLocations`):
```bash
# Trace any option to its source file
nix eval .#nixosConfigurations.t15g2.options.programs.gamemode.enable.definitionsWithLocations
# Output: [ { file = "/nix/store/.../system/programs/gaming"; value = true; } ]

# Find which file added a package
nix eval .#nixosConfigurations.t15g2.options.environment.systemPackages.definitionsWithLocations \
  | grep -A2 -B2 heroic
# Output: { file = "/nix/store/.../system/programs/gaming"; value = [ heroic ... ]; }
```

**Why this matters:**
- Checklist said "Heroic Launcher (GOG + Epic NOT FOUND)" but it was in `system/programs/gaming/default.nix`
- Always verify against flake eval when documentation conflicts with memory
- Use `.definitionsWithLocations` to trace configuration to exact file

### System Debugging on NixOS

**Use `journalctl -k` instead of `dmesg` for kernel logs**

NixOS enables `dmesg_restrict=1` by default. Use systemd's journal instead:
```bash
journalctl -k                          # Kernel messages (replaces dmesg)
journalctl -k -b                       # Kernel messages since boot
journalctl -k --since "5 minutes ago"  # Recent kernel messages
```

### Build/Switch Commands

This repo uses **nh** for better UX (shows diffs, cleaner output):

```bash
# NixOS
nh os build -Q ~/.config/nixpkgs     # Build, no sudo
nh os switch -Q ~/.config/nixpkgs    # Apply, needs sudo
nh os test -Q ~/.config/nixpkgs      # Temporary test (needs sudo)

# Debugging
nix build --show-trace            # Full error trace when builds fail
```

**Initial machine setup only** (bootstrapping):
```bash
nix run path:${HOME}/.config/nixpkgs#install  # Custom installer for new machines
```

## Repository-Specific Notes

### Module Creation Pattern

When creating new system modules:

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

### Hyprland Ecosystem

All Hyprland components (hyprland, hypridle, hyprlock, hyprpaper, etc.) use `.follows` to share:
- Same nixpkgs version
- Same hyprutils/hyprlang libraries

**Why**: Ensures ABI compatibility between compositor and all plugins/tools.

### Custom Packages

Defined in `packages/default.nix` via `perSystem.packages`, auto-exported as overlay via `easyOverlay` module.

Discovery: `nix flake show | grep packages`
