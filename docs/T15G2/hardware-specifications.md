# ThinkPad T15g Gen 2i - Hardware Specifications

## Machine Identity

- **Model:** Lenovo ThinkPad T15g Gen 2i
- **Product Code:** 20YTS0EV00
- **Form Factor:** 15.6" Mobile Workstation
- **Category:** High-Performance Laptop / Desktop Replacement

---

## Processor

**CPU:** Intel Core i7-11800H (Tiger Lake-H, 11th Generation)

| Specification             | Value                          |
|---------------------------|--------------------------------|
| **Architecture**          | x86_64 (Tiger Lake-H)          |
| **Cores**                 | 8 physical cores               |
| **Threads**               | 16 (Hyper-Threading)           |
| **Base Frequency**        | 2.30 GHz                       |
| **Max Turbo Frequency**   | 4.60 GHz                       |
| **Cache**                 | 24 MB Intel Smart Cache (L3)   |
| **TDP**                   | 45W (configurable)             |
| **Process**               | 10nm SuperFin                  |
| **Socket**                | BGA (soldered)                 |

**CPU Features:**
- AVX-512, AVX2, SSE4.2, AES-NI, SHA-NI
- Intel VT-x (virtualization)
- Intel TSX (Transactional Synchronization Extensions)
- Enhanced SpeedStep, Turbo Boost 2.0

**Security Features:**
- Intel SGX (Software Guard Extensions)
- Intel TME (Total Memory Encryption)
- Hardware-based IBRS/STIBP (Spectre mitigations)

---

## Graphics

### Primary GPU: NVIDIA GeForce RTX 3080 Laptop

| Specification          | Value                              |
|------------------------|------------------------------------|
| **GPU**                | NVIDIA GA104M (Ampere)             |
| **Model**              | GeForce RTX 3080 Mobile / Max-Q    |
| **VRAM**               | 16GB GDDR6 (high-memory variant)   |
| **CUDA Cores**         | 6144                               |
| **RT Cores**           | 48 (2nd generation)                |
| **Tensor Cores**       | 192 (3rd generation)               |
| **Memory Bus**         | 256-bit                            |
| **Memory Bandwidth**   | ~448 GB/s                          |
| **Driver Version**     | 580.95.05 (proprietary)            |
| **PCI ID**             | `10de:249c`                        |

**GPU Features:**
- Ray tracing (2nd gen RT cores)
- DLSS 2.0 / 3.0 support
- CUDA 8.6 compute capability
- NVIDIA Reflex low-latency
- Resizable BAR support
- AV1 decode, H.264/HEVC encode

### Integrated GPU: Intel UHD Graphics

| Specification          | Value                               |
|------------------------|-------------------------------------|
| **GPU**                | Intel UHD Graphics (Tiger Lake GT1) |
| **Execution Units**    | 32 EUs                              |
| **Base Frequency**     | 350 MHz                             |
| **Max Frequency**      | 1.45 GHz                            |
| **PCI ID**             | `8086:9a60`                         |

**GPU Mode:** PRIME Synchronized (hybrid switching between Intel iGPU and NVIDIA dGPU)

---

## Memory

| Specification       | Value                            |
|---------------------|----------------------------------|
| **Capacity**        | 64 GB                            |
| **Type**            | DDR4 SDRAM                       |
| **Speed**           | 3200 MT/s (PC4-25600)            |
| **Configuration**   | Dual-channel (2x 32GB SO-DIMM)   |
| **ECC**             | Not supported                    |
| **Slots**           | 2x SO-DIMM (both populated)      |

---

## Storage

### Primary SSD

| Specification         | Value                                   |
|-----------------------|-----------------------------------------|
| **Model**             | Samsung PM9A1 / 980 PRO                 |
| **Capacity**          | 1 TB (953.9 GB usable)                  |
| **Interface**         | NVMe PCIe Gen 4.0 x4                    |
| **Form Factor**       | M.2 2280                                |
| **Controller**        | Samsung PM9A1 (PCI ID: `144d:a80a`)     |
| **Sequential Read**   | ~6500 MB/s (typical)                    |
| **Sequential Write**  | ~5000 MB/s (typical)                    |

### Partition Layout

```
nvme0n1 (953.9 GB)
├─ nvme0n1p1 (1 GB)       /boot (vfat, EFI System Partition)
├─ nvme0n1p2 (4 GB)       [SWAP] (LUKS encrypted)
└─ nvme0n1p3 (948.9 GB)   ZFS member (zpool)
```

### ZFS Pool Architecture

