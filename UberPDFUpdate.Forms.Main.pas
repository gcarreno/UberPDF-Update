unit UberPDFUpdate.Forms.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, JSONPropStorage, Menus,
  ActnList, StdActns, LCLType;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    alMain: TActionList;
    actFileExit: TFileExit;
    mnuFileExit: TMenuItem;
    mnuFile: TMenuItem;
    mmMain: TMainMenu;
    psMain: TJSONPropStorage;
    procedure FormCreate(Sender: TObject);
  private
    procedure InitPropStorage;
    procedure InitTitle;
    procedure InitShortCuts;
  public

  end;

var
  frmMain: TfrmMain;

implementation

const
  cVersionMajor    = 0;
  cVersionMinor    = 1;
  cVersionRevision = 0;
  cVersionBuild    = 7;

{$R *.lfm}

function GetApplicationName: String;
begin
  Result := 'UberPDFUpdate';
end;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitPropStorage;
  InitTitle;
  InitShortCuts;
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

initialization
  OnGetApplicationName := @GetApplicationName;
end.

