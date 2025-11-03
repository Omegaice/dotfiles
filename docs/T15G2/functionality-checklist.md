# T15G2 System Functionality Checklist

Comprehensive checklist for essential functionality of a high-performance Linux laptop serving as desktop-replacement, development workstation, and gaming machine.

## Summary

This checklist has been significantly expanded based on best practices analysis. Items are grouped by functional area with detailed sub-categories.

**Completion Overview (Post-Audit):**
- ✅ **Power & Thermal Management:** 45/54 implemented (83%) - CORE COMPLETE
- ✅ **Dual-GPU Orchestration:** 7/10 implemented (70%)
- ⚠️ **Display Management:** 8/16 (50%) - VRR, workspaces, auto-positioning configured
- ⚠️ **Input Devices:** 16/30 (53%) - Touchpad, function keys, OSD (swayosd), media keys configured
- ⚠️ **Desktop Environment:** 32/64 (50%) - Waybar, dunst, clipboard (clipse w/ Super+V), screenshots (grimblast), anyrun, AppImage support, hypridle/hyprlock
- ✅ **File Management:** 19/31 (61%) - Nautilus + Dolphin, yazi, allmytoes thumbnails, ark + file-roller archives, kio-extras (SMB/NFS/SFTP)
- ⚠️ **Development Workstation:** 15/42 (36%) - Docker, libvirt, Helix, VS Code, LSPs, git
- ⚠️ **Gaming Infrastructure:** 22/52 (42%) - Steam, gamemode, gamescope, MangoHud, Heroic, umu, Wine configured
- ⚠️ **Multimedia & Content:** 10/32 (31%) - MPV, pipewire, Intel media drivers, xdg-portal
- ⚠️ **Connectivity & Networking:** 15/44 (34%) - NetworkManager, Bluetooth, SSH, Firefox, messaging
- ⚠️ **Security & Privacy:** 9/42 (21%) - Bitwarden GUI+CLI, gnome-keyring, seahorse, polkit
- ⚠️ **System Monitoring:** 7/12 (58%) - Basic monitoring tools installed
- ⚠️ **Firmware & Updates:** 4/8 (50%) - fwupd, microcode, NVIDIA driver working
- ⚠️ **Mobile Features:** 1/5 (20%) - Battery thresholds configured

**Total Items: 444+**
**Implemented: ~212**
**Overall Completion: ~48%**

**Key Finding:** The configuration is significantly more complete than initially estimated. Many essential components are already in place, particularly for development, gaming basics, and desktop environment foundations.

**Recent Additions (Last 4 Commits):**
- ✅ **Gaming Infrastructure** (current):
  - MangoHud performance overlay (`home/programs/mangohud.nix`)
  - FPS, frametime graph, GPU/CPU monitoring with color-coded load thresholds
  - VRAM/RAM tracking, thermal monitoring, gamemode integration indicator
  - Keybindings: Shift+F12 (toggle overlay), Shift+F1 (cycle FPS limits)
  - Heroic Launcher installed (GOG + Epic games support)
  - Heroic window rules (immediate tearing mode for games)
  - Steam gaming documentation (`home/programs/steam-gaming-setup.md`)
  - PRIME offload launch options for NVIDIA GPU (per-game configuration)
  - Proton setup guide (Experimental, GE, ProtonDB integration)
  - Power validation script (`scripts/power-validation.sh`) - 10-point diagnostic
- ✅ **File Management Ecosystem** (commit 83f8480):
  - Dual file managers: Nautilus (GNOME) + Dolphin (KDE with F3 dual-pane, F4 terminal)
  - Archive handling: ark (KDE) + file-roller (GNOME) with context menu integration
  - AllMyToes thumbnail system with custom Home Manager module
  - RAW image support: Sony ARW, Canon CR2, Nikon NEF (libraw + kimageformats)
  - Network protocols: SMB, NFS, SFTP via kio-extras
  - Yazi integration with allmytoes for terminal thumbnails
- ✅ **Desktop Environment Essentials** (commit d32f748):
  - Screenshot functionality complete (grimblast with custom module, full keybindings)
  - Clipboard manager fully configured (clipse TUI with Kitty graphics, Super+V)
  - OSD functionality complete (swayosd for volume/brightness/mute)
  - Custom Home Manager modules: grimblast, clipse
- ✅ **Power & Thermal Refinements** (commit 8b4cdff):
  - Battery thresholds optimized: 75-90% (was 90-100%)
  - Platform profiles configured (performance AC, low-power battery)
  - Automatic suspend on 30min idle (hypridle)
  - Module reorganization: backlight, Intel Tiger Lake, logind separated
  - Runtime PM, PCIe ASPM, WiFi power save, audio codec power all tuned

**Priority Focus Areas:**
1. Gaming Polish (vkBasalt, Proton GE via ProtonUp-Qt)
2. Development Containers (NVIDIA runtime testing, distrobox, additional LSPs)
3. Security & Privacy (firewall, SSH hardening, GPG key management)
4. System Maintenance (ZFS snapshots automation via sanoid, SMART monitoring)
5. Desktop Polish (color picker, notification history, advanced display hotplug)

---

## Core Hardware Management

### Power & Thermal

#### Battery Management
- [x] TLP enabled and configured (`system/hardware/power.nix`)
- [x] Battery charge thresholds: 75% start, 90% stop (longevity mode)
- [x] Battery charge thresholds enforced via thinkpad_acpi module
- [x] AC vs battery power profiles configured
- [ ] Battery statistics/history tracking
- [ ] Low battery warning notifications
- [ ] Battery health monitoring and alerts

#### CPU Power Management
- [x] Intel P-states driver enabled (`intel_pstate=active`)
- [x] Hardware P-States (HWP) support configured
- [x] CPU governor: performance on AC, powersave on battery
- [x] Energy Performance Preference (EPP): performance on AC, balance_power on battery
- [x] CPU turbo boost: enabled on AC, disabled on battery
- [x] CPU performance limits: 0-100% on AC, 0-80% on battery
- [x] Platform profile: performance on AC, low-power on battery

