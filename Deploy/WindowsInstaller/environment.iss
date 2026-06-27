; (*
; Source - https://stackoverflow.com/a/46609047
; Posted by Wojciech Mleczek, modified by community. See post 'Timeline' for change history
; Retrieved 2026-06-26, License - CC BY-SA 3.0
; Modification: added removing duplicated semicolon, refactor code
; *)

[Code]
const EnvironmentKey = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

procedure EnvAddPath(Path: string);
var
    Paths: string;
    P: Integer;
begin
    { Retrieve current path (use empty string if entry not exists) }
    if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
        Paths := '';

    { Skip if string already found in path }
    if Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';') > 0 then
        exit;

    { Add string to the end of the path variable }
    Paths := Paths + ';' + Path + ';';
    
    { Remove duplicated semicolon }
    while Pos(';;', Paths) > 0 do
    begin
        P := Pos(';;', Paths);
        Delete(Paths, P, 1);
    end;

    { Overwrite (or create if missing) path environment variable }
    if RegWriteStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
        Log(Format('The [%s] added to PATH: [%s]', [Path, Paths]))
    else
        Log(Format('Error while adding the [%s] to PATH: [%s]', [Path, Paths]));
end;

procedure EnvRemovePath(Path: string);
var
    Paths: string;
    P: Integer;
begin
    { Skip if registry entry not exists }
    if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
        exit;

    { Skip if string not found in path }
    P := Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';');
    if P = 0 then
        exit;

    { Update path variable }
    Delete(Paths, P - 1, Length(Path) + 1);
    
    { Remove duplicated semicolon }
    while Pos(';;', Paths) > 0 do
    begin
        P := Pos(';;', Paths);
        Delete(Paths, P, 1);
    end;

    { Overwrite path environment variable }
    if RegWriteStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', Paths) then
        Log(Format('The [%s] removed from PATH: [%s]', [Path, Paths]))
    else
        Log(Format('Error while removing the [%s] from PATH: [%s]', [Path, Paths]));
end;
