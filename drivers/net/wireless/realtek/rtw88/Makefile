SHELL := /bin/sh

# Get the absolute path of this Makefile's directory
PWD := $(shell pwd)

# Android-specific configuration
# Set these according to your device and build environment
ARCH ?= arm64
SUBARCH ?= arm64

# Toolchain configuration
# Set these via environment variables or modify here
CLANG_PATH ?= $(HOME)/toolchains/android_prebuilts_clang_host_linux-x86_clang-r416183b/bin
CC ?= $(CLANG_PATH)/clang
CLANG_TRIPLE ?= aarch64-linux-gnu-
CROSS_COMPILE ?= $(HOME)/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-
HOSTCC ?= gcc-12
HOSTCXX ?= g++-12

# Kernel configuration
KVER ?= $(if $(KERNELRELEASE),$(KERNELRELEASE),$(shell uname -r))
KSRC ?= $(if $(KERNEL_SRC),$(KERNEL_SRC),$(HOME)/android_crdroid_14_kernel_dev_testing_kit)
KBUILD_OUTPUT ?= $(KSRC)/out
JOBS ?= $(shell nproc --ignore=1)

# Android module and firmware paths
ANDROID_PRODUCT_OUT ?= /path/to/android/out/target/product/yourdevice
MODDESTDIR := $(ANDROID_PRODUCT_OUT)/vendor/lib/modules
FWDIR := $(ANDROID_PRODUCT_OUT)/vendor/firmware/rtw88

# If building directly with kernel output
# MODDESTDIR := $(KBUILD_OUTPUT)/vendor/lib/modules
# FWDIR := $(KBUILD_OUTPUT)/vendor/firmware/rtw88

MODLIST := rtw_8723cs rtw_8723de rtw_8723ds rtw_8723du \
	   rtw_8812au rtw_8814ae rtw_8814au rtw_8821au rtw_8821ce rtw_8821cs rtw_8821cu \
	   rtw_8822be rtw_8822bs rtw_8822bu rtw_8822ce rtw_8822cs rtw_8822cu \
	   rtw_8703b rtw_8723d rtw_8821a rtw_8812a rtw_8814a rtw_8821c rtw_8822b rtw_8822c \
	   rtw_8723x rtw_88xxa rtw_pci rtw_sdio rtw_usb rtw_core

# Compiler flags - adjusted for Android
ccflags-y += -O2 -Wno-declaration-after-statement
ccflags-y += -DCONFIG_RTW88_LEDS=1
ccflags-y += -DCONFIG_RTW88_DEBUG=1
ccflags-y += -DCONFIG_RTW88_DEBUGFS=1
ccflags-y += -D__CHECK_ENDIAN__

# Remove -std=gnu11 if your Android kernel toolchain doesn't support it
# Uncomment the line below if you encounter compilation errors
ccflags-y += -std=gnu11

obj-$(CONFIG_RTW88)		+= rtw_core.o
rtw_core-objs	+= main.o \
		   led.o \
		   mac80211.o \
		   util.o \
		   debug.o \
		   tx.o \
		   rx.o \
		   mac.o \
		   phy.o \
		   coex.o \
		   efuse.o \
		   fw.o \
		   ps.o \
		   sec.o \
		   bf.o \
		   regd.o \
		   sar.o

ifeq ($(CONFIG_PM), y)
rtw_core-objs	+= wow.o
endif

obj-$(CONFIG_RTW88)		+= rtw_8703b.o
rtw_8703b-objs	:= rtw8703b.o rtw8703b_tables.o

ifeq ($(CONFIG_MMC), y)
obj-$(CONFIG_RTW88)		+= rtw_8723cs.o
rtw_8723cs-objs	:= rtw8723cs.o
endif

obj-$(CONFIG_RTW88)		+= rtw_8723d.o
rtw_8723d-objs	:= rtw8723d.o rtw8723d_table.o

