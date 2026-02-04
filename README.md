## NetHunter Kernel v3 for Samsung Galaxy A32 (SM-A325F)
This kernel is based on:
- [Samsung Galaxy A32 Kernel Source](https://github.com/Samsung-MT6769-Devs/android_kernel_samsung_a32/tree/bpf-5.10-phoenix)

## Features
- Kali NetHunter Patches
- SELinux disabled (boot parameter controlled) (when disabled it just shows its Enforcing)
- USB OTG support
- WiFi monitor mode & injection (external USB adapters only)

## Bugs
- USB HID (not working)
- Internal & External BT (not working when you want to use it as attack)

## Disclaimer
This kernel is **unofficial** and provided for **educational and security research purposes only**.  
I am not responsible for any damage, data loss, or misuse.

This project is **not affiliated** with Offensive Security or Kali NetHunter.

## Supported
- Device: Samsung Galaxy A32 (SM-A325F)
- SoC: MediaTek MT6769
- Android: One UI 5.1 (Android 13 Tested), One UI 6,7 and 8 Ports (Android 14,15 and 16 not tested)
- Bootloader: Unlocked

## Requirements to Flash
- Samsung Galaxy A32 (SM-A325F)
- Custom recovery (TWRP recommended) - [TWRP Download](https://github.com/Luminous418/twrp_device_samsung_a32/releases/tag/TWRP-3.7.0_12.1-a32-20251227)

## Notes
- WiFi drivers are **not integrated** into the kernel (The kernel got some drivers added).
- Users must compile and load external USB WiFi drivers as kernel modules.
- Modules can be stored anywhere and can be managed using the NetHunter app.

## WiFi Drivers Integrated
### Realtek
  - **RTL8812A, RTL8814A, RTL8821A, RTL8821C**

## Compiling the kernel or a driver as module
A real Linux environment is required (Ubuntu 20.04 / 22.04 recommended).  
Windows Subsystem for Linux (WSL) is **not supported**.

### 1. Install dependencies
```
sudo apt update && sudo apt install -y git build-essential bc flex bison libssl-dev libelf-dev \
device-tree-compiler lz4 xz-utils zlib1g-dev libncurses-dev pahole python3 python-is-python3 \
openjdk-17-jdk rsync cpio kmod zstd
```

### 2. Clone ZyC Clang Toolchain
```
git clone https://github.com/EmanuelCN/zyc_clang-14.git ~/toolchains/zyc-clang
```

### 3. Clean Kernel
```
./clean_kernel.sh
```

### 4. Build Kernel (Skip if you just don't want to compile the kernel)
```
./build_kernel.sh
```

### 5. Prepare & Compile Modules (Skip if you just want to compile the kernel)
```
./module_prepare.sh
```

### 6. Compile a driver as module against the kernel (Step 5. is required for having the headers)
Please use the same **toolchain** I provided if you're going to compile the driver out of the tree