#### GPU Power Management
- [x] NVIDIA PRIME offload mode configured (iGPU default, dGPU on-demand)
- [x] PCI bus IDs configured (Intel: PCI:0:2:0, NVIDIA: PCI:1:0:0)
- [x] nvidia-offload wrapper command available
- [x] NVIDIA power management enabled with fine-grained control
- [x] Intel iGPU frequency scaling configured (350-1450 MHz)
- [x] Intel iGPU as primary renderer for Hyprland
- [ ] Automatic GPU selection for games (Hyprland window rules)
- [ ] NVIDIA fan curve customization
- [ ] GPU overclocking profiles

**Note:** GPU stays at P3-P8 (~12-14W) due to NixOS PRIME offload requiring nvidia-drm.modeset=1. Cannot fully power off but significantly better than sync mode.

#### Thermal Management
- [x] thermald enabled with ThinkPad compatibility (ignoreCpuidCheck)
- [x] Intel DPTF (Dynamic Platform & Thermal Framework) active
- [x] Temperature sensors available via lm_sensors
- [ ] Custom fan curves (using default Lenovo firmware control)
- [ ] Thermal stress testing validation
- [ ] Thermal throttling detection and logging

#### Suspend & Sleep States
- [x] S3 suspend (deep sleep) configured via mem_sleep_default=deep
- [x] Lid close triggers suspend
- [x] Lid close while docked: ignored (no suspend)
- [x] Power button: short press suspends
- [x] Power button: long press powers off
- [x] NVIDIA resume support enabled
- [ ] Hibernate to encrypted swap (not recommended with ZFS root)
- [x] Automatic suspend after extended idle (hypridle: suspend@30min)
- [ ] Wake-on-LAN configuration

#### Display Power Management
- [x] brightnessctl installed and configured
- [x] Brightness control without sudo (udev rules + video group)
- [x] User in video group for backlight access
- [x] Keyboard backlight udev rules (ThinkPad tpacpi::kbd_backlight)
- [x] hypridle screen timeout: dim@5min, off@10min, lock@15min, suspend@30min
- [x] Hardware brightness keys functional (Fn+F5/F6)
- [ ] Adaptive brightness based on ambient light sensor
- [ ] Night light/blue light filter scheduling
- [ ] Content-aware brightness adjustment

#### System-Wide Power Policies
- [x] Runtime power management: on (AC), auto (battery)
- [x] PCIe ASPM: default (AC), powersupersave (battery)
- [x] WiFi power save: off (AC), on (battery)
- [x] USB autosuspend enabled globally
- [x] USB autosuspend disabled during shutdown (prevent hangs)
- [x] Audio codec power save: 0s timeout (AC), 1s timeout (battery)
- [x] NVMe/AHCI runtime PM: on (AC), auto (battery)
- [x] SATA link power management: max_performance (AC), med_power_with_dipm (battery)
- [ ] Per-device USB autosuspend exclusions (if needed)
- [ ] Workload-aware power profile switching

#### Monitoring & Analysis Tools
- [x] btop (system resource monitoring)
- [x] nvtop (GPU monitoring - NVIDIA + Intel)
- [x] lm_sensors (temperature monitoring)
- [x] acpi (battery status)
- [x] brightnessctl (backlight control)
- [ ] powertop (power consumption analysis)
- [ ] turbostat (CPU frequency/C-state monitoring)
- [ ] s-tui (stress testing with monitoring)
- [ ] upower CLI (detailed battery info)
- [ ] Power consumption logging and trending

**Module Organization (commit 8b4cdff):**
- `system/hardware/power.nix` - TLP configuration, battery thresholds, power policies
- `system/hardware/backlight.nix` - Brightness control (udev rules, video group)
- `system/hardware/intel-tigerlake.nix` - CPU-specific optimizations
- `system/services/logind.nix` - Lid/power button handling

### Dual-GPU Orchestration
- [x] NVIDIA/Intel switching strategy: PRIME offload mode configured
- [x] Intel iGPU as default renderer for desktop/compositor
- [x] NVIDIA dGPU available on-demand via nvidia-offload command
- [x] PCI bus IDs properly configured in hardware.nvidia.prime
- [x] Wayland compatibility: nvidia-drm.modeset=1 enabled automatically
- [x] NVIDIA proprietary driver (better stability than open source)
- [x] Mesa demos (glxinfo/glxgears) for GPU testing
- [ ] Per-application GPU selection via Hyprland window rules (auto-offload games)
- [ ] NVIDIA settings persistence (fan curves, overclocking, power limits)
- [ ] Manual GPU switching profiles for different workloads

### Display Management

#### Hotplug & Multi-Display
- [x] Automatic display detection on dock connection (fixed via AQ_DRM_DEVICES + VRR disable)
- [x] Workspace persistence across display changes (workspaces 1,3-5 on eDP-1, 2,6-10 on DP-9)
- [x] Resolution and refresh rate auto-detection (explicit 5120x2160@72 for DP-9)
- [x] Primary display switching (auto-positioning configured)
- [x] Hotplug working reliably (VRR disabled to fix page flip deadlock)
- [ ] Suspend-and-dock handling (configure displays on wake)
- [ ] Multiple dock profiles (home, office, mobile-only)

#### Color & Visual Quality
- [ ] Per-display ICC color profiles
- [ ] sRGB baseline for development work
- [ ] Consistent brightness across displays
- [ ] Night light/blue light filter (mutually exclusive with color profiles)

#### Advanced Display Features
- [x] VRR (Variable Refresh Rate) **disabled** (`vrr = 0`) - causes page flip deadlock with NVIDIA + Thunderbolt dock
- [x] Tearing allowed for games (`allow_tearing = true`)
- [x] XWayland scaling fixed (`xwayland.force_zero_scaling = true`)
- [ ] VRR testing and validation (blocked: VRR incompatible with NVIDIA Thunderbolt hotplug)
- [ ] HDR support (experimental, skip until mature)
- [x] Per-display scaling configured (1.0x on both displays)
- [ ] Fractional scaling validation (test without first)

### Input Devices

