unit AlertFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzTabs, Data.DB,
  Vcl.Grids, Vcl.DBGrids, DBAccess, Uni, MemDS, Vcl.ExtCtrls, RzPanel,
  Vcl.MPlayer, RzLabel, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TfrmAlert = class(TForm)
    Image1: TImage;
    dsSounds: TUniDataSource;
    dsTemperatures: TUniDataSource;
    dsSmoke: TUniDataSource;
    Image2: TImage;
    qrtSmoke: TUniQuery;
    qrtTemperature: TUniQuery;
    qrySounds: TUniQuery;
    RzPageControl1: TRzPageControl;
    tsSound: TRzTabSheet;
    DBGrid1: TDBGrid;
    tsSmoke: TRzTabSheet;
    DBGrid2: TDBGrid;
    tsTemp: TRzTabSheet;
    DBGrid3: TDBGrid;
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    Image3: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Private declarations }
    FShowlater: LongInt;
  public
    { Public declarations }
  end;

var
  frmAlert: TfrmAlert;

implementation

{$R *.dfm}

uses MainFrm;


procedure TfrmAlert.FormShow(Sender: TObject);
begin
  frmMain.Player.Stop;
  frmMain.Player.FileName := ExtractFilePath(Application.ExeName) + 'sounds\Alarm.wav';
  frmMain.Player.Open;
  frmMain.Player.Play;
end;

procedure TfrmAlert.Image2Click(Sender: TObject);
begin
  FShowlater := getTickCount;
  frmMain.Player.Stop;
  Close;
end;

procedure TfrmAlert.Timer1Timer(Sender: TObject);
var
  d: String;
begin
  d := formatdatetime('yyyy-mm-dd', Now());
  if not Visible then
  begin
    qrySounds.Execute;
    if qrySounds.RecordCount > 10 then
    begin
      Left := Screen.Width - Width;
      Top := Screen.Height - Height - 48;
      tsSound.Show;
      if getTickCount - FShowlater > 5000 then
        ShowModal;
    end;
    qrtTemperature.Execute;
    if qrtTemperature.RecordCount > 0 then
    begin
      Left := Screen.Width - Width;
      Top := Screen.Height - Height - 48;
      tsTemp.show;
      if getTickCount - FShowlater > 5000 then
        ShowModal;
    end;

    qrtSmoke.Execute;
    if qrtSmoke.RecordCount > 0 then
    begin
      Left := Screen.Width - Width;
      Top := Screen.Height - Height - 48;
      tsSmoke.Show;
      if getTickCount - FShowlater > 5000 then
      ShowModal;
    end;
  end;
end;

end.
