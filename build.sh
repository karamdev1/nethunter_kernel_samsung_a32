#!/bin/bash

if ! command -v figlet >/dev/null 2>&1; then
    sudo apt install -y figlet
fi

if [ ! -f config ]; then
    echo "\e[1;31m[-] config file not found\e[0m"
    exit 1
fi

source config

export ARCH=$(eval echo $ARCH)
export CC=$(eval echo $CC)
export LD=$(eval echo $LD)
export OBJCOPY=$(eval echo $OBJCOPY)
export AS=$(eval echo $AS)
export NM=$(eval echo $NM)
export STRIP=$(eval echo $STRIP)
export OBJDUMP=$(eval echo $OBJDUMP)
export READELF=$(eval echo $READELF)
export CROSS_COMPILE=$(eval echo $CROSS_COMPILE)
export CROSS_COMPILE_ARM32=$(eval echo $CROSS_COMPILE_ARM32)
OUT_DIR=$(eval echo $OUT_DIR)
KDIR=$(pwd)
DEFCONFIG=$(eval echo $DEFCONFIG)
export KCFLAGS=' -w -pipe -O3'
export ANDROID_MAJOR_VERSION=r
export KCPPFLAGS=' -O3'
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

BOLDGREEN="\e[1;32m"
BOLDRED="\e[1;31m"
BOLDBLUE="\e[1;96m"
BOLDYELLOW="\e[1;33m"
ENDCOLOR="\e[0m"

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
	echo -e "${BOLDGREEN}Kernel Config: ${CONFIG_STATUS}$ENDCOLOR"
	echo
	echo -e "$BOLDGREEN|-----------------------------------------------------|$ENDCOLOR"
	echo -e "${BOLDGREEN}| Actions:                                            |$ENDCOLOR"
	echo -e "$BOLDGREEN|-------------------${ENDCOLOR}Kernel${BOLDGREEN}----------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}1${ENDCOLOR}] Compile Kernel                           $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}2${ENDCOLOR}] Compile Module $BOLDBLUE(Doesn't need prepare)    $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}3${ENDCOLOR}] Prepare Module                           $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|-----------------------------------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}4${ENDCOLOR}] Clean Kernel $BOLDBLUE(Clean & Mrproper)          $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}5${ENDCOLOR}] Apply Defconfig $BOLDBLUE(Selection in Config)    $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|-----------------------------------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}6${ENDCOLOR}] Edit Config $BOLDBLUE(MENUCONFIG) $BOLDYELLOW(GOOD)          $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}7${ENDCOLOR}] Edit Config $BOLDBLUE(NCONFIG) $BOLDGREEN(BEST)             $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}8${ENDCOLOR}] Save .config as new defconfig            $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|-------------------${ENDCOLOR}Script${BOLDGREEN}----------------------------|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDRED}E${ENDCOLOR}] Exit Builder                             $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|        ${ENDCOLOR}[${BOLDBLUE}G${ENDCOLOR}] Open the creator's github page           $BOLDGREEN|$ENDCOLOR"
	echo -e "$BOLDGREEN|-------------------${ENDCOLOR}End${BOLDGREEN}-------------------------------|$ENDCOLOR"
	echo
}

function check_exit_code() {
	local ret=$?
	if [ $ret -eq 0 ]; then
		echo -e "$BOLDGREEN[+] Success$ENDCOLOR"
	else
		echo -e "$BOLDRED[-] Failed (exit code: $ret)$ENDCOLOR"
	fi
}

