unit UberPDFUpdate.Manager;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  UberPDFUpdate.Manager.Tasks,
  UberPDFUpdate.Manager.Task;

type
{
  TInstallOSType
}
  TInstallOSType = (iotWindows, iotLinux, iotBSD, iotDarwin);
{
  TInstallOSArchitectureType
}
  TInstallOSArchitectureType = (ioat32, ioat64);
{
  TInstallOS
  Contains the OS information
}
  TInstallOS = record
{$IFDEF LINUX}
    Distribution: String;
{$ENDIF}
    OS: TInstallOSType;
    Architecture: TInstallOSArchitectureType;
    Version: String;
  end;

{
  TInstallManager
  Manages the OS, Environment and Install Tasks
}
  TInstallManager = class(TObject)
  private
    FTasks: TInstallTasks;
    FVerbose: Boolean;

    FInstallPath: String;
    FCurrentOS: TInstallOS;
    FEnvVars: TStringList;
    FPath: TStringList;
  protected
  public
    constructor Create(const AInstallPath: String);
    destructor Destroy; override;

    property Verbose: Boolean
      read FVerbose;

    property InstallPath: String
      read FInstallPath;
    property CurrentOS: TInstallOS
      read FCurrentOS;
    property EnvVars: TStringList
      read FEnvVars;
    property Path: TStringList
      read FPath;
  end;

implementation

{ TInstallManager }

constructor TInstallManager.Create(const AInstallPath: String);
var
  index: Integer;
  s: String;
  t: TInstallTaskGetLinuxDistribution;
begin
  FTasks := TInstallTasks.Create;
  FVerbose := False;

{$IFDEF LINUX}
  t := TInstallTaskGetLinuxDistribution.Create(Self);
  t.Exec;
  if t.Result.Success then
  begin
    if Pos('ubuntu', LowerCase(t.Result.Output)) > 0 then
    begin
      FCurrentOS.Distribution:='ubuntu';
      FCurrentOS.OS := iotLinux;
      // TODO: Get Distribution Version
      // TODO: Get Architecture
    end;
  end;
  t.Free;
{$ENDIF}
{$IFDEF WINDOWS}
  FCurrentOS.OS := iotWindows;
  // TODO: Get Windows Version
  // TODO: Get Architecture
{$ENDIF}
{$IFDEF BSD}
  FCurrentOS.OS := iotBSD;
  // TODO: Get BSD Version
  // TODO: Get Architecture
{$ENDIF}
{$IFDEF DARWIN}
  FCurrentOS.OS := iotDarwin;
  // TODO: Get MacOS Version
  // TODO: Get Architecture
{$ENDIF}
  FInstallPath := AInstallPath;
  FEnvVars := TStringList.Create;
  FPath := TStringList.Create;
  for index := 0 to GetEnvironmentVariableCount - 1 do
  begin
    FEnvVars.Add(GetEnvironmentString(index));
  end;
  if FEnvVars.Values['PATH'] <> EmptyStr then
  begin
{$IFDEF LINUX}
    FPath.Delimiter:=':';
{$ENDIF}
{$IFDEF WINDOWS}
    FPath.Delimiter:=';';
{$ENDIF}
    FPath.DelimitedText:=FEnvVars.Values['PATH'];
  end;
end;

destructor TInstallManager.Destroy;
begin
  if Assigned(FEnvVars) then
  begin
    FEnvVars.Free;
  end;
  if Assigned(FPath) then
  begin
    FPath.Free;
  end;
  inherited Destroy;
end;

end.

