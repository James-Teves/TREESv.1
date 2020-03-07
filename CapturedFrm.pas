unit CapturedFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel,
  Vcl.Imaging.pngimage, Vcl.StdCtrls, RzLabel, Vcl.Imaging.jpeg, Vcl.ComCtrls;

type
  TfrmCaptured = class(TForm)
    RzPanel1: TRzPanel;
    Image1: TImage;
    RzLabel1: TRzLabel;
    RzPanel3: TRzPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCaptured: TfrmCaptured;

implementation

{$R *.dfm}
end.
