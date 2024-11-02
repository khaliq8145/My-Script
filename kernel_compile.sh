#!/bin/bash
#===========================================#
#           KERNEL COMPILER TOOL           #
#        Copyright by @Bias_khaliq           #
#    Telegram: https://t.me/Bias_khaliq     #
#===========================================#

# Color codes
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# Banner function
show_banner() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║      KERNEL COMPILER TOOL        ║${RESET}"
    echo -e "${CYAN}╚══════════════════════════════════╝${RESET}"
    echo
}

# Progress bar function
show_progress() {
    local duration=$1
    local width=50
    local progress=0
    
    while [ $progress -le 100 ]; do
        local count=$(($width * $progress / 100))
        local spaces=$((width - count))
        
        printf "${GREEN}[${RESET}"
        printf "%${count}s" | tr ' ' '█'
        printf "%${spaces}s" | tr ' ' '.'
        printf "${GREEN}]${RESET} ${YELLOW}%3d%%${RESET}\r" $progress
        
        progress=$((progress + 2))
        sleep 0.1
    done
    echo
}

# Configuration
DEFCONFIG="sunfish_defconfig"
KBUILD_BUILD_USER="khaliq"
KBUILD_BUILD_HOST="ichacarissa16@khaliq"
TC_DIR="/workspace"
export PATH="$TC_DIR/bin:$PATH"

# Main execution
show_banner

echo -e "${BLUE}[*] Initializing Build Process...${RESET}"
show_progress 2

echo -e "\n${YELLOW}[!] Press ENTER to continue...${RESET}"
read -r

# Create output directory
mkdir -p out

echo -e "\n${CYAN}[*] Building with configuration: ${WHITE}${DEFCONFIG}${RESET}"
if ! make O=out ARCH=arm64 "$DEFCONFIG"; then
    echo -e "\n${RED}[×] Failed to create config!${RESET}"
    exit 1
fi

echo -e "\n${CYAN}[*] Starting kernel compilation...${RESET}"
if make -j"$(nproc --all)" O=out ARCH=arm64 \
    CC=clang \
    LD=ld.lld \
    AR=llvm-ar \
    AS=llvm-as \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    CROSS_COMPILE=aarch64-linux-gnu- \
    CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee log.txt; then
    
    if [ -f out/arch/arm64/boot/Image.gz ]; then
        echo -e "\n${GREEN}╔══════════════════════════════════╗${RESET}"
        echo -e "${GREEN}║   KERNEL COMPILED SUCCESSFULLY!   ║${RESET}"
        echo -e "${GREEN}╚══════════════════════════════════╝${RESET}"
    else
        echo -e "\n${RED}[×] Kernel image not found!${RESET}"
        exit 1
    fi
else
    echo -e "\n${RED}[×] Compilation failed! Check log.txt for details${RESET}"
    exit 1
fi