unit ControlCenterFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, RzLabel, RzPanel, Vcl.Imaging.jpeg, RzBmpBtn, RzButton, RzTabs,
  System.ImageList, Vcl.ImgList, Data.DB, DBAccess, Uni, MemDS, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdAuthentication, HttpLibUnt,
  Vcl.Grids, Vcl.DBGrids, RzDBGrid, Vcl.OleCtrls, SHDocVw, uSimpleBrowser,
  Vcl.Samples.Gauges, Vcl.WinXCtrls;

type
  TfrmControlCenter = class(TForm)
    pnlLeft: TRzPanel;
    RzPanel1: TRzPanel;
    IdHTTP1: TIdHTTP;
    ImageList1: TImageList;
    qryCamera: TUniQuery;
    tmrCamera: TTimer;
    RzPanel8: TRzPanel;
    RzDBGrid1: TRzDBGrid;
    qryDevices: TUniQuery;
    qryCameraid: TIntegerField;
    qryCamerauser_id: TIntegerField;
    qryCameradevice_id: TIntegerField;
    qryCameraiCameraPos: TIntegerField;
    qryCameraiGPIO_1: TIntegerField;
    qryCameraiGPIO_2: TIntegerField;
    qryCamerasMacAddr: TStringField;
    qryCamerasIP: TStringField;
    qryCameradUpdate: TDateTimeField;
    qryCamerabIsOnline: TLargeintField;
    Timer1: TTimer;
    dsCamera: TUniDataSource;
    dsDevices: TUniDataSource;
    RzPageControl1: TRzPageControl;
    tsImages: TRzTabSheet;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    RzPanel5: TRzPanel;
    Label3: TLabel;
    imgView3: TImage;
    RzToolbar1: TRzToolbar;
    RzPanel6: TRzPanel;
    Label1: TLabel;
    imgView1: TImage;
    RzPanel7: TRzPanel;
    Label2: TLabel;
    imgView2: TImage;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    Image1: TImage;
    gDevice1: TGauge;
    RzLabel1: TRzLabel;
    RzLabel8: TRzLabel;
    Image2: TImage;
    Image4: TImage;
    Image5: TImage;
    qryBattery: TUniQuery;
    dsBattery: TUniDataSource;
    tmrBattery: TTimer;
    btnFSound1: TToggleSwitch;
    btnFSmoke1: TToggleSwitch;
    btnFTemp1: TToggleSwitch;
    gDevice2: TGauge;
    gDevice3: TGauge;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    Image3: TImage;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    RzLabel7: TRzLabel;
    RzLabel9: TRzLabel;
    dspTimeLeft1: TRzLabel;
    dspTimeLeft2: TRzLabel;
    dspTimeLeft3: TRzLabel;
    qryDevicess: TUniQuery;
    procedure tmrCameraTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure tmrBatteryTimer(Sender: TObject);
    procedure btnFSound1Click(Sender: TObject);
    procedure RzDBGrid1CellClick(Column: TColumn);
    procedure btnFSmoke1Click(Sender: TObject);
    procedure btnFTemp1Click(Sender: TObject);
  private
    { Private declarations }
    frmMap: TfrmWeb;
    FFreezeTimer: Bool;
  public
    { Public declarations }
    qryScreenshot : TUniQuery;
    qrySounds : TUniQuery;
    qrtSmoke : TUniQuery;
    qrtTemperature : TUniQuery;
  end;

var
  frmControlCenter: TfrmControlCenter;

implementation

{$R *.dfm}

uses MainFrm;



procedure TfrmControlCenter.btnFSmoke1Click(Sender: TObject);
begin
    FFreezeTimer := true;
  if qryDevices.RecordCount <> 0 then
  begin
    qryDevices.Edit;
    if btnFSound1.State = tssOn then
      qryDevices.FieldByName('Enable_Smoke').AsInteger := 1
    else
      qryDevices.FieldByName('Enable_Smoke').AsInteger := 0;
    qryDevices.Post;
  end;
  FFreezeTimer := false;
end;

procedure TfrmControlCenter.btnFSound1Click(Sender: TObject);
begin
  FFreezeTimer := true;
  if qryDevices.RecordCount <> 0 then
  begin
    qryDevices.Edit;
    if btnFSound1.State = tssOn then
      qryDevices.FieldByName('Enable_Sound').AsInteger := 1
    else
      qryDevices.FieldByName('Enable_Sound').AsInteger := 0;
    qryDevices.Post;
  end;
  FFreezeTimer := false;
end;

procedure TfrmControlCenter.btnFTemp1Click(Sender: TObject);
begin
   FFreezeTimer := true;
  if qryDevices.RecordCount <> 0 then
  begin
    qryDevices.Edit;
    if btnFSound1.State = tssOn then
      qryDevices.FieldByName('Enable_Temp').AsInteger := 1
    else
      qryDevices.FieldByName('Enable_Temp').AsInteger := 0;
    qryDevices.Post;
  end;
  FFreezeTimer := false;
end;

procedure TfrmControlCenter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tmrCamera.Enabled := False;
end;

