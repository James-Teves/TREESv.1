unit DashboardFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzBmpBtn, RzTabs, Vcl.ExtCtrls, RzPanel,
  Vcl.StdCtrls, RzLabel, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, Vcl.DBCGrids, uSimpleBrowser,
  Vcl.ComCtrls, Vcl.OleCtrls, SHDocVw, uCEFWindowParent, uCEFChromiumWindow,
  Data.DB, DBAccess, Uni, MemDS, WMPLib_TLB, RzLstBox;

type
  TfrmDashboard = class(TForm)
    tmrViewer: TTimer;
    PageControl1: TPageControl;
    tsHome: TTabSheet;
    RzLabel4: TRzLabel;
    RzPanel1: TRzPanel;
    Image1: TImage;
    Image4: TImage;
    txtName: TRzLabel;
    Label1: TLabel;
    RzLabel3: TRzLabel;
    Image9: TImage;
    RzPanel3: TRzPanel;
    btnStatsAnalys: TLabel;
    btnControlCenter: TLabel;
    btnAbout: TLabel;
    btnHistory: TLabel;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    RzPanel2: TRzPanel;
    Image3: TImage;
    Image2: TImage;
    RzLabel1: TRzLabel;
    WindowsMediaPlayer1: TWindowsMediaPlayer;
    btnTheTeam: TLabel;
    Image10: TImage;
    qryDevices: TUniQuery;
    tmrDevices: TTimer;
    lstDeviceList: TRzListBox;
    Panel1: TPanel;
    RzLabel2: TRzLabel;
    procedure btnStatsAnalysClick(Sender: TObject);
    procedure btnControlCenterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHistoryClick(Sender: TObject);
    procedure tmrViewerTimer(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnTheTeamClick(Sender: TObject);
    procedure tmrDevicesTimer(Sender: TObject);
    procedure lstDeviceListEnter(Sender: TObject);
  private
    { Private declarations }
    frmMap : TfrmWeb;
  public
    { Public declarations }
  end;

var
  frmDashboard: TfrmDashboard;

implementation

{$R *.dfm}

uses StatisticsandAnalysisFrm, ControlCenterFrm, HistoryFrm, MainFrm, AboutFrm, OurTeamFrm;

procedure TfrmDashboard.btnAboutClick(Sender: TObject);
begin
  frmAbout.show;
  frmMain.f.WindowsMediaPlayer1.controls.stop;
end;

procedure TfrmDashboard.btnControlCenterClick(Sender: TObject);
begin
  frmControlCenter.Show;
  frmControlCenter.Timer1.Enabled := True;
  frmMain.f.WindowsMediaPlayer1.controls.stop;
end;

procedure TfrmDashboard.btnHistoryClick(Sender: TObject);
begin
  frmMain.f.WindowsMediaPlayer1.controls.stop;
  frmHistory.ShowModal;
end;

procedure TfrmDashboard.btnStatsAnalysClick(Sender: TObject);
begin
  frmMain.f.WindowsMediaPlayer1.controls.stop;
  frmStatisticsandAnalysis.Show;
  frmStatisticsandAnalysis.Timer1.Enabled := True;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
begin
  tmrViewer.Enabled := True;
  //webDashboard.Navigate('http://192.168.1.1/vid.html');
end;


procedure TfrmDashboard.Image9Click(Sender: TObject);
begin
    frmMain.f.WindowsMediaPlayer1.controls.stop;
    Application.terminate;
end;


procedure TfrmDashboard.lstDeviceListEnter(Sender: TObject);
begin
  if Panel1.CanFocus then
    Panel1.SetFocus;
end;

procedure TfrmDashboard.btnTheTeamClick(Sender: TObject);
begin
    frmMain.f.WindowsMediaPlayer1.controls.stop;
    frmTheTeam.Show;
end;

procedure TfrmDashboard.tmrDevicesTimer(Sender: TObject);
begin
  lstDeviceList.Clear;
  with qryDevices do
  begin
    Execute;
    while not EoF do
    begin
      if FieldByName('iCamOnline').AsInteger > 0 then
        lstDeviceList.Add('Device ' + FieldByName('device_id').AsString + ' is ONLINE.')
      else
        lstDeviceList.Add('Device ' + FieldByName('device_id').AsString + ' is OFFLINE.');
      Next;
    end;
  end;
end;

procedure TfrmDashboard.tmrViewerTimer(Sender: TObject);
begin
  tmrViewer.Enabled := False;
  //frmMap.ChromiumWindow1.LoadURL('https://www.youtube.com/watch?v=Ic-J6hcSKa8&t=11s');
end;



end.
