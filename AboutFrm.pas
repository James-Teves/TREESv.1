unit AboutFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel, uCEFChromiumWindow, uSimpleBrowser,
  Vcl.StdCtrls, RzLabel, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, WMPLib_TLB;

type
  TfrmAbout = class(TForm)
    RzPanel1: TRzPanel;
    Timer1: TTimer;
    Image1: TImage;
    Image3: TImage;
    Image4: TImage;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzPanel3: TRzPanel;
    Image2: TImage;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

uses DashboardFrm, MainFrm;

procedure TfrmAbout.Image3Click(Sender: TObject);
begin
  close;
  frmMain.tsBoard.Show;
  frmMain.f.WindowsMediaPlayer1.controls.play;
end;

procedure TfrmAbout.Image4Click(Sender: TObject);
begin
  close;
  frmMain.tsBoard.Show;
  frmMain.f.WindowsMediaPlayer1.controls.play;
end;
end.
