unit UberPDFUpdate.Manager;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  UberPDFUpdate.Manager.Tasks;

type
{
  TInstallManager
}
  TInstallManager = class(TObject)
  private
    FTasks: TInstallTasks;
    FVerbose: Boolean;

    FInstallPath: String;
    FEnvVars: TStringList;
    FPath: TStringList;
  protected
  public
    constructor Create(const AInstallPath: String);
    destructor Destroy; override;

    property InstallPath: String
      read FInstallPath;
    property Verbose: Boolean
      read FVerbose;
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
begin
  FTasks := TInstallTasks.Create;
  FVerbose := False;
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

