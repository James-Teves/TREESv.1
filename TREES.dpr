program TREES;







uses
  Vcl.Forms,
  uCEFApplication,
  MainFrm in 'MainFrm.pas' {frmMain},
  SignUpFrm in 'SignUpFrm.pas' {frmSignUp},
  DashboardFrm in 'DashboardFrm.pas' {Form1},
  StatisticsandAnalysisFrm in 'StatisticsandAnalysisFrm.pas' {frmStatisticsandAnalysis},
  ControlCenterFrm in 'ControlCenterFrm.pas' {frmControlCenter},
  AboutFrm in 'AboutFrm.pas' {frmAbout},
  HttpLibUnt in 'HttpLibUnt.pas',
  uSimpleBrowser in '..\CebuDIYTech\CEF4Delphi-Stable\demos\SimpleBrowser\uSimpleBrowser.pas' {frmWeb},
  HistoryFrm in 'HistoryFrm.pas' {frmHistory},
  AlertFrm in 'AlertFrm.pas' {frmAlert},
  MotionFrm in 'MotionFrm.pas' {frmMotion},
  OurTeamFrm in 'OurTeamFrm.pas' {frmTheTeam};

{$R *.res}
{$SetPEFlags $20}

begin
  GlobalCEFApp := TCefApplication.Create;
  if GlobalCEFApp.StartMainProcess then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSignUp, frmSignUp);
  Application.CreateForm(TfrmDashboard, frmDashboard);
  Application.CreateForm(TfrmStatisticsandAnalysis, frmStatisticsandAnalysis);
  Application.CreateForm(TfrmControlCenter, frmControlCenter);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmWeb, frmWeb);
  Application.CreateForm(TfrmHistory, frmHistory);
  Application.CreateForm(TfrmAlert, frmAlert);
  Application.CreateForm(TfrmMotion, frmMotion);
  Application.CreateForm(TfrmTheTeam, frmTheTeam);
  Application.Run;
  end;
  GlobalCEFApp.Free;
end.
