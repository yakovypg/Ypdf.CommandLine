# User Guide
This document serves as a comprehensive guide for using **Ypdf.CommandLine**.

## Table of contents
*    [Basics](#basics)
*    [Installation](#installation)
     * [Deb Package](#deb-package)
     * [Zip Archive](#zip-archive)
     * [Windows Installer](#windows-installer)
     * [Docker](#docker)
     * [Manual](#manual)
*    [Uninstalling](#uninstalling)

## Basics
First, here are some important points to keep in mind:
- PDF document page numbers start at 1.
- The origin (0,0) is located at the bottom-left corner. Units along each axis are measured in pixels.
- To perform actions on a PDF document, it must not be password-protected.

For some actions on a PDF document, you may need to install additional dependencies on your system. If an action requires a dependency, it is described in the tools [documentation](/Documentation/Tools.md). Here is the full list of dependencies that may be required:
1. **Python 3**. The application will automatically create a virtual environment and install the required packages. However, on Linux and some other platforms, you may need to install `python3-pip` and `python3-venv` separately.
    - Linux
        ```bash
        sudo apt install python3 python3-pip python3-venv
        ```
    - Windows
        1. [Download](https://www.python.org/downloads/) the installer.
        2. Install Python using it. Make sure to select the checkbox to add Python to your `PATH`.
2. **Java 17+**. Older Java versions are not supported.
    - Linux
        ```bash
        sudo apt install openjdk-17-jre-headless
        ```
    - Windows
        1. [Download](https://www.java.com/en/download/manual.jsp) the installer.
        2. Install Java using it.
3. **Poppler**.
    - Linux
        ```bash
        sudo apt install poppler-utils
        ```
    - Windows
        1. [Download](https://github.com/oschwartz10612/poppler-windows/releases) the archive.
        2. Unpack it to the folder you want (e.g., `C:\Program Files\poppler-26.02.0`).
        3. Add its `bin` folder to `PATH` (e.g., `C:\Program Files\poppler-26.02.0\Library\bin`).

The download links are provided for convenience only.

## Installation
You can install **Ypdf.CommandLine** in different ways. Choose the one that best fits your OS.

### Deb Package
Follow these steps to install the application from a deb package:
1. Download the package: let it be `ypdf_2.0.0_amd64.deb`
2. Install it: `sudo apt install ./ypdf_2.0.0_amd64.deb`

Now you can check the application.
```bash
ypdf --version
```

### Zip Archive
Follow these steps to install the application from an archive:
1. Download the archive: let it be `ypdf_2.0.0.zip`
2. Extract it: `unzip ./ypdf_2.0.0.zip`
3. Move the extracted folder to the location you want: `sudo mv ./ypdf_2.0.0 /opt/Ypdf.CommandLine`
4. To run the application without using the full path, choose one of the following options:
    - Create a symlink to the executable: `sudo ln -s /opt/Ypdf.CommandLine/ypdf /usr/local/bin/ypdf`
    - Add an alias to your shell configuration file (e.g., `.bashrc`, `.zshrc`): `echo "alias ypdf='/opt/Ypdf.CommandLine/ypdf'" >> ~/.bashrc`

On Windows, you can use a graphical shell instead of terminal utilities, but the steps are the same. The last step may require creating a batch script and placing it in a directory that is included in `PATH`:
```bat
@echo off
pushd "C:\Path\To\Ypdf.CommandLine"
call ypdf.exe %*
popd
```

Now you can check the application.
```bash
ypdf --version
```

### Windows Installer
Follow these steps to install the application from a deb package:
1. Download the installer: let it be `Ypdf.CommandLine-2.0.0-Installer.exe`
2. Install **Ypdf.CommandLine** using it. Make sure to select the checkbox to add **Ypdf.CommandLine** to your `PATH`

Now you can check the application.
```bash
ypdf --version
```

### Docker
Follow these steps to install the application with Docker:
1. Clone the repository: `git clone https://github.com/yakovypg/Ypdf.CommandLine.git`
2. Move to it: `cd Ypdf.CommandLine`
3. Initialize submodules: `git submodule update --init --recursive`
4. Create `.env` file in the [Deploy/Docker](/Deploy/Docker/) directory. Use [.env-template.txt](/Deploy/Docker/.env-template.txt) as a template. Set `INPUT_DIR` and `OUTPUT_DIR` to the host paths that Docker Compose will mount into the container: `${INPUT_DIR}` will be mounted read-only to `/input`, and `${OUTPUT_DIR}` will be mounted to `/output`. These are the paths you should pass to the application as `--input /input/...` and `--output /output/...`
5. Build the Docker image using [container-build.sh](/Deploy/Docker/container-build.sh) script: `./Deploy/Docker/container-build.sh`
6. Copy directory with Docker scripts to the location you want: `sudo cp -r ./Deploy/Docker /opt/Ypdf.CommandLine`
7. Create a launcher for running the application: `sudo sh -c 'printf "#!/usr/bin/env bash\nexec /opt/Ypdf.CommandLine/container-run.sh \"\$@\"\n" > /usr/local/bin/ypdf && chmod +x /usr/local/bin/ypdf'`

Now you can check the application.
```bash
ypdf --version
```

Before installing and executing the application, make sure the Docker Engine is running.

### Manual
Follow these steps to install the application from sources:
1. Clone the repository: `git clone https://github.com/yakovypg/Ypdf.CommandLine.git`
2. Move to it: `cd Ypdf.CommandLine`
3. Initialize submodules: `git submodule update --init --recursive`
4. Publish application: `dotnet publish ./Application/Ypdf.CommandLine/Ypdf.CommandLine.csproj -c Release -f net10.0 -o Ypdf.CommandLine.Publish`
5. Move the directory with published application to the location you want: `sudo mv ./Ypdf.CommandLine.Publish /opt/Ypdf.CommandLine`
6. To run the application without using the full path, choose one of the following options:
    - Create a symlink to the executable: `sudo ln -s /opt/Ypdf.CommandLine/ypdf /usr/local/bin/ypdf`
    - Add an alias to your shell configuration file (e.g., `.bashrc`, `.zshrc`): `echo "alias ypdf='/opt/Ypdf.CommandLine/ypdf'" >> ~/.bashrc`

Now you can check the application.
```bash
ypdf --version
```

## Uninstalling
You can easily uninstall the application. Choose the option that matches your installation method:
- Deb Package: `sudo apt purge ypdf`
- Zip Archive: `sudo rm -rf /opt/Ypdf.CommandLine`
- Windows Installer: `Control Panel > Programs > Programs and Features > Uninstall`
- Docker: `sudo rm -rf /opt/Ypdf.CommandLine && docker rmi ypdf-command-line:latest`
- Manual: `sudo rm -rf /opt/Ypdf.CommandLine`

Additional steps:
- If you created a symlink to the executable, remove it: `sudo rm -f /usr/local/bin/ypdf`
- If you added an alias for the executable, remove it: `nano ~/.bashrc`
- If you do not want to keep configuration for a future installation, remove the `.ypdf` directory from your user folder: `rm -rf ~/.ypdf`

Make sure to update the paths if you install the application in your own location. The commands below match the installation examples.