#### Touchpad Configuration
- [x] Two-finger scroll configured (scroll_factor = 0.75)
- [ ] Two-finger right-click for context menus
- [ ] Pinch-to-zoom gesture
- [x] Three-finger swipe for workspace switching (configured in Hyprland)
- [x] Four-finger swipe for window overview (hyprexpo plugin installed)
- [ ] Tap-to-click (user configurable)
- [ ] Natural scrolling vs traditional (user preference)
- [ ] Palm rejection while typing
- [x] Sensitivity adjustment (1.5 for Synaptics touchpad)

#### TrackPoint Configuration
- [ ] TrackPoint enabled alongside touchpad
- [ ] Sensitivity/speed adjustment (50-100% higher than default)
- [ ] Middle button scrolling enabled
- [ ] Acceleration curve (light pressure = precise, firm = fast)
- [ ] Usage pattern: TrackPoint for precision, touchpad for gestures

#### Keyboard Features
- [x] Display brightness keys (Fn+F5/F6) - hardware keys working (`XF86MonBrightnessUp/Down`)
- [x] Keyboard backlight available (ThinkPad tpacpi::kbd_backlight udev rules)
- [ ] Keyboard backlight auto-off after 30s of no typing
- [ ] Keyboard backlight instant-on with keystroke
- [ ] Keyboard backlight brightness levels (low/medium/off)
- [ ] Keyboard backlight setting persistence

#### Function Key Bindings & OSD
- [x] Brightness up/down (Fn+F5/F6) - swayosd-client with OSD feedback
- [x] Volume up/down/mute (XF86Audio*) - swayosd-client with OSD feedback
- [x] Volume OSD (on-screen display) - swayosd configured (GTK-based, 90% from top)
- [x] Brightness OSD (on-screen display) - swayosd configured
- [x] Mic mute (XF86AudioMicMute) - swayosd-client with OSD feedback
- [ ] Screen blank for quick privacy
- [ ] WiFi toggle (airplane mode)
- [ ] Bluetooth toggle
- [ ] Camera toggle (privacy)
- [x] Media keys (Play/Prev/Next) - bound to playerctl
- [ ] Function key priority configuration (Fn-as-modifier vs media-as-default)

---

## Desktop Environment Essentials

### Hyprland Ecosystem

#### Notification System
- [x] Notification daemon installed (dunst in `home/programs/wayland/dunst.nix`)
- [ ] Notification priority levels (critical, important, normal, low)
- [ ] Notification positioning (top-right standard)
- [ ] Duration configuration (5s normal, 10s important, indefinite critical)
- [ ] Do Not Disturb mode (suppress during gaming/presenting)
- [ ] Notification history (view dismissed notifications)
- [ ] Action buttons (View, Dismiss, Remind later)
- [ ] Per-application notification control
- [ ] DND mode for specific apps only (calendar, messages)

#### Status Bar (Waybar)
- [x] Waybar installed and configured (`home/programs/wayland/waybar.nix`)
- [x] Battery percentage and charging status (battery module)
- [x] Current workspace indicator (workspaces module)
- [x] Time and date display (clock module)
- [x] Audio status (pulseaudio module)
- [x] Network status (network module)
- [ ] System resources (CPU temp for throttling awareness, memory usage)
- [x] Active window title (window module)
- [ ] Media player info (current song, play/pause)
- [ ] Notifications indicator (unread count)
- [x] System tray configured (tray module)
- [x] Backlight module for brightness
- [x] Privacy module
- [ ] Dual-display bar strategy (both displays or primary only)

#### Screen Lock & Idle
- [x] Screen locking (hyprlock configured in `home/programs/wayland/hyprlock.nix`)
- [x] Idle management (hypridle configured: dim@5min, off@10min, lock@15min, suspend@30min)
- [ ] AC vs battery idle profiles (longer timeouts on AC)
- [ ] Presentation mode (inhibit idle during full-screen)
- [ ] Immediate lock on lid close (already configured via logind)
- [ ] Fingerprint unlock (if ThinkPad has fingerprint reader)

#### Screenshots & Recording
- [x] Screenshot tool installed (grimblast from hyprwm/contrib)
- [x] Full screen screenshot (Ctrl+Print Screen)
- [x] Region selection screenshot (Shift+Print Screen → file, Print → clipboard)
- [x] Active window screenshot (Alt+Print Screen)
- [x] Copy to clipboard mode (Print Screen)
- [x] Screenshot notifications (--notify flag)
- [x] Cursor capture for window/screen shots (--cursor flag)
- [x] Consistent save location (~/Pictures/ via XDG defaults)
- [ ] Screenshot delay (3 seconds)
- [ ] Screenshot annotation (swappy integration)
- [ ] Filename format customization
- [ ] Screenshot notification with preview and "Copy path" button
- [ ] Screen recording (grimblast or wf-recorder)
- [ ] Region selection for recording
- [ ] GPU encoding for recording (NVENC via RTX 3080)