procedure TfrmControlCenter.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to componentcount-1 do
  begin
    if components[i] is TUniConnection then
      (components[i] as TUniConnection).Connect
    else if(components[i] is TUniQuery) then
      (components[i] as TUniQuery).Active := true
    else if(components[i] is TUniTable) then
      (components[i] as TUniTable).Active := true;
  end;

  frmMap := TfrmWeb.Create(Self);
  frmMap.BorderStyle := bsNone;
  frmMap.Align := alClient;
  frmMap.Parent := pnlLeft;
  frmMap.Show;
end;

procedure TfrmControlCenter.FormShow(Sender: TObject);
begin
  tmrCamera.Enabled := True;
end;

procedure TfrmControlCenter.Image1Click(Sender: TObject);
begin
  close;
  frmMain.tsBoard.Show;
  frmMain.f.WindowsMediaPlayer1.controls.play;
end;

procedure TfrmControlCenter.RzDBGrid1CellClick(Column: TColumn);
begin
  if qryDevices.RecordCount <> 0 then
  begin
    RzLabel1.Caption := qryDevices.FieldByName('sSerialNumber').AsString;
    if (qryDevices.FieldByName('Enable_Sound').AsInteger = 1) then
      btnFSound1.State := tssOn
    else
      btnFSound1.State := tssOff;
    if (qryDevices.FieldByName('Enable_Smoke').AsInteger = 1) then
      btnFSmoke1.State := tssOn
    else
      btnFSmoke1.State := tssOff;
    if (qryDevices.FieldByName('Enable_Temp').AsInteger = 1) then
      btnFTemp1.State := tssOn
    else
      btnFTemp1.State := tssOff;
  end;
end;

procedure TfrmControlCenter.Timer1Timer(Sender: TObject);
begin
  frmMap.ChromiumWindow1.LoadURL(ExtractFilePath(Application.ExeName) + 'tmp.htm');
  Timer1.Enabled := False;
end;

procedure TfrmControlCenter.tmrBatteryTimer(Sender: TObject);
var
constant:Integer;
d : Integer;
begin
     qryBattery.Execute;

      while not qryBattery.Eof do
      begin
        if qryBattery.RecordCount > 10 then
        begin
          case qryBattery.FieldbyName('device_id').AsInteger of
              1: begin gDevice1.Progress := Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*100);
                 case Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*100) of
                   0..30 : dspTimeLeft1.Caption:='Critical Level!';
                   31..100: dspTimeLeft1.Caption:=IntToStr(Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*10))+' hrs left';
                 else
                 end;
              end;
           2: begin gDevice2.Progress := Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*100);
                   case  Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*100) of
                      0..30 : dspTimeLeft2.Caption:='Critical Level!';
                      31..100: dspTimeLeft2.Caption:=IntToStr(Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*10))+' hrs left';
                     else
                   end;
                 end;
           3: begin gDevice3.Progress := Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*100);
                   case  Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*100) of
                      0..30 : dspTimeLeft3.Caption:='Critical Level!';
                      31..100: dspTimeLeft3.Caption:=IntToStr(Round(((qryBattery.FieldbyName('iValues').AsInteger-10)/2)*10))+' hrs left';
                      else
                   end;
                 end;
          end;
        end
        else
        begin
          gDevice1.Progress :=0;
          dspTimeLeft1.Caption:='Offline!';
          gDevice2.Progress :=0;
          dspTimeLeft2.Caption:='Offline!';
          gDevice3.Progress :=0;
          dspTimeLeft3.Caption:='Offline!';
        end;
        qryBattery.Next;
      end;

end;

procedure TfrmControlCenter.tmrCameraTimer(Sender: TObject);
var
  mem: TMemoryStream;
  jpg: TjpegImage;
  url: String;
begin
  if FFreezeTimer then
    exit;
//  qryCamera.First;
//  while not qryCamera.Eof do
//  begin
    mem := TMemoryStream.Create;
    jpg := TjpegImage.Create;
    url := 'http://' + qryCamera.FieldByName('sIP').AsString + '/capture?_cb=1575432439685';
    try
      case qryCamera.FieldByName('iCameraPos').AsInteger of
        1: imgView1.Visible := qryCamera.FieldByName('bIsOnline').AsInteger = 1;
        2: imgView2.Visible := qryCamera.FieldByName('bIsOnline').AsInteger = 1;
        3: imgView3.Visible := qryCamera.FieldByName('bIsOnline').AsInteger = 1;
      end;
      if qryCamera.FieldByName('bIsOnline').AsInteger = 1 then
      begin
        HTTPGetMemoryStream(idHttp1, url, mem);
        mem.Position := 0;
        jpg.LoadFromStream(mem);
        if mem.Size > 0 then
        begin
          case qryCamera.FieldByName('iCameraPos').AsInteger of
            1: imgView1.Picture.Assign(jpg);
            2: imgView2.Picture.Assign(jpg);
            3: imgView3.Picture.Assign(jpg);
          end;
        end;
      end;

    finally
      jpg.Free;
      mem.Free;
    end;

    if not qryCamera.Eof then
      qryCamera.Next
    else
      qryCamera.Execute;
  //end;

end;


end.
