#!/bin/bash

BOLDGREEN="\e[1;32m"
BOLDRED="\e[1;31m"
BOLDBLUE="\e[1;96m"
BOLDYELLOW="\e[1;33m"
ENDCOLOR="\e[0m"

if ! command -v figlet >/dev/null 2>&1; then
    sudo apt install -y figlet
fi

if [ ! -f config.cfg ]; then
    echo "${BOLDRED}[-] config file not found$ENDCOLOR"
    exit 1
fi

source config.cfg

if [[ ! $ARCH ]] then
	echo -e "${BOLDRED}[-] ARCH is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $TD ]] then
	echo -e "${BOLDRED}[-] TD is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $BIN_PATH ]] then
	echo -e "${BOLDRED}[-] BIN_PATH is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $CC ]] then
	echo -e "${BOLDRED}[-] CC is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $CLANG_TRIPLE ]] then
	echo -e "${BOLDRED}[-] CLANG_TRIPLE is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ ! $CROSS_COMPILE ]] then
	echo -e "${BOLDRED}[-] CROSS_COMPILE is empty or not set!$ENDCOLOR"
	exit 1
fi
BIN_PATH=$BIN_PATH
export PATH="$BIN_PATH:$PATH"
export ARCH=$ARCH
export CC=$CC
export CLANG_TRIPLE=$CLANG_TRIPLE
export CROSS_COMPILE=$CROSS_COMPILE
if [[ $CROSS_COMPILE_ARM32 ]] then
	export CROSS_COMPILE_ARM32=$CROSS_COMPILE_ARM32
fi
if [[ $KCFLAGS ]] then
	export KCFLAGS=$KCFLAGS
fi
if [[ $KCPPFLAGS ]] then
	export KCPPFLAGS=$KCPPFLAGS
fi
if [[ $ANDROID_MAJOR_VERSION ]] then
	export ANDROID_MAJOR_VERSION=$ANDROID_MAJOR_VERSION
fi
if [[ ! $SECTION_MISMATCH_WARN_ONLY ]] then
	echo -e "${BOLDRED}[-] SECTION_MISMATCH_WARN_ONLY is empty or not set!$ENDCOLOR"
	exit 1
fi
if [[ $ENV ]] then
	export BUILDER_ENV=$ENV
fi

case $SECTION_MISMATCH_WARN_ONLY in
	y)
		export CONFIG_SECTION_MISMATCH_WARN_ONLY=y
		BUILDER_ENV_2="CONFIG_SECTION_MISMATCH_WARN_ONLY=y"
		;;
	e)
		export CONFIG_SECTION_MISMATCH=y
		export CONFIG_SECTION_MISMATCH_WARN_ONLY=n
		BUILDER_ENV_2="CONFIG_SECTION_MISMATCH=y"
		;;
	n)
		export CONFIG_SECTION_MISMATCH=n
		export CONFIG_SECTION_MISMATCH_WARN_ONLY=n
		BUILDER_ENV_2=""
		;;
esac
OUT_DIR=$OUT_DIR
MODULES_OUT_DIR=$MODULES_OUT_DIR
KDIR=$(pwd)

function show_gui() {
	if [ -f "$KDIR/$OUT_DIR/.config" ]; then
		CONFIG_STATUS="${BOLDGREEN}Config present$ENDCOLOR"
	else
		CONFIG_STATUS="${BOLDRED}No .config found$ENDCOLOR"
	fi
	clear
	echo -e "\e[1;93m"
	figlet Kernel Builder
	echo -e "\e[0m"
	echo -e "${BOLDGREEN}By: ${BOLDYELLOW}Karam (karamdev1)$ENDCOLOR"
	echo -e "${BOLDGREEN}Version: ${BOLDYELLOW}v1.1$ENDCOLOR"
	echo
	echo -e "${BOLDGREEN}ARCH: $BOLDYELLOW${ARCH}$ENDCOLOR"
	echo -e "${BOLDGREEN}CC Version: ${BOLDYELLOW}N/A$ENDCOLOR"
	echo -e "${BOLDGREEN}Kernel Config: ${CONFIG_STATUS}$ENDCOLOR"
	echo
	echo -e "$BOLDGREEN|-----------------------------------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN| Actions:                                            |$ENDCOLOR"
	echo -e "$BOLDGREEN|-------------------${ENDCOLOR}Kernel$BOLDGREEN----------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}1$ENDCOLOR] Compile Kernel                           $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}2$ENDCOLOR] Compile Module $BOLDBLUE(Prepare before Compile!) $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}3$ENDCOLOR] Prepare Module                           $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}4$ENDCOLOR] Copy Modules   $BOLDBLUE(Compile before Copy!)    $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|-----------------------------------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}5$ENDCOLOR] Clean Kernel    $BOLDBLUE(Clean & Mrproper)       $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}6$ENDCOLOR] Apply Defconfig $BOLDBLUE(Selection in Config)    $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|-----------------------------------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}7$ENDCOLOR] Edit Config $BOLDBLUE(MENUCONFIG) $BOLDYELLOW(GOOD)          $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}8$ENDCOLOR] Edit Config $BOLDBLUE(NCONFIG) $BOLDGREEN(BEST)             $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}9$ENDCOLOR] Save .config as new defconfig            $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|-------------------${ENDCOLOR}Script$BOLDGREEN----------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDRED}E$ENDCOLOR] Exit Builder                             $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        $ENDCOLOR[${BOLDBLUE}G$ENDCOLOR] Open the creator's github page           $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|-------------------${ENDCOLOR}End$BOLDGREEN-------------------------------|$ENDCOLOR"
	echo
}