#### Clipboard Management
- [x] Clipboard manager installed (clipse TUI + wl-clipboard in `home/programs/wayland/clipboard.nix`)
- [x] History size configured (100 items via programs.clipse.maxHistory)
- [x] Persistence across reboots (daemon runs via exec-once)
- [x] Quick access keybinding (Super+V opens floating TUI)
- [x] Image preview support (Kitty graphics protocol in ghostty)
- [x] Floating window configuration (960x540, 16:9 aspect ratio)
- [x] Duplicate filtering (allowDuplicates = false)
- [x] Custom Home Manager module created (modules/home/programs/clipse.nix)
- [ ] Pin favorite snippets (clipse supports this, needs keybinding exploration)
- [ ] Password detection (don't store Bitwarden entries)
- [ ] Clear clipboard on lock (optional security feature)
- [ ] Sensitive data detection (credit cards, API keys)

#### Utilities
- [ ] Color picker (hyprpicker NOT CONFIGURED)
- [ ] Color picker keybinding (Super+Shift+C)
- [ ] Multiple color format output (hex, rgb, hsl)
- [ ] Auto-copy to clipboard
- [x] Application launcher (anyrun in `home/programs/anyrun.nix` with launch-prefix)
- [x] Fuzzy search for apps
- [x] Learning/ranking by usage
- [x] Plugin support (applications plugin enabled)
- [x] AppImage support (`system/programs/appimage.nix`)
- [x] AppImage binfmt integration (run .appimage files directly)

### File Management

#### GUI File Manager
- [x] File managers installed: Nautilus (GNOME) + Dolphin (KDE) in `home/programs/file-manager.nix`
- [x] Terminal file manager (yazi with allmytoes integration in `home/terminal/programs/yazi.nix`)
- [x] Dual pane mode (Dolphin: F3 toggles dual-pane)
- [x] Keyboard navigation (arrows, Enter, Backspace - both file managers)
- [x] Quick preview (Space bar for images/text/PDFs - Dolphin built-in)
- [x] Tab support for multiple directories (both Nautilus and Dolphin)
- [x] Address bar with editable path (Ctrl+L in both)
- [x] Hidden files toggle (Ctrl+H standard in both)
- [x] Fast startup time (both file managers optimized)
- [x] Integrated terminal (Dolphin: F4 opens terminal in current directory)
- [ ] Custom actions (right-click → Open in VS Code)
- [x] Network share browsing (SMB/NFS/SFTP via kio-extras for Dolphin, GVFS for Nautilus)

#### Trash & Safety
- [ ] Trash integration (Delete = trash, Shift+Delete = permanent)
- [ ] CLI rm stays permanent (don't alias to trash)
- [ ] Auto-empty trash after 30 days
- [ ] Easy restore from trash view
- [ ] ZFS snapshot integration (alternative to trash)

#### Preview & Thumbnails
- [x] AllMyToes universal thumbnail generator (`modules/home/programs/allmytoes.nix`)
- [x] Automatic thumbnail generation on first view (freedesktop.org thumbnailer spec)
- [x] Thumbnail caching persistent (XDG cache directory)
- [x] Format support: images (JPEG, PNG, GIF, WebP, TIFF, BMP, SVG, HEIF, AVIF)
- [x] Video thumbnails (ffmpegthumbnailer provider)
- [x] RAW image formats (Sony ARW, Canon CR2, Nikon NEF via libraw)
- [x] yazi preview with allmytoes integration and exiftool metadata
- [ ] File size threshold configuration for thumbnails (skip >50MB files)

#### Archive Support
- [x] Context menu integration (ark + file-roller integrate with Dolphin + Nautilus)
- [x] Browse archives without extracting (both ark and file-roller support)
- [x] All common formats (zip, tar.gz, tar.xz, 7z supported)
- [x] Archive manager GUI (ark for KDE + file-roller for GNOME installed)
- [ ] CLI tools verification (zip, unzip, tar, 7z - need to verify unrar for proprietary RAR)
- [ ] Automatic archive format detection and handler selection

#### Remote Filesystems
- [x] GVFS installed for Nautilus (`system/services/gvfs.nix`)
- [x] kio-extras installed for Dolphin (SMB, NFS, SFTP, FTP protocols)
- [x] MTP support for phones (GVFS + kio)
- [x] SMB/CIFS support (Windows shares, NAS via kio-extras + GVFS)
- [x] NFS support (Unix shares via kio-extras + GVFS)
- [x] SFTP support (SSH-based file browsing via kio-extras + GVFS)
- [ ] Bookmark common network shares (user configuration)
- [ ] Auto-mount on network availability (home WiFi → NAS)
- [x] Credentials stored in keyring (gnome-keyring configured)
- [ ] Cloud storage integration (Google Drive, Dropbox, rclone)

**Implementation Notes:**
- **Dual file manager strategy:** Nautilus for simplicity, Dolphin for power features (dual-pane, integrated terminal)
- **AllMyToes custom module:** Universal thumbnail generator replacing fragmented thumbnailer ecosystem
- **RAW image workflow:** Sony ARW provider uses embedded preview extraction (30-50x faster than full decode)
- **Network protocols:** Dual implementation (GVFS for Nautilus, kio-extras for Dolphin) ensures compatibility

---

## Development Workstation

### Containerization & Virtualization

#### Container Platform (Docker)
- [x] Docker installed and running (`system/services/docker.nix`)
- [x] User in docker group
- [x] Docker auto-prune enabled
- [x] NVIDIA container toolkit installed (in docker.nix)
- [ ] NVIDIA container runtime configured
- [ ] Test GPU access in containers (nvidia-smi in container)
- [ ] CUDA version compatibility (host driver 580.95.05 = CUDA 12.6)
- [ ] Docker compose for multi-container apps
- [ ] Container image management and cleanup

#### Alternative: Podman (Future Consideration)
- [ ] Podman evaluation (daemonless, rootless, more secure)
- [ ] Podman compatibility testing with existing workflows
- [ ] Decision: Docker vs Podman based on needs

#### Virtual Machines (QEMU/KVM)
- [x] libvirt and QEMU installed (`system/virtualization/default.nix`)
- [x] virt-manager for VM GUI management
- [x] OVMF (UEFI) support configured
- [x] swtpm (TPM emulation) available
- [ ] Windows 11 VM for cross-platform testing
- [ ] VM networking configuration (bridged, NAT)
- [ ] GPU passthrough research (RTX 3080 to Windows VM)
- [x] IOMMU support verification (Tiger Lake supports this)
- [ ] Decision: GPU passthrough vs Proton for gaming

#### Development Containers (distrobox)
- [ ] distrobox installed
- [ ] Ubuntu 24.04 container created (FHS compatibility)
- [ ] Arch container for AUR packages (if needed)
- [ ] Home directory shared with containers
- [ ] Graphics/audio/GPU working in containers
- [ ] Seamless binary integration (container bins in host PATH)

### Language Tooling

#### Language Servers (LSPs)
- [x] Nix: nil LSP installed (VS Code + Helix)
- [x] Rust: rust-analyzer (VS Code extension)
- [x] Helix LSP support enabled (`home/editor/helix`)
- [ ] Python: pyright or pylsp
- [ ] JavaScript/TypeScript: tsserver
- [ ] Go: gopls
- [ ] C/C++: clangd
- [x] Per-project LSP via devShells (NixOS pattern)
- [x] Editor integration: VS Code + Helix configured
- [ ] NixOS-specific: direnv + nix-shell for library paths

#### Debuggers
- [ ] GDB installed (C/C++ debugging)
- [ ] LLDB installed (alternative C/C++, Rust)
- [ ] Python: pdb or debugpy (VS Code integration)
- [ ] Go: delve debugger
- [x] VS Code debugging support (Remote SSH, Remote Containers extensions)
- [ ] Remote debugging for containers/servers

#### Build Systems
- [x] CMake (VS Code CMake + CMake Tools extensions)
- [ ] Make installed (universal)
- [ ] Ninja installed (fast builds, CMake backend)
- [ ] Meson installed (Python-based, growing adoption)
- [ ] Per-project build system in devShell

#### Package Managers (Per-Language)
- [x] npm (Node.js - `home/terminal/programs/nodejs.nix`)
- [x] pdm (Python - custom package in `packages/default.nix`)
- [ ] Python: pip + venv (standard approach)
- [ ] Python: poetry consideration (better dependency management)
- [ ] JavaScript: pnpm recommended (faster, smaller)
- [ ] Rust: cargo (built-in, via devShells)
- [ ] Go: go modules (built-in, via devShells)
- [x] Per-project tools via NixOS devShells pattern

### Infrastructure Tools
- [x] git configured (`home/terminal/programs/git.nix`)
- [x] Modern CLI tools: ripgrep, bat, eza, jq
- [ ] Database tools: psql, redis-cli, etc.
- [ ] API testing: httpie, curl, postman alternatives
- [ ] Network debugging: wireshark, tcpdump
- [ ] SSH agent systemd service (cache passphrases)
- [ ] SSH keys per-service (GitHub, servers, work)
- [ ] Ed25519 keys (modern, fast, secure)

---

## Gaming Infrastructure

### Game Platforms

#### Steam & Proton
- [x] Steam installed (`system/programs/gaming/steam.nix`)
- [x] Gamescope session enabled
- [x] gamemode integrated as extraPkg
- [x] Steam user config (8 shader background threads in `home/programs/steam.nix`)
- [x] Remote Play firewall rules
- [x] Local network game transfers firewall rules
- [ ] Proton enabled for all titles (Settings → Compatibility)
- [ ] Per-game Proton version selection
- [ ] Proton Experimental for latest fixes
- [ ] Proton GE (Glorious Eggroll) for community fixes
- [ ] ProtonDB checking before game purchase
- [ ] DLSS support validation (some games via Proton)
- [ ] Ray tracing testing (works but performance varies)
- [ ] Steam Input for controller support

#### Other Stores & Launchers
- [x] umu-launcher installed (`system/programs/gaming/umu.nix` - unified launcher)
- [x] Wine Stable (WoW packages - system-wide)
- [x] winetricks available
- [x] Heroic Launcher installed (`system/programs/gaming/default.nix` - GOG + Epic)
- [x] Heroic window rules configured (immediate tearing mode in Hyprland)
- [ ] Lutris (NOT FOUND)
- [ ] Wine-GE for non-Steam games
- [ ] EAC anti-cheat compatibility (Fortnite, etc.)

### Gaming Enhancements

#### Performance Optimization
- [x] Gamemode daemon installed and enabled (`system/programs/gaming/default.nix`)
- [x] Steam integration configured (extraPkg)
- [x] Screen saver inhibit disabled in gamemode (0)
- [ ] Non-Steam games: gamemoderun wrapper testing
- [ ] CPU governor → performance during gaming
- [ ] Process priority boost (nice -10)
- [ ] GPU overclocking (optional, via gamemode)

#### Performance Monitoring
- [x] MangoHud installed (`home/programs/mangohud.nix`)
- [x] Per-game MangoHud enable/disable (via Steam launch options or `mangohud` prefix)
- [x] Custom MangoHud config (FPS, frametime graph, GPU temp, power, load)
- [x] Keybinding for overlay toggle (Shift+F12)
- [x] CPU/GPU bottleneck identification (overlay shows both CPU and GPU stats)
- [x] Thermal throttling detection (GPU temp monitoring with color thresholds)
- [x] Frame pacing analysis (frametime graph with 1-frame timing)

#### Visual Enhancement (Optional)
- [ ] vkBasalt for post-processing (CAS sharpening, SMAA/FXAA)
- [ ] Per-game vkBasalt configuration
- [ ] Decision: Use only for specific games with blurry TAA

#### Compatibility Layer
- [x] Gamescope available (Steam session configured)
- [ ] Custom resolution support (5120x2160 ultrawide)
- [ ] FSR upscaling for games without native support
- [ ] Proper fullscreen handling

### Controller Support
- [x] Xbox controller plug-and-play (xpad driver in kernel 6.12.54)
- [x] PS5 controller Bluetooth support (hid-playstation driver in 6.12.54)
- [x] Switch Pro controller support (hid-nintendo driver in 6.12.54)
- [ ] Steam Input configuration
- [ ] Per-game controller remapping
- [ ] Gyro support (PS5/Switch controllers)
- [ ] Wired vs Bluetooth latency testing
- [ ] Controller firmware updates (via Steam)

### Shader & Cache Management
- [x] Shader background threads configured (8 in Steam config)
- [ ] Shader pre-compilation validation (Steam does this)
- [ ] Shader cache location and management
- [ ] DXVK state cache
- [ ] Pipeline cache
- [ ] Cache backup strategy (some caches are large)

---

## Multimedia & Content

### Video Playback

#### Player & Configuration
- [x] MPV installed (`home/programs/media/mpv.nix`)
- [x] MPV config: profile=gpu-hq configured
- [x] MPV mpris script for media control
- [ ] MPV config: hwdec=auto validation (hardware decode)
- [ ] MPV config: vo=gpu validation (GPU rendering)
- [ ] Keyboard shortcuts (j/k seek, [ ] speed control)
- [ ] VLC as fallback (easier GUI, slightly worse performance)

#### Hardware Acceleration
- [x] Intel media driver (VAAPI - `system/hardware/intel-tigerlake.nix`)
- [x] intel-compute-runtime (OpenCL)
- [x] vpl-gpu-rt (Intel VPL)
- [x] libva-utils (vainfo for testing)
- [ ] NVDEC (NVIDIA) for H.264, HEVC, AV1, VP9
- [ ] Intel Quick Sync validation (should work with Intel media driver)
- [ ] Preference: NVDEC on AC/gaming, Quick Sync on battery
- [ ] Hardware decode testing (check CPU usage during 4K video)

#### Codec Support
- [x] ffmpegthumbnailer for video thumbnails
- [ ] H.264 support (universal video)
- [ ] HEVC (H.265) support (4K videos)
- [ ] AV1 support (YouTube, next-gen)
- [ ] VP9 support (YouTube, older)
- [ ] AAC audio support
- [ ] Opus audio support (Discord, voice chat)
- [ ] ffmpeg-full installed (all codecs)
- [x] Unfree packages allowed (NVIDIA driver requires this)

#### HDR & Quality
- [ ] HDR tone-mapping to SDR displays
- [ ] MPV auto-detect HDR content
- [ ] Display brightness-aware tone-mapping

### Screen Capture & Streaming

#### OBS Studio
- [ ] OBS Studio installed (NOT FOUND)
- [ ] NVENC H.264 encoder configured (RTX 3080 hardware encode)
- [ ] 1080p60 recording profile (quality/size balance)
- [ ] Separate audio tracks (mic, desktop audio)
- [ ] Scene system configured (webcam, screen, overlays)
- [ ] Noise suppression plugin
- [ ] Virtual camera for video calls
- [ ] Streaming profiles (Twitch, YouTube)
- [ ] Recording for bug reproduction
- [ ] Gaming highlights clipping

#### Wayland Screen Sharing
- [x] pipewire installed and running (`system/services/pipewire.nix`)
- [x] ALSA, JACK, PulseAudio compatibility
- [x] 32-bit support for Steam/Wine
- [x] rtkit enabled for real-time priority
- [x] pavucontrol (volume control GUI)
- [x] xdg-desktop-portal configured (`system/programs/xdg.nix`)
- [x] xdg-desktop-portal-hyprland from Hyprland flake
- [ ] Browser screen sharing testing (Google Meet, Zoom)
- [ ] OBS pipewire source for screen capture
- [ ] Discord screen sharing validation
- [ ] Per-window vs full-screen sharing

### Image Handling
- [ ] Image viewer installed (imv for Wayland)
- [ ] Basic image editing (GIMP if needed)
- [ ] Screenshot annotation (swappy)
- [ ] Image format support (jpg, png, webp, svg)
- [ ] Quick image preview in file manager

---

## Connectivity & Networking

### Network Management

#### WiFi & Ethernet
- [x] NetworkManager installed (`system/network/default.nix`)
- [x] DNS: systemd-resolved
- [x] WiFi power save enabled
- [ ] nm-applet in system tray (GUI network control)
- [x] WiFi 6E support (Intel AX210 - 2.4/5/6 GHz tri-band)
- [ ] Auto-connect to known WiFi networks
- [ ] Connection profiles saved (WiFi passwords)
- [ ] Prefer Ethernet when available (lower latency, higher bandwidth)
- [x] 2.5GbE Ethernet available (Intel I225-V controller)
- [ ] Seamless WiFi ↔ Ethernet transition
- [ ] Thunderbolt dock Ethernet passthrough

#### VPN
- [ ] VPN integration in NetworkManager
- [ ] WireGuard support
- [ ] OpenVPN support
- [ ] Commercial VPN support (NordVPN, etc.)
- [ ] VPN on-demand (work networks)
- [ ] Kill switch (block traffic if VPN drops)

### Bluetooth

#### Core Functionality
- [x] Bluetooth manager installed (blueman - `system/hardware/bluetooth.nix`)
- [x] bluez5-experimental
- [x] blueman-applet (home service)
- [x] Power on boot: true
- [ ] Auto-connect to known devices
- [ ] A2DP high-quality audio to headphones/speakers
- [ ] HFP/HSP headset mode (mic + audio for calls)
- [x] LE Audio (LC3 codec) support (kernel 6.12.54 ✓)
- [ ] Dual-mode switching (A2DP for music, HSP for calls)

#### Reality Check
- [ ] Bluetooth audio quality degradation in call mode (this is Bluetooth limitation)
- [ ] Recommendation: Wired headset for calls, Bluetooth for music
- [ ] Latency testing for gaming (Bluetooth not ideal for competitive)

### Thunderbolt
- [x] Bolt daemon for Thunderbolt authorization (`system/hardware/thunderbolt.nix`)
- [x] Auto-authorize known devices (Lenovo ThinkPad Thunderbolt 4 Workstation Dock - DK2131)
- [ ] Ask for new/unknown Thunderbolt devices
- [ ] Security: DMA attack prevention via authorization

### SSH Server (Optional)

#### Configuration (if enabled)
- [x] SSH server installed and running (`system/services/ssh.nix`)
- [x] OpenSSH enabled
- ⚠️ PermitRootLogin: yes (SECURITY RISK - should disable)
- [ ] Key-only authentication (password auth disabled)
- [ ] Non-standard port (not 22, reduces automated attacks)
- [ ] Firewall rules (LAN only, not internet-facing)
- [ ] fail2ban installed (auto-ban after failed attempts)
- [ ] Disable when traveling (untrusted networks)

#### Use Cases
- [x] Remote file transfer capability (scp, rsync available)
- [x] Remote debugging from desktop (SSH server running)
- [ ] "Work from couch" while laptop docked

### Communication & Browsers

#### Web Browsers
- [x] Firefox installed (`home/programs/firefox/default.nix`)
- [ ] Firefox hardware acceleration enabled (VAAPI flags)
- [ ] Chromium installed as fallback (NOT FOUND)
- [ ] Browser extensions (uBlock Origin, Bitwarden, etc.)

#### Messaging & Communication
- [x] Webcord (Discord client - in `host/t15g2/nixosConfiguration.nix`)
- [x] Slack (`home/programs/slack.nix`)
- [x] Mattermost (`home/programs/slack.nix`)
- [x] Zoom (`home/programs/zoom.nix`)
- [ ] Signal (secure messaging - NOT FOUND)
- [ ] Email client (Thunderbird, or web-based)
- [ ] Video call testing (Google Meet, Zoom, Teams)
- [ ] Webcam working (camera toggle for privacy)
- [x] Microphone mute key configured (XF86AudioMicMute)
- [ ] Microphone mute LED indicator validation

---

## Security & Privacy

### Authentication & Secrets

#### Password Manager
- [x] bitwarden-cli installed
- [x] Bitwarden GUI installed (`home/programs/bitwarden.nix`)
- [x] Custom Bitwarden server: vault.james-sweet.com
- [x] gnome-keyring configured (home service)
- [x] Seahorse (keyring GUI - `system/services/seahorse.nix`)
- [ ] Browser extension installed (auto-fill passwords)
- [ ] Strong master password (diceware passphrase)
- [ ] 2FA enabled where possible (TOTP in Bitwarden)
- [ ] Hardware keys (YubiKey) for critical accounts
- [ ] Auto-lock timeout (15 minutes idle)
- [ ] Never reuse passwords
- [ ] Password generator for new accounts

#### SSH Key Management
- [ ] ssh-agent systemd service (cache passphrases once per session)
- [ ] Per-service SSH keys (GitHub, servers, work - separate and revocable)
- [ ] Ed25519 algorithm (modern, fast, secure - not RSA 2048)
- [ ] Passphrase-protected keys (laptop theft doesn't compromise keys)
- [ ] Keys added to agent at login
- [ ] ssh-agent integration with terminals

#### GPG Key Management
- [ ] GPG key generated for git commit signing
- [ ] Git configured to sign commits
- [ ] Master key backed up (paper backup or YubiKey)
- [ ] Subkeys for daily use (revocable without revoking master)
- [ ] Key expiration dates (must renew to prove control)
- [ ] File encryption capability (sensitive docs)
- [ ] Email encryption (PGP email if needed)

#### Privilege Escalation
- [x] Polkit agent (hyprpolkitagent) configured in Hyprland
- [x] GUI password prompts for elevated operations
- [x] Software updates, disk management work correctly

### System Security

#### Firewall
- [ ] Firewall enabled (firewalld or nftables)
- [ ] Default deny incoming connections
- [ ] Allow outgoing connections
- [ ] Explicit allows for needed services (SSH if enabled)
- [ ] Docker port handling (Docker bypasses some firewalls)
- [ ] LAN vs internet rules (more restrictive for public WiFi)
- [ ] Firewall GUI (firewalld has firewall-config)

#### Network Security
- [ ] fail2ban installed (if running SSH server)
- [ ] Auto-ban after failed login attempts
- [ ] fail2ban monitoring of SSH, if enabled
- [ ] VPN for untrusted networks (coffee shop WiFi)

#### Device Security
- [ ] USB device authorization policy
- [ ] Thunderbolt authorization (already configured via bolt)
- [ ] Auto-lock on idle (already configured via hypridle)
- [ ] Encrypted swap (LUKS, already configured)
- [ ] ZFS encryption consideration (performance cost)

#### Optional Hardening
- [ ] AppArmor profiles for critical apps
- [ ] SELinux (more complex, optional)
- [ ] Kernel hardening flags
- [ ] Disable unused services

---

## System Monitoring & Maintenance

### Monitoring Tools
- [x] System resource monitoring: btop installed
- [x] GPU monitoring: nvtop (full package with NVIDIA + Intel support)
- [x] Disk usage: duf installed
- [x] Temperature sensors: lm_sensors configured
- [x] ACPI monitoring tools
- [x] nvme-cli for NVMe SSD monitoring
- [x] smartmontools for SMART data
- [ ] powertop (power consumption analysis)
- [ ] turbostat (CPU frequency/C-state monitoring)
- [ ] s-tui (stress testing with monitoring)
- [ ] Network monitoring tools (iftop, nethogs, etc.)
- [ ] ZFS pool health monitoring automation (scrubs, SMART data, alerts)

### Backup & Recovery
- [ ] ZFS snapshot automation (sanoid/syncoid)
- [ ] External backup strategy
- [ ] System state backups

---

## Quality of Life

### Fonts
- [ ] Programming fonts (JetBrains Mono, Fira Code, Iosevka)
- [ ] System fonts (good rendering for UI)
- [ ] Emoji support

### Theming
- [x] Qt theming configured (`system/programs/qt.nix`)
- [x] Qt5/Qt6 theme tools (qt5ct, qt6ct) installed
- [ ] GTK/Qt theme consistency (tools installed, needs user configuration)
- [ ] Cursor theme
- [ ] Icon pack
- [ ] Dark/light mode switching

### Printing
- [ ] CUPS
- [ ] Printer drivers for specific hardware

---

## Firmware & Updates

### System Firmware
- [x] fwupd enabled (`system/hardware/fwupd.nix`) for UEFI, Thunderbolt, WiFi firmware
- [x] Intel microcode updates enabled automatically
- [x] NVIDIA driver: proprietary 580.95.05 with automatic updates via nixpkgs
- [x] thinkpad_acpi kernel module for ThinkPad-specific features

### Data Integrity
- [ ] Automated regular ZFS scrubs (manual currently)
- [x] SMART monitoring tools: smartmontools and nvme-cli installed
- [ ] Automated battery health monitoring and trending
- [x] Manual battery health check via acpi/upower

---

## Mobile/Portable Features

### Location & Time
- [ ] Automatic timezone detection
- [ ] Location services (geoclue)

### Battery
- [ ] Battery statistics/history tracking and graphs
- [ ] Low battery warning notifications
- [x] Charge threshold management: TLP configured with 75-90% thresholds

---

## Priority Areas for T15G2

### Critical (Must Have)
- [x] NVIDIA + Wayland stability: proprietary driver 580.95.05 with nvidia-drm.modeset=1
- [x] Dual-GPU power management: PRIME offload mode configured (iGPU default, dGPU on-demand)

**Note:** GPU stays at P3-P8 (~12-14W idle) - cannot fully power off due to NixOS PRIME offload design requiring nvidia-drm driver loaded. This is better than sync mode and acceptable for desktop replacement use.

### High Priority
- [ ] Gaming stack (Steam + Proton + gamemode + MangoHud)
- [ ] Development containers (Docker with NVIDIA runtime for ML/CUDA work)
- [x] Display hotplug (Thunderbolt dock with ultrawide) - SOLVED: AQ_DRM_DEVICES + VRR disabled

### Medium Priority
- [ ] Screen recording/sharing for development (OBS + pipewire)
- [ ] Backup automation (ZFS snapshots + external backup)

---

## Implementation Roadmap

This checklist represents **440+ configuration items** across 14 functional areas. Implementation should be prioritized by impact and dependencies.

### Phase 1: Essential Desktop Experience (Weeks 1-2)

**Desktop Environment - High Impact**
1. ✅ Install and configure waybar (status bar with battery, time, system stats) - COMPLETE
2. ✅ Install notification daemon (dunst) - COMPLETE
3. ✅ Configure screenshot tools (grimblast + keybindings) - COMPLETE (commit d32f748)
4. ✅ Install clipboard manager (clipse + Super+V keybinding) - COMPLETE (commit d32f748)
5. ✅ Configure function keys with OSD (swayosd for volume, brightness feedback) - COMPLETE (commit d32f748)

**Display Management - Daily Workflow**
6. Configure automatic display hotplug detection
7. Test and validate workspace persistence (workspaces 6-10 on ultrawide)
8. Set up display profiles for different contexts (docked, mobile)

**Input Devices - Quality of Life**
9. Configure touchpad gestures (two-finger scroll, three-finger workspace switching)
10. Tune TrackPoint sensitivity and middle-button scrolling
11. Set up keyboard backlight auto-timeout

### Phase 2: Development Environment (Weeks 3-4)

**Containers & Virtualization**
12. Install NVIDIA container toolkit and test GPU in Docker
13. Set up distrobox with Ubuntu container for FHS compatibility
14. Create Windows 11 VM for testing (libvirt + virt-manager)

**Language Tooling**
15. Configure per-project LSPs via devShells
16. Install common build systems (make, cmake, ninja, meson)
17. Set up debugger integration (GDB, LLDB)

**File Management**
18. ✅ Install Dolphin file manager with KDE Plasma 6 - COMPLETE (commit 83f8480)
19. ✅ Configure archive handling (ark + file-roller) and thumbnails (allmytoes) - COMPLETE (commit 83f8480)
20. ✅ Set up GVFS + kio-extras for network filesystem access - COMPLETE (commit 83f8480)

### Phase 3: Gaming & Multimedia (Week 5)

**Gaming Infrastructure**
21. Install Steam and enable Proton for all titles
22. Install gamemode daemon (auto-activated by Steam)
23. ✅ Install MangoHud for performance monitoring - COMPLETE (current commit)
24. ✅ Install Heroic Launcher (GOG + Epic games) - COMPLETE
25. Configure Hyprland window rules for auto-GPU-offload

**Multimedia**
26. Install and configure MPV with hardware acceleration
27. Install OBS Studio with NVENC encoding
28. Set up full codec support (ffmpeg-full)
29. Test Wayland screen sharing (xdg-desktop-portal-hyprland)

### Phase 4: Security & Connectivity (Week 6)

**Security**
30. Install Bitwarden desktop app with browser extension
31. Set up firewall (firewalld with default deny)
32. Configure SSH keys (Ed25519, per-service)
33. Set up GPG for git commit signing

**Networking**
34. Verify NetworkManager and nm-applet configuration
35. Install blueman for Bluetooth management
36. Test VPN integration (WireGuard/OpenVPN)
37. Configure fail2ban if SSH server enabled

### Phase 5: System Maintenance (Week 7)

**Monitoring & Backups**
38. Install remaining monitoring tools (powertop, turbostat, s-tui)
39. Configure ZFS snapshot automation (sanoid/syncoid)
40. Set up ZFS scrub scheduling (monthly)
41. Configure SMART monitoring with alerts

**Optimization**
42. Benchmark and validate all hardware acceleration
43. Test thermal performance under load
44. Validate battery life on full charge
45. Document any hardware-specific quirks

### Phase 6: Polish & Advanced Features (Week 8+)

**Advanced Configuration**
46. Per-display color calibration (if needed)
47. Custom power profiles for specific workloads
48. Advanced Hyprland customization
49. Cloud storage integration (if needed)
50. GPU passthrough experimentation (if desired)

### Quick Wins (Can Do Anytime)

These are high-value, low-effort items that can be done immediately:
- [ ] Install missing monitoring tools (powertop, turbostat, s-tui) - 5 minutes
- [ ] Add Hyprland window rules for auto-GPU-offload - 10 minutes
- [x] ~~Install file manager (Dolphin)~~ - ✅ COMPLETE (commit 83f8480)
- [x] ~~Install screenshot tool (grimblast)~~ - ✅ COMPLETE (commit d32f748)
- [x] ~~Install clipboard manager (clipse)~~ - ✅ COMPLETE (commit d32f748)
- [x] ~~Install MangoHud for gaming performance monitoring~~ - ✅ COMPLETE (current commit)
- [x] ~~Install Heroic Launcher for GOG/Epic games~~ - ✅ COMPLETE

### Validation Testing

After each phase, validate with:
1. **Power testing:** Battery life on typical workload (target: 4+ hours)
2. **Display testing:** Hotplug cycle (plug/unplug dock 5 times)
3. **Gaming testing:** Launch game, check FPS, thermals, GPU usage
4. **Development testing:** Build project in container, check LSP works
5. **Multimedia testing:** Play 4K video, check hardware decode (CPU <10%)

### Notes on Implementation

- **Don't rush:** This is 8+ weeks of configuration at a sustainable pace
- **Test incrementally:** After each change, verify it works before moving on
- **Document issues:** Track what doesn't work in issues.md
- **Version control:** Commit after each working phase
- **Backup before major changes:** ZFS snapshot before significant system changes

### Reference Documents

For implementation details, refer to:
- **Best practices:** `docs/T15G2/optimal-configuration-best-practices.md`
- **Current state:** `docs/T15G2/power-thermal-audit-FINAL.md`
- **Hardware specs:** `docs/T15G2/hardware-specifications.md`

---

*System: Lenovo ThinkPad T15g Gen 2i (20YTS0EV00)*
*NixOS Configuration: /home/omegaice/.config/nixpkgs*
