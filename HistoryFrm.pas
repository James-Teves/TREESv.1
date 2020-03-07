unit HistoryFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzCmboBx, Data.DB, MemDS,
  DBAccess, Uni, Vcl.Grids, Vcl.DBGrids, RzDBGrid, Vcl.ExtCtrls, RzPanel,
  RzRadGrp, RzLabel, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg;

type
  TfrmHistory = class(TForm)
    x: TImage;
    RzDBGrid1: TRzDBGrid;
    RzDBGrid2: TRzDBGrid;
    RzDBGrid3: TRzDBGrid;
    rzSensor: TRzRadioGroup;
    qryDate: TUniQuery;
    qryDateDate: TDateField;
    qryDatedevice_id: TIntegerField;
    qryDevice: TUniQuery;
    qryDeviceid: TIntegerField;
    qryDevicesSerialNumber: TStringField;
    qryDevicesGeolocation: TStringField;
    qryDeviceiType: TIntegerField;
    qryDevicedDateTime: TDateTimeField;
    dsDevice: TUniDataSource;
    dsDate: TUniDataSource;
    qryValues: TUniQuery;
    dsValues: TUniDataSource;
    RzLabel2: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    Image2: TImage;
    Image3: TImage;
    procedure dsDateDataChange(Sender: TObject; Field: TField);
    procedure rzSensorClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHistory: TfrmHistory;

implementation

{$R *.dfm}

uses MainFrm, DashboardFrm;


procedure TfrmHistory.dsDateDataChange(Sender: TObject; Field: TField);
begin
  qryValues.Active := qryDate.RecordCount <> 0 ;
  if qryDate.RecordCount <> 0 then
  begin
    qryValues.Filter := 'Date = ' + QuotedStr(qryDate.FieldByName('Date').AsString);
    qryValues.Filtered := True;
  end;
end;


procedure TfrmHistory.Image2Click(Sender: TObject);
begin
  close;
  frmMain.tsBoard.Show;
  frmMain.f.WindowsMediaPlayer1.controls.play;
end;

procedure TfrmHistory.Image3Click(Sender: TObject);
begin
  close;
  frmMain.tsBoard.Show;
  frmMain.f.WindowsMediaPlayer1.controls.play;
end;

procedure TfrmHistory.rzSensorClick(Sender: TObject);
begin
  case rzSensor.ItemIndex of
    0: qryValues.SQL.Text := 'SELECT DATE(dDateTime) as Date, TIME(dDateTime) as Time, ' +
                             'iValue, if(iValue> 90, ''Above Normal'', '''') As remark, device_id  FROM `sounds`';
    1: qryValues.SQL.Text := 'SELECT DATE(dDateTime) as Date, TIME(dDateTime) as Time, ' +
                             'iValue, if(iValue> 120, ''Above Normal'', '''') As remark, device_id  FROM `smokes`';
    2: qryValues.SQL.Text := 'SELECT DATE(dDateTime) as Date, TIME(dDateTime) as Time, ' +
                             'iValue, if(iValue> 45, ''Above Normal'', '''') As remark, device_id  FROM `temperatures`';
  end;
  qryValues.Execute;
end;

end.
