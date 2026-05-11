# NetHunter Kernel v4.1 — Samsung Galaxy A32 4G (SM-A325x)

Custom NetHunter-ready kernel built for stability, performance tuning, and external adapter penetration testing.

---

## [Download from Google Drive](https://drive.google.com/drive/folders/1-WTgc8WdROdaQjSQCMAMkMX8YOPUw8yN?usp=drive_link)
## [Kernel Source](https://github.com/Samsung-MT6769-Devs/android_kernel_samsung_mt6768)

---

## Disclaimer

This kernel is unofficial and intended strictly for **development, security research, and educational use**.
You accept full responsibility for anything that happens to your device, data, or network.

Not affiliated with Offensive Security or Kali NetHunter.

---

## Key Features

* Integrated **KernelSU Next v3.2.0-legacy** (Working & Tested)
* SELinux **Permissive**
* USB OTG Support
* USB HID Support (Emulating Keyboard and Mouse)
* Wi-Fi Monitor mode and Injection for external adapters
* BT Subsystem support (some chipsets may need their firmware in **/vendor/firmware**)
* CANBus Subsystem Support
* NFS Support
* SDR Support

---

## Bugs

* Internal Wi-Fi injection not supported (hardware limitation)

---

## Wi-Fi Drivers

**Tested**

* RTL8821CU
* RTL8192EU
* ZD1211/ZD1211B

**Built-in but untested**

* ATH: ATH6KL, AR9170
* MediaTek: MT7601U
* Ralink: RT2x00, RT2500USB, RT2800USB
* Realtek:
  
  * RTL88XXAU **Module**
  * RTL8192EU **Module**
  * RTL8188EU/CU
  * RTL8192CU
  * RTL8821CU **Module**
  * RTL8187/RTL8187B
* ZyDas: ZD1201, ZD1211/ZD1211B

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

1. Boot to recovery
2. Install kernel zip
3. Reboot

---

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
