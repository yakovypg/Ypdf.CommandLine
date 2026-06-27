#include "environment.iss"

#define AppName "Ypdf.CommandLine"
#define AppVersion "2.0.0"
#define AppPublisher "yakovypg"
#define AppSourcesDir "sources"

[Setup]
AppId={{C9873E9A-6174-4F24-8C5D-01F76D097E4E}}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={commonpf}\{#AppName}
DisableDirPage=no
DisableProgramGroupPage=yes
PrivilegesRequired=admin
OutputDir=.
OutputBaseFilename={#AppName}-{#AppVersion}-Installer
Compression=lzma
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
ChangesEnvironment=true

[Files]
Source: "{#AppSourcesDir}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[UninstallDelete]
Type: dirifempty; Name: "{app}"
Type: files; Name: "{app}\*"

[Tasks]
Name: envPath; Description: "Add to PATH variable" 

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
    if (CurStep = ssPostInstall) and WizardIsTaskSelected('envPath') then
        EnvAddPath(ExpandConstant('{app}') +'\bin');
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
    if CurUninstallStep = usPostUninstall then
        EnvRemovePath(ExpandConstant('{app}') +'\bin');
end;
