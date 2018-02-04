unit UberPDFUpdate.Manager.Task;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process;

type
{
  TInstallTaksResult
}
  TInstallTaskResult = record
    Success: Boolean;
    Return: Integer;
    Output: String;
  end;

{
  TInstallTask
  Base clase for tasks
}
  TInstallTask = class(TObject)
  private
  protected
    FManager: TObject;
    FResult: TInstallTaskResult;
  public
    constructor Create(const AManager: TObject);
    destructor Destroy; override;

    property Result: TInstallTaskResult
      read FResult;
  end;

{
  TInstallTaskGetLinuxDistribution
  Finds out the Linux Distribution
}
  TInstallTaskGetLinuxDistribution = class(TInstallTask)
  private
    FProcess: TProcess;

    function ReadOutput: Boolean;
  protected
  public
    procedure Exec;
  end;

implementation

uses
  UberPDFUpdate.Manager;

{ TInstallTask }

constructor TInstallTask.Create(const AManager: TObject);
begin
  inherited Create;
  FManager := AManager;
  FResult.Success := False;
  FResult.Return := -1;
  FResult.Output := EmptyStr;
end;

destructor TInstallTask.Destroy;
begin
  FManager := nil;
  inherited Destroy;
end;

{ TInstallTaskGetLinuxDistribution }

function TInstallTaskGetLinuxDistribution.ReadOutput: Boolean;
const
  BufSize = 4096;
var
  Buffer: array[0..BufSize - 1] of byte;
  ReadBytes: integer;
  c: byte;
begin
  Result := False;
  while FProcess.Output.NumBytesAvailable > 0 do
  begin
    ReadBytes := FProcess.Output.Read({%H-}Buffer, BufSize);
    for c in Buffer do
    begin
      FResult.Output := FResult.Output + Char(c);
    end;
    Result := True;
  end;
end;

procedure TInstallTaskGetLinuxDistribution.Exec;
var
  Release: TStringList;
  FileName: String;
begin
  FResult.Output:='Could not find distribution information.';

    FileName := '/etc/os-release';
    if FileExists(FileName) then
    begin
      Release := TStringList.Create;
      try
        Release.LoadFromFile(FileName);
        FResult.Success := True;
        FResult.Return := 0;
        FResult.Output := Format('%s %s', [
          Release.Values['NAME'],
          Release.Values['VERSION_ID']]);
        exit;
      finally
        Release.Free;
      end;
    end;

    FileName := '/etc/system-release';
    if FileExists(FileName) then
    begin
      Release := TStringList.Create;
      try
        Release.LoadFromFile(FileName);
        FResult.Success := True;
        FResult.Return := 0;
        FResult.Output := Format('%s %s', [
          Release.Values['NAME'],
          Release.Values['VERSION_ID']]);
        exit;
      finally
        Release.Free;
      end;
    end;
end;

end.

