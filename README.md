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

* Integrated **KernelSU Next v3.1.0-legacy** (Working & Tested)
* Kali NetHunter patches
* SELinux **Permissive** (Bootparam enabled)
* USB OTG support
* External USB Wi-Fi monitor mode + injection
* Driver's Modules support for multiple USB Wi-Fi chipsets
* CANbus support
* Bluetooth Subsystem Support
* Overclock:
  
  * CPU Stock Speeds
  * GPU Overclocked to 1.22GHz
* Force module unload support
* External module loading supported via NetHunter app

---

## Known Issues

* USB HID attacks → limited on MediaTek platform (hardware + kernel constraints)
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

1. Boot to recovery
2. Install kernel zip
3. Reboot

---

## Wi-Fi Drivers (Saved in /sdcard/kernel/modules)

**Tested**

* RTL8821CU
* RTL8192EU
* ZD1211/ZD1211B

**Built-in but untested**

* ATH: ATH6KL, AR9170 **Module**
* MediaTek: MT7601U **Module**
* Ralink: RT2x00, RT2500USB, RT2800USB **Module**
* Realtek:

  * RTL88XXAU **Module**
  * RTL8192EU **Module**
  * RTL8187/RTL8187B **Module**
  * RTL8821CU **Module**
* ZyDas: ZD1201, ZD1211/ZD1211B **Module**

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

---

### Compile External Modules

Recommended module path:

```
/sdcard/kernel/modules
```

Modules can be managed via NetHunter app.

---

## Author Notes

This kernel prioritizes:

* stability first
* performance second
* features third

Design goal: daily-driver capable NetHunter kernel.
