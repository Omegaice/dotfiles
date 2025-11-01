# Steam Gaming Setup - NVIDIA GPU Offload

## Configuration Status

Your system uses **PRIME Offload mode**:
- **Default:** Intel iGPU (low power, desktop use)
- **On-demand:** NVIDIA RTX 3080 (gaming, GPU-intensive tasks)

Games need to be explicitly launched with NVIDIA GPU.

## How to Enable NVIDIA GPU for Steam Games

### Method 1: Per-Game Launch Options (Recommended)

1. Open Steam
2. Right-click game → **Properties**
3. Under **Launch Options**, add:

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia mangohud %command%
```

**Breakdown:**
- `__NV_PRIME_RENDER_OFFLOAD=1` - Use NVIDIA GPU
- `__GLX_VENDOR_LIBRARY_NAME=nvidia` - Force NVIDIA for OpenGL
- `mangohud` - Enable performance overlay
- `%command%` - Steam's placeholder for the game executable

### Method 2: With Gamemode (Better Performance)

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia gamemoderun mangohud %command%
```

**Additional benefit:** CPU governor switches to `performance` mode automatically.

### Method 3: Vulkan Games Only (Simpler)

For Vulkan-only games (no OpenGL):

```bash
__NV_PRIME_RENDER_OFFLOAD=1 mangohud %command%
```

## Verification

### While Game is Running:

**Terminal 1 - Check GPU usage:**
```bash
watch nvidia-smi
```

Should show:
- Game process in the list
- GPU utilization >0%
- Memory used by game

**Terminal 2 - Check CPU governor:**
```bash
watch cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

Should show `performance` if gamemode is active.

### MangoHud Overlay:

Press `Shift+F12` in-game. Overlay should show:
- GPU: `NVIDIA GeForce RTX 3080 Laptop GPU`
- FPS counter
- GPU temp, power, load
- VRAM usage

## Proton Configuration

### Enable Proton for All Games

1. Steam → Settings → Compatibility
2. Enable: **"Enable Steam Play for all other titles"**
3. Select: **Proton Experimental** (latest)

### Per-Game Proton Versions

Some games work better with specific Proton versions:
- Right-click game → Properties → Compatibility
- Force specific Proton version

**Recommended versions:**
- `Proton Experimental` - Latest fixes, bleeding edge
- `Proton GE` - Community build with extra patches (install via ProtonUp-Qt)
- `Proton 9.0` - Stable fallback

### Check Compatibility

Before buying games:
1. Visit [ProtonDB](https://www.protondb.com/)
2. Search for game title
3. Check user reports and required tweaks

## Heroic Games Launcher (GOG/Epic)

Launch Heroic:
```bash
heroic
```

Heroic automatically detects and offers to use NVIDIA GPU for games.

## Troubleshooting

### Game Uses Intel GPU Instead

**Verify:**
```bash
# While game is running:
nvidia-smi
```

**If no game process listed:**
- Check launch options have the env vars
- Restart Steam after configuration changes
- Some games need `__VK_LAYER_NV_optimus=NVIDIA_only` for Vulkan

### Game Stutters/Low FPS

1. **Check MangoHud overlay:**
   - GPU usage should be 80-100%
   - If CPU usage is 100%: CPU bottleneck
   - If GPU usage is low: likely game issue or driver problem

2. **Enable gamemode:**
   - Add `gamemoderun` to launch options
   - Verify with: `gamemoded -s` (should show active)

3. **Check thermals:**
   - MangoHud shows GPU temp
   - If >85°C: thermal throttling (clean fans, improve airflow)

### MangoHud Not Showing

- Verify in launch options: `mangohud %command%`
- Toggle with `Shift+F12`
- Check MangoHud installed: `which mangohud`

## Example Configurations

### Competitive FPS (CS2, Valorant, etc.)
```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia gamemoderun mangohud MANGOHUD_CONFIG=fps_only=1 %command%
```

### Story/Single-Player (Maximum Quality)
```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia mangohud %command%
```

### Benchmarking
```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia gamemoderun mangohud MANGOHUD_CONFIG=log_duration=60 %command%
```
(Logs FPS data to `/tmp/mangohud.csv` for 60 seconds)

## Advanced: Global NVIDIA for All Games

If you want NVIDIA GPU for **all** games automatically, you can modify the Steam desktop entry, but this:
- Wastes power when not gaming
- Not recommended for laptop use

**Better approach:** Set launch options per-game as shown above.

## Performance Expectations (RTX 3080 Laptop)

| Game Type | Expected FPS @ 1080p |
|-----------|---------------------|
| Competitive FPS | 200+ (CS2, Valorant) |
| AAA (High Settings) | 100-144 |
| AAA (Ultra + RT) | 60-100 |
| Indie | 144+ (locked) |

**Note:** 5120x2160 ultrawide requires significantly more GPU power. Consider 1440p or lower for older games.
