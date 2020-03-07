unit StatisticsandAnalysisFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  RzButton, Vcl.StdCtrls, RzLabel, RzPanel, Vcl.Imaging.jpeg, RzBmpBtn,
  Vcl.ComCtrls, Vcl.OleCtrls, SHDocVw, VclTee.TeeGDIPlus, Vcl.Grids,
  Vcl.Samples.Calendar, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, RzGrids,
  Data.DB, VCLTee.DBChart, MemDS, DBAccess, Uni, Vcl.DBGrids, RzDBGrid, RzRadChk,
  VCLTee.Series, RzPopups, uSimpleBrowser,  WMPLib_TLB, Vcl.Menus;

const
  OPTION_SOUND = 0;
  OPTION_SMOKE = 1;
  OPTION_TEMP = 2;
  OPTION_MOTION = 3;

type
  TfrmStatisticsandAnalysis = class(TForm)
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    btnTemperature: TImage;
    btnSound: TImage;
    btnSmoke: TImage;
    Image4: TImage;
    RzLabel1: TRzLabel;
    RzPanel1: TRzPanel;
    RzPanel4: TRzPanel;
    qrtTemperature: TUniQuery;
    dsTemperatures: TUniDataSource;
    qrySounds: TUniQuery;
    dsSounds: TUniDataSource;
    qrySoundsid: TIntegerField;
    qrySoundsdevice_id: TIntegerField;
    qrySoundsiValue: TIntegerField;
    qrySoundsdDateTime: TDateTimeField;
    pnlLeft: TRzPanel;
    pnlStat: TRzPanel;
    rzCalendar: TRzCalendar;
    Timer1: TTimer;
    tblDevices: TUniTable;
    RzLabel2: TRzLabel;
    btnMotion: TImage;
    Image1: TImage;
    qrtSmokes: TUniQuery;
    dsSmokes: TUniDataSource;
    Timer2: TTimer;
    cTimer1: TRzLabel;
    cTimer2: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnTemperatureClick(Sender: TObject);
    procedure btnSmokeClick(Sender: TObject);
    procedure rzCalendarClick(Sender: TObject);
    procedure btnSoundClick(Sender: TObject);
    procedure btnMotionClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    frmMap: TfrmWeb;
    frmStat: TfrmWeb;
    OPTION: Integer;
  public
    { Public declarations }
  end;

var
  frmStatisticsandAnalysis: TfrmStatisticsandAnalysis;

implementation

{$R *.dfm}

uses DashboardFrm, MainFrm;

procedure TfrmStatisticsandAnalysis.btnMotionClick(Sender: TObject);
begin
  OPTION := OPTION_MOTION;
  rzCalendarClick(nil);
end;

procedure TfrmStatisticsandAnalysis.btnSmokeClick(Sender: TObject);
begin
  OPTION := OPTION_SMOKE;
  rzCalendarClick(nil);
end;

procedure TfrmStatisticsandAnalysis.btnSoundClick(Sender: TObject);
begin
  OPTION := OPTION_SOUND;
  rzCalendarClick(nil);
end;

procedure TfrmStatisticsandAnalysis.btnTemperatureClick(Sender: TObject);
begin
    OPTION := OPTION_TEMP;
    rzCalendarClick(nil);;
end;



procedure TfrmStatisticsandAnalysis.FormCreate(Sender: TObject);
begin
  frmMap := TfrmWeb.Create(Self);
  frmMap.BorderStyle := bsNone;
  frmMap.Align := alClient;
  frmMap.Parent := pnlLeft;
  frmMap.Show;

  frmStat := TfrmWeb.Create(Self);
  frmStat.BorderStyle := bsNone;
  frmStat.Align := alClient;
  frmStat.Parent := pnlStat;
  frmStat.Show;
  OPTION := 0;
end;

procedure TfrmStatisticsandAnalysis.Image1Click(Sender: TObject);
begin
  close;
  frmMain.tsBoard.Show;
  frmMain.f.WindowsMediaPlayer1.controls.play;
