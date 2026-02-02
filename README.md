## NetHunter Kernel v2 for Samsung Galaxy A32 (SM-A325F)
This kernel is based on:
- [Samsung Galaxy A32 Kernel Source](https://github.com/Samsung-MT6769-Devs/android_kernel_samsung_a32/tree/bpf-5.10-phoenix)

## Features
- Kali NetHunter Patches
- SELinux disabled (boot parameter controlled) (when disabled it just shows its Enforcing)
- USB OTG support
- USB HID (Not Tested)
- WiFi monitor mode & injection (external USB adapters only)

## Disclaimer
This kernel is **unofficial** and provided for **educational and security research purposes only**.  
I am not responsible for any damage, data loss, or misuse.

This project is **not affiliated** with Offensive Security or Kali NetHunter.

## Supported
- Device: Samsung Galaxy A32 (SM-A325F)
- SoC: MediaTek MT6769
- Android: One UI 5.1 (Android 13)
- Bootloader: Unlocked

## Requirements to Flash
- Samsung Galaxy A32 (SM-A325F)
- Custom recovery (TWRP recommended) - [TWRP Download](https://github.com/Luminous418/twrp_device_samsung_a32/releases/tag/TWRP-3.7.0_12.1-a32-20251227)

## Notes
- WiFi drivers are **not integrated** into the kernel (The kernel got some drivers added).
- Users must compile and load external USB WiFi drivers as kernel modules.
- Modules can be stored anywhere and can be managed using the NetHunter app.

If you didnt find your **WiFi Adapter SoC** Driver, Unfortunately you'll need to compile it as **module**
## WiFi Drivers Integrated
### Realtek
  - **RTL8821C**

## Compile a driver as module against the kernel
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

### 3. Clean & Prepare Modules (Cleaning is required)
```
./clean_kernel.sh & ./module_prepare.sh
```

### 4. Compile the driver as module against the kernel
Enjoy.

## Compiling the kernel
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

### 3. Clean, Compile Modules & Build the kernel
```
./clean_kernel.sh & ./module_prepare.sh & ./build_kernel.sh
```