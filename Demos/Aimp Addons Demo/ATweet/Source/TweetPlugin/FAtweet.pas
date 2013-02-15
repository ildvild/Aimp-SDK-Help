unit FAtweet;

interface

uses
  Classes,
  Controls,
  Forms,
  StdCtrls,
  XPman,
  Atweet_Impl, LangRes, TwitterLib;

type

  TAPTweet = class(TForm)
    btnLogin: TButton;
    EdUsername: TEdit;
    grpTweet: TGroupBox;
    grpAutorize: TGroupBox;
    EditStweet: TEdit;
    lblStweet: TLabel;
    chkEachPlay: TCheckBox;
    btnOK: TButton;
    cbbLang: TComboBox;
    lblLang: TLabel;
    chkLog: TCheckBox;
    procedure btnLoginClick(Sender: TObject);
    procedure EditStweetChange(Sender: TObject);

    procedure btnOKClick(Sender: TObject);
    procedure cbbLangChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);

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
  SsAuth, SsPin: string;

implementation

uses
  Atweet_uses, Atweet_LangRes, ulog;
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
    SsPin := sRusPin;
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
    SsPin := sEngPin;
  end;

  grpAutorize.Caption := SgrpAutorize;
  grpTweet.Caption := SgrpTweet;
  btnLogin.Caption := SbtnLogin;
  lblLang.Caption := SlblLang;
  chkLog.Caption := SchkLog;
  chkEachPlay.Caption := SchkEachPlay;

end;

procedure TAPTweet.btnOKClick(Sender: TObject);
begin
  Close;
end;

constructor TAPTweet.Create(APlugin: TTweetPlugin);
begin
  inherited Create(nil);
  FPlugin := APlugin;
  OnSettingsChange := OnSettingsChanged;
end;

destructor TAPTweet.Destroy;
begin
  inherited Destroy;
end;

procedure TAPTweet.EditStweetChange(Sender: TObject);
begin
  if Assigned(Plugin) then
  begin
    TweetFormatMessage := EditStweet.Text;
    TweetMessage := Plugin.Hook.SetTwitMess;
    lblStweet.Caption := TweetMessage;
  end;
end;

procedure TAPTweet.btnLoginClick(Sender: TObject);
begin
  if EdUsername.Text = '' then
  begin

    if mySettings.Log then
      sLog('', 'Authenticating with Twitter...');

    Authenticated := false;
    Twit.Login(tlPIN, True);
  end
  else

    if not Authenticated then
  begin
    if Twit.LastReq <> trLogin then
      Exit;
    Twit.AccessPIN := EdUsername.Text;

    if mySettings.Log then
      sLog('', 'Send Pin');

    Twit.ContinuePINLogin;
    Exit;
  end;
end;

procedure TAPTweet.cbbLangChange(Sender: TObject);
begin
  SettingsChanged(mySettings);
end;

procedure TAPTweet.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  with mySettings do
  begin
    TweetEachPlay := chkEachPlay.Checked;
    Log := chkLog.Checked;
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
    EdUsername.Text := SsAuth;

  if EditStweet.Text = '' then
    EditStweet.Text := SEditStweetChange;
end;

procedure TAPTweet.OnSettingsChanged;
begin
  SelectLangForm;
end;

end.
