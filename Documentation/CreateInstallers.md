# Create Installer
This document provides essential information for creating installers for **Ypdf.CommandLine**.

## Table of contents
*    [Create Deb Package](#create-deb-package)
*    [Create Zip Archive](#create-zip-archive)
*    [Create Windows Installer](#create-windows-installer)
*    [Create Docker Image](#create-docker-image)

## Create Deb Package
You can create deb package using the [create-deb.sh](/Deploy/Deb/create-deb.sh) script.
```bash
./create-deb.sh
```

Before running it, review the configuration at the top of the script and edit it if necessary.

## Create Zip Archive
You can create deb package using the [create-zip.sh](/Deploy/Zip/create-zip.sh) script.
```bash
./create-zip.sh
```

Before running it, review the configuration at the top of the script and edit it if necessary.

## Create Windows Installer
Follow these steps to create a Windows installer:
1. Create the installer sources using the [create-sources.bat](/Deploy/WindowsInstaller/create-sources.bat) script.
2. Install [Inno Setup](https://jrsoftware.org/isinfo.php) if it is not already installed.
3. Open [inno-setup-config.iss](/Deploy/WindowsInstaller/inno-setup-config.iss) in Inno Setup and compile it.

If you want to use your own UUID, you can generate a new one using the [generate-uuid.bat](/Deploy/WindowsInstaller/generate-uuid.bat) script. Next, update the old value in [inno-setup-config.iss](/Deploy/WindowsInstaller/inno-setup-config.iss) to the new UUID.

## Create Docker Image
You can create Docker image using the [container-build.sh](/Deploy/Docker/container-build.sh) script.
```bash
./container-build.sh
```

Before executing it, make sure the Docker Engine is running.
