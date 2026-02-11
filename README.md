## NetHunter Kernel v3 for Samsung Galaxy A32 (SM-A325F)
This kernel is based on:
- [Samsung Galaxy A32 Kernel Source](https://github.com/Samsung-MT6769-Devs/android_kernel_samsung_mt6768)

## Disclaimer
This kernel is **unofficial** and provided for **educational and security research purposes only**.
I am not responsible for any damage, data loss, or misuse.

This project is **not affiliated** with Offensive Security or Kali NetHunter.

## Features
- SukiSU Integrated and Working (Tested)
- Kali NetHunter Patches
- SELinux **Permissive** (disguised as **Enforcing**)
- USB OTG support
- Wi-Fi monitor mode & injection (external USB adapters **only**) (Some Wi-Fi Drivers are built-in)
- CPU Overclocked: Little Cores from 1800MHz to 2300MHz, Big cores from 2000MHz, 2500MHz
- CPU Default Governor: Interactive (It makes the device smoother and doesn't affect alot on battery)

## Bugs
- USB HID Injection (Basically **Impossible** without heavy **patches** on **MTK**) (I might try!)
- Internal & External BT (The **Bluetooth Subsystem Support** has undeclared idenifiers so it couldn't be compiled)

## Supported
- Device: Samsung Galaxy A32 4G (SM-A325x)
- Roms: One UI 5.1, 6, 7, 8, 8.5? (Only 5.1 tested, if you want to try the ports 6,7,8,8.5 I recommend LumiROM **BUT** they are not tested)

## Requirements to Flash
- Samsung Galaxy A32 4G (SM-A325x)
- Custom recovery (TWRP recommended) - [TWRP Download](https://github.com/Luminous418/twrp_device_samsung_a32/releases/tag/TWRP-3.7.0_12.1-a32-20251227)

## Setup (Requires Root) (For root either use SukiSU or Magisk)
```
Flash Kernel
- Boot into Custom Recovery (TWRP)
-   Go to **Install** and flash the zip file you downloaded
Flash Root
Magisk (Not required if your kernel had magisk and setup showed Magisk Detected)
- Flash magisk apk file
SukiSU
- Just install SukiSU Manager (SukiSU Integrated in kernel)
Install Kali Nethunter Generic (Do the rooting method you used)
Magisk (if your magisk version is **30.6** then Nethunter Terminal won't work) **(Recommended)**
- Open magisk
- Go to modules tab
- Press **Install from Storage**
- Select **kali-nethunter-XXXX.X-generic-arm64-full.zip** and press **Ok** (You can use minimal if you want)
- Wait for flashing to finish it might take 10-30 minutes
- After flashing is completed Reboot your phone
- Enjoy!
KernelSU/SukiSU **(Not Recommended)**
- Unfortunately you have to flash it manually or use module for KernelSU/SukiSU
Recovery **(Not Recommended)**
- Kali Nethunter supports Recovery flash but Unfortunately for me it fails due to the A325x is a dynamic device
- You could edit the binary to make it pass but it might break your system
```

## Notes
- Not all Wi-Fi drivers are **integrated** into the kernel.
- Users must compile and load external USB Wi-Fi drivers as kernel modules if not listed in section **Integrated Wi-Fi Drivers**.
- Modules can be stored anywhere and can be managed using the NetHunter app.

## Integrated Wi-Fi Drivers
### ATH (Not **Tested**)
  - **ATH6KL, AR9170**
### Atmel (Not **Tested**)
  - **AT76c503, AT76c505, AT76c505a**
### Mediatek (Not **Tested**)
  - **MT7601U**
### Ralink (Not **Tested**)
  - **RT2x00, RT2500USB, RT2800USB**
### Realtek (Only **RTL8821CU** Tested)
  - **RTL8192C/CE/CU/SE/DE/EE, RTL8723COM/AE/BE, RTL8188EE**
  - **RTL818X, RTL8821A/C, RTL8812A, RTL8814A**
### ZyDas (Not **Tested**)
  - **ZD1201**

## Compiling the kernel or driver as an external module
Windows Subsystem for Linux (WSL) is **supported and tested**.

### 1. Install dependencies
```
sudo apt update && sudo apt install -y git build-essential bc flex bison libssl-dev libelf-dev \
device-tree-compiler lz4 xz-utils zlib1g-dev libncurses-dev pahole python3 python-is-python3 \
openjdk-17-jdk rsync cpio kmod zstd
```

### 2. Clone ZyC Clang Toolchain
```
git clone https://github.com/EmanuelCN/zyc_clang-14.git ~/toolchains/zyc-clang-14
```

### 3. Run Build Script (Able to select actions in GUI)
```
./build.sh
```

### 4. Compile a driver as an out of tree module (**Reminder**: )
**Notes**: Please use the **toolchain** I provided, I recommend to save the kernel in ```/vendor/lib/modules``` and use **NetHunter** App to manage them
