# T15G2 Optimal Configuration - Best Practices Guide

**System:** Lenovo ThinkPad T15g Gen 2i (20YTS0EV00)
**Use Case:** Desktop Replacement, Development Workstation, Gaming Machine

---

## Overview

This guide outlines best practices and optimal configuration choices for each functional area of the T15G2 system. The philosophy throughout: **Automation where possible, visibility where needed, defaults that work.**

Each section considers:
1. What optimal configuration looks like
2. Why these choices matter for your specific use case
3. Trade-offs and decision points
4. When to implement vs skip

---

## Display Management - Philosophy: Seamless Adaptation

### Hotplug Handling (LG Ultrawide via Thunderbolt)

**The Goal:** Plug in dock, displays configure automatically. Unplug, laptop display takes over. Zero manual intervention.

**Best Practice:**
- **Workspace persistence:** When you plug in external display, workspaces 6-10 should automatically move there. When you unplug, those workspaces should migrate to the internal display (not disappear).
- **Resolution and refresh rate detection:** System should auto-select highest supported resolution and refresh rate. Your ultrawide supports 72Hz - use it.
- **Display ordering:** Primary display should be the one you're actively using. When docked, ultrawide is primary. When mobile, laptop is primary.
- **Notification of connection:** Brief, non-intrusive notification that displays were reconfigured. Helps confirm hotplug worked.

**Why This Matters:** You mentioned this is a desktop replacement. The flow of "arrive at desk, plug in one cable, everything works" vs "arrive at desk, plug in cable, manually configure displays, move windows" is the difference between 5 seconds and 2 minutes of workflow disruption, multiple times per day.

**Edge Cases to Handle:**
- Dock plugged in while system is suspended (should configure on wake)
- Dock plugged in while system is locked (should configure but not unlock)
- Multiple display configurations (dock at home, dock at office, just laptop)

### Color Management & ICC Profiles

**The Goal:** Colors look consistent and accurate across displays.

**Reality Check:** Your displays have different characteristics:
- Internal: 15.6" IPS, ~99% sRGB
- External: 49" IPS ultrawide

**Best Practice:**
- **Per-display profiles:** Each display should have its own color profile. Hardware calibration is ideal but software profiles are good enough for development work.
- **sRGB as baseline:** Web development? sRGB is what most users see. Keep this as your reference.
- **Night mode consideration:** Color profiles conflict with night light/blue light filters. They're solving the same problem differently. Choose one approach.

**When You Care:**
- Photo/video editing: Accurate colors critical
- Web development: Consistent colors important
- Terminal/code: Colors barely matter, readability matters

**Recommendation for Your Use Case:** Basic color management is enough. You're doing development and gaming, not color-critical creative work. Standard sRGB profiles and consistent brightness matter more than precise calibration.

### VRR (Variable Refresh Rate) & HDR

**VRR Philosophy:** Eliminates tearing without the input lag of traditional VSync. Critical for gaming, nice for desktop.

**Best Practice:**
- **Always enabled on gaming display:** Your ultrawide supports VRR. Enable it system-wide, games will benefit automatically.
- **Per-application control:** Desktop apps don't need VRR. Games do. Let Wayland/Hyprland handle this automatically.
- **Frame rate consideration:** VRR is most noticeable when frame rates vary (40-72Hz). For steady 60fps or 72fps, benefit is minimal.

**HDR Philosophy:** Better contrast and color range, but ecosystem is immature on Linux.

**Reality Check for 2025:**
- HDR on Wayland is experimental
- Most content isn't HDR
- Color management conflicts with HDR
- Games with HDR support on Linux are rare

**Recommendation:** Enable VRR (mature, works well, gaming benefit). Skip HDR (immature, marginal benefit, compatibility issues). Revisit HDR in 2026-2027.

### Per-Display Scaling

**The Problem:**
- Internal: 1920x1080 at 15.6" = 141 DPI
- External: 5120x2160 at 49" = 103 DPI (estimated)

These are close enough that you might not need scaling. But if text feels too small on the ultrawide or too large on the laptop:

**Best Practice:**
- **Fractional scaling on Wayland works well now.** 1.0x for ultrawide, 1.25x for laptop would equalize perceived size.
- **But:** Fractional scaling has performance cost (rendering at higher res, then downscaling). On your RTX 3080, this is negligible.
- **Test without scaling first.** You might find the DPI difference acceptable. Many users prefer more screen real estate on larger displays.

**Recommendation:** Start with no scaling (1.0x both displays). If ultrawide text is too small, scale laptop to 1.25x instead of scaling ultrawide up. Reason: You have more pixels on ultrawide; use them.

---

## Input Devices - Philosophy: Muscle Memory and Predictability

### Touchpad Gestures

**The Goal:** Gestures should match user expectations from years of laptop use.

**Critical Gestures (in priority order):**
1. **Two-finger scroll** - This is the most used gesture. Must be smooth, natural speed, no accidental palm touches.
2. **Two-finger right-click** - Standard for contextual menus.
3. **Pinch to zoom** - Nice for web browsing, maps, but only works in apps that support it.
4. **Three-finger swipe for workspace switching** - This is transformative for workflow. Swipe left/right to change workspaces feels natural.
5. **Four-finger swipe for showing all windows** - macOS has this, it's useful but less critical.

**Configuration Philosophy:**
- **Sensitivity:** Gentle touch should work. Don't require firm pressure.
- **Palm rejection:** Critical on a laptop. Palms touching while typing shouldn't trigger clicks/movements.
- **Tap to click:** Personal preference. Some love it (speed), some hate it (accidental clicks). Should be user configurable with sane default (enabled).
- **Natural scrolling:** macOS style (swipe down, content moves down) vs traditional (swipe down, viewport moves down). User preference, but natural scrolling is becoming standard.

**For ThinkPad Specifically:**
- Your touchpad is probably good but not great (ThinkPads prioritize TrackPoint).
- Lower sensitivity than a MacBook is typical and expected.
- Gestures might be more important for you since TrackPoint is alternative.

### TrackPoint Configuration

**The Philosophy:** ThinkPad's secret weapon. Divisive - users either love it or never touch it.

**Best Practice:**
- **Enable both TrackPoint and touchpad simultaneously.** Some users disable touchpad when using TrackPoint to prevent accidental palm touches. Others use both depending on context.
- **Sensitivity (speed):** TrackPoint requires higher sensitivity than touchpad. Default is usually too slow. Bump it up 50-100%.
- **Scrolling:** Middle button + TrackPoint for scrolling is incredibly efficient once learned. Enable this.
- **Acceleration:** Light pressure = slow, precise. Firm pressure = fast movement. This should be enabled.

**When to Use Each:**
- **TrackPoint:** Precise cursor positioning (clicking small buttons, text selection). Hands stay on home row.
- **Touchpad:** Gestures (workspace switching, zooming). Large movements.

