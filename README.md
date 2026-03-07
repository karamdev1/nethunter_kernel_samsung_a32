# NetHunter Kernel v3 — Samsung Galaxy A32 4G (SM-A325x)

Custom NetHunter-ready kernel built for stability, performance tuning, and external adapter penetration testing.

---

## [Download from Telegram](https://t.me/karamdev1group)
## [Kernel Source](https://github.com/Samsung-MT6769-Devs/android_kernel_samsung_mt6768)

---

## Disclaimer

This kernel is unofficial and intended strictly for **development, security research, and educational use**.
You accept full responsibility for anything that happens to your device, data, or network.

Not affiliated with Offensive Security or Kali NetHunter.

---

## Key Features

* Integrated **KernelSU Next v3.0.1-legacy** (Working & Tested)
* Kali NetHunter patches
* SELinux **Permissive** (Bootparam enabled)
* USB OTG support
* External USB Wi-Fi monitor mode + injection
* Driver's Modules support for multiple USB Wi-Fi chipsets
* CANbus support
* Overclock:
  
  * CPU Stock Speeds
  * GPU Overclocked to 1.22GHz
* Force module unload support
* External module loading supported via NetHunter app

---

## Known Issues

* USB HID attacks → limited on MediaTek platform (hardware + kernel constraints)
* Bluetooth subsystem currently disabled due to unresolved compile errors
* Internal Wi-Fi injection not supported (hardware limitation)

---

## Supported Devices

* Samsung Galaxy A32 4G (SM-A325x variants)

---

## Flash Requirements

* Unlocked bootloader
* Custom recovery (recommended)

[TWRP Build](https://github.com/Luminous418/twrp_device_samsung_a32/releases/tag/TWRP-3.7.0_12.1-a32-20251227)

---

## Installation

### Flash Kernel

1. Boot to recovery
2. Install kernel zip
3. Reboot

---

### Root Setup

**Magisk (recommended)**

1. Install Magisk APK
2. Reboot if prompted

**KernelSU Next**

1. Install KernelSU Next Manager
2. Kernel already contains SU backend

---

### Install Kali NetHunter (Generic)

**Magisk method**

1. Open Magisk → Modules
2. Install from storage
3. Select NetHunter ZIP
4. Wait for install (10–30 min)
5. Reboot

> Note: Some Magisk builds may break NetHunter Terminal.

---

**KernelSU Next** (Not tested)

1. Open KernelSU Next → Settings (Gear icon in top right)
2. Meta Modules
3. Install **Hybrid Mount**
4. Reboot
5. Open KernelSU Next → Modules (The modules count)
6. Press '+ Install' and select NetHunter ZIP
7. Wait for install (10-30 min)
8. Reboot NetHunter App, NetHunter Terminal root privileges
9. Grant

---

**KernelSU Next Manual** (Incase KernelSU Next didnt work)

1. Download F-Droid app
2. Add nethunter repository
3. Download and install NetHunter App, NetHunter Terminal, NetHunter Kex and NetHunter Store
4. Grant NetHunter App, NetHunter Terminal root privileges
5. Open NetHunter App
6. Press the 3 lines on top right
7. Press Kali Chroot Manager
8. Press install and select full (Must full not minimal)
9. Wait to Installation of chroot to finish
10. Enjoy!

---

## Wi-Fi Drivers (Saved in /sdcard/nh_files/modules)

**Tested**

* RTL8821CU
* RTL8192EU
* ZD1211/ZD1211B

**Built-in but untested**

* ATH: ATH6KL, AR9170 **Module**
* Atmel: AT76c503 / 505 / 505a
* MediaTek: MT7601U **Module**
* Ralink: RT2x00, RT2500USB, RT2800USB,
* Realtek:

  * RTL88XXAU **Module**
  * RTL8192EU **Module**
  * RTL8187/RTL8187B
  * RTL8821CU **Module**
* ZyDas: ZD1201, ZD1211/ZD1211B **Module**

---

## Build Environment

WSL confirmed working.

### Dependencies

```
sudo apt update && sudo apt install -y \
git build-essential bc flex bison libssl-dev libelf-dev \
device-tree-compiler lz4 xz-utils zlib1g-dev libncurses-dev \
pahole python3 python-is-python3 openjdk-17-jdk rsync cpio kmod zstd
```

---

### Toolchain

```
git clone https://github.com/EmanuelCN/zyc_clang-14.git ~/toolchains/zyc-clang-14
```

---

### Build

```
./build.sh
```

---

### Compile External Modules

Recommended module path:

```
/sdcard/nh_files/modules
```

Modules can then be managed via NetHunter app.

---

## Author Notes

This kernel prioritizes:

* stability first
* performance second
* features third

Design goal: daily-driver capable NetHunter kernel.
