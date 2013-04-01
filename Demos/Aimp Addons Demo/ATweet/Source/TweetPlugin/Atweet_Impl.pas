unit Atweet_Impl;

interface

uses
  AIMPSDKCore, AIMPSDKAddons, Windows, AIMPAddonCustomPlugin, TwitterLib,
  CodeSiteLogging;

type
  TTweetPlugin = class;

  { TAIMPHook }
  TAIMPHook = class(TInterfacedObject, IAIMPCoreUnitMessageHook)
  private
    FPlugin: TAIMPAddonsCustomPlugin;
  protected
    procedure CoreMessage(AMessage: DWORD; AParam1: Integer; AParam2: Pointer;
      var AResult: HRESULT); stdcall;
  public
    function SetTwitMess: string;
    property Plugin
      : TAIMPAddonsCustomPlugin read FPlugin write FPlugin default nil;

  end;

  { TTweetPlugin }
  TTweetPlugin = class(TAIMPAddonsCustomPlugin)
  private
    FMenuHandle: HAIMPMENU;
    FTRAYHandle: HAIMPMENU;
    FPlaylistManager: IAIMPAddonsPlaylistManager;
    FHook: TAIMPHook;

    procedure MenuInitialize;
    procedure MenuFinalize;
    //
    procedure PostTweet;
    //
    procedure TwitterCallBackProc(Sender: TObject);
    //
    function getProfileDirectory: string;
  protected
    function GetPluginAuthor: PWideChar; override; stdcall;
    function GetPluginInfo: PWideChar; override; stdcall;
    function GetPluginName: PWideChar; override; stdcall;
    function GetPluginFlags: DWORD; override; stdcall;
    function ShowSettingsDialog(AParentWindow: HWND): HRESULT; override;
      stdcall;
    function Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT; override; stdcall;
    function Finalize: HRESULT; override; stdcall;
  public
    procedure SelectLangMenu;
    //
    property PlaylistManager
      : IAIMPAddonsPlaylistManager read FPlaylistManager
      default nil;
    property Hook: TAIMPHook read FHook write FHook;
  end;

const
  PluginFullName = 'ATweet v1.45';
  PluginName = 'ATweet';

implementation

uses
  SysUtils, FAtweet, LangRes, Atweet_uses;

var
  SplugInfo, SsTweet: string;

procedure _MenuClick(AUserData: TTweetPlugin; AHandle: HAIMPMENU); stdcall;
begin
  CodeSite.TraceMethod('_MenuClick');
  if Assigned(AUserData) then
    AUserData.PostTweet;
end;

function TTweetPlugin.getProfileDirectory: string;
var
  APathBuffer: array [0 .. MAX_PATH] of WideChar;
  APlayerManager: IAIMPAddonsPlayerManager;
begin
  if CoreUnit.QueryInterface(IID_IAIMPAddonsPlayerManager, APlayerManager)
    = S_OK then
  begin
    ZeroMemory(@APathBuffer[0], Length(APathBuffer) * SizeOf(WideChar));
    if APlayerManager.ConfigGetPath(AIMP_CFG_PATH_PROFILE, @APathBuffer[0],
      Length(APathBuffer)) = S_OK then
      Result := APathBuffer;
  end;
end;

{ TAIMPHook }

procedure TAIMPHook.CoreMessage(AMessage: DWORD; AParam1: Integer;
  AParam2: Pointer; var AResult: HRESULT);

begin
  if not Assigned(Plugin) then
    Exit;

  case AMessage of
    AIMP_MSG_EVENT_STREAM_START:
      begin
        TweetMessage := SetTwitMess;

        if Assigned(ATweetFrame) then
        begin
          ATweetFrame.lblStweet.Caption := TweetMessage;

          if (Authenticated and mySettings.TweetEachPlay) then
            ATweetFrame.Plugin.PostTweet;
        end;
      end;

  end;

end;

function TAIMPHook.SetTwitMess: string;
var
  APlaylistManager: IAIMPAddonsPlaylistManager;
  w: WideString;
  wc: PWideChar;
begin
  CodeSite.TraceMethod(Self, 'SetTwitMess');
  Result := '';
  if Plugin.GetPlaylistManager(APlaylistManager) then
    try
      w := TweetFormatMessage;
      APlaylistManager.FormatString(PWideChar(w), Length(w),
        AIMP_PLAYLIST_FORMAT_MODE_CURRENT, nil, wc);

      if Length(w) > 140 then
        w := Copy(w, 1, 140);

      Result := wc;
    finally
      APlaylistManager := nil;
    end;
end;

{ TTweetPlugin }

procedure TTweetPlugin.SelectLangMenu;
begin
  if mySettings.Language = 'English' then
  begin
    SplugInfo := sEngPlugInfo;
    SsTweet := sEngSendTweet;
  end
  else
  begin
    SplugInfo := sRusPlugInfo;
    SsTweet := SRusSendTweet;
  end;
end;

function TTweetPlugin.Finalize: HRESULT;
begin
  if Assigned(ATweetFrame) then
  begin
    if ATweetFrame.Showing then
      ATweetFrame.Close;
    FreeAndNil(ATweetFrame);
  end;
  //
  MenuFinalize;
  //
  if Assigned(FPlaylistManager) then
    FPlaylistManager := nil;
  //
  CoreUnit.MessageUnhook(FHook);
  FHook.Plugin := nil;
  FHook := nil;
  //
  Twit.Free;
  //
  Result := inherited Finalize;