**Recommendation:** Configure both well. Let user choose based on task. For development work, TrackPoint excels. For browsing/general use, touchpad with gestures is better.

### Keyboard Backlight

**The Goal:** See keys in the dark. Don't waste battery when not needed.

**Best Practice:**
- **Auto-off after 30 seconds of no typing.** You're not looking at keyboard when typing (touch typing). You look when you pause.
- **Instant-on with keystroke.** When you touch any key, backlight activates. No delay.
- **Brightness levels:** ThinkPads typically have 2-3 levels. Low is enough for dim rooms. Medium for dark rooms. Off for daylight.
- **Remember last setting.** If user sets it to medium, stay at medium when it turns back on.
- **Disable entirely on AC (optional).** If you're at a desk, you probably have enough light. Battery matters more on the go.

**Function Key Philosophy:**
- Hardware keys (Fn+Space for backlight on ThinkPads) should always work.
- Software should complement, not replace hardware keys.

### Function Key Bindings

**The Critical Ones (Must Work Without Thinking):**
1. **Brightness up/down (Fn+F5/F6)** - Already working for you ✓
2. **Volume up/down/mute** - Instant audio control
3. **Mic mute** - Critical for video calls. Should have LED indicator.
4. **Screen blank** - Quick privacy when walking away from desk

**Secondary Functions:**
5. **WiFi toggle** - Quick airplane mode
6. **Bluetooth toggle** - Disable when not needed (battery)
7. **Camera toggle** - Privacy (if hardware switch not present)

**Best Practice:**
- **Instant response.** No perceptible lag between key press and action.
- **Visual feedback.** On-screen display (OSD) showing volume level, brightness level. Should fade after 2 seconds.
- **LED indicators.** Mic mute and airplane mode should have physical LED indicators (ThinkPads usually do).
- **No accidental triggers.** Fn key should be distinct enough not to press accidentally.

**ThinkPad-Specific:**
- **Fn lock:** Some ThinkPads let you swap Fn key behavior (press F5 for brightness vs Fn+F5). This is personal preference. Default should be Fn+F5 (explicit).
- **Function key priority:** Fn-as-modifier vs function-as-default. For developers, function keys (F1-F12) as default is better (debugging, IDE shortcuts). For general users, media keys as default is better.

### OSD Implementation

**Decision: swayosd**

After considering alternatives (standalone tools like avizo, or integrated solutions like AGS):

**Why swayosd:**
- **Home Manager native:** Built-in `services.swayosd` module exists
- **GTK3-based:** Visual consistency with Waybar (same toolkit)
- **Minimal config:** 5 lines of Nix for complete functionality
- **Zero friction:** No custom module creation needed
- **Wayland-native:** Purpose-built for Wayland compositors

**Configuration:**
```nix
services.swayosd = {
  enable = true;
  topMargin = 0.9;  # 90% from top (near status bar)
  stylePath = null;  # Default GTK styling
};
```

**Integration:**
- All volume/brightness/mute keybindings use `swayosd-client`
- Instant visual feedback on all function key actions
- Default styling "looks good" without customization

**Result:** OSD functionality complete in ~30 minutes from decision to working implementation. This exemplifies "defaults that work" philosophy.

---

## Desktop Environment Essentials - Philosophy: Information Without Distraction

### Notification Daemon

**The Goal:** Be informed of important events. Don't be interrupted by unimportant noise.

**Notification Priority Philosophy:**
1. **Critical:** System issues (disk full, battery critical). Should be intrusive - sound, persistent display, blocks other notifications.
2. **Important:** Messages from people, calendar reminders, build failures. Should be visible but dismissable.
3. **Normal:** Background task completion, system updates available. Should be visible but shouldn't interrupt.
4. **Low:** Media player state, volume changes. Should be transient (fade quickly).

**Best Practice:**
- **Position:** Top-right is standard. Less disruptive than center. Bottom notifications conflict with taskbars.
- **Duration:** 5 seconds for normal, 10 seconds for important, indefinite for critical (must dismiss).
- **Do Not Disturb mode:** When presenting, gaming, or in full-screen, suppress non-critical notifications.
- **History:** Keep dismissed notifications available. You might ignore a build notification, then later think "did it finish?"
- **Action buttons:** "View", "Dismiss", "Remind me in 10 min" are useful for important notifications.

**Per-Application Control:**
Some apps over-notify. You should be able to:
- Disable notifications entirely for an app
- Set default priority for an app's notifications
- Set DND mode to allow only specific apps (e.g., calendar, messages)

