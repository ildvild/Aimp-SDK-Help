unit FAtweet;

interface

uses
  Classes,
  Controls,
  Forms,
  StdCtrls,
  XPman,
  Atweet_Impl, LangRes, TwitterLib, CodeSiteLogging;

type

  TAPTweet = class(TForm)
    btnLogin: TButton;
    EdUsername: TEdit;
    grpTweet: TGroupBox;
    grpAutorize: TGroupBox;
    EditStweet: TEdit;
    lblStweet: TLabel;
    btnOK: TButton;
    lblShag1: TLabel;
    lblShag2: TLabel;
    lblShag3: TLabel;
    grpConfig: TGroupBox;
    chkEachPlay: TCheckBox;
    chkLog: TCheckBox;
    lblLang: TLabel;
    cbbLang: TComboBox;
    btnReset: TButton;
    procedure btnLoginClick(Sender: TObject);
    procedure EditStweetChange(Sender: TObject);

    procedure btnOKClick(Sender: TObject);
    procedure cbbLangChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure btnResetClick(Sender: TObject);

  private
    FPlugin: TTweetPlugin;
    procedure OnSettingsChanged;

  public
    { Public declarations }
    constructor Create(APlugin: TTweetPlugin); reintroduce;
    destructor Destroy; override;
    //
    property Plugin: TTweetPlugin read FPlugin;
    procedure SelectLangForm;
    //

  end;

  { DONE -oildvild -cVisual : Èñïðàâèòü èêîíêó }
  { TODO -oildvild -cMisc : Èçìåíèòü ñîõðàíåíèå íàñòðîåê }

var
  ATweetFrame: TAPTweet = nil;
  SsAuth, SsStep1, SsStep2, SsStep3, SsReset, SsConfig: string;

implementation

uses
  Atweet_uses, Atweet_LangRes, Graphics;
{$R *.dfm}

var
  SgrpAutorize, SgrpTweet, SbtnLogin, SlblLang, SchkEachPlay,
    SEditStweetChange, SchkLog: string;

procedure TAPTweet.SelectLangForm;
begin
  if cbbLang.ItemIndex = 0 then
  begin
    SgrpAutorize := sRusÀuthorization;
    SgrpTweet := sRusGrpTweet;
    SbtnLogin := sRusLogin;
    SlblLang := sRusLanguage;
    SchkEachPlay := sRusSendEachPlay;
    SchkLog := sRusLog;
    SEditStweetChange := sRusDefaultTweet;
    SsAuth := sRusAuth;
    SsStep1 := sRusStep1;
    SsStep2 := sRusStep2;
    SsStep3 := sRusStep3;
    SsReset := sRusReset;
    SsConfig := sRusConfig;
  end
  else
  begin
    SgrpAutorize := sEngÀuthorization;
    SgrpTweet := sEngGrpTweet;
    SbtnLogin := sEngLogin;
    SlblLang := sEngLanguage;
    SchkEachPlay := sEngSendEachPlay;
    SchkLog := sEngLog;
    SEditStweetChange := sEngDefaultTweet;
    SsAuth := sEngAuth;
    SsStep1 := sEngStep1;
    SsStep2 := sEngStep2;
    SsStep3 := sEngStep3;
    SsReset := sEngReset;
    SsConfig := sEngConfig;
  end;

  grpAutorize.Caption := SgrpAutorize;
  grpTweet.Caption := SgrpTweet;
  btnLogin.Caption := SbtnLogin;
  lblLang.Caption := SlblLang;
  chkLog.Caption := SchkLog;
  chkEachPlay.Caption := SchkEachPlay;
  lblShag1.Caption := SsStep1;
  lblShag2.Caption := SsStep2;
  lblShag3.Caption := SsStep3;
  btnReset.Caption := SsReset;
  grpConfig.Caption := SsConfig;

end;

procedure TAPTweet.btnOKClick(Sender: TObject);
begin
  CodeSite.TraceMethod(Self, 'btnOKClick');
  Close;
end;

procedure TAPTweet.btnResetClick(Sender: TObject);
begin
  CodeSite.TraceMethod(Self, 'btnResetClick');
  Twit.OAuthToken := '';
  Twit.OAuthTokenSecret := '';
  mySettings.AccessToken := '';
  mySettings.AccessTokenSecret := '';
  EdUsername.Text := '';
end;

constructor TAPTweet.Create(APlugin: TTweetPlugin);
begin
  CodeSite.TraceMethod(Self, 'Create');
  inherited Create(nil);
  FPlugin := APlugin;
  OnSettingsChange := OnSettingsChanged;
end;

destructor TAPTweet.Destroy;
begin
  CodeSite.TraceMethod(Self, 'Destroy');
  inherited Destroy;
end;

procedure TAPTweet.EditStweetChange(Sender: TObject);
begin
  CodeSite.TraceMethod(Self, 'EditStweetChange');
  if Assigned(Plugin) then
  begin
    TweetFormatMessage := EditStweet.Text;
    TweetMessage := Plugin.Hook.SetTwitMess;
    lblStweet.Caption := TweetMessage;
  end;
end;

procedure TAPTweet.btnLoginClick(Sender: TObject);
begin
  CodeSite.TraceMethod(Self, 'btnLoginClick');
  if EdUsername.Text = '' then
  begin
    CodeSite.Send('Authenticating with Twitter...');

    Authenticated := false;
    Twit.Login(tlPIN, True);
  end
  else

    if not Authenticated then
  begin
    if Twit.LastReq <> trLogin then
      Exit;
    Twit.AccessPIN := EdUsername.Text;

    CodeSite.Send('Send Pin', Twit.AccessPIN);

    Twit.ContinuePINLogin;
    Exit;
  end;
end;

procedure TAPTweet.cbbLangChange(Sender: TObject);
begin
  CodeSite.TraceMethod(Self, 'cbbLangChange');
  SettingsChanged(mySettings);
end;

procedure TAPTweet.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CodeSite.TraceMethod(Self, 'FormCloseQuery');
  with mySettings do
  begin
    TweetEachPlay := chkEachPlay.Checked;
    Log := chkLog.Checked;
    CodeSite.Enabled := mySettings.Log;

    if cbbLang.ItemIndex = 0 then
      Language := 'Russian'
    else
      Language := 'English';

    Tweet := EditStweet.Text;

  end;

  if Assigned(FPlugin) then
  begin
    SaveSettings(Plugin, PluginName, mySettings);
    SettingsChanged(mySettings);
  end;
end;

procedure TAPTweet.FormShow(Sender: TObject);
begin
  CodeSite.TraceMethod(Self, 'FormShow');
  with mySettings do
  begin
    chkEachPlay.Checked := TweetEachPlay;
    chkLog.Checked := Log;
    if Language = 'Russian' then
      cbbLang.ItemIndex := 0
    else if Language = 'English' then
      cbbLang.ItemIndex := 1;
    EditStweet.Text := Tweet;
  end;

  if Assigned(Plugin) then
    lblStweet.Caption := TweetMessage;
  //
  SelectLangForm;

  if Authenticated then
  begin
    EdUsername.Font.Color := clGreen;
    EdUsername.Text := SsAuth;
  end;

  if EditStweet.Text = '' then
    EditStweet.Text := SEditStweetChange;
end;

procedure TAPTweet.OnSettingsChanged;
begin
  SelectLangForm;
end;

end.
