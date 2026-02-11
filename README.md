# NetHunter Kernel v3 — Samsung Galaxy A32 (SM-A325F / A325x)

Custom NetHunter-ready kernel built for stability, performance tuning, and external adapter penetration testing.

---

## [Click here to download](https://t.me/karamdev1group)

---

## Base Source

Derived from Samsung MT6768 kernel tree
[Kernel Source](https://github.com/Samsung-MT6769-Devs/android_kernel_samsung_mt6768)

---

## Disclaimer

This kernel is unofficial and intended strictly for **development, security research, and educational use**.
You accept full responsibility for anything that happens to your device, data, or network.

Not affiliated with Offensive Security or Kali NetHunter.

---

## Key Features

* Integrated **SukiSU** (working and tested)
* Kali NetHunter patches
* SELinux **Permissive** (reported as Enforcing)
* USB OTG support
* External USB Wi-Fi monitor mode + injection
* Built-in support for multiple USB Wi-Fi chipsets
* CPU overclock:

  * LITTLE cores: 1.8 → 2.3 GHz
  * BIG cores: 2.0 → 2.5 GHz
* Default governor: **Interactive** (balanced smoothness + battery)
* Force module unload support
* External module loading supported via NetHunter app

---

## Known Issues

* USB HID attacks → limited on MediaTek platform (hardware + kernel constraints)
* Bluetooth subsystem currently disabled due to unresolved compile errors
* Internal Wi-Fi injection not supported (hardware limitation)

---

## Supported Devices

* Samsung Galaxy A32 4G (SM-A325F / A325M / A325x variants)

---

## Supported ROMs

Tested:

* One UI 5.1

Should work (not verified):

* One UI 6 / 7 / 8 ports
* LumiROM builds

---

## Flash Requirements

* Unlocked bootloader
* Custom recovery (recommended)

TWRP build: [Recommended TWRP](https://github.com/Luminous418/twrp_device_samsung_a32/releases/tag/TWRP-3.7.0_12.1-a32-20251227)

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

**SukiSU**

1. Install SukiSU Manager
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

**KernelSU / SukiSU**
Manual install required. Module support varies.

---

**Recovery method**
Generic installer may fail on dynamic partitions. Editing installer scripts can bypass this but may break system.

---

## Integrated Wi-Fi Drivers

**Tested**

* RTL8821CU

**Built-in but untested**

* ATH: ATH6KL, AR9170
* Atmel: AT76c503 / 505 / 505a
* MediaTek: MT7601U
* Ralink: RT2x00, RT2500USB, RT2800USB
* Realtek:

  * RTL8192 series
  * RTL8723 series
  * RTL8188EE
  * RTL818X
  * RTL8821A/C
  * RTL8812A
  * RTL8814A
* ZyDas: ZD1201

External modules can be compiled separately and loaded dynamically.

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
/vendor/lib/modules
```

Modules can then be managed via NetHunter app.

---

## Notes

* Not all USB Wi-Fi chipsets are compiled in.
* Some adapters require manual module builds.
* Stability testing is ongoing.
* Releases are versioned and recoverable via Git history.

---

## Status

Current build has passed:

* boot tests
* stability tests
* Wi-Fi injection tests
* long runtime tests

Further testing in progress before public release.

---

## Author Notes

This kernel prioritizes:

* stability first
* performance second
* features third

Design goal: daily-driver capable NetHunter kernel.