ifeq ($(CONFIG_PCI), y)
obj-$(CONFIG_RTW88)		+= rtw_8723de.o
rtw_8723de-objs	:= rtw8723de.o
endif

ifeq ($(CONFIG_MMC), y)
obj-$(CONFIG_RTW88)		+= rtw_8723ds.o
rtw_8723ds-objs	:= rtw8723ds.o
endif

obj-$(CONFIG_RTW88)		+= rtw_8723du.o
rtw_8723du-objs	:= rtw8723du.o

obj-$(CONFIG_RTW88)		+= rtw_8723x.o
rtw_8723x-objs	:= rtw8723x.o

obj-$(CONFIG_RTW88)		+= rtw_8812au.o
rtw_8812au-objs	:= rtw8812au.o

obj-$(CONFIG_RTW88)		+= rtw_8821a.o
rtw_8821a-objs	:= rtw8821a.o rtw8821a_table.o

obj-$(CONFIG_RTW88)		+= rtw_8812a.o
rtw_8812a-objs	:= rtw8812a.o rtw8812a_table.o

obj-$(CONFIG_RTW88)		+= rtw_88xxa.o
rtw_88xxa-objs	:= rtw88xxa.o

obj-$(CONFIG_RTW88)		+= rtw_8821au.o
rtw_8821au-objs	:= rtw8821au.o

obj-$(CONFIG_RTW88)		+= rtw_8814a.o
rtw_8814a-objs	:= rtw8814a.o rtw8814a_table.o

obj-$(CONFIG_RTW88)		+= rtw_8814au.o
rtw_8814au-objs	:= rtw8814au.o

ifeq ($(CONFIG_PCI), y)
obj-$(CONFIG_RTW88)		+= rtw_8814ae.o
rtw_8814ae-objs	:= rtw8814ae.o
endif

obj-$(CONFIG_RTW88)		+= rtw_8821c.o
rtw_8821c-objs	:= rtw8821c.o rtw8821c_table.o

ifeq ($(CONFIG_PCI), y)
obj-$(CONFIG_RTW88)		+= rtw_8821ce.o
rtw_8821ce-objs	:= rtw8821ce.o
endif

ifeq ($(CONFIG_MMC), y)
obj-$(CONFIG_RTW88)		+= rtw_8821cs.o
rtw_8821cs-objs	:= rtw8821cs.o
endif

obj-$(CONFIG_RTW88)		+= rtw_8821cu.o
rtw_8821cu-objs	:= rtw8821cu.o

obj-$(CONFIG_RTW88)		+= rtw_8822b.o
rtw_8822b-objs	:= rtw8822b.o rtw8822b_table.o

ifeq ($(CONFIG_PCI), y)
obj-$(CONFIG_RTW88)		+= rtw_8822be.o
rtw_8822be-objs	:= rtw8822be.o
endif

ifeq ($(CONFIG_MMC), y)
obj-$(CONFIG_RTW88)		+= rtw_8822bs.o
rtw_8822bs-objs	:= rtw8822bs.o
endif

obj-$(CONFIG_RTW88)		+= rtw_8822bu.o
rtw_8822bu-objs	:= rtw8822bu.o

obj-$(CONFIG_RTW88)		+= rtw_8822c.o
rtw_8822c-objs	:= rtw8822c.o rtw8822c_table.o

ifeq ($(CONFIG_PCI), y)
obj-$(CONFIG_RTW88)		+= rtw_8822ce.o
rtw_8822ce-objs	:= rtw8822ce.o
endif

ifeq ($(CONFIG_MMC), y)
obj-$(CONFIG_RTW88)		+= rtw_8822cs.o
rtw_8822cs-objs	:= rtw8822cs.o
endif

obj-$(CONFIG_RTW88)		+= rtw_8822cu.o
rtw_8822cu-objs	:= rtw8822cu.o

ifeq ($(CONFIG_PCI), y)
obj-$(CONFIG_RTW88)		+= rtw_pci.o
rtw_pci-objs	:= pci.o
endif