function compileKernel() {
	echo -e "$BOLDGREEN[+] Building$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
	else
		echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
		make -s -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Kernel Building Succeed$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Kernel Building Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function compileModules() {
	echo -e "$BOLDGREEN[+] Building Modules$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
	else
		echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
		make -s -C "$KDIR" O="$OUT_DIR" INSTALL_MOD_PATH="$MODULES_OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 modules -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Modules Building Succeed$ENDCOLOR"
			echo -e "$BOLDGREEN[+] You can find the modules in $MODULES_OUT_DIR$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Modules Building Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function prepareModules() {
	echo -e "$BOLDGREEN[+] Preparing Modules$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
	else
		echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
		make -s -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 modules_prepare -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Preparing Modules Succeed$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Preparing Modules Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function copyModules() {
	echo -e "$BOLDGREEN[+] Coping Modules to $MODULES_OUT_DIR$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
	else
		echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
		make -C "$KDIR" O="$OUT_DIR" INSTALL_MOD_PATH="$MODULES_OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 modules_install -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Coping Building Succeed$ENDCOLOR"
			echo -e "$BOLDGREEN[+] You can find the modules in $MODULES_OUT_DIR$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Coping Building Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function cleanKernel() {
	echo -e "$BOLDGREEN[+] Cleaning$ENDCOLOR"
	if [[ ! -d "$KDIR/$MODULES_OUT_DIR" ]] then
		echo -e "$BOLDGREEN[+] Deleting $MODULES_OUT_DIR"
		rm -rf $MODULES_OUT_DIR
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Deleting Succeed$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Deleting Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
	make -s -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 clean -j"$(nproc)" && make -s -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 mrproper -j"$(nproc)"
	ret=$?
	if [ $ret -eq 0 ]; then
		echo -e "$BOLDGREEN[+] Cleaning Succeed$ENDCOLOR"
	else
		echo -e "$BOLDRED[-] Cleaning Failed (exit code: $ret)$ENDCOLOR"
	fi
}

function applyDefconfig() {
	echo -ne "$BOLDGREEN[+] Enter the defconfig's name: $ENDCOLOR"
	read config
	if [ ! -f "$KDIR/arch/$ARCH/configs/$config" ]; then
		echo -e "$BOLDRED[-] $config is not found$ENDCOLOR"
	else
		make -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 $config -j"$(nproc)"
		ret=$?
		if [ $ret -eq 0 ]; then
			echo -e "$BOLDGREEN[+] Config Applying Succeed$ENDCOLOR"
		else
			echo -e "$BOLDRED[-] Config Applying Failed (exit code: $ret)$ENDCOLOR"
		fi
	fi
}

function editConfig() {
	local config="$1"
	echo -e "$BOLDGREEN[+] Editing Config (${config^^})$ENDCOLOR"
	make -C "$KDIR" O="$OUT_DIR" $BUILDER_ENV $BUILDER_ENV_2 $config -j"$(nproc)"
}

function saveConfig() {
	echo -e "$BOLDGREEN[+] Saving current .config as new defconfig$ENDCOLOR"
	if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
		echo -e "$BOLDRED[!] .config is not found$ENDCOLOR"
	else
		echo -ne "$BOLDGREEN[!] Enter the new defconfig name: $ENDCOLOR"
		read newconfig
		if [ -f "$KDIR/arch/$ARCH/configs/$newconfig" ]; then
			echo -e "$BOLDRED[!] $newconfig is found"
			echo -ne "Do you want to overwrite it?$ENDCOLOR [y,N]: "
			read answer
			case "$answer" in
				Y|y)
					echo -e "$BOLDGREEN[+] Overwriting current .config as $newconfig$ENDCOLOR"
					cp "$KDIR/$OUT_DIR/.config" "$KDIR/arch/$ARCH/configs/$newconfig"
					ret=$?
					if [ $ret -eq 0 ]; then
						echo -e "$BOLDGREEN[+] Coping succeed$ENDCOLOR"
					else
						echo -e "$BOLDRED[-] Coping Failed (exit code: $ret)$ENDCOLOR"
					fi
					;;
				N|n|'')
					echo -e "$BOLDGREEN[!] Skipped Saving the new defconfig$ENDCOLOR"
					;;
			esac
		else
			echo -e "$BOLDGREEN[+] Saving current .config as $newconfig$ENDCOLOR"
			cp "$KDIR/$OUT_DIR/.config" "$KDIR/arch/$ARCH/configs/$newconfig"
			ret=$?
			if [ $ret -eq 0 ]; then
				echo -e "$BOLDGREEN[+] Coping succeed$ENDCOLOR"
			else
				echo -e "$BOLDRED[-] Coping Failed (exit code: $ret)$ENDCOLOR"
			fi
		fi
	fi
}

while true; do
	show_gui
	echo -ne "${BOLDGREEN}Enter the action: $ENDCOLOR"
	read action

	case $action in
		1)
			compileKernel
			;;
		2)
			compileModules
			;;
		3)
			prepareModules
			;;
		4)
			copyModules
			;;
		5)
			cleanKernel
			;;
		6)
			applyDefconfig
			;;
		7)
			editConfig "menuconfig"
			;;
		8)
			editConfig "nconfig"
			;;
		9)
			saveConfig
			;;
		E|e)
			echo -e "$BOLDRED[!] Exiting!!$ENDCOLOR"
			break
			;;
		G|g)
			echo -e "$BOLDGREEN[+] Opening the creator's github page$ENDCOLOR"
			xdg-open https://github.com/karamdev1 > /dev/null 2>&1 &
			;;
		*)
			echo -e "$BOLDRED[!] Invalid Action!!$ENDCOLOR"
			;;
	esac
	echo -ne "${BOLDYELLOW}Press enter to continue$ENDCOLOR"
	read
done