**For Your Use Case:**
- **Development:** Build completion notifications are important. Syntax errors, less so (you'll see them in editor).
- **Gaming:** Suppress everything when full-screen game is running.
- **General:** System health (thermals, battery) should always show.

**Recommendation:** Mako or Dunst. Both are lightweight, flexible, well-integrated with Wayland. Mako is more modern but Dunst has more configuration options. Start with Mako.

### Status Bar (Waybar)

**The Philosophy:** Glanceable information for system health and workflow context.

**Critical Information (Always Visible):**
1. **Battery percentage and charging status** - On a laptop, this is non-negotiable. Icon should show charging state (AC, battery, percentage).
2. **Current workspace** - You need to know where you are. Numbers (1-10) or icons.
3. **Time** - Surprisingly important. Knowing "it's 5:47pm" helps time-awareness.
4. **Audio status** - Volume level, muted state. Muted microphone indicator is important for video calls.

**Important Information (Visible on Hover or Secondary Display):**
5. **Network status** - WiFi signal strength, VPN active. Ethernet connection (when docked).
6. **System resources** - CPU temperature (thermal throttling awareness), Memory usage (before OOM killer strikes).
7. **Active window title** - Helps identify which window is focused in multi-window setup.

**Optional But Useful:**
8. **Media player info** - Current song, play/pause. Integration with Spotify/YouTube.
9. **Notifications indicator** - "You have 3 unread notifications."
10. **System tray** - Some apps need tray icons (Bitwarden, Dropbox, etc.).

**Layout Philosophy:**
- **Left side:** Workspace indicator, active window title
- **Center:** Clock, date
- **Right side:** System status (network, audio, battery, temperature)

**For Dual-Display Setup:**
- **Both displays should have their own bar.** Seeing battery on the ultrawide is still useful.
- **Or:** Primary display has full bar, secondary has minimal bar (just workspaces and clock).

**Styling Philosophy:**
- **Minimalist.** Bar should be information-dense but visually quiet. You don't want it drawing attention.
- **Consistent with system theme.** If using dark theme, bar should be dark.
- **Icons vs text:** Icons are space-efficient but require learning. Text is clearer but verbose. Mix: icons for common things (WiFi, battery), text for specifics (workspace numbers, time).

**Recommendation:** Waybar is the standard for Hyprland. Highly customizable, good Hyprland integration, active development.

### Screen Locking & Idle Management

**You already have:** hyprlock + hypridle configured. This is already best practice. Let me validate your configuration choices:

**Screen Dimming (5 min):** Perfect. Signals "system is about to lock" without immediately disrupting.

**Screen Off (10 min):** Good balance. Long enough not to annoy, short enough to save battery.

**Lock Screen (15 min):** This is the security decision. 15 min is reasonable for a home/office environment. For public spaces (coffee shop, airport), 5 minutes is safer.

**Suspend (30 min):** Conservative but wise. Some apps don't handle suspend well (VPN disconnects, SSH connections drop, Docker containers might hiccup). 30 min means you intended to walk away.

**Refinements to Consider:**
- **AC vs Battery profiles:** On AC, longer timeouts (you're at desk). On battery, aggressive timeouts (save power). hypridle doesn't support this natively, but you could have two configurations and switch based on power state.
- **Inhibit when presenting:** Full-screen presentations should prevent idle actions. Same for watching videos.
- **Immediate lock on lid close:** Already configured via logind ✓
- **Unlock behavior:** Face recognition is convenient but security risk. Password is standard. Fingerprint is best balance (ThinkPads often have fingerprint reader).

### Screenshot & Screen Recording

**Screenshot Philosophy:** Fast, flexible, obvious where file went.

**Essential Modes:**
1. **Full screen** - Entire display to file. Keybinding: Print Screen.
2. **Region selection** - Click and drag to select area. Keybinding: Shift+Print Screen.
3. **Active window** - Current window only. Keybinding: Alt+Print Screen.

**Advanced Modes:**
4. **Copy to clipboard instead of file** - Paste directly into chat/document.
5. **Delay (3 seconds)** - Set up the screen, then screenshot captures it.
6. **Annotate immediately** - Screenshot opens in editor to add arrows/text.

**File Management:**
- **Consistent location:** ~/Pictures/Screenshots/ (not ~/screenshot.png in random places)
- **Filename format:** `screenshot_YYYY-MM-DD_HH-MM-SS.png` (sortable, descriptive)
- **Notification with preview:** "Screenshot saved to..." with thumbnail and "Copy path" button.

**Best Tools for Wayland:**
- **grimblast** (grim + slurp wrapper) - Standard choice, works well
- **swappy** - Annotation tool, integrates with grimblast
- **wl-clipboard** - Copy screenshots to clipboard

**Screen Recording Philosophy:**
- **Lightweight for quick demos.** Not movie production.
- **Two use cases:** Local recording (file) vs streaming (Twitch, Discord screen share)

**Best Practice:**
- **Region selection** - Record just the relevant window, not entire 5120px ultrawide with chat/code visible.
- **GPU encoding** - Use NVENC (your RTX 3080) for recording. Zero CPU impact.
- **Format:** MP4 with H.264 is most compatible. WebM for smaller files (web sharing).
- **Audio source control:** System audio, microphone audio, both, or neither.

**For Wayland Screen Sharing:**
This is historically problematic. Modern solution:
- **pipewire** - Handles audio and video routing
- **xdg-desktop-portal-hyprland** - Lets apps request screen sharing
- **Result:** Discord, Zoom, OBS work correctly

**Status:** This should already be configured since you have pipewire. Test it: share screen in Discord or browser-based video call.

### Clipboard Manager

**The Philosophy:** Clipboard history is a massive quality-of-life improvement. You don't realize how often you copy A, copy B, then realize you needed A again.

**Essential Features:**
1. **History (50-100 items)** - Recent clipboard entries, searchable
2. **Persistence** - Survives reboot
3. **Quick access** - Keybinding (Super+V is common) opens menu
4. **Pin favorites** - Important snippets stay at top
5. **Clear history** - Before pasting sensitive data (passwords), clear clipboard

**Security Considerations:**
- **Don't store passwords.** Clipboard managers should detect password managers (Bitwarden) and not store those entries.
- **Clear on lock** - Option to clear clipboard history when screen locks.
- **Sensitive data detection** - Credit cards, API keys shouldn't persist indefinitely.

**Best Tool for Wayland:**
- **cliphist** - Lightweight, Wayland-native, integrates with rofi/wofi for UI.

**Usage Pattern:**
1. Copy multiple things while researching
2. Super+V to open history
3. Search or arrow-keys to select
4. Paste

This becomes muscle memory and dramatically speeds up workflow.

### Color Picker

**The Philosophy:** Developer tool for web/UI work. "What color is that?" should be one click.

**Best Practice:**
- **Keybinding (Shift+Print Screen is common, or Super+Shift+C)**
- **Click anywhere on screen** - Cursor becomes crosshair, click on any pixel
- **Show color in multiple formats:** #RGB, rgb(r,g,b), hsl, hex
- **Copy to clipboard automatically**
- **Visual feedback** - Show picked color as a swatch

**For Your Use Case:**
If you do web development, this is essential. If not, it's rarely used. Low priority.

**Best Tools:**
- **hyprpicker** - Simple, Hyprland-native
- **grim + imagemagick** - More complex but more powerful

### Application Launcher

**You already have:** anyrun configured. This is good. Let me explain why it's optimal:

**Launcher Philosophy:** Fast access to apps and actions. Keyboard-driven.

**Essential Features:**
1. **Fuzzy search** - Type "fire" matches "Firefox"
2. **Learning** - Frequently used apps rank higher
3. **Fast** - Sub-100ms to open, instant search results
4. **More than just apps:** Calculator (type "2+2"), web search (type "? linux tips"), run commands

**anyrun Specifically:**
- **Plugins architecture** - Extensible (apps, shell, calculator, web search)
- **launch-prefix** - Your fork adds enhanced functionality
- **Modern, fast, Wayland-native**

**Alternative Consideration:**
- **rofi (with wayland fork)** - More mature, more themes, but slower and X11-native
- **fuzzel** - Simpler, faster, but fewer features

**Recommendation:** Stick with anyrun. It's optimal for your setup.

---

## File Management - Philosophy: Fast Navigation, Keyboard Priority

### GUI File Manager

**The Philosophy:** Developers spend less time in file managers than general users (we use terminal for most file operations). But when you need a GUI, it should be good.

**Critical Features for Developers:**
1. **Dual pane** - Copy/move between directories efficiently
2. **Keyboard navigation** - Arrow keys, Enter to open, Backspace to go up
3. **Quick preview** - Space bar to preview file (images, text, PDFs)
4. **Tabs** - Multiple directories open simultaneously
5. **Address bar with path** - See and edit full path
6. **Hidden files toggle** - Ctrl+H is standard
7. **Fast startup** - Opening file manager should be instant

**Nice to Have:**
8. **Integrated terminal** - F4 to open terminal in current directory
9. **Custom actions** - Right-click → "Open in VS Code"
10. **Trash integration** - Delete sends to trash, not permanent deletion
11. **Network shares** - Browse SMB/NFS shares

**Best Options:**
- **Dolphin** (KDE) - Feature-rich, Qt-based, works well with Qt theming you have configured
- **Thunar** (XFCE) - Lightweight, simple, GTK-based
- **Nemo** (Cinnamon) - Middle ground, fork of Nautilus with more features
- **Nautilus** (GNOME) - Minimal, opinionated, removed features for simplicity

**Recommendation for Your Use Case:**
**Dolphin** - You have Qt theming configured, Dolphin is most powerful for power users, has dual-pane, integrated terminal, highly configurable. It's "heavy" (KDE app) but on your hardware that's irrelevant.

**Alternative:** Thunar if you want lightweight. But honestly, on 64GB RAM and RTX 3080, "lightweight" is unnecessary optimization.

### Trash Management

**The Philosophy:** Safety net for file operations. rm is permanent, trash is recoverable.

**Best Practice:**
- **GUI file manager deletes should go to trash by default.** Shift+Delete for permanent.
- **CLI commands (rm) should still be permanent.** Don't wrap rm in alias that goes to trash (breaks scripts).
- **Auto-empty after 30 days.** Trash isn't infinite storage.
- **Easy restore** - File manager should have "Restore" option in trash view.

**For Your Use Case:**
You're on ZFS with snapshots. Trash is less critical (you can roll back from snapshots). But it's still good UX for daily workflow.

### Thumbnail Generation

**The Philosophy:** Visual scanning is faster than reading filenames. For directories with images, videos, PDFs, thumbnails are essential.

**Best Practice:**
- **Auto-generate on first view.** When you open a directory with images, thumbnails generate in background.
- **Cache indefinitely.** Regenerating every time is wasteful.
- **Respect file size.** Don't thumbnail a 4GB video file (too slow). Set threshold (50MB).
- **Standard formats:** Images (jpg, png), videos (mp4, mkv), documents (pdf), archives (zip shows content preview on some file managers).

**For Your Use Case:**
Gaming/screenshot directories will have many images. Video editing will have many video files. Thumbnails dramatically improve navigation.

**Implementation:**
Most GUI file managers handle this automatically. Dolphin/Thunar both use `tumbler` daemon for thumbnail generation. Should "just work" when file manager is installed.

### Archive Handling

**The Philosophy:** Archives (.zip, .tar.gz, .7z, .rar) should be transparent. Right-click → Extract. Done.

**Best Practice:**
- **Context menu integration** - Right-click archive → Extract Here / Extract to Folder
- **Preview without extracting** - Open archive like a folder, browse contents
- **Create archives** - Select files → Right-click → Compress
- **All common formats:** zip, tar, tar.gz, tar.xz, tar.bz2, 7z, rar

**Tools:**
- **file-roller** (GNOME) - GUI archive manager
- **ark** (KDE) - More powerful, better preview
- **CLI tools** - zip, unzip, tar, 7z, unrar - need to be installed

**Recommendation:**
Install CLI tools for formats, configure file manager for GUI integration. You'll mostly use CLI (`tar xzf file.tar.gz`) but GUI is nice for exploring unknown archives.

### Remote Filesystem Support (SMB/NFS/SFTP)

**The Philosophy:** Network storage should mount like local storage. Browse in file manager, access from any app.

**Use Cases:**
1. **NAS at home** - Media storage, backups (SMB/NFS)
2. **SSH to servers** - Edit files remotely (SFTP)
3. **Cloud storage** - Google Drive, Dropbox (WebDAV or FUSE)

**Best Practice:**
- **GVFS (GNOME Virtual Filesystem)** - Standard abstraction layer. File managers use this for network mounts.
- **Bookmark common shares** - One-click access to NAS
- **Auto-mount on network availability** - When you connect to home WiFi, NAS share mounts automatically
- **Credentials management** - Store password in keyring (GNOME Keyring / KDE Wallet), not prompted every time

**Protocol Choices:**
- **SMB/CIFS:** Windows shares, most NAS devices. Widely compatible.
- **NFS:** Linux/Unix shares. Better performance, less overhead, but only works with Unix-like systems.
- **SFTP:** SSH-based. Secure, works anywhere with SSH. Slower than SMB/NFS.

**For Your Use Case:**
If you have a NAS: Use SMB for compatibility or NFS for performance.
If SSH to servers: SFTP is built-in (Dolphin/Nautilus can browse `sftp://hostname`)
If cloud storage: Official clients (Google Drive, Dropbox) or rclone for CLI.

**Recommendation:**
Install GVFS, configure file manager for network browsing. You probably already have this via GNOME/KDE integration.

---

## Development Workstation - Philosophy: Isolation, Reproducibility, Performance

### Containerization & Virtualization

**The Core Philosophy:**
Development environments should be:
1. **Isolated** - Project A's Python 3.9 doesn't conflict with Project B's Python 3.11
2. **Reproducible** - "Works on my machine" → "Works in the container, which works everywhere"
3. **Disposable** - Experiment freely, delete, start over
4. **Fast** - Container overhead should be negligible

**Docker vs Podman Decision:**

**Docker:**
- **Pros:** Industry standard, vast image ecosystem, everyone knows it, better documentation
- **Cons:** Requires daemon (root process), less secure design, corporate governance (Docker Inc)

**Podman:**
- **Pros:** Daemonless (more secure), rootless by default, drop-in Docker replacement, Red Hat backed
- **Cons:** Slightly less mature, some edge case compatibility issues, smaller community

**Recommendation:** **Use Docker for now.**
- You're already in the Docker group (existing config)
- Compatibility is critical (some tools assume Docker)
- Performance is identical
- Security concerns are minimal for local development (not running untrusted workloads)

**When to Switch to Podman:**
- If security becomes critical (multi-tenant, running user-provided code)
- If Docker licensing becomes concern (enterprise context)
- For learning (Podman teaches better container concepts)

### NVIDIA Container Runtime

**The Critical Feature:** ML/AI frameworks (TensorFlow, PyTorch, CUDA apps) need GPU access inside containers.

**Best Practice:**
- **nvidia-container-toolkit** - Docker plugin that exposes GPU to containers
- **--gpus all flag** - `docker run --gpus all nvidia/cuda:12.0` gives container access to all GPUs
- **CUDA version matching** - Container's CUDA version should match or be older than host driver. Your 580.95.05 driver supports CUDA 12.6. Most containers want CUDA 11.x or 12.x. You're fine.

**Testing:**
```bash
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi
# Should show your RTX 3080
```

**For Your Use Case:**
If you do ML/AI work, this is essential. If not, it's unused. But it's low-cost to configure (just install toolkit) and high-value when needed.

**Recommendation:** Install nvidia-container-toolkit. Even if not used daily, having the capability is valuable.

### libvirt/QEMU for VMs

**The Philosophy:** Containers are great for Linux workloads. VMs are for everything else (Windows, testing different Linux distros, untrusted code).

**Use Cases:**
1. **Windows VM for testing** - If you build cross-platform software, Windows VM is essential for testing
2. **GPU passthrough for Windows gaming** - Play Windows-only games in VM with near-native performance
3. **Testing different distros** - Try Fedora, Arch without leaving NixOS
4. **Untrusted code execution** - Run sketchy executables in isolated VM

**QEMU/KVM vs VirtualBox:**
- **QEMU/KVM:** Native Linux virtualization, better performance, GPU passthrough support, libvirt management
- **VirtualBox:** Easier GUI, slightly worse performance, no GPU passthrough

**Recommendation:** **QEMU/KVM with virt-manager.**
- Better performance (KVM is kernel-level)
- GPU passthrough possible (your RTX 3080 could be dedicated to Windows VM)
- libvirt provides standard management interface
- virt-manager is GUI that's actually good

**GPU Passthrough for Gaming:**
This is advanced but powerful:
- Dedicate RTX 3080 to Windows VM
- Play Windows-only games with 95% native performance
- Switch between NixOS and Windows VM seamlessly

**Requirements:**
- Second GPU (or use Intel iGPU for host)
- IOMMU support (your Tiger Lake supports this)
- VFIO drivers
- Significant configuration

**Reality Check:** This is a weekend project. Only worth it if you have Windows-only games you really want to play. Proton covers 90% of games now.

**Recommendation for Your Use Case:**
- **Install libvirt/QEMU** - Low cost, available when needed
- **Create Windows 11 VM for testing** - Useful for cross-platform development
- **Skip GPU passthrough** - Use Proton for games, nvidia-offload for native Linux games, Windows VM is fallback

### distrobox/toolbx

**The Philosophy:** "I want Arch packages in NixOS" or "This tutorial assumes Ubuntu."

**What It Solves:**
NixOS is amazing but occasionally you hit:
- Software not packaged in nixpkgs
- Build instructions that assume FHS (Filesystem Hierarchy Standard - /usr/bin, /lib, etc.)
- Quick testing of software without committing to NixOS package

**distrobox:**
- Creates containerized environments of other distros
- Seamless integration - binaries in container appear in host PATH
- Graphics, audio, GPU all work
- Home directory is shared

**Example Workflow:**
```bash
distrobox create --name ubuntu --image ubuntu:24.04
distrobox enter ubuntu
# Now in Ubuntu environment, but in your NixOS home directory
apt install some-package-not-in-nixpkgs
some-package-command  # Works
exit
# Back in NixOS, but `some-package-command` still works
```

**For Your Use Case:**
NixOS's learning curve means you'll occasionally hit "this doesn't work, but would on Ubuntu." distrobox is escape hatch.

**Recommendation:** Install distrobox. Create an Ubuntu container. Use rarely, but when needed it's invaluable.

---

## Language Tooling - Philosophy: Per-Project, Not Global

**The Anti-Pattern:** Global Python installation with pip packages. Leads to:
- Dependency conflicts (Project A needs requests 2.25, Project B needs 2.31)
- "Works on my machine" (your global env is different from coworker's)
- Breaking system tools (pipx exists because pip conflicts with system Python)

**The Solution:** Per-project environments that are version-controlled and reproducible.

### Language Servers (LSPs)

**The Philosophy:** Editor-agnostic language intelligence. Autocomplete, go-to-definition, refactoring work in any editor (VS Code, Vim, Helix, Emacs).

**Best Practice:**
- **Per-project LSP** - Project's pyproject.toml/package.json specifies LSP version
- **Editor agnostic** - Change editors without changing tooling
- **Background updates** - LSP updates don't break your workflow

**For Common Languages:**
- **Python:** pyright or pylsp
- **JavaScript/TypeScript:** tsserver (built into VS Code, standalone for others)
- **Rust:** rust-analyzer (amazing, sets the standard)
- **Go:** gopls (official)
- **C/C++:** clangd (best) or ccls

**NixOS Specific:**
LSPs need to know about system libraries. In NixOS, they're in weird /nix/store paths. Solutions:
- **direnv + nix-shell** - Per-project nix-shell loads correct paths
- **flake.nix devShell** - Project specifies exact environment, LSP works
- **Global LSPs with wrappers** - Less ideal but sometimes necessary

**Recommendation:**
Use per-project devShells (flake.nix or shell.nix). This is NixOS's strength - reproducible dev environments.

### Debuggers

**The Philosophy:** Print debugging is quick but limited. Real debuggers show stack traces, inspect variables, set breakpoints.

**Best Practice:**
- **Integrated with editor** - VS Code debugger UI is great
- **Language-specific:** GDB for C/C++, pdb for Python, delve for Go
- **Remote debugging** - Debug code running in container or remote server

**For Your Use Case:**
If you debug compiled languages (C, C++, Rust): GDB and LLDB are essential.
If you debug scripting languages (Python, JS): Editor-integrated debuggers (VS Code) are enough.

**Recommendation:** Install GDB and LLDB (low cost), configure editor for debugging (per-language).

### Build Systems

**The Philosophy:** Reproducible builds across machines.

**Common Systems:**
- **Make:** Universal, old, everybody knows it
- **CMake:** Modern C/C++ builds
- **Ninja:** Fast builds, generated by CMake/Meson
- **Meson:** Python-based, faster than CMake, growing adoption

**For Your Use Case:**
You're on NixOS. Nix is your build system for NixOS packages. For upstream projects, you need their build system.

**Recommendation:** Install make, cmake, ninja, meson. Low disk cost, needed occasionally, frustrating when missing.

### Package Managers (per-language)

**The Philosophy:** Don't fight the ecosystem. Each language has standard tooling.

**Python:**
- **pip + venv** - Standard, works
- **poetry** - Better dependency management, lockfiles
- **pipenv** - Middle ground
- **Recommendation:** Start with pip+venv, move to poetry when dependency management becomes painful.

**JavaScript/TypeScript:**
- **npm** - Default, slow, works
- **yarn** - Faster, better lockfiles
- **pnpm** - Fastest, disk-efficient, growing
- **bun** - New, very fast, not fully compatible yet
- **Recommendation:** pnpm for new projects (faster, smaller disk usage). npm for compatibility (works everywhere).

**Rust:**
- **cargo** - Official, excellent, no alternatives needed

**Go:**
- **go modules** - Built into go command, official, works great

**For NixOS:**
Each language's tools should be in project's devShell, not globally installed. This ensures version consistency.

---

## Gaming Infrastructure - Philosophy: Compatibility, Performance, Convenience

### Game Platforms

**Steam:**
- **The Foundation:** 99% of PC gaming goes through Steam
- **Proton:** Valve's compatibility layer for Windows games. Fork of Wine with performance optimizations, DXVK, VKD3D-Proton.
- **Proton Experimental:** Latest fixes, opt-in per-game
- **Proton GE (Glorious Eggroll):** Community fork with additional patches, often fixes games that don't work with official Proton

**Best Practice:**
- Install Steam (already common on gaming setups)
- Enable Proton for all titles (Settings → Compatibility → Enable Steam Play for all titles)
- Per-game Proton version selection (some games work better with older/newer Proton)
- Check ProtonDB before buying (community database of game compatibility)

**For Your RTX 3080:**
- Most games will work flawlessly
- DLSS support in some games via Proton
- Ray tracing works but performance varies

**Recommendation:** Steam is non-negotiable for PC gaming. Install, enable Proton, expect 80% of games to "just work."

### Other Stores (Lutris, Heroic)

**GOG Games:**
- DRM-free (can download installers, keep forever)
- Often need Lutris or Heroic to install/run
- **Heroic Launcher:** Modern, native Linux app, good UI for GOG and Epic

**Epic Games:**
- Free games every week (actually good games sometimes)
- EAC anti-cheat works on Linux now (Fortnite, others)
- **Heroic Launcher** handles Epic well

**Recommendation:**
- **Heroic Launcher** - One app for GOG and Epic, native Linux, good UX
- **Lutris** - More complex, needed for niche games (Battle.net, EA, older games with complex setup)

### Wine/Wine-GE/Proton-GE

**When You Need It:**
- Non-Steam games
- Windows-only apps (not games)
- Custom builds of games

**Wine-GE vs Proton-GE:**
- Proton-GE: For Steam games
- Wine-GE: Same patches, but standalone (for non-Steam use)

**Recommendation:**
Lutris and Heroic handle Wine for you. Manually managing Wine is only for edge cases.

### Gaming Enhancements

**Gamemode:**
**What It Does:** Temporarily boosts performance for games
- CPU governor → performance
- Process nice level → -10 (higher priority)
- Disables screen saver
- Optionally overclocks GPU

**Best Practice:**
- Install gamemode daemon
- Steam automatically uses it (no config needed)
- For non-Steam games: `gamemoderun ./game`

**For Your Use Case:**
Your CPU can turbo to 4.6GHz. Gamemode ensures it does when gaming (not throttled for battery).

**Recommendation:** Install and enable. Zero downside, measurable benefit (5-10% better frametimes).

**MangoHud:**
**What It Does:** On-screen overlay showing FPS, frame time, CPU/GPU usage, temperatures.

**Why It Matters:**
- **Performance tuning:** If getting 40fps, is it CPU or GPU bottleneck? MangoHud shows which.
- **Thermal monitoring:** Is 45fps because GPU is thermal throttling? Overlay shows temp.
- **Settings validation:** Turned graphics to ultra, did framerate actually drop?

**Best Practice:**
- Install MangoHud
- Enable per-game (not all games, overlay is visual clutter)
- Custom config (show FPS, frametime, GPU temp - hide CPU details unless debugging)

**Keybinding:**
- Shift+F12 (default) toggles overlay
- Shift+F1 cycles FPS limits (0, 60, 120, 144)

**Implementation Notes:**
- Configuration in `home/programs/mangohud.nix`
- GPU load color thresholds: white → orange@60% → red@90%
- Top-left position, 3-column layout, semi-transparent background
- Shows: FPS, frametime graph, GPU (temp/power/load), CPU (temp/power), VRAM/RAM
- Gamemode integration indicator

**Recommendation:** Install, enable for competitive/performance-critical games, disable for story-driven games where immersion matters.

**vkBasalt:**
**What It Does:** Post-processing shaders (CAS sharpening, improved anti-aliasing, color grading).

**Use Cases:**
- Old games with blurry textures → sharpen with CAS
- Games with poor AA → inject SMAA/FXAA
- Color grading for preference

**Reality Check:**
This is enthusiast-level tweaking. Most games look fine without it. Some games have built-in sharpening (NVIDIA DLSS includes sharpening).

**Recommendation:** Skip initially. Install if you find a specific game that needs it (blurry TAA, for example).

**Gamescope:**
**What It Does:** Microcompositor - runs game in isolated session with custom resolution, refresh rate, upscaling.

**Use Cases:**
- Game doesn't support your 5120x2160 resolution → run at 2560x1080, gamescope upscales
- Game has bad fullscreen handling → gamescope forces proper fullscreen
- FSR upscaling for games without native support

**For Your Use Case:**
Your ultrawide is 5120x2160. Some older games don't support this. Gamescope can run them at 2560x1080 and upscale.

**Recommendation:** Install, use when needed (per-game basis), not global.

### Controller Support

**The Philosophy:** Plug in controller, it just works. No config, no drivers, no software.

**Steam Input:**
- Universal controller support (Xbox, PS5, Switch Pro, generic)
- Per-game remapping
- Gyro support (PS5/Switch controllers)
- Works automatically for Steam games

**For Non-Steam Games:**
- Xbox controllers: Work natively (xpad kernel driver)
- PS5 controllers: Work via Bluetooth (hid-playstation driver)
- Switch Pro: Works (hid-nintendo driver)

**Best Practice:**
- Bluetooth for wireless controllers (low latency on modern kernel)
- Wired for competitive (lowest latency)
- Steam Input for configuration (better than in-game controller settings)

**For Your Use Case:**
Your kernel (6.12.54) has excellent controller support. Everything should work.

**Recommendation:** No special config needed. Plug in and play.

---

## Multimedia & Content - Philosophy: Hardware Acceleration, Codec Support, Quality

### Video Playback

**The Goal:** Play any video file, use hardware decode (no CPU heat/battery drain), look good.

**MPV vs VLC:**
- **MPV:** Minimalist, keyboard-driven, highly configurable, better performance
- **VLC:** GUI-first, plays everything, slightly worse performance, easier for beginners

**Recommendation:** **MPV**
- Better hardware acceleration support
- Lower CPU usage
- Keyboard shortcuts for power users (j/k for seeking, [ ] for speed)
- Config file for persistent settings

**Hardware Acceleration:**
Your RTX 3080 has **NVDEC** (hardware video decoder):
- H.264: Yes
- HEVC (H.265): Yes
- AV1: Yes (Gen 4+ NVDEC)
- VP9: Yes

Your Intel iGPU has **Quick Sync** (also hardware decoder):
- Same codec support
- Lower power (use this on battery)

**Best Practice:**
- **VAAPI (Intel) on battery** - Lower power
- **NVDEC (NVIDIA) on AC or when gaming** - Better quality scaling

**MPV Config:**
```
hwdec=auto  # Use hardware decode when possible
vo=gpu      # GPU rendering
profile=gpu-hq  # High quality
```

**For Your Use Case:**
You watch videos for entertainment and reference (documentation videos, tutorials). Hardware decode means silent fan, cool temps, long battery life.

### Codec Support

**The Problem:** Not all codecs are freely distributable. Patent issues.

**Solution:** Install codec packs that include patented codecs (legal in most jurisdictions for personal use).

**Essential Codecs:**
- H.264 (universal video)
- HEVC (H.265, 4K videos)
- AV1 (YouTube, next-gen)
- VP9 (YouTube, older)
- AAC (audio)
- Opus (audio, Discord/voice chat)

**NixOS Specific:**
You need to allow unfree packages (NVIDIA driver already requires this). Codec packs should be available.

**Recommendation:** Install ffmpeg-full (includes all codecs), mpv with hardware acceleration.

### HDR Tone-mapping

**The Problem:** HDR video on SDR display needs tone-mapping (compressing HDR range to SDR range).

**MPV Handles This:**
- Auto-detect HDR content
- Tone-map to SDR
- Adjust based on display brightness

**For Your Use Case:**
Your displays are SDR. HDR tone-mapping ensures HDR videos don't look washed out.

**Best Practice:**
MPV's default tone-mapping is good. No config needed.

### Screen Recording/Streaming

**OBS Studio:**
**The Standard:** Everyone uses OBS. Twitch streamers, YouTube creators, corporate screen recordings.

**Why OBS:**
- NVENC encoding (RTX 3080) - hardware encode, zero CPU impact
- Scene system (switch between webcam, screen, overlays)
- Plugin ecosystem (noise suppression, virtual camera)
- Streaming and recording

**Best Practice:**
- **NVENC H.264 encoder** - Your RTX 3080 has dedicated hardware
- **1080p60 for recording** - Balance quality and file size
- **Separate audio tracks** - Mic on one track, desktop audio on another (edit later)

**For Your Use Case:**
- **Development:** Record bug reproductions, demo features
- **Gaming:** Clip highlights (no need to record entire session)
- **Meetings:** Record presentations (local backup)

**Recommendation:** Install OBS, configure NVENC encoder, test recording.

### Wayland Screen Sharing

**The Challenge:** Wayland is more secure than X11. Apps can't spy on other windows. This breaks screen sharing (apps can't see screen contents).

**The Solution:**
- **pipewire** - Audio/video routing
- **xdg-desktop-portal** - Permission system (apps request screen share, user approves)
- **xdg-desktop-portal-hyprland** - Hyprland-specific backend

**What Should Work:**
- Browser screen sharing (Google Meet, Zoom web)
- OBS (with pipewire source)
- Discord (with xdg-desktop-portal)

**Status:** You have pipewire. Portal integration may need verification.

**Testing:**
Open Chromium/Firefox, start Google Meet call, share screen. Should prompt for which screen/window, then work.

**If Broken:**
Check xdg-desktop-portal-hyprland is installed and configured.

---

## Connectivity & Networking - Philosophy: Reliable, Secure, Automatic

### NetworkManager

**Why NetworkManager:**
- Standard on most Linux distros
- WiFi, Ethernet, VPN, mobile broadband - unified interface
- Works with GUI (nm-applet) and CLI (nmcli)
- Connection profiles - save WiFi passwords, VPN configs

**Best Practice:**
- **GUI applet in system tray** - Click to switch networks
- **Auto-connect to known networks** - When home WiFi in range, connect automatically
- **VPN integration** - WireGuard, OpenVPN, commercial VPNs all integrate

**For Your Use Case:**
You have WiFi 6E (tri-band, 2.4/5/6 GHz), 2.5GbE Ethernet, Thunderbolt dock (likely Ethernet passthrough).

**Configuration:**
- **Prefer Ethernet when available** - Lower latency, higher bandwidth, more reliable
- **WiFi as fallback** - Seamless transition when unplugging dock
- **VPN on-demand** - For work networks, enable when needed

**Recommendation:** NetworkManager is likely already configured. Verify system tray shows network status.

### Bluetooth

**The Historical Problem:** Bluetooth on Linux was terrible. Pipewire fixed most of this.

**Modern State:**
- **A2DP audio:** High-quality audio to headphones/speakers (works)
- **HFP/HSP headset mode:** Mic + audio for calls (works but quality downgrade)
- **LE Audio (LC3 codec):** Next-gen, better quality, lower latency (kernel 6.0+, you have 6.12 ✓)

**Best Practice:**
- **blueman or blueberry** - GUI manager (applet in system tray)
- **Auto-connect to known devices** - Put on headphones, they connect automatically
- **Dual-mode devices:** Some headphones support A2DP (music) and HSP (calls), switch automatically

**For Your Use Case:**
Development + gaming = likely wired headphones (latency). But Bluetooth for music, calls is convenient.

**Common Issue:**
Bluetooth audio + video calls = codec switches to HSP (sounds bad). This is Bluetooth limitation, not Linux. Solution: Wired headset for calls, Bluetooth for music.

**Recommendation:** Install blueman, configure auto-connect, use Bluetooth for music/casual, wired for serious work.

### Thunderbolt Device Authorization

**The Security Risk:** Thunderbolt = PCIe over cable. Malicious device can DMA attack (read/write RAM, bypass OS).

**The Solution:** Bolt (Thunderbolt authorization daemon).

**Authorization Levels:**
1. **Reject all** - Nothing connects without approval (most secure, annoying)
2. **Ask each time** - Per-device authorization (good balance)
3. **Auto-authorize known devices** - Once authorized, always allowed (convenient)
4. **Allow all** - No security (not recommended)

**Best Practice:**
- **Auto-authorize known devices** (your dock, your external SSD)
- **Ask for new devices** (unknown USB-C devices)

**For Your Use Case:**
You have one dock (LG ultrawide + peripherals via Thunderbolt). Authorize once, then seamless.

**Recommendation:** Bolt with auto-auth for known devices. You already have this (`system/hardware/thunderbolt.nix`).

### SSH Server

**The Question:** Should your laptop run SSH server?

**Considerations:**
- **Pros:** Remote access (access laptop from desktop, transfer files with scp/rsync, remote debugging)
- **Cons:** Attack surface (open port), battery drain (listening daemon)

**Best Practice If Enabled:**
- **Disable password auth** - SSH key only
- **Non-standard port** - Not 22 (reduces automated attacks)
- **Firewall rules** - Only allow from local network, not internet
- **fail2ban** - Auto-ban IPs after failed attempts

**For Your Use Case:**
Desktop replacement, mostly at home. SSH server is useful for:
- Transferring files from other machines
- Remote debugging from desktop
- "Work from couch" while laptop is docked upstairs

**Recommendation:**
Enable SSH server, key-only auth, LAN-only (firewall), fail2ban. Disable when traveling (untrusted networks).

### Communication Apps

**Browser:**
- **Firefox:** Privacy-focused, excellent Wayland support, default choice for many
- **Chromium/Chrome:** Better web compatibility (corporate sites), slightly worse privacy
- **Brave:** Privacy-focused Chromium fork

**Hardware Acceleration in Browser:**
- **Critical for battery life** - Software video decode drains battery
- **VAAPI on Firefox** - Requires config flags
- **VA-API on Chromium** - Works better out of box

**Recommendation:** Firefox with hardware acceleration enabled (flags), Chromium as fallback.

---

## Security & Privacy - Philosophy: Defense in Depth, Convenience vs Security

### Password Manager

**You have:** bitwarden-cli

**Best Practice:**
- **All passwords in manager** - Never reuse, never remember
- **Strong master password** - This is the one password to remember (diceware passphrase)
- **2FA where possible** - TOTP (bitwarden supports this), hardware keys (YubiKey)
- **Auto-lock timeout** - 15 minutes idle = lock vault

**CLI vs GUI:**
- **bitwarden-cli:** Terminal access, scriptable
- **Bitwarden desktop app:** GUI, browser integration

**For Your Use Case:**
You're a developer. CLI is fine for occasional password retrieval. Browser integration is more convenient for daily use.

**Recommendation:** Install Bitwarden desktop app (GUI) in addition to CLI. Browser integration auto-fills passwords.

### SSH Key Management

**Best Practice:**
- **ssh-agent** - Loads keys at login, caches passphrase
- **Per-service keys** - GitHub key, server key, work key (separate, revocable)
- **Ed25519 algorithm** - Modern, fast, secure (not RSA 2048)
- **Passphrase-protected keys** - If laptop stolen, keys aren't usable

**For Your Use Case:**
You probably have GitHub SSH key, personal server keys. These should be in ssh-agent (type passphrase once per session).

**Recommendation:** systemd user service for ssh-agent, keys added on login, passphrase required.

### GPG Key Management

**Use Cases:**
1. **Git commit signing** - Proves commits are from you
2. **File encryption** - Sensitive docs
3. **Email encryption** - PGP email (rare now)

**Best Practice:**
- **Master key offline** - On YubiKey or paper backup
- **Subkeys for daily use** - Revocable without revoking master
- **Expiration dates** - Keys expire, must renew (proves you still control key)

**For Your Use Case:**
Git commit signing is increasingly common (required by some projects). Worth setting up.

**Recommendation:** Generate GPG key, configure git to sign commits, backup private key.

### Polkit Agent

**What It Is:** GUI prompt for privilege escalation. "Enter password to install software" popup.

**You have:** hyprpolkitagent

**Why It Matters:**
GUI apps that need root (software updates, disk management) can't just run as root. They request elevation via polkit, agent prompts user.

**Recommendation:** Already configured ✓. No action needed.

### Firewall

**The Question:** Do you need a firewall on a laptop?

**Considerations:**
- **NAT router firewall:** Your home router already blocks incoming connections
- **Public WiFi:** Coffee shop WiFi has no protection
- **Docker:** Opens ports, bypasses some firewalls

**Best Practice:**
- **Default deny incoming** - No connections from internet/LAN unless explicitly allowed
- **Allow outgoing** - You can initiate connections
- **Explicit allows:** SSH (if enabled), development servers (if needed)

**firewalld vs nftables:**
- **firewalld:** High-level, easier configuration, GUI available
- **nftables:** Low-level, more powerful, kernel replacement for iptables

**Recommendation for Your Use Case:**
Enable firewalld, default deny, allow SSH from LAN (if you enabled SSH server). Most services you run (dev servers) bind to localhost (127.0.0.1) only, so no firewall rule needed.

---

## System Monitoring & Maintenance - Philosophy: Preventive, Not Reactive

### ZFS Pool Health Monitoring

**The Reality:** ZFS self-heals but needs regular scrubs to detect problems early.

**Best Practice:**
- **Scrub monthly** - Full read of all data, checks/repairs checksums
- **Automatic scrubbing** - systemd timer, runs at 2am Sunday
- **Email alerts** - If scrub finds errors, notify
- **SMART monitoring** - Weekly check of drive health

**For Your Use Case:**
Your Samsung PM9A1 NVMe is reliable but not immortal. ZFS scrubs detect bit rot (rare but catastrophic).

**Recommendation:**
Create systemd timer for monthly ZFS scrub, integrate with monitoring (email or desktop notification on errors).

### ZFS Snapshot Automation

**The Philosophy:** Snapshots are cheap (copy-on-write), instant, and powerful.

**sanoid/syncoid:**
- **sanoid:** Automatic snapshot creation/deletion (configurable retention)
- **syncoid:** Replication to external drive/NAS (backups)

**Example Policy:**
- Hourly snapshots, keep 24 (last day)
- Daily snapshots, keep 7 (last week)
- Weekly snapshots, keep 4 (last month)
- Monthly snapshots, keep 12 (last year)

**Why This Matters:**
- Accidentally deleted file? Restore from snapshot (minutes ago).
- Broke system config? Rollback to yesterday.
- Ransomware? Immutable snapshots can't be encrypted.

**For Your Use Case:**
You experiment with NixOS configurations. Snapshots are insurance.

**Recommendation:** Configure sanoid for automatic snapshots. Low cost (COW), high value (disaster recovery).

### SMART Monitoring

**The Goal:** Predict drive failure before it happens.

**smartmontools:**
- Reads drive self-diagnostics
- Tracks reallocated sectors (bad blocks)
- Temperature monitoring
- Predicts failure

**Best Practice:**
- **Weekly short test** - 2 minutes, checks critical parameters
- **Monthly long test** - Hours, full surface scan
- **Alerts on threshold** - Reallocated sectors >5 = warning, >50 = urgent

**For Your Use Case:**
Your NVMe has wear leveling, SMART data shows remaining lifespan. Monitor this.

**Recommendation:** systemd timers for SMART tests, email on warnings.

---

## Conclusion

This guide represents optimal configuration for a desktop replacement system prioritizing:
1. **Automation** - Things work without manual intervention
2. **Performance** - Hardware capabilities fully utilized
3. **Reliability** - Predictable behavior, failure prevention
4. **Flexibility** - Adapt to different contexts (docked, mobile, gaming, development)

Implementation priority should be based on:
- **Pain points** - What's currently broken or annoying?
- **Risk mitigation** - What could cause data loss? (ZFS snapshots, backups)
- **Workflow impact** - What saves the most time? (Hotplug handling, clipboard history)

---

*System: Lenovo ThinkPad T15g Gen 2i (20YTS0EV00)*
*Configuration Repository: /home/omegaice/.config/nixpkgs*
