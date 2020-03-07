unit HTTPLibUnt;

interface

uses
  Classes, IdMultipartFormData, idHTTP, ExtActns, RzPrgres,
  IdComponent, StrUtils;

type
  THTTPService = class(TObject)
  private
    FHTTP: TIdHTTP;
    FFileSize: Integer;
    FProgressBar: TRzProgressBar;
    procedure HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure HTTPWork(Sender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure URL_OnDownloadProgress(Sender: TDownLoadURL; Progress, ProgressMax: Cardinal; StatusCode: TURLDownloadStatus; StatusText: String; var Cancel: Boolean) ;
  public
    constructor Create;
    destructor Destroy; override;
    property ProgressBar: TRzProgressBar read FProgressBar write FProgressBar;
    function Download(AURL, ADestFile: String; AAutoDisconnect: Boolean): Boolean;
  end;

  function HTTPGet(AHTTP: TidHTTP; AURL: String): String;
  function HTTPGet2(AHTTP: TidHTTP; AURL: String): TMemoryStream;
  function HTTPPost(AHTTP: TidHTTP; AURL: String;
      ASource: TIdMultiPartFormDataStream): String;
  function HTTPPost2(AHTTP: TidHTTP; AURL: String;
      ASource: TIdMultiPartFormDataStream): TMemoryStream;
  function HTTPPost3(AHTTP: TidHTTP; AURL: String; ASource: TStringList): String;
  function SimpleDownload(AURL, AFilename: String): Boolean;
  procedure HTTPGetFileStream(AHTTP: TidHTTP; AURL, Filename: String);
  procedure HTTPGetMemoryStream(AHTTP: TidHTTP; AURL: String; Strm: TMemoryStream);

var
  sHTTPLogFile: String;
  bHTTPWriteLog: Boolean;

implementation

uses
  Forms, Controls, SysUtils, Dialogs, Math;

{ THTTPService }

procedure THTTPService.HTTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  if (AWorkMode = wmRead) and Assigned(FProgressBar) then
  begin
    FProgressBar.PartsComplete := FProgressBar.TotalParts;
    Application.ProcessMessages;
  end;
end;

procedure THTTPService.HTTPWork(Sender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  if (AWorkMode = wmRead) and (Assigned(FProgressBar)) then begin
    FProgressBar.Percent := Floor((AWorkCount / FFileSize) * 100);
    Application.ProcessMessages;
  end
end;

procedure THTTPService.HTTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  if Assigned(FProgressBar) then
  begin
    FProgressBar.PartsComplete := 0;
    FProgressBar.TotalParts := 100;
    FProgressBar.PartsComplete := 0;
    Application.ProcessMessages;
  end;
end;

procedure THTTPService.URL_OnDownloadProgress(Sender: TDownLoadURL; Progress,
  ProgressMax: Cardinal; StatusCode: TURLDownloadStatus; StatusText: String;
  var Cancel: Boolean);
begin
  if Assigned(FProgressBar) then
  begin
    FProgressBar.TotalParts := ProgressMax;
    FProgressBar.PartsComplete := Progress;
  end;
end;

constructor THTTPService.Create;
begin
  FHTTP := TidHTTP.Create(nil);
  FProgressBar := nil;
end;

destructor THTTPService.Destroy;
begin
  if FHTTP.Connected then FHTTP.Disconnect;
  FreeAndNil(FHTTP);
  inherited;
end;

function THTTPService.Download(AURL, ADestFile: String;
  AAutoDisconnect: Boolean): Boolean;
var
  DownloadURL: TDownLoadURL;
begin
  Result:= true;
  DownloadURL := TDownLoadURL.Create(nil);
  with DownloadURL do
  try
    URL:= AURL;
    OnDownloadProgress := URL_OnDownloadProgress;
    Filename:= ADestFile;
    try
      ExecuteTarget(nil);
    except
      Result:=False
    end;
  finally
    FreeAndNil(DownloadURL);
  end;
end;

procedure WriteLog(ALog: String; AIsClear: Boolean = False);
begin
//  if not bHTTPWriteLog then Exit;
//  Version3LibUnt.SaveLog(UserAppDataFolder + sHTTPLogFile, ALog, AIsClear);
end;

function HTTPGet(AHTTP: TidHTTP; AURL: String): String;
var
  iTryCnt: Byte;
  bSuccess, bAbort: Boolean;
begin
  Result := '';
  iTryCnt := 0;
  bSuccess := False;
  bAbort := False;
  Screen.Cursor := crHourGlass;
  try
    repeat
      try
        if iTryCnt = 0 then WriteLog('Calling ' + AURL);
        Result := AHTTP.Get(AURL);
        bSuccess := True;
        WriteLog('Sucessful!');
      except
        on E: exception do
        begin
          WriteLog(StringReplace(E.Message, #13#10, ' ', [rfReplaceAll]));
          if iTryCnt < 3 then
          begin
            inc(iTryCnt);
            WriteLog('Retry calling ' + AURL + ' #' + IntToStr(iTryCnt));
          end
          else
          begin
            bAbort := True;
            WriteLog('FAILED!');
            MessageDlg('Cannot connect to server.', mtError, [mbOK], 0);
          end;
        end;
      end;
    until bAbort or bSuccess;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function HTTPGet2(AHTTP: TidHTTP; AURL: String): TMemoryStream;
var
  iTryCnt: Byte;
  bSuccess, bAbort: Boolean;
begin
  iTryCnt := 0;
  bSuccess := False;
  bAbort := False;
  Screen.Cursor := crHourGlass;
  Result := TMemoryStream.Create;
  try
    repeat
      try
        if iTryCnt = 0 then WriteLog('Calling ' + AURL);
        AHTTP.Get(AURL, Result);
        bSuccess := True;
        WriteLog('Sucessful!');
      except
        on E: exception do
        begin
          if iTryCnt < 3 then
          begin
            inc(iTryCnt);
            Result.Clear;
            WriteLog('Retry calling ' + AURL + ' #' + IntToStr(iTryCnt));
          end
          else
          begin
            bAbort := True;
            FreeAndNil(Result);
            WriteLog('FAILED!');
            MessageDlg('Cannot connect to server.', mtError, [mbOK], 0);
          end;
        end;
      end;
    until bAbort or bSuccess;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure HTTPGetMemoryStream(AHTTP: TidHTTP; AURL: String; Strm: TMemoryStream);
begin
  try
    AHTTP.Get(AURL, Strm);
    WriteLog('Sucessful!');
  except
    Strm.Clear;
  end;
end;

procedure HTTPGetFileStream(AHTTP: TidHTTP; AURL, Filename: String);
var
  iTryCnt: Byte;
  bSuccess, bAbort: Boolean;
  f: TFileStream;
begin
  iTryCnt := 0;
  bSuccess := False;
  bAbort := False;
  Screen.Cursor := crHourGlass;
  f := TFileStream.Create(Filename, fmCreate);
  try
    repeat
      try
        if iTryCnt = 0 then WriteLog('Calling ' + AURL);
        AHTTP.Get(AURL, f);
        bSuccess := True;
        WriteLog('Sucessful!');
      except
        on E: exception do
        begin
          if iTryCnt < 3 then
          begin
            inc(iTryCnt);
            //f.Clear;
            WriteLog('Retry calling ' + AURL + ' #' + IntToStr(iTryCnt));
          end
          else
          begin
            bAbort := True;
            FreeAndNil(f);
            WriteLog('FAILED!');
            MessageDlg('Cannot connect to server.', mtError, [mbOK], 0);
          end;
        end;
      end;
    until bAbort or bSuccess;
  finally
    Screen.Cursor := crDefault;
  end;
end;


function HTTPPost(AHTTP: TidHTTP; AURL: String;
    ASource: TIdMultiPartFormDataStream): String;
var
  iTry: Byte;
  bAbort, bSuccess: Boolean;
begin
  iTry := 0;
  bAbort := False;
  bSuccess := False;
  Result := '';
  Screen.Cursor := crHourGlass;
  try
    repeat
      try
        if iTry = 0 then WriteLog('Calling ' + AURL);
        Result := AHTTP.Post(AURL, ASource);
        WriteLog('SUCCESSFUL!');
        bSuccess := True;
      except
        on E: exception do
        begin
          WriteLog(StringReplace(E.Message, #13#10, ' ', [rfReplaceAll]));
          if iTry < 3 then
          begin
            inc(iTry);
            WriteLog('Retry calling ' + AURL + ' #' + IntToStr(iTry));
          end
          else
          begin
            bAbort := True;
            WriteLog('FAILED!');
            MessageDlg('Cannot connect to server.', mtError, [mbOK], 0);
          end;
        end;
      end;
    until bAbort or bSuccess;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function HTTPPost2(AHTTP: TidHTTP; AURL: String;
    ASource: TIdMultiPartFormDataStream): TMemoryStream;
var
  iTry: Byte;
  bAbort, bSuccess: Boolean;
begin
  iTry := 0;
  bAbort := False;
  bSuccess := False;
  Screen.Cursor := crHourGlass;
  Result := TMemoryStream.Create;
  try
    repeat
      try
        if iTry = 0 then WriteLog('Calling ' + AURL);
        AHTTP.Post(AURL, ASource, Result);
        WriteLog('SUCCESSFUL!');
        bSuccess := True;
      except
        on E: exception do
        begin
          WriteLog(StringReplace(E.Message, #13#10, ' ', [rfReplaceAll]));
          if iTry < 3 then
          begin
            inc(iTry);
            WriteLog('Retry calling ' + AURL + ' #' + IntToStr(iTry));
          end
          else
          begin
            bAbort := True;
            FreeAndNil(Result);
            WriteLog('FAILED!');
            MessageDlg('Cannot connect to server.', mtError, [mbOK], 0);
          end;
        end;
      end;
    until bAbort or bSuccess;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function HTTPPost3(AHTTP: TidHTTP; AURL: String; ASource: TStringList): String;
var
  iTry: Byte;
  bAbort, bSuccess: Boolean;
begin
  iTry := 0;
  bAbort := False;
  bSuccess := False;
  Screen.Cursor := crHourGlass;
  Result := '';
  try
    repeat
      try
        if iTry = 0 then WriteLog('Calling ' + AURL);
        AHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
        Result := AHTTP.Post(AURL, ASource);
        WriteLog('SUCCESSFUL!');
        bSuccess := True;
      except
        on E: exception do
        begin
          WriteLog(StringReplace(E.Message, #13#10, ' ', [rfReplaceAll]));
          if iTry < 3 then
          begin
            inc(iTry);
            WriteLog('Retry calling ' + AURL + ' #' + IntToStr(iTry));
          end
          else
          begin
            bAbort := True;
            WriteLog('FAILED!');
            MessageDlg('Cannot connect to server.', mtError, [mbOK], 0);
          end;
        end;
      end;
    until bAbort or bSuccess;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function SimpleDownload(AURL, AFilename: String): Boolean;
var
  duDL: TDownloadURL;
  iTryCnt: Byte;
begin
  iTryCnt := 0;
  duDL := TDownloadURL.Create(nil);
  try
    duDL.URL := AURL;
    duDL.Filename := AFilename;
    repeat
      try
        duDL.ExecuteTarget(nil);
        Result := True;
      except
        inc(iTryCnt);
        Result := False;
      end;
    until (iTryCnt >= 3) or Result;
  finally
    FreeAndNil(duDL);
  end;
end;

end.
