#!/bin/bash
#==================================================================#
#                    KERNELSU INTEGRATION TOOL                       #
#                       Version: 1.0.0                               #
#==================================================================#

# Color codes
declare -r ESC="\033"
declare -r RESET="${ESC}[0m"
declare -r BOLD="${ESC}[1m"
declare -r SUCCESS="${ESC}[38;5;041m"
declare -r ERROR="${ESC}[38;5;196m"
declare -r INFO="${ESC}[38;5;075m"
declare -r WARNING="${ESC}[38;5;214m"

# Configuration
KERNELSU_VERSION="v0.9.5"
DEFCONFIG_PATH="arch/arm64/configs/sunfish_defconfig"
KERNEL_PATH="android/kernel"  # Path to directoru kernel
REQUIRED_CONFIGS=(
    "CONFIG_KPROBES=y"
    "CONFIG_HAVE_KPROBES=y"
    "CONFIG_KPROBE_EVENTS=y"
)

# Logging function
log() {
    local level=$1
    shift
    local message=$*
    local timestamp=$(date '+%H:%M:%S')
    
    case "${level}" in
        "INFO")  echo -e "${INFO}[${timestamp}] ${BOLD}INFO${RESET}    ${message}" ;;
        "ERROR") echo -e "${ERROR}[${timestamp}] ${BOLD}ERROR${RESET}   ${message}" ;;
        "SUCCESS") echo -e "${SUCCESS}[${timestamp}] ${BOLD}SUCCESS${RESET} ${message}" ;;
        "WARN")  echo -e "${WARNING}[${timestamp}] ${BOLD}WARN${RESET}    ${message}" ;;
    esac
}

show_banner() {
    clear
    echo -e "${INFO}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                KERNELSU INTEGRATION TOOL                  ║"
    echo "╠══════════════════════════════════════════════════════════╣"
    echo -e "║  Version    : ${WARNING}${KERNELSU_VERSION}${INFO}                                   ║"
    echo "╚══════════════════════════════════════════════════════════╝${RESET}"
    echo
}

check_kernel_directory() {
    if [ ! -d "kernel" ]; then
        log "ERROR" "Kernel directory not found!"
        log "INFO" "Please run this script from the root of your kernel source."
        exit 1
    fi
}

setup_kernelsu() {
    log "INFO" "Changing to kernel directory..."
    cd "$KERNEL_PATH" || {
        log "ERROR" "Failed to change directory to $KERNEL_PATH"
        exit 1
    }
    
    log "INFO" "Downloading KernelSU setup script..."
    curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s ${KERNELSU_VERSION}
    
    if [ $? -eq 0 ]; then
        log "SUCCESS" "KernelSU setup completed successfully"
    else
        log "ERROR" "Failed to setup KernelSU"
        exit 1
    fi
}

modify_defconfig() {
    log "INFO" "Checking defconfig file..."
    if [ ! -f "$DEFCONFIG_PATH" ]; then
        log "ERROR" "Defconfig file not found at: $DEFCONFIG_PATH"
        exit 1
    }
    
    log "INFO" "Adding required configurations to defconfig..."
    local config_modified=false
    
    for config in "${REQUIRED_CONFIGS[@]}"; do
        if ! grep -q "^${config}$" "$DEFCONFIG_PATH"; then
            echo "${config}" >> "$DEFCONFIG_PATH"
            config_modified=true
            log "INFO" "Added ${config}"
        else
            log "INFO" "${config} already exists"
        fi
    done
    
    if [ "$config_modified" = true ]; then
        log "SUCCESS" "Defconfig has been updated successfully"
    else
        log "INFO" "No modifications needed for defconfig"
    fi
}

verify_config() {
    log "INFO" "Verifying configurations..."
    local missing_configs=()
    
    for config in "${REQUIRED_CONFIGS[@]}"; do
        if ! grep -q "^${config}$" "$DEFCONFIG_PATH"; then
            missing_configs+=("$config")
        fi
    done
    
    if [ ${#missing_configs[@]} -eq 0 ]; then
        log "SUCCESS" "All required configurations are present"
        return 0
    else
        log "ERROR" "Missing configurations:"
        for config in "${missing_configs[@]}"; do
            echo -e "${ERROR}  ✗ ${config}${RESET}"
        done
        return 1
    fi
}

main() {
    show_banner
    
    log "INFO" "Starting KernelSU integration process..."
    
    # Check if we're in the correct directory
    check_kernel_directory
    
    # Setup KernelSU
    setup_kernelsu
    
    # Modify defconfig
    modify_defconfig
    
    # Verify configurations
    verify_config
    
    if [ $? -eq 0 ]; then
        echo
        log "SUCCESS" "KernelSU integration completed successfully!"
        echo -e "${INFO}You can now proceed with kernel compilation${RESET}"
    else
        echo
        log "ERROR" "KernelSU integration completed with errors"
        log "WARN" "Please check the above messages and fix any issues"
        exit 1
    fi
}

# Execute main function
main "$@"