end;

function TTweetPlugin.GetPluginAuthor: PWideChar;
begin
  Result := 'ildvild';
end;

function TTweetPlugin.GetPluginFlags: DWORD;
begin
  Result := 1;
end;

function TTweetPlugin.GetPluginInfo: PWideChar;
begin
  Result := PWideChar(SplugInfo);
end;

function TTweetPlugin.GetPluginName: PWideChar;
begin
  Result := PluginFullName;
end;

function TTweetPlugin.Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT;

begin

  Result := inherited Initialize(ACoreUnit);

  if Succeeded(Result) then
  begin
    LoadSettings(Self, PluginName, mySettings);
    SettingsChanged(mySettings);

    AppProfileFolder := getProfileDirectory;

    Dest := TCodeSiteDestination.Create(nil);
    Dest.LogFile.FileName := 'ATweet.csl';
    Dest.LogFile.FilePath := AppProfileFolder;
    Dest.LogFile.Active := True;

    CodeSite.Enabled := mySettings.Log;
    CodeSite.Destination := Dest;

    if not GetPlaylistManager(FPlaylistManager) then
      FPlaylistManager := nil;

    FHook := TAIMPHook.Create;
    FHook.Plugin := Self;
    CoreUnit.MessageHook(FHook);

    MenuInitialize;
    ATweetFrame := TAPTweet.Create(Self);

    TweetMessage := Hook.SetTwitMess;

    Twit := TwitterCli.Create(TKey, TSecret);
    with Twit do
    begin
      OnReqDone := TwitterCallBackProc;
      Twit.AccessToken := mySettings.AccessToken;
      Twit.AccessTokenSecret := mySettings.AccessTokenSecret;
      if Authenticated then
      begin
        ATweetFrame.EdUsername.Text := SsAuth;
        SetStoredLogin(AccessToken, AccessTokenSecret);
      end;
      RefURL := 'http://www.aimp.ru';
    end;

    CodeSite.Send('Authenticated', Authenticated);
  end;
end;

procedure TTweetPlugin.MenuFinalize;
var
  AMenuManager: IAIMPAddonsMenuManager;
begin
  if GetMenuManager(AMenuManager) then
    try
      AMenuManager.MenuRemove(FMenuHandle);
      FMenuHandle := nil;
      AMenuManager.MenuRemove(FTRAYHandle);
      FTRAYHandle := nil;
    finally
      AMenuManager := nil;
    end;
  Dest.Free;
end;

procedure TTweetPlugin.MenuInitialize;
var
  AMenuInfo: TAIMPMenuItemInfo;
  AMenuManager: IAIMPAddonsMenuManager;
begin
  if GetMenuManager(AMenuManager) then
    try
      SelectLangMenu;
      ZeroMemory(@AMenuInfo, SizeOf(AMenuInfo));
      AMenuInfo.StructSize := SizeOf(AMenuInfo);
      AMenuInfo.Bitmap := LoadBitmap(HInstance, 'TWIT');
      AMenuInfo.Caption := PWideChar(SsTweet);
      AMenuInfo.Flags := AIMP_MENUITEM_ENABLED;
      AMenuInfo.Proc := @_MenuClick;
      AMenuInfo.UserData := Self;
      FMenuHandle := AMenuManager.MenuCreate(14, @AMenuInfo);
      FTRAYHandle := AMenuManager.MenuCreate(17, @AMenuInfo);
    finally
      AMenuManager := nil;
    end;
end;

// отправка сообщения
procedure TTweetPlugin.PostTweet;
Var
  a: string;
begin
  CodeSite.TraceMethod(Self, 'PostTweet');
  if TweetMessage = '' then
    Exit;
  if not Authenticated then
    Exit;

  a := TweetMessage;
  a := Translit(a);
  if Length(a) > 140 then
    a := Copy(a, 1, 140);

  CodeSite.Send('Message', a);

  Twit.SendTwit(a);
end;

{ DONE -oildvild -cMisc : Отправка твита при каждом проигрывании }

function TTweetPlugin.ShowSettingsDialog(AParentWindow: HWND): HRESULT;
begin
  ATweetFrame.Show;
  Result := S_OK;
end;

procedure TTweetPlugin.TwitterCallBackProc(Sender: TObject);
begin
  if Twit.LastHttpStatus <> 200 then
  begin
    CodeSite.Send('Error communicating with Twitter. Error ',
      Twit.LastHttpStatus);
    Exit;
  end;

  if (Twit.LastReq = trLogin) and (Twit.LastInternalReq = trRequestAccess) then
  begin
    Authenticated := True;
    CodeSite.Send('Authenticated', Authenticated);
    mySettings.AccessToken := Twit.AccessToken;
    mySettings.AccessTokenSecret := Twit.AccessTokenSecret;

    ATweetFrame.EdUsername.Text := SsAuth;
    Exit;
  end;

  if Twit.LastReq = trLogin then
  begin
    CodeSite.Send('Enter PIN');
    Exit;
  end;

  if Twit.LastReq = trTwit then
  begin
    CodeSite.Send('Message sent');
    Exit;
  end;
end;

end.
