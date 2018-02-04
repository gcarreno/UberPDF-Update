unit UberPDFUpdate.Forms.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, JSONPropStorage, Menus,
  ActnList, StdActns, LCLType, ExtCtrls, StdCtrls, PairSplitter, SynEdit;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actFileUpdate: TAction;
    actHelpAbout: TAction;
    actLoggingClearLogs: TAction;
    alMain: TActionList;
    actFileExit: TFileExit;
    btnFileUpdate: TButton;
    btnClearLogs: TButton;
    cbAutoClear: TCheckBox;
    edtStatus: TEdit;
    edtInstallPath: TEdit;
    lblPathTitle: TLabel;
    memError: TMemo;
    mnuHelpAbout: TMenuItem;
    mnuLoggingClearLogs: TMenuItem;
    mnuHelp: TMenuItem;
    mnuLogs: TMenuItem;
    mnuSep1: TMenuItem;
    mnuFileUpdate: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuFile: TMenuItem;
    mmMain: TMainMenu;
    panControlsButtons: TPanel;
    panLogsStatus: TPanel;
    psLogs: TPairSplitter;
    pssLog: TPairSplitterSide;
    pssError: TPairSplitterSide;
    panControls: TPanel;
    panLogs: TPanel;
    psMain: TJSONPropStorage;
    synLog: TSynEdit;
    procedure actFileUpdateExecute(Sender: TObject);
    procedure actHelpAboutExecute(Sender: TObject);
    procedure actLoggingClearLogsExecute(Sender: TObject);
    procedure edtInstallPathChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure psMainRestoreProperties(Sender: TObject);
  private
    FRestoredOnce: Boolean;
    FInstallPath: String;

    procedure InitPropStorage;
    procedure InitTitle;
    procedure InitShortCuts;

    procedure Output(AMsg: String);
    procedure Log(AMsg: String);
  public

  end;

var
  frmMain: TfrmMain;

implementation

uses
  UberPDFUpdate.Manager,
  UberPDFUpdate.Manager.Task;

const
  cVersionMajor    = 0;
  cVersionMinor    = 1;
  cVersionRevision = 0;
  cVersionBuild    = 12;

{$R *.lfm}

function GetApplicationName: String;
begin
  Result := 'UberPDFUpdate';
end;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FRestoredOnce := False;
  InitPropStorage;
  InitTitle;
  InitShortCuts;
end;

procedure TfrmMain.psMainRestoreProperties(Sender: TObject);
begin
  if Length(edtInstallPath.Text) = 0 then
  begin
{$IFDEF LINUX}
    edtInstallPath.Text := GetEnvironmentVariable('HOME') + '/UberPDF';
{$ENDIF}
{$IFDEF WINDOWS}
    edtInstallPath.Text := GetEnvironmentVariable('HOMEPATH') + '\UberPDF';
{$ENDIF}
  end;
  if not FRestoredOnce then
  begin
    FRestoredOnce := True;
    // TODO: Checks and stuff
  end;
end;

procedure TfrmMain.actFileUpdateExecute(Sender: TObject);
var
  s: String;
  m: TInstallManager;
begin
  Log('Intsall Path: '+FInstallPath);
  m := TInstallManager.Create(FInstallPath);
{$IFDEF LINUX}
  Log(Format('Dist: %s', [m.CurrentOS.Distribution]));
  Log(Format('HOME: %s', [m.EnvVars.Values['HOME']]));
  Log(Format('PATH(%d): %s', [m.Path.Count, m.Path.DelimitedText]));
  for s in m.Path do
  begin
    Log(Format(#9'%s', [s]));
  end;
{$ENDIF}
{$IFDEF WINDOWS}
  Log(Format('HOMEPATH: %s', [m.EnvVars.Values['HOMEPATH']]));
  Log(Format('PATH(%d): %s', [m.Path.Count, m.Path.DelimitedText]));
  for s in m.Path do
  begin
    Log(Format(#9'%s', [s]));
  end;
{$ENDIF}
  m.Free;
end;

procedure TfrmMain.actHelpAboutExecute(Sender: TObject);
begin
  //
end;

procedure TfrmMain.actLoggingClearLogsExecute(Sender: TObject);
begin
  memError.Clear;
  synLog.Clear;
end;

procedure TfrmMain.edtInstallPathChange(Sender: TObject);
begin
  FInstallPath := edtInstallPath.Text;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := True;
end;

procedure TfrmMain.InitPropStorage;
var
  configFile: String;
begin
  configFile := GetAppConfigFile(False);
  psMain.JSONFileName := ChangeFileExt(configFile,'.json');
  psMain.RootObjectPath := 'application';
end;

procedure TfrmMain.InitTitle;
begin
  Caption := 'ÜberPDF Update Utility v'+
    IntToStr(cVersionMajor) + '.' +
    IntToStr(cVersionMinor) + '.' +
    IntToStr(cVersionRevision) + '.' +
    IntToStr(cVersionBuild);
end;

procedure TfrmMain.InitShortCuts;
begin
{$IFDEF LINUX}
  actFileExit.ShortCut := KeyToShortCut(VK_Q, [ssCtrl]);
{$ENDIF}
{$IFDEF WINDOWS}
  actFileExit.ShortCut := KeyToShortCut(VK_X, [ssAlt]);
{$ENDIF}
end;

procedure TfrmMain.Output(AMsg: String);
begin
  synLog.Lines.Add(AMsg);
  Application.ProcessMessages;
end;

procedure TfrmMain.Log(AMsg: String);
begin
  memError.Lines.Add(AMsg);
  Application.ProcessMessages;
end;

initialization
  OnGetApplicationName := @GetApplicationName;
end.

