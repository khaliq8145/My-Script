# Kernel Build & KernelSU Integration Scripts Documentation

## Overview
This documentation covers two essential scripts for kernel development:
1. Kernel Compilation Suite (kernel_compile.sh)
2. KernelSU Integration Tool (setup_kernelsu.sh)

---

## 1. Kernel Compilation Suite

### Description
A professional-grade bash script designed to automate and streamline the kernel compilation process. The script provides a user-friendly interface with real-time build status, error handling, and comprehensive logging.

### Features
- Professional UI with color-coded output
- Real-time compilation progress tracking
- Detailed error reporting and logging
- Build time calculation
- Multi-threaded compilation support
- Comprehensive error handling
- Automated build environment setup

### Requirements
- Linux-based operating system
- Installed build tools (gcc, clang, etc.)
- Sufficient storage space
- Proper kernel source code

### Usage
```bash
chmod +x kernel_compile.sh
./kernel_compile.sh
```

### Configuration Options (for example)
```bash
KERNEL_VERSION="5.0.0"      # Your kernel version
KERNEL_NAME="MorpheusKernel"    # Your kernel name
DEFCONFIG="sunfish_defconfig"   # Device defconfig
DEVICE_NAME="Pixel 4a"      # Target device
BUILD_TYPE="STABLE"         # Build type
```

### Output Files
- `out/arch/arm64/boot/Image.gz`: Compiled kernel image
- `build.log`: Compilation logs
- Console output with build statistics

---

## 2. KernelSU Integration Tool

### Description
An automated tool for integrating KernelSU into your kernel source. The script handles the download, setup, and configuration of KernelSU while ensuring all required kernel options are properly set.

### Features
- Automated KernelSU download and integration
- Automatic defconfig modification
- Configuration verification
- Detailed progress logging
- Error handling and recovery
- Easy version management

### Requirements
- Internet connection
- Access to kernel source directory
- Write permissions for kernel directory
- curl installed

### Usage
```bash
chmod +x setup_kernelsu.sh
./setup_kernelsu.sh
```

### Configuration Settings
```bash
KERNELSU_VERSION="v0.9.5"   # KernelSU version
DEFCONFIG_PATH="arch/arm64/configs/sunfish_defconfig"   # Path to defconfig
```

### Required Kernel Configs
The script ensures these configurations are present:
```bash
CONFIG_KPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_KPROBE_EVENTS=y
```

### Process Flow
1. Checks kernel directory existence
2. Downloads KernelSU setup script
3. Executes KernelSU integration
4. Modifies defconfig
5. Verifies configurations
6. Reports success/failure

---

## Common Issues & Troubleshooting

### Kernel Compilation Issues
- Ensure all build dependencies are installed
- Check available storage space
- Verify toolchain path and environment variables
- Review build.log for specific errors

### KernelSU Integration Issues
- Check internet connectivity
- Ensure proper permissions in kernel directory
- Verify defconfig path
- Check for conflicting configurations

## Best Practices
1. Always backup your kernel source before integration
2. Keep build tools updated
3. Review logs for any warnings or errors
4. Maintain consistent versioning
5. Test compilation after KernelSU integration

## Support
For issues and support:
- Telegram: @zetaxbyte
- Check build logs in case of failures
- Verify your kernel source is compatible

## Notes
- Scripts are tested on Linux environments
- Requires bash shell
- Root access may be required for some operations
- Keep backups of original configurations

This documentation covers the basic usage and configuration of both scripts. For advanced usage or custom modifications, please refer to the script comments or contact the developer.