- **Pool Name:** `zpool`
- **Datasets:**
  - `zpool/root` - System root filesystem
  - `zpool/nix` - Nix store (isolated high-churn data)
  - `zpool/var` - Variable data (logs, cache)
  - `zpool/home` - User home directories

---

## Display Configuration

### Internal Display

| Specification      | Value                               |
|--------------------|-------------------------------------|
| **Size**           | 15.6" diagonal                      |
| **Resolution**     | 1920x1080 (Full HD)                 |
| **Panel Type**     | IPS                                 |
| **Refresh Rate**   | 60 Hz                               |
| **Manufacturer**   | Chimei Innolux Corporation          |
| **Model**          | 0x150C                              |
| **Physical Size**  | 340mm x 190mm                       |
| **Connection**     | eDP-1 (embedded DisplayPort)        |
| **Color Gamut**    | ~99% sRGB (typical for this panel)  |

### External Display

| Specification               | Value                                       |
|-----------------------------|---------------------------------------------|
| **Model**                   | LG UltraWide 49"                            |
| **Product**                 | LG ULTRAWIDE (404NTGYBJ247)                 |
| **Resolution**              | 5120x2160 (Dual QHD, 32:9 aspect)           |
| **Refresh Rate**            | 72 Hz (max), 60/50/30 Hz supported          |
| **Panel Type**              | IPS (assumed)                               |
| **Physical Size**           | 930mm x 390mm                               |
| **Connection**              | DisplayPort via Thunderbolt dock (DP-9)     |
| **Variable Refresh Rate**   | Enabled (VRR/FreeSync)                      |
| **HDR**                     | Supported                                   |

**Workspace Allocation:**
- Internal (eDP-1): Hyprland workspaces 1-5
- External (DP-9): Hyprland workspaces 6-10

---

## Connectivity

### Wireless

| Component       | Specification                         |
|-----------------|---------------------------------------|
| **WiFi**        | Intel Wi-Fi 6E AX210                  |
| **Standard**    | 802.11ax (Wi-Fi 6E)                   |
| **Bands**       | 2.4 GHz, 5 GHz, 6 GHz (tri-band)      |
| **Antenna**     | 2x2 MIMO                              |
| **Max Speed**   | 2400 Mbps (theoretical)               |
| **Bluetooth**   | Bluetooth 5.1+                        |
| **PCI ID**      | `8086:2725`                           |

### Wired Ethernet

| Specification    | Value                            |
|------------------|----------------------------------|
| **Controller**   | Intel Ethernet Controller I225-V |
| **Speed**        | 2.5 Gigabit Ethernet             |
| **PCI ID**       | `8086:15f3`                      |

### Thunderbolt / USB-C

| Component       | Specification                                   |
|-----------------|-------------------------------------------------|
| **Controller**  | Intel Goshen Ridge 2020                         |
| **Standard**    | Thunderbolt 4 / USB4                            |
| **Ports**       | 2x USB-C (Thunderbolt 4)                        |
| **Bandwidth**   | 40 Gbps per port                                |
| **Features**    | PCIe tunneling, DisplayPort 2.0, USB PD 3.0     |
| **PCI ID**      | `8086:0b26`                                     |

**Thunderbolt Capabilities:**
- Dual 4K displays or single 8K display
- External GPU support (eGPU)
- High-speed storage (NVMe enclosures)
- Docking station connectivity
- Power delivery (charging)

### USB Ports

- **USB 3.2 Gen 2x1** (10 Gbps) - Via Tiger Lake-H controller
- **USB 3.2 Gen 2** (10 Gbps) Type-C
- **USB 3.2 Gen 1** (5 Gbps) Type-A (2x ports typical)

### Card Reader

| Specification        | Value              |
|----------------------|--------------------|
| **Model**            | Realtek RTS525A    |
| **Interface**        | PCI Express        |
| **Supported Cards**  | SD, SDHC, SDXC     |
| **PCI ID**           | `10ec:525a`        |

---

## Audio

| Component         | Specification                                |
|-------------------|----------------------------------------------|
| **Controller**    | Intel Tiger Lake-H HD Audio                  |
| **Codec**         | Realtek ALC287 (typical for T15g Gen 2)      |
| **Outputs**       | Combo headphone/mic jack                     |
| **Speakers**      | Dual stereo speakers (Dolby Atmos)           |
| **Microphones**   | Dual-array far-field mics                    |
| **NVIDIA Audio**  | GA104 HDMI/DP Audio (for external displays)  |

---

## Battery

