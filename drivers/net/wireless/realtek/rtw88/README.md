# RTW88 WiFi Drivers for Android 🚀

<div align="center">

![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)
![Kernel](https://img.shields.io/badge/kernel-4.x%20%7C%205.x-orange.svg)
![Architecture](https://img.shields.io/badge/arch-ARM64-green.svg)
![Status](https://img.shields.io/badge/build-passing-brightgreen.svg)

**Realtek RTW88 WiFi Driver Suite - Android Kernel Compatible**

*Pre-patched and ready to build for Android devices running Linux 4.x/5.x kernels*

[Features](#-features) • [Supported Hardware](#-supported-hardware) • [Building](#-building) • [Installation](#-installation) • [Loading Modules](#-loading-modules) • [Troubleshooting](#-troubleshooting)

</div>

---

## 📋 Overview

This repository contains the **RTW88** WiFi driver suite from the Linux kernel mainline, specially patched and configured for **Android devices**. These drivers support modern Realtek WiFi chipsets with **5 GHz capability** and multiple bus interfaces (SDIO, USB, PCI).

### Why This Repository?

The upstream RTW88 drivers use newer kernel APIs that aren't always available in Android kernel trees. This repo provides:

- ✅ **Ready-to-build** drivers for Android kernels (4.x/5.x)
- ✅ **Backward compatibility** patches for older kernel APIs
- ✅ **Complete SDIO/USB/PCI** interface support
- ✅ **Pre-configured** Makefile for Android toolchains
- ✅ **25+ kernel modules** for various Realtek chipsets

---

## ✨ Features

- 🌐 **Dual-band WiFi** (2.4 GHz + 5 GHz)
- 📡 **802.11a/b/g/n/ac** support
- 🔌 **Multiple interfaces:** SDIO, USB, PCI/PCIe
- 🎯 **Monitor mode** capable (depends on chipset)
- 🔧 **DebugFS** interface for advanced debugging
- 💡 **LED control** support
- 🐧 **mac80211** wireless subsystem integration
- 📊 **WPA/WPA2/WPA3** encryption support

---

## 🔧 Supported Hardware

### Chipsets Supported

| Chipset Family | Models | Interface Types |
|---------------|--------|-----------------|
| **RTL8703** | RTL8703B | SDIO |
| **RTL8723** | RTL8723CS, RTL8723D, RTL8723DS, RTL8723DU | SDIO, USB |
| **RTL8812** | RTL8812A, RTL8812AU | USB |
| **RTL8814** | RTL8814A, RTL8814AE, RTL8814AU | PCI, USB |
| **RTL8821** | RTL8821A, RTL8821AU, RTL8821C, RTL8821CE, RTL8821CS, RTL8821CU | PCI, SDIO, USB |
| **RTL8822** | RTL8822B, RTL8822BE, RTL8822BS, RTL8822BU, RTL8822C, RTL8822CE, RTL8822CS, RTL8822CU | PCI, SDIO, USB |

### Bus Interface Support

- **SDIO** - SD card interface (common in embedded/mobile devices)
- **USB** - USB WiFi adapters
- **PCI/PCIe** - PCI Express (desktop/laptop cards)

---

## 📦 What's Included

### Kernel Modules (25 total)

#### Core Module
- `rtw_core.ko` - Main driver core (8.2 MB)

#### Bus Interfaces
- `rtw_sdio.ko` - SDIO interface support
- `rtw_usb.ko` - USB interface support
- `rtw_pci.ko` - PCI interface support

#### Chipset Drivers
All chipset-specific modules for RTL8703B, RTL8723 series, RTL8812/8814/8821/8822 series

---

## 🛠️ Building

### Prerequisites

1. **Android kernel source tree** (configured and prepared)
2. **ARM64 cross-compilation toolchain**
3. **Clang/LLVM** (for modern Android kernels)
4. **GCC cross-compiler** (for linking)

### Environment Setup

Export these environment variables (adjust paths to match your system):
```bash
export ARCH=arm64
export SUBARCH=arm64
export CC=~/toolchains/android_prebuilts_clang_host_linux-x86_clang-r416183b/bin/clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=~/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export HOSTCC=gcc-12
export HOSTCXX=g++-12
```

### Build Configuration

Edit the `Makefile` to match your environment:
```makefile
# Kernel configuration
KVER ?= $(shell uname -r)
KSRC ?= /path/to/your/android/kernel/source
KBUILD_OUTPUT ?= $(KSRC)/out

# Android paths (for installation)
ANDROID_PRODUCT_OUT ?= /path/to/android/out/target/product/yourdevice
```

### Compile Drivers
```bash
# Clone this repository
git clone https://github.com/ShorterKing/RTW88-Android-Drivers.git
cd RTW88-Android-Drivers

# Show current configuration
make config

# Build all modules
make -j$(nproc)

# Check built modules
ls -lh *.ko
```

### Build Targets
```bash
make              # Build all modules
make clean        # Clean build artifacts
make prepare      # Prepare kernel headers
make config       # Show current configuration
make install      # Install to Android product output
make install_fw   # Install firmware files
make install_device # Push directly to device via ADB
```

---

## 📲 Installation

### Method 1: Manual Installation (Recommended)
```bash
# Enable root and remount system
adb root
adb remount

# Create directories
adb shell mkdir -p /vendor/lib/modules
adb shell mkdir -p /vendor/firmware/rtw88

# Push modules
adb push *.ko /vendor/lib/modules/

# Push firmware (if available)
adb push firmware/*.bin /vendor/firmware/rtw88/

# Reboot device
adb reboot
```

### Method 2: Automated Installation
```bash
# Install directly to connected device
make install_device
```

### Method 3: Include in ROM Build

Copy modules to your Android build tree:
```bash
# Copy to vendor modules
cp *.ko $ANDROID_PRODUCT_OUT/vendor/lib/modules/

# Copy firmware
cp firmware/*.bin $ANDROID_PRODUCT_OUT/vendor/firmware/rtw88/
```

---

## 🔌 Loading Modules

> **⚠️ CRITICAL: Module Loading Order**
>
> RTW88 modules **MUST** be loaded in the correct dependency order. Loading modules out of order will result in `insmod: failed to load: No such file or directory` errors, even though the file exists. This misleading error actually means **"missing dependency symbols"**.

### Understanding Module Dependencies

Each RTW88 module has dependencies that must be loaded first. You can check any module's dependencies with:
```bash
modinfo /path/to/module.ko | grep depends
```

**Example:**
```bash
# Check what rtw_8822bu depends on
modinfo /vendor/lib/modules/rtw_8822bu.ko | grep depends
# Output: depends: rtw_usb,rtw_8822b

# This means you must load rtw_core, rtw_usb, and rtw_8822b BEFORE rtw_8822bu
```

### Module Dependency Hierarchy
```
rtw_core.ko                    # Base module (ALWAYS LOAD FIRST!)
├── rtw_usb.ko                 # USB bus interface
├── rtw_sdio.ko                # SDIO bus interface
├── rtw_pci.ko                 # PCI bus interface
├── rtw_8723x.ko               # Common code for 8723 series
├── rtw_88xxa.ko               # Common code for 88xx series
├── rtw_8703b.ko               # Depends on: rtw_core, rtw_8723x
│   └── rtw_8723cs.ko          # Depends on: rtw_8703b, rtw_sdio
├── rtw_8723d.ko               # Depends on: rtw_core, rtw_8723x
│   ├── rtw_8723ds.ko          # Depends on: rtw_8723d, rtw_sdio
│   └── rtw_8723du.ko          # Depends on: rtw_8723d, rtw_usb
├── rtw_8812a.ko               # Depends on: rtw_core, rtw_88xxa
│   └── rtw_8812au.ko          # Depends on: rtw_8812a, rtw_usb
├── rtw_8814a.ko               # Depends on: rtw_core, rtw_88xxa
│   └── rtw_8814au.ko          # Depends on: rtw_8814a, rtw_usb
├── rtw_8821a.ko               # Depends on: rtw_core, rtw_88xxa
│   └── rtw_8821au.ko          # Depends on: rtw_8821a, rtw_usb
├── rtw_8821c.ko               # Depends on: rtw_core
│   ├── rtw_8821cs.ko          # Depends on: rtw_8821c, rtw_sdio
│   └── rtw_8821cu.ko          # Depends on: rtw_8821c, rtw_usb
├── rtw_8822b.ko               # Depends on: rtw_core
│   ├── rtw_8822bs.ko          # Depends on: rtw_8822b, rtw_sdio
│   └── rtw_8822bu.ko          # Depends on: rtw_8822b, rtw_usb
└── rtw_8822c.ko               # Depends on: rtw_core
    ├── rtw_8822cs.ko          # Depends on: rtw_8822c, rtw_sdio
    └── rtw_8822cu.ko          # Depends on: rtw_8822c, rtw_usb
```

### Standard Loading Sequence
```bash
cd /vendor/lib/modules

# Step 1: Load core module (REQUIRED - must be first!)
insmod ./rtw_core.ko

# Step 2: Load bus interfaces
insmod ./rtw_sdio.ko   # For SDIO devices
insmod ./rtw_usb.ko    # For USB devices
# insmod ./rtw_pci.ko  # For PCI devices (if needed)

# Step 3: Load common code modules (if using related chipsets)
insmod ./rtw_8723x.ko  # Required for 8703B and 8723D series
insmod ./rtw_88xxa.ko  # Required for 8812/8814/8821A series

# Step 4: Load chipset base modules (for your specific hardware)
# Example for RTL8822BU (USB):
insmod ./rtw_8822b.ko   # Load base chipset module
insmod ./rtw_8822bu.ko  # Load USB interface module

# Example for RTL8821CU (USB):
insmod ./rtw_8821c.ko
insmod ./rtw_8821cu.ko

# Example for RTL8723DS (SDIO):
insmod ./rtw_8723x.ko   # Common code
insmod ./rtw_8723d.ko   # Chipset base
insmod ./rtw_8723ds.ko  # SDIO interface
```

### Loading All Modules (Complete Script)

If you want to load support for all chipsets:
```bash
#!/system/bin/sh
# RTW88 Complete Module Loading Script

cd /vendor/lib/modules

echo "Loading RTW88 WiFi drivers..."

# Core module (MUST be first)
insmod ./rtw_core.ko || { echo "Failed to load rtw_core!"; exit 1; }

# Bus interfaces
insmod ./rtw_sdio.ko
insmod ./rtw_usb.ko
# insmod ./rtw_pci.ko  # Uncomment if PCI support needed

# Common code modules
insmod ./rtw_88xxa.ko
insmod ./rtw_8723x.ko

# Chipset base modules
insmod ./rtw_8703b.ko
insmod ./rtw_8723d.ko
insmod ./rtw_8812a.ko
insmod ./rtw_8814a.ko
insmod ./rtw_8821a.ko
insmod ./rtw_8821c.ko
insmod ./rtw_8822b.ko
insmod ./rtw_8822c.ko

# Interface-specific modules (SDIO)
insmod ./rtw_8723cs.ko
insmod ./rtw_8723ds.ko
insmod ./rtw_8821cs.ko
insmod ./rtw_8822bs.ko
insmod ./rtw_8822cs.ko

# Interface-specific modules (USB)
insmod ./rtw_8723du.ko
insmod ./rtw_8812au.ko
insmod ./rtw_8814au.ko
insmod ./rtw_8821au.ko
insmod ./rtw_8821cu.ko
insmod ./rtw_8822bu.ko
insmod ./rtw_8822cu.ko

echo "Modules loaded successfully!"
lsmod | grep rtw
```

Save this as `/vendor/bin/load_rtw88.sh`, make it executable with `chmod +x`, and run it.

### Automatic Loading on Boot

Create `/vendor/etc/init/rtw88-wifi.rc`:
```rc
on boot
    # RTW88 WiFi Driver Loading
    # Load in strict dependency order
    
    # Core (required)
    insmod /vendor/lib/modules/rtw_core.ko
    
    # Bus interfaces
    insmod /vendor/lib/modules/rtw_sdio.ko
    insmod /vendor/lib/modules/rtw_usb.ko
    
    # Common code
    insmod /vendor/lib/modules/rtw_88xxa.ko
    insmod /vendor/lib/modules/rtw_8723x.ko
    
    # Chipset bases
    insmod /vendor/lib/modules/rtw_8703b.ko
    insmod /vendor/lib/modules/rtw_8723d.ko
    insmod /vendor/lib/modules/rtw_8812a.ko
    insmod /vendor/lib/modules/rtw_8814a.ko
    insmod /vendor/lib/modules/rtw_8821a.ko
    insmod /vendor/lib/modules/rtw_8821c.ko
    insmod /vendor/lib/modules/rtw_8822b.ko
    insmod /vendor/lib/modules/rtw_8822c.ko
    
    # Interface modules
    insmod /vendor/lib/modules/rtw_8723cs.ko
    insmod /vendor/lib/modules/rtw_8723ds.ko
    insmod /vendor/lib/modules/rtw_8723du.ko
    insmod /vendor/lib/modules/rtw_8812au.ko
    insmod /vendor/lib/modules/rtw_8814au.ko
    insmod /vendor/lib/modules/rtw_8821au.ko
    insmod /vendor/lib/modules/rtw_8821cs.ko
    insmod /vendor/lib/modules/rtw_8821cu.ko
    insmod /vendor/lib/modules/rtw_8822bs.ko
    insmod /vendor/lib/modules/rtw_8822bu.ko
    insmod /vendor/lib/modules/rtw_8822cs.ko
    insmod /vendor/lib/modules/rtw_8822cu.ko
```

### For Kali NetHunter Users

If using Kali NetHunter, create a custom script at `/sdcard/nh_files/modules/rtw88_loader.sh`:
```bash
#!/system/bin/sh
# NetHunter RTW88 Module Loader

MODULE_DIR="/vendor/lib/modules"

# Check dependencies before loading
check_dependency() {
    local module=$1
    local deps=$(modinfo ${MODULE_DIR}/${module}.ko 2>/dev/null | grep "depends:" | cut -d: -f2 | tr -d ' ')
    
    if [ -n "$deps" ]; then
        echo "Module $module depends on: $deps"
        IFS=',' read -ra DEP_ARRAY <<< "$deps"
        for dep in "${DEP_ARRAY[@]}"; do
            if ! lsmod | grep -q "^${dep} "; then
                echo "Loading dependency: $dep"
                insmod ${MODULE_DIR}/${dep}.ko || return 1
            fi
        done
    fi
}

# Load module with dependency checking
load_module() {
    local module=$1
    if lsmod | grep -q "^${module} "; then
        echo "✓ $module already loaded"
        return 0
    fi
    
    check_dependency $module
    insmod ${MODULE_DIR}/${module}.ko
    
    if [ $? -eq 0 ]; then
        echo "✓ $module loaded successfully"
        return 0
    else
        echo "✗ Failed to load $module"
        return 1
    fi
}

# Main loading sequence
load_module rtw_core || exit 1
load_module rtw_usb
load_module rtw_sdio
load_module rtw_88xxa
load_module rtw_8723x

# Load your specific chipset here
# Example: load_module rtw_8822b && load_module rtw_8822bu

echo ""
echo "Loaded modules:"
lsmod | grep rtw
```

---

## 🔍 Verification

### Check Module Loading
```bash
# List loaded modules
lsmod | grep rtw

# Check dmesg for driver messages
dmesg | grep rtw88

# Verify WiFi interface
ip link show
# OR
ifconfig -a
```

### Check Module Info
```bash
modinfo /vendor/lib/modules/rtw_core.ko
```

### Check Module Dependencies
```bash
# Check dependencies for any module
modinfo /vendor/lib/modules/rtw_8822bu.ko | grep depends

# Check all module dependencies at once
for ko in /vendor/lib/modules/rtw_*.ko; do 
    echo "$(basename $ko): $(modinfo $ko 2>/dev/null | grep depends | cut -d: -f2)"
done
```

---

## 🐛 Troubleshooting

### Module Won't Load - "No such file or directory"

**Error:** `insmod: failed to load ./rtw_8822bu.ko: No such file or directory`

**This error is misleading!** The file exists, but the module can't load because:

1. **Missing dependencies** - Required modules not loaded yet
2. **Unresolved symbols** - Functions from other modules not available

**Solution:**
```bash
# Check what the module depends on
modinfo ./rtw_8822bu.ko | grep depends
# Output: depends: rtw_usb,rtw_8822b

# Load dependencies first
insmod ./rtw_core.ko    # Always load core first
insmod ./rtw_usb.ko     # Load USB bus interface
insmod ./rtw_8822b.ko   # Load chipset base
insmod ./rtw_8822bu.ko  # Now this will work!
```

### Module Won't Load - "Unknown symbol"

**Error:** `rtw_8822c: Unknown symbol rtw_power_off (err -2)`

**Cause:** Core module (`rtw_core.ko`) not loaded or loaded after the chipset module.

**Solution:**
```bash
# Unload the failed module
rmmod rtw_8822c

# Load core first, then reload
insmod ./rtw_core.ko
insmod ./rtw_8822c.ko
```

### Module Won't Load - "Invalid module format"

**Error:** `Invalid module format` or version mismatch

**Solution:**
1. Check kernel version matches:
```bash
   uname -r  # Your kernel version
   modinfo ./rtw_core.ko | grep vermagic  # Module's kernel version
```
2. If versions don't match, rebuild modules with correct kernel source
3. Ensure module architecture matches (ARM64 modules for ARM64 kernel)

### Firmware Not Found

**Error:** `rtw88: firmware request failed`

**Solution:**
1. Verify firmware files are in `/vendor/firmware/rtw88/`
2. Check SELinux permissions: `restorecon -R /vendor/firmware/rtw88`
3. Download firmware from [linux-firmware repository](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git)

### WiFi Interface Not Appearing

**Solution:**
1. Check if modules loaded: `lsmod | grep rtw`
2. Check dmesg for errors: `dmesg | grep -i rtw`
3. Verify hardware is detected: `lsusb` or `lspci`
4. Ensure correct modules loaded for your hardware (USB vs SDIO vs PCI)

### Build Errors

**Error:** `__nonstring undeclared` or `RX_FLAG_NO_PSDU undeclared`

**Solution:** This repo is already patched! If you see this, you might have the wrong branch. Use the `main` branch.

---

## 📝 Compatibility Notes

### Tested Kernels
- ✅ Linux 4.14 (Android common kernel)
- ✅ Linux 4.19 (GKI base)
- ✅ Linux 5.4 (LTS)
- ✅ Linux 5.10 (LTS)

### Known Limitations
- PCI modules require `CONFIG_PCI=y` in kernel config
- SDIO modules require `CONFIG_MMC` support
- Some chipsets may require additional firmware files
- **Module loading order is critical** - see [Loading Modules](#-loading-modules) section

---

## 📚 Documentation

- [Changelog](CHANGELOG.md) - Detailed change history and patch descriptions
- [Android Kernel Docs](https://source.android.com/docs/core/architecture/kernel) - Android kernel guide
- [Upstream RTW88 Docs](https://wireless.wiki.kernel.org/en/users/drivers/rtw88) - Kernel.org documentation

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Report bugs** - Open an issue with device details and logs
2. **Test on new devices** - Share compatibility results
3. **Improve patches** - Submit PRs with better compatibility fixes
4. **Add firmware** - Help locate and document required firmware files
5. **Documentation** - Improve setup instructions

### Contribution Guidelines

- Test changes on real hardware before submitting
- Maintain compatibility with both old and new kernels
- Keep patches minimal and well-documented
- Follow kernel coding style

---

## ⚖️ License

This project maintains the original driver licenses:

- **Driver code:** GPL-2.0 OR BSD-3-Clause
- **Build scripts:** GPL-3.0 (this repository)

See [LICENSE](LICENSE) for full details.

---

## 🙏 Credits

- **Upstream RTW88 drivers** - Linux kernel wireless maintainers
- **Realtek** - Original driver development
- **Android kernel team** - Kernel infrastructure
- **Community contributors** - Testing and bug reports

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/ShorterKing/RTW88-Android-Drivers/issues)
- **Discussions:** Use GitHub Discussions for questions

---

## 🌟 Star History

If this project helped you, consider giving it a ⭐ star!

---

<div align="center">

**Built with ❤️ for the Android modding community**

[Report Bug](https://github.com/ShorterKing/RTW88-Android-Drivers/issues) • [Request Feature](https://github.com/ShorterKing/RTW88-Android-Drivers/issues) • [Contribute](https://github.com/ShorterKing/RTW88-Android-Drivers/pulls)

</div>
