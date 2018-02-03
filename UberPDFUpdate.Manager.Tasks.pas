unit UberPDFUpdate.Manager.Tasks;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Contnrs,
  UberPDFUpdate.Manager.Task;

type
  TInstallTasksEnumerator = class; // Forward
{
  TInstallTasks
  Container of tasks
}
  TInstallTasks = class(TFPObjectList)
  private
    function GetTask(Index: Integer): TInstallTask;
    procedure SetTask(Index: Integer; ATask: TInstallTask);
  protected
  public
    function GetEnumerator: TInstallTasksEnumerator;

    function Add(const ATask: TInstallTask): Integer;

    property Items[Index: Integer]: TInstallTask
      read GetTask
      write SetTask; default;
  end;

{
  TInstallTasksEnumerator
  Enumerator for the container of tasks
}
  TInstallTasksEnumerator = class(TObject)
  private
    FTasks: TInstallTasks;
    FPosition: Integer;

    function GetCurrent: TInstallTask;
  protected
  public
    constructor Create(ATasks: TInstallTasks);
    function MoveNext: Boolean;

    property Current: TInstallTask
      read GetCurrent;
  end;

implementation

{ TInstallTasks }

function TInstallTasks.GetTask(Index: Integer): TInstallTask;
begin
  Result := inherited Items[Index] as TInstallTask;
end;

procedure TInstallTasks.SetTask(Index: Integer; ATask: TInstallTask);
begin
  inherited Items[Index] := ATask;
end;

function TInstallTasks.GetEnumerator: TInstallTasksEnumerator;
begin
  Result := TInstallTasksEnumerator.Create(Self);
end;

function TInstallTasks.Add(const ATask: TInstallTask): Integer;
begin
  inherited Add(ATask);
end;

{ TInstallTasksEnumerator }

constructor TInstallTasksEnumerator.Create(ATasks: TInstallTasks);
begin
  FTasks := ATasks;
  FPosition := -1;
end;

function TInstallTasksEnumerator.GetCurrent: TInstallTask;
begin
  Result := FTasks[FPosition];
end;

function TInstallTasksEnumerator.MoveNext: Boolean;
begin
  Inc(FPosition);
  Result := FPosition < FTasks.Count;
end;

end.

