unit Atweet_uses;

interface

uses
  AIMPAddonCustomPlugin, TwitterLib, FAtweet, ulog;

type
  TSettings = record
    AuthorizeAutoStart: Boolean;
    TweetEachPlay: Boolean;
    Log: Boolean;
    Language: String;
    Tweet: String;
    AccessToken: String;
    AccessTokenSecret: String;
  end;

  TConfigProc = procedure of object;

const

  { Twitter App }
  TKey = 'wDyD6UNSPeJ4hoACarmICA';
  TSecret = 'U8B0HbtmHonzze5VYHQyi6AzlJPUddwv696eg0yv0pw';

  { settings }
  optAuthorizeAutoStart = 'AutoStart';
  optTweetEachPlay = 'EachPlay';
  optLog = 'Log';
  optLanguage = 'Language';
  optTweet = 'Tweet';
  optAccessToken = 'Token';
  optAccessTokenSecret = 'TokenSecret';

var
  { twitter }
  TweetMessage, TweetFormatMessage: string;
  AppProfileFolder: string;
  Authenticated: Boolean = false;
  Twit: TwitterCli;

  { setting }
  mySettings: TSettings = (AuthorizeAutoStart: false; TweetEachPlay: false;
    Log: false; Language: 'Russian'; Tweet: ''; AccessToken: '';
    AccessTokenSecret: '');
  OnSettingsChange: TConfigProc = nil;

function Translit(s: string): string;

//
procedure LoadSettings(const Plugin: TAIMPAddonsCustomPlugin;
  const Section: String; var Settings: TSettings);
procedure SaveSettings(const Plugin: TAIMPAddonsCustomPlugin;
  const Section: String; const Settings: TSettings);
procedure SettingsChanged(const Settings: TSettings);

implementation

uses
  Atweet_LangRes;

procedure LoadSettings(const Plugin: TAIMPAddonsCustomPlugin;
  const Section: String; var Settings: TSettings);
begin
  if Assigned(Plugin) then
    with Plugin do
      with Settings do
      begin
        AuthorizeAutoStart := ConfigReadBoolean(Section, optAuthorizeAutoStart);
        TweetEachPlay := ConfigReadBoolean(Section, optTweetEachPlay);
        Log := ConfigReadBoolean(Section, optLog);
        Language := ConfigReadString(Section, optLanguage);
        Tweet := ConfigReadString(Section, optTweet);
        if Tweet = '' then
          Tweet := sDefaultTweet;

        AccessToken := ConfigReadString(Section, optAccessToken);
        AccessTokenSecret := ConfigReadString(Section, optAccessTokenSecret);
        if (AccessToken <> '') and (AccessTokenSecret <> '') then
          Authenticated := True;

        if mySettings.Log then
          sLog('', 'Load Settings');
      end;
end;

procedure SaveSettings(const Plugin: TAIMPAddonsCustomPlugin;
  const Section: String; const Settings: TSettings);
begin
  if Assigned(Plugin) then
    with Plugin do
      with Settings do
      begin
        ConfigWriteBoolean(Section, optAuthorizeAutoStart, AuthorizeAutoStart);
        ConfigWriteBoolean(Section, optTweetEachPlay, TweetEachPlay);
        ConfigWriteBoolean(Section, optLog, Log);
        ConfigWriteString(Section, optLanguage, Language);
        ConfigWriteString(Section, optTweet, Tweet);
        ConfigWriteString(Section, optAccessToken, AccessToken);
        ConfigWriteString(Section, optAccessTokenSecret, AccessTokenSecret);

        if mySettings.Log then
          sLog('', 'Save Settings');
      end;
end;

procedure SettingsChanged(const Settings: TSettings);
begin
  if Assigned(OnSettingsChange) then
    OnSettingsChange;
end;

function Translit(s: string): string;
const
  rus: string =
    '‡·‚„‰Â∏ÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘¸˚˙˝˛ˇ¿¡¬√ƒ≈®∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ‹€⁄›ﬁﬂ';
  lat: array [1 .. 66] of string = ('a', 'b', 'v', 'g', 'd', 'e', 'yo', 'zh',
    'z', 'i', 'y', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f', 'kh',
    'ts', 'ch', 'sh', 'shch', '''', 'y', '''', 'e', 'yu', 'ya', 'A', 'B', 'V',
    'G', 'D', 'E', 'Yo', 'Zh', 'Z', 'I', 'Y', 'K', 'L', 'M', 'N', 'O', 'P',
    'R', 'S', 'T', 'U', 'F', 'Kh', 'Ts', 'Ch', 'Sh', 'Shch', '''', 'Y', '''',
    'E', 'Yu', 'Ya');
var
  p, i, l: integer;
begin
  Result := '';
  l := Length(s);
  for i := 1 to l do
  begin
    p := Pos(s[i], rus);
    if p < 1 then
      Result := Result + s[i]
    else
      Result := Result + lat[p];
  end;
end;

end.