while true; do
	show_gui
	echo -ne "${BOLDGREEN}Enter the action: $ENDCOLOR"
	read action

	case $action in
		1)
			echo -e "$BOLDGREEN[+] Building$ENDCOLOR"
			if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
				echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
			else
				echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
				make -s -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y -j"$(nproc)" && make -C "$KDIR" O="$OUT_DIR" INSTALL_MOD_PATH="modules" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y modules_install -j"$(nproc)"
				check_exit_code
				echo -e "$BOLDGREEN[+] You can find the modules in '$OUT_DIR/modules'$ENDCOLOR"
				if [ ! -f "$KDIR/$OUT_DIR/arch/$ARCH/boot/Image" ]; then
					echo -e "$BOLDRED[-] Image binary isn't made$ENDCOLOR"
				else
					echo -e "$BOLDGREEN[+] Image binary is being copied to '$KDIR/arch/$ARCH/boot/Image'$ENDCOLOR"
					cp "$KDIR/$OUT_DIR/arch/$ARCH/boot/Image" "$KDIR/arch/$ARCH/boot/Image"
					ret=$?
					if [ $ret -eq 0 ]; then
						echo -e "$BOLDGREEN[+] Coping succeed$ENDCOLOR"
					else
						echo -e "$BOLDRED[-] Coping Failed (exit code: $ret)$ENDCOLOR"
					fi
				fi
			fi
			;;
		2)
			echo -e "$BOLDGREEN[+] Building Modules$ENDCOLOR"
			if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
				echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
			else
				echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
				make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y module_prepare -j"$(nproc)" && make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y module -j"$(nproc)" && make -C "$KDIR" O="$OUT_DIR" INSTALL_MOD_PATH="modules" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y modules_install -j"$(nproc)"
				check_exit_code
				echo -e "$BOLDGREEN[+] You can find the modules in '$OUT_DIR/modules'$ENDCOLOR"
			fi
			;;
		2)
			echo -e "$BOLDGREEN[+] Preparing Modules$ENDCOLOR"
			if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
				echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
			else
				echo -e "$BOLDGREEN[+] .config found$ENDCOLOR"
				make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y module_prepare -j"$(nproc)"
				check_exit_code
			fi
			;;
		4)
			echo -e "$BOLDGREEN[+] Cleaning$ENDCOLOR"
			make -s -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y clean -j"$(nproc)" && make -s -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y mrproper -j"$(nproc)" && make -s -C "$KDIR" O="$KDIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y clean -j"$(nproc)" && make -s -C "$KDIR" O="$KDIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y mrproper -j"$(nproc)"
			check_exit_code
			;;
		5)
			echo -e "$BOLDGREEN[+] Appling $DEFCONFIG$ENDCOLOR"
			if [ ! -f "$KDIR/arch/$ARCH/configs/$DEFCONFIG" ]; then
				echo -e "$BOLDRED[-] $DEFCONFIG is not found$ENDCOLOR"
			else
				echo -e "$BOLDGREEN[+] $DEFCONFIG is found$ENDCOLOR"
				echo -ne "$BOLDRED[!] Want to apply $BOLDYELLOW$DEFCONFIG$BOLDRED?$ENDCOLOR [Y,n]: "
				read answer
				if [[ "$answer" == "Y" || "$answer" == "y" || "$answer" == "" ]]; then
					make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y $DEFCONFIG -j"$(nproc)"
					check_exit_code
				elif [[ "$answer" == "N" || "$answer" == "n" ]]; then
					echo -ne "$BOLDGREEN[+] Enter the defconfig's name: $ENDCOLOR"
					read config
					if [ ! -f "$KDIR/arch/$ARCH/configs/$config" ]; then
						echo -e "$BOLDRED[-] $config is not found$ENDCOLOR"
					else
						make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y $config -j"$(nproc)"
						check_exit_code
					fi
				else
					echo -e "$BOLDRED[!] Invalid Action!!$ENDCOLOR"
				fi
			fi
			;;
		6)
			echo -e "$BOLDGREEN[+] Editing Config (MENUCONFIG)$ENDCOLOR"
			make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y menuconfig -j"$(nproc)"
			;;
		7)
			echo -e "$BOLDGREEN[+] Editing Config (NCONFIG)$ENDCOLOR"
			make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y nconfig -j"$(nproc)"
			;;
		8)
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
					if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
						echo -e "$BOLDGREEN[+] Overwriting current .config as $newconfig$ENDCOLOR"
						cp "$KDIR/$OUT_DIR/.config" "$KDIR/arch/$ARCH/configs/$newconfig"
						ret=$?
						if [ $ret -eq 0 ]; then
							echo -e "$BOLDGREEN[+] Coping succeed$ENDCOLOR"
						else
							echo -e "$BOLDRED[-] Coping Failed (exit code: $ret)$ENDCOLOR"
						fi
					fi
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
			;;
		E)
			echo -e "$BOLDRED[!] Exiting!!$ENDCOLOR"
			break
			;;
		G)
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