end;

procedure TfrmStatisticsandAnalysis.rzCalendarClick(Sender: TObject);
var
  dFrm, dTo, surl: String;
begin
  dFrm := formatdatetime('yyyy-mm-dd 00:00:00', rzCalendar.Date);
  dTo := formatdatetime('yyyy-mm-dd 23:59:59', rzCalendar.Date);
  case OPTION of
    OPTION_SOUND: surl := 'http://192.168.1.1/chart_sound.php?from='+ dFrm + '&to=' + dTo;
    OPTION_SMOKE: surl := 'http://192.168.1.1/chart_smoke.php?from='+ dFrm + '&to=' + dTo;
    OPTION_TEMP: surl := 'http://192.168.1.1/chart_temp.php?from='+ dFrm + '&to=' + dTo;
    OPTION_MOTION: surl := 'http://192.168.1.1/captured.php?DATE='+ formatdatetime('yyyy-mm-dd', rzCalendar.Date);
  end;

  frmStat.ChromiumWindow1.LoadURL(surl);
end;


procedure TfrmStatisticsandAnalysis.Timer1Timer(Sender: TObject);
var
  str: TStringList;
begin
  str := TStringList.Create;
  try
    str.Clear;
    str.add('  <!DOCTYPE html> ');
    str.add('<html> ');
    str.add('<head> ');
    str.add('  <title></title> ');
    str.add('  <style> ');
    str.add('    #map { ');
    str.add('      height: 100%; ');
    str.add('    }');
    str.add('     html, body { ');
    str.add('       height: 100%; ');
    str.add('       margin: 0;');
    str.add('       padding: 0; ');
    str.add('     } ');
    str.add('   </style> ');
    str.add(' </head> ');
    str.add(' <body> ');
    str.add('   <div id="map"></div> ');
    str.add('   <script> ');
    str.add('     let map; ');
    str.add('     function initMap() { ');
    str.add(' 		var loc = {lat: 10.3334174, lng: 123.9371182}; ');
    str.add(' 		map = new google.maps.Map(document.getElementById(''map''), { ');
    str.add(' 			center: loc, ');
    str.add(' 			zoom: 15 ');
    str.add(' 		}); ');
    tblDevices.First;
    while not tblDevices.Eof do
    begin
      str.add(' 		var marker = new google.maps.Marker({position: {'+tblDevices.FieldByName('sGeolocation').AsString+'}, map: map}); ');
      str.add(' 		var infowindow = new google.maps.InfoWindow({content:"'+tblDevices.FieldByName('sSerialNumber').AsString+'"}); ');
      str.add(' 		infowindow.open(map,marker); ');

      tblDevices.Next;
    end;

    str.add('     } ');
    str.add('   </script> ');
    str.add('   <script async defer');
    str.add('     src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBo201tJrE6JBIsmkZRvPWx6CcByFzZOcI&callback=initMap">');
    str.add('   </script> ');
    str.add(' </body> ');
    str.add(' </html> ');
    str.savetoFile(ExtractFilePath(Application.ExeName) + 'tmp.htm');
  finally
    str.Free;
  end;

  frmMap.ChromiumWindow1.LoadURL(ExtractFilePath(Application.ExeName) + 'tmp.htm');
  frmStat.ChromiumWindow1.LoadURL('http://192.168.1.1/chart_sound.php');
  frmStat.ChromiumWindow1.LoadURL('http://192.168.1.1/chart_smoke.php');
  frmStat.ChromiumWindow1.LoadURL('http://192.168.1.1/chart_temp.php');
  rzCalendarClick(nil);
  Timer1.Enabled := False;
end;

procedure TfrmStatisticsandAnalysis.Timer2Timer(Sender: TObject);
begin
    cTimer1.Caption := TimetoStr(Now);
    cTimer2.Caption := DateToStr(Now);
end;

end.