| Specification             | Value                   |
|---------------------------|-------------------------|
| **Design Capacity**       | 94 Wh (4-cell Li-ion)   |
| **Current Full Charge**   | 77.3 Wh                 |
| **Battery Health**        | ~82%                    |
| **Chemistry**             | Lithium-ion Polymer     |
| **Current Charge**        | 100%                    |

**Charging Configuration:**
- Smart charging with 90-100% thresholds (TLP managed)
- Preserves battery longevity for predominantly plugged-in use

**Typical Runtime:**
- Light tasks (web, documents): 4-5 hours
- Development (compiling, containers): 2-3 hours
- Gaming: 1-1.5 hours (not recommended on battery)

---

## Chipset & Platform

| Component              | Specification                           |
|------------------------|-----------------------------------------|
| **Chipset**            | Intel WM590 (Tiger Lake-H)              |
| **ISA Bridge**         | Intel WM590 LPC/eSPI Controller         |
| **Management Engine**  | Intel ME (Tiger Lake-H)                 |
| **SMBus Controller**   | Intel Tiger Lake-H SMBus                |
| **BIOS/UEFI**          | Lenovo UEFI (systemd-boot bootloader)   |

---

## Physical Specifications

| Specification    | Typical Value (T15g Gen 2)                  |
|------------------|---------------------------------------------|
| **Dimensions**   | 375mm x 252mm x 25.4mm (W x D x H)          |
| **Weight**       | ~2.9 kg (6.4 lbs) with RTX 3080             |
| **Material**     | Magnesium alloy chassis, carbon fiber top   |
| **Color**        | Black                                       |

---

## Thermal Management

| Component              | Details                                      |
|------------------------|----------------------------------------------|
| **Cooling System**     | Dual-fan vapor chamber cooling               |
| **Heat Pipes**         | Multiple heat pipes (shared CPU/GPU)         |
| **Thermal Interface**  | Liquid metal TIM (CPU), thermal paste (GPU)  |
| **Air Vents**          | Rear exhaust, bottom intake                  |

**Typical Temperatures:**
- CPU idle: 45-50°C
- CPU load: 80-90°C (thermal throttle at 100°C)
- GPU idle: 40-45°C
- GPU load: 75-85°C (thermal throttle at 87°C)

---

## Firmware & Kernel

| Component          | Version                       |
|--------------------|-------------------------------|
| **Kernel**         | Linux 6.12.54                 |
| **NVIDIA Driver**  | 580.95.05 (proprietary)       |
| **UEFI Firmware**  | Lenovo (fwupd managed)        |
| **Microcode**      | Intel microcode (auto-updated)|

---

## PCI Device Summary

```
00:00.0 Host bridge: Intel Tiger Lake-H 8 cores Host Bridge
00:01.0 PCI bridge: Intel 11th Gen Core PCIe Controller #1
00:02.0 VGA: Intel TigerLake-H GT1 [UHD Graphics]
00:07.0/1 PCI bridge: Intel Thunderbolt 4 PCIe Root Port #0/#1
00:0d.0 USB controller: Intel Thunderbolt 4 USB Controller
00:14.0 USB controller: Intel Tiger Lake-H USB 3.2 Gen 2x1 xHCI
00:16.0 Communication: Intel Tiger Lake-H Management Engine
00:1f.0 ISA bridge: Intel WM590 LPC/eSPI Controller
00:1f.3 Audio: Intel Tiger Lake-H HD Audio Controller
01:00.0 VGA: NVIDIA GA104M [GeForce RTX 3080 Mobile]
05:00.0 NVMe: Samsung NVMe SSD Controller PM9A1/980PRO
09:00.0 Network: Intel Wi-Fi 6E AX210
0a:00.0 Card Reader: Realtek RTS525A
0b:00.0 Ethernet: Intel I225-V 2.5GbE
20-21:xx.x Thunderbolt: Intel Goshen Ridge 2020 Bridge
```

---

## System Identification

```bash
# Product name
cat /sys/class/dmi/id/product_name
# Output: ThinkPad T15g Gen 2i

# Product version
cat /sys/class/dmi/id/product_version
# Output: 20YTS0EV00

# System vendor
cat /sys/class/dmi/id/sys_vendor
# Output: LENOVO
```

---

## Hardware Detection Commands

```bash
# PCI devices
lspci -nn

# CPU info
lscpu

# Memory info
free -h

# Storage layout
lsblk

# GPU info
nvidia-smi

# Display info
hyprctl monitors

# USB devices
lsusb

# Kernel version
uname -r

# ZFS pool status
zpool status
```

---

*Hardware specifications collected via system detection on 2025-10-28 running NixOS with Linux kernel 6.12.54*
