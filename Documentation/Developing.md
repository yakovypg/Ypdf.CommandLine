# Developing
This document provides essential information for continuing development of **Ypdf.CommandLine**.

## Table of contents
*    [Build From Source](#build-from-source)
*    [Run Tests](#run-tests)
*    [Run Application](#run-application)
*    [Debug Application](#debug-application)

## Build From Source
First, update the submodules if you have not done it yet.
```bash
git submodule update --init --recursive
```

Next, [build](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-build) the application by running the following command from the project root.
```bash
dotnet build
```

## Run Tests
Integration tests are provided for **Ypdf.CommandLine**. They run the compiled executable via `bash` and perform basic verification of the output files. However, you will need to review the contents of these files manually.

Follow these steps to run the tests (it is assumed that you are in the [Tests](/Application/Ypdf.CommandLine/Tests/) directory):
1. Build the project: `dotnet build ..`
2. Remove any previous test outputs (if present): `rm -rf ./Output`
3. Ensure an `Input` directory exists and contains files required by the tests inside it: `mkdir ./Input`
4. Run the test script: `./run_tests.sh`

> **_NOTE:_**
> - Test files have not been provided yet.
> - Tests execution is only possible on systems that support bash. Universal tests have not been implemented yet.

## Run Application
You can [run](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-run) the application by executing the following command from the project root.
```bash
dotnet run --framework net10.0 --project Application/Ypdf.CommandLine --version
```

Alternatively, you can [build](#build-from-source) the application and run the generated executable from the `bin` directory.
```bash
./Application/Ypdf.CommandLine/bin/Debug/net10.0/ypdf --version
```

Naturally, in both commands you can change the target framework from `net10.0` to any framework you want.

## Debug Application
If you are using VS Code, you can use these files to configure debugging. Do not forget to update `args` as needed.
- `launch.json`
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Ypdf.CommandLine",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${workspaceFolder}/Application/Ypdf.CommandLine/bin/Debug/net10.0/ypdf.dll",
      "args": [
        "-y", "render", "-i", "/path/to/input.pdf", "-o", "/path/to/output/dir"
      ],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false,
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```
- `tasks.json`
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build",
      "command": "dotnet",
      "type": "process",
      "args": [
        "build"
      ],
      "problemMatcher": "$msCompile",
      "group": {
        "kind": "build",
        "isDefault": true
      }
    }
  ]
}

```