ifeq ($(CONFIG_MMC), y)
obj-$(CONFIG_RTW88)		+= rtw_sdio.o
rtw_sdio-objs	:= sdio.o
endif

obj-$(CONFIG_RTW88)		+= rtw_usb.o
rtw_usb-objs	:= usb.o

all: 
	$(MAKE) -j$(JOBS) \
		ARCH=$(ARCH) \
		SUBARCH=$(SUBARCH) \
		CC=$(CC) \
		CLANG_TRIPLE=$(CLANG_TRIPLE) \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		HOSTCC=$(HOSTCC) \
		HOSTCXX=$(HOSTCXX) \
		-C $(KSRC) \
		O=$(KBUILD_OUTPUT) \
		M=$(PWD) modules

install: all
	@mkdir -p $(MODDESTDIR)
	@install -D -m 644 -t $(MODDESTDIR) *.ko
	@echo "Modules installed to $(MODDESTDIR)"
	@echo "Note: You may need to manually push these to your device"

install_fw:
	@mkdir -p $(FWDIR)
	@install -Dvm 644 -t $(FWDIR) firmware/*.bin
	@echo "Firmware installed to $(FWDIR)"
	@echo "Note: You may need to manually push these to your device"

# For direct device installation (requires root access)
install_device:
	@echo "Installing modules to device..."
	@adb root
	@adb remount
	@adb shell mkdir -p /vendor/lib/modules
	@adb shell mkdir -p /vendor/firmware/rtw88
	@adb push *.ko /vendor/lib/modules/
	@adb push firmware/*.bin /vendor/firmware/rtw88/
	@adb reboot
	@echo "Modules and firmware pushed to device. Device rebooting..."

uninstall:
	@for mod in $(MODLIST); do \
		rm -vf $(MODDESTDIR)/$$mod.ko; \
	done
	@echo "Modules removed from $(MODDESTDIR)"

clean:
	$(MAKE) \
		ARCH=$(ARCH) \
		SUBARCH=$(SUBARCH) \
		CC=$(CC) \
		CLANG_TRIPLE=$(CLANG_TRIPLE) \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		-C $(KSRC) \
		O=$(KBUILD_OUTPUT) \
		M=$(PWD) clean

# Helper target to show configuration
config:
	@echo "Current configuration:"
	@echo "PWD               = $(PWD)"
	@echo "ARCH              = $(ARCH)"
	@echo "SUBARCH           = $(SUBARCH)"
	@echo "CC                = $(CC)"
	@echo "CLANG_TRIPLE      = $(CLANG_TRIPLE)"
	@echo "CROSS_COMPILE     = $(CROSS_COMPILE)"
	@echo "HOSTCC            = $(HOSTCC)"
	@echo "HOSTCXX           = $(HOSTCXX)"
	@echo "KSRC              = $(KSRC)"
	@echo "KBUILD_OUTPUT     = $(KBUILD_OUTPUT)"
	@echo "MODDESTDIR        = $(MODDESTDIR)"
	@echo "FWDIR             = $(FWDIR)"
	@echo "JOBS              = $(JOBS)"

# Prepare kernel for module building
prepare:
	@echo "Preparing kernel configuration..."
	@if [ ! -f $(KBUILD_OUTPUT)/.config ]; then \
		echo "ERROR: Kernel not configured. Please build your kernel first or copy .config to $(KBUILD_OUTPUT)"; \
		exit 1; \
	fi
	$(MAKE) \
		ARCH=$(ARCH) \
		SUBARCH=$(SUBARCH) \
		CC=$(CC) \
		CLANG_TRIPLE=$(CLANG_TRIPLE) \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		HOSTCC=$(HOSTCC) \
		HOSTCXX=$(HOSTCXX) \
		-C $(KSRC) \
		O=$(KBUILD_OUTPUT) \
		modules_prepare

.PHONY: all install install_fw install_device uninstall clean config prepare
