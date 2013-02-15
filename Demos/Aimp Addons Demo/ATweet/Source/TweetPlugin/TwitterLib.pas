﻿{
  You can contact me at: http://eden.fm

  License Version: LGPL v3

  The contents of this file are subject to the Lesser GPL License Version
  3 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at
  http://www.gnu.org/licenses/lgpl.html

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the
  License.

  You may use the code freely for freeware and commercial applications, as long
  you keep a notice the software is using my library, and the original source
  of my code isn't modified.

  TwitterLib for Delphi v0.5. Developed by http://eden.fm

  Usage: see usage.pas for details.

  3rd party:

  - I'm using ICS' overbyte winsock library, which you can get at www.overbyte.be
  I recommend you get the latest daily, from here: http://wiki.overbyte.be/arch/icsv8w.zip

  History:

  v0.1: 15 Feb 2011
  v0.3: 27 Feb 2011
  - modified OverbyteIcsHttpProt no longer required.
  - added new method: RetrievePIN(user,pass). With this your user wont
  need to open a twitter page to login and get a PINcode, the program
  will simulate a browser login and retrieve the PIN without any user
  intervention. This is quite prone to errors though whenever Twitter
  changes anything in their login and auth process, so use with care.
  * lastreq will be trRequestRawAccess after this call, after which you
  can proceed as if the user had already told us the PIN:  Twit.RequestAccess;
  v0.32: 28 Feb 2011
  - Fixed error in unix timestamp offset
  - Removed dependancy of extra b64 unit
  - Changed license to LGPL
  v0.33: 05 Mar 2011
  - Fixed error in unix timestamp offset (somehow the fix wasnt included in my last rar)
  - Added xAuth support (needs OpenSSL dlls in the system and you need to declare USE_SSL in the ICS inc file).
  Keep in mind your app has to be pre-authorized by Twitter to use xAuth first.
  - Simplified login process a bit by handling token/access requests internally.

  Login methods: (note there is an overloaded Login method for the 2nd and 3rd methods)

  * tlPIN: normal login. you can specify whether the pin URL will be launched automatically or not,
  else you need to do it. You can use RequestPinURL to get it in a string if you wish to handle
  it yourself. After that, you must call Twit.ContinuePINLogin (after you set Twit.AccessPIN).
  * tlxAuth: this will use xAuth with SSL.
  * tlSimulatexAuth: this is the same as tlPIN, but the PIN will be retrieved automatically
  by simulating a login via the browser, catching the cookie and allowing
  access to the app, then parsing the resulting html for the PIN.
  v0.34: 31 Mar 2011
  - Fixed timestamp function (issues with conversion after daylight savings ticked in)

  v0.5: 10 Jan 2013
  - Fixed issues with Twiter now requiring content encoding (gzip) in all calls.

  If you make use of my implementation please put a notice in your app about it and mention my website :)

}

unit TwitterLib;

interface

Uses Windows, SysUtils, Classes, StdCtrls, Dialogs,
  OverbyteIcsHttpCCodZLib,
  OverbyteIcsWSocket, // for SslContext
  OverbyteIcsMimeUtils, OverbyteIcsSha1, OverbyteIcsHttpProt;

Const
  RequestTokenURL = 'http://api.twitter.com/oauth/request_token';
  RequestAccessURL = 'http://api.twitter.com/oauth/access_token';
  SSLRequestAccessURL = 'https://api.twitter.com/oauth/access_token';
  RequestTwitURL = 'http://api.twitter.com/1/statuses/update.xml';

  shell32 = 'shell32.dll';

  // APPNOTXAUTHENABLED = 'Client application is not permitted to use xAuth';
{$EXTERNALSYM ShellExecute}
function ShellExecute(hWnd: hWnd; Operation, FileName, Parameters,
  Directory: PWideChar; ShowCmd: Integer): HINST; stdcall;

Type
  TwitterRequests = (trDummy,
    // login process
    // internal calls
    trRequestToken, trRequestAccess, trRequestRawAccess,

    // public methods
    trLogin,
    // status update
    trTwit);

Type
  TwitterLoginModes = (tlPIN, tlxAuth, tlSimulatexAuth);

Type
  TwitterCli = class(TObject)
  private
    FCookie: ansistring;
    ExtraHeader: string;
    LoginMode: TwitterLoginModes;
    AutoReqPIN: Boolean;
    FOnReqDone: TNotifyEvent;
    FOnBeforeSocketCall: TNotifyEvent; // use this to set socket proxy option, since sockets are created/destroyed on demand

    xUser, xPass: ansistring;

    procedure InternalCallback;
    procedure RecreateSocket(ssl: Boolean);

    // VCL handlers
    procedure HTTPClientDocEnd(Sender: TObject);
    procedure HTTPClientHeaderEnd(Sender: TObject);
    procedure HTTPClientRequestDone(Sender: TObject; RqType: THttpRequest;
      ErrCode: Word);
    procedure SSLHTTPClientRequestDone(Sender: TObject; RqType: THttpRequest;
      ErrCode: Word);
    procedure HTTPClientBeforeHeaderSend(Sender: TObject; const Method: string;
      Headers: TStrings);
    procedure GrabCookie(Sender: TObject; const Data: string;
      var Accept: Boolean);

    procedure BuildSignature;
    procedure GetTimeStamp;
    procedure GetNonce;
    procedure GenerateBaseURL(Method, url: string);
    procedure ParseTokenandTokenSecret(rawResult: string);
    procedure ParseAccessData(rawResult: string);

    procedure RequestToken; // socket call
    procedure RequestAccess; // socket call
    procedure xAuthRequestAccess; // socket call
  public
    ConsumerKey: string;
    ConsumerSecret: string;

    OAuthToken: string;
    OAuthTokenSecret: string;
    AccessToken: string;
    AccessTokenSecret: string;
    AccessUserID: string;
    AccessScreenName: string;

    LastInternalReq: TwitterRequests;

    URLRequestToken: string;
    URLRequestAccess: string;
    SSLURLRequestAccess: string;
    URLTwit: string;
    SignBase: string;
    TStamp: string;
    Nonce: string;
    Signature: string;
    Postvars: ansistring;
    AuthHeader: string;
    HTTPClient: THttpCli;
    SSLHTTPClient: TSslHttpCli;
    RefURL: string;
    ResultStrings: TStringList;
    LastReq: TwitterRequests;
    DebugMode: Boolean;
    DebugMemo: TMemo;
    LastHttpStatus: Integer;
    AccessPIN: String;
    SendStatus: String;

    Constructor Create(CKey, CSecret: string); // virtual;
    Destructor Destroy; override;

    procedure Login(Mode: TwitterLoginModes; AutoRequestPIN: Boolean); overload;
    procedure Login(Mode: TwitterLoginModes; user, pass: ansistring); overload;
    procedure ContinuePINLogin;

    procedure SendTwit(twit: string); // socket call
    procedure RequestPIN; // call browser
    procedure RetrievePIN(user, pass: ansistring);

    procedure TriggerReqDone; virtual;
    procedure TriggerBeforeSocketCall; virtual;

    function RequestPinURL: string;
    procedure SetStoredLogin(AToken, ATokenSecret: string);
  published
    property OnReqDone: TNotifyEvent read FOnReqDone write FOnReqDone;
    property OnBeforeSocketCall
      : TNotifyEvent read FOnBeforeSocketCall write FOnBeforeSocketCall;
  end;

function UrlEncode2(const S: String): String;
function UrlEncodeExceptUnicode(const S: String): String;
function GetUTCUnixTime: Int64;
function urlEncodeRFC3986(url: string): string;
function HasUnicode(src: string): Boolean;
function BuildHexedUtf8String(src: string): string;

implementation

function ShellExecute; external shell32 name 'ShellExecuteW';

function BuildHexedUtf8String(src: string): string;
Var
  ut: utf8string;
  a: Integer;
  BinarySize: Integer;
  // InputString: utf8string;
  StringAsBytes: array of Byte;
begin
  Result := '';
  for a := 1 to length(src) do
  begin
    if Ord(src[a]) < 256 then
    begin
      if src[a] = ' ' then
        Result := Result + '%2520'
      else
        Result := Result + UrlEncode2(src[a]);
    end
    else
    begin
      ut := src[a];
      BinarySize := 3; // (Length(InputString) + 1) * SizeOf(Char);
      SetLength(StringAsBytes, BinarySize);
      Move(ut[1], StringAsBytes[0], BinarySize);
      Result := Result + '%25' + IntToHex(StringAsBytes[0], 2);
      Result := Result + '%25' + IntToHex(StringAsBytes[1], 2);
      Result := Result + '%25' + IntToHex(StringAsBytes[2], 2);
    end;
  end;
end;

function HasUnicode(src: string): Boolean;
Var
  a: Integer;
begin
  Result := False;
  for a := 1 to length(src) do
    if Ord(src[a]) > 255 then
      Exit(True);
end;

function GetUTCUnixTime: Int64;
Var
  UTC: TSystemTime;
  t: TDateTime;
begin
  GetSystemTime(UTC);
  t := SystemTimeToDateTime(UTC);
  Result := Round((t - 25569) * 86400);
end;

function UrlEncode2(const S: String): String;
var
  I: Integer;
  Ch: Char;
begin
  Result := '';
  for I := 1 to length(S) do
  begin
    Ch := S[I];
    if ((Ch >= '0') and (Ch <= '9')) or ((Ch >= 'a') and (Ch <= 'z')) or
      ((Ch >= 'A') and (Ch <= 'Z')) or (Ch = '.') or (Ch = '-') or (Ch = '_')
      or (Ch = '~') then
      Result := Result + Ch
    else
    begin
      // if HasUnicode(Ch) then Result := Result + BuildHexedUtf8String(Ch)
      { else } Result := Result + '%' + IntToHex(Ord(Ch), 2);
    end;
  end;
end;

function UrlEncodeExceptUnicode(const S: String): String;
var
  I: Integer;
  Ch: Char;
begin
  Result := '';
  for I := 1 to length(S) do
  begin
    Ch := S[I];
    if ((Ch >= '0') and (Ch <= '9')) or ((Ch >= 'a') and (Ch <= 'z')) or
      ((Ch >= 'A') and (Ch <= 'Z')) or (Ch = '.') or (Ch = '-') or (Ch = '_')
      or (Ch = '~') or HasUnicode(Ch) then
      Result := Result + Ch
    else
      Result := Result + '%' + IntToHex(Ord(Ch), 2);
  end;
end;

function urlEncodeRFC3986(url: string): string;
var
  URL1: string;
begin
  URL1 := UrlEncode2(url);
  URL1 := StringReplace(URL1, '+', ' ', [rfReplaceAll, rfIgnoreCase]);
  Result := URL1;
end;

Constructor TwitterCli.Create(CKey, CSecret: string);
begin
  inherited Create;

  ConsumerKey := CKey;
  ConsumerSecret := CSecret;
  DebugMode := False;

  URLRequestToken := RequestTokenURL;
  URLRequestAccess := RequestAccessURL;
  SSLURLRequestAccess := SSLRequestAccessURL;
  URLTwit := RequestTwitURL;

  ExtraHeader := '';
  ResultStrings := TStringList.Create;
end;

Destructor TwitterCli.Destroy;
begin
  ResultStrings.Free;
  inherited Destroy;
end;

procedure TwitterCli.Login(Mode: TwitterLoginModes; AutoRequestPIN: Boolean);
begin
  LastHttpStatus := 0;
  LastReq := trLogin;
  // LastReq :=
  if Mode <> tlPIN then
  begin
    TriggerReqDone;
    Exit;
  end;

  LoginMode := tlPIN;
  AutoReqPIN := AutoRequestPIN;
  LastInternalReq := trRequestToken;
  LastReq := trLogin;
  OAuthToken := '';
  OAuthTokenSecret := '';

  RequestToken;
end;

procedure TwitterCli.Login(Mode: TwitterLoginModes; user, pass: ansistring);
begin
  LastHttpStatus := 0;
  LastReq := trLogin;
  // LastReq :=
  if Mode = tlPIN then
  begin
    TriggerReqDone;
    Exit;
  end;
  LoginMode := Mode;
  AutoReqPIN := False;
  LastInternalReq := trRequestToken;
  LastReq := trLogin;
  OAuthToken := '';
  OAuthTokenSecret := '';

  xUser := user;
  xPass := pass;

  if Mode = tlxAuth then
  begin
    LastInternalReq := trRequestAccess;
    xAuthRequestAccess;
  end
  else
    RequestToken;
end;

procedure TwitterCli.ContinuePINLogin;
begin
  LastInternalReq := trRequestAccess;
  RequestAccess;
end;

procedure TwitterCli.BuildSignature;
Var
  SignKey: string;
begin
  SignKey := UrlEncode2(ConsumerSecret) + '&' + UrlEncode2(OAuthTokenSecret);
  Signature := { madCrypt.Encode } OverbyteIcsMimeUtils.Base64Encode
    (HMAC_SHA1_EX(SignBase, SignKey));
  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- Build Signature -');
        Lines.Add('SignKey=' + SignKey);
        Lines.Add('Signature=' + Signature);
        Lines.Add('----------------------------------');
      end;
end;

procedure TwitterCli.GetTimeStamp;
begin
  TStamp := UIntToStr(GetUTCUnixTime);
end;

procedure TwitterCli.GetNonce;
Var
  a: Integer;
begin
  Nonce := '';
  for a := 1 to 20 do
    Nonce := Nonce + Chr(Random(26) + 65);
end;

procedure TwitterCli.GenerateBaseURL(Method, url: string);
Var
  ver, tok, cbak: string;
begin
  GetNonce;
  GetTimeStamp;
  if AccessPIN <> '' then
    ver := 'oauth_verifier=' + AccessPIN + '&'
  else
    ver := '';
  // if OAuthToken <> '' then tok := 'oauth_token='   + OAuthToken + '&' else tok := '';

  tok := 'oauth_token=' + OAuthToken + '&';
  if LastReq <> trTwit then
    cbak := 'oauth_callback=oob&';

  if (LastInternalReq = trRequestAccess) and (LoginMode = tlxAuth) then
    SignBase := Method + '&' + UrlEncode2(url) + '&' + UrlEncode2(
      // cbak
      'oauth_consumer_key=' + ConsumerKey + '&' + 'oauth_nonce=' + Nonce +
        '&' + 'oauth_signature_method=HMAC-SHA1' + '&' + 'oauth_timestamp=' +
        TStamp + '&'
      // + tok
      // + ver // access PIN if any
        + 'oauth_version=1.0' + '&' + 'x_auth_mode=client_auth' + '&' +
        'x_auth_password=' + xPass + '&' + 'x_auth_username=' + xUser)
  else
    SignBase := Method + '&' + UrlEncode2(url) + '&' + UrlEncode2
      (cbak + 'oauth_consumer_key=' + ConsumerKey + '&' + 'oauth_nonce=' +
        Nonce + '&' + 'oauth_signature_method=HMAC-SHA1' + '&' +
        'oauth_timestamp=' + TStamp + '&' + tok + ver // access PIN if any
        + 'oauth_version=1.0');

  if SendStatus <> '' then
    SignBase := SignBase + UrlEncode2('&status=') + BuildHexedUtf8String
      (SendStatus);

  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- Generate Base URL -');
        Lines.Add('base=' + SignBase);
        Lines.Add('----------------------------------');
      end;
end;

procedure TwitterCli.RequestToken;
begin

  // first auth step

  // LastReq := trRequestToken;

  OAuthToken := '';
  OAuthTokenSecret := '';
  AccessToken := '';
  AccessTokenSecret := '';
  AccessPIN := '';

  GenerateBaseURL('GET', URLRequestToken);
  BuildSignature;
  { postvars := 'oauth_consumer_key'     + '=' + ConsumerKey + '&' +
    'oauth_signature_method' + '=' + 'HMAC-SHA1' + '&' +
    'oauth_signature'        + '=' + URLEncode2(Signature) + '' + '&' +
    'oauth_timestamp'        + '=' + TStamp      + '&' +
    'oauth_nonce'            + '=' + Nonce       + '&' +
    'oauth_token'            + '=' + OAuthToken  + '&' +
    'oauth_callback'         + '=' + 'oob' + '&' +
    'oauth_version'          + '=' + '1.0';
    }

  RecreateSocket(False);

  ExtraHeader := 'Authorization: OAuth oauth_nonce="' + Nonce +
    '", oauth_callback="oob", oauth_token="' + OAuthToken +
    '", oauth_signature_method="HMAC-SHA1", oauth_timestamp="' + TStamp +
    '", oauth_consumer_key="' + ConsumerKey + '", oauth_signature="' +
    UrlEncode2(Signature) + '", oauth_version="1.0"';

  With HTTPClient do
  begin
    Reference := RefURL;
    RcvdStream := TMemoryStream.Create;
    // SendStream := TMemoryStream.Create;
    // SendStream.Write(postvars[1], Length(postvars));
    // SendStream.Seek(0, soFromBeginning);
    Accept := '*/*';
    url := URLRequestToken; // + '?' + postvars;
    Options := [httpoEnableContentCoding];
    ResultStrings.Clear;

    if DebugMode then
      if Assigned(DebugMemo) then
        with TMemo(DebugMemo) do
        begin
          Lines.Add('- Request Token Start -');
          Lines.Add('postvars=' + Postvars);
          Lines.Add('url=' + url);
          Lines.Add('----------------------------------');
        end;

    try
      GetAsync;
    except
      on E: Exception do
      begin
        RcvdStream.Destroy;
        RcvdStream := nil;
        // SendStream.Destroy; SendStream := nil;
        ResultStrings.Text := 'ERROR ' + E.Message;
        LastHttpStatus := HTTPClient.StatusCode;
        InternalCallback;
        FreeAndNil(HTTPClient);
        Exit;
      end;
    end; // try
  end; // with
end;

procedure TwitterCli.RequestAccess;
begin

  // 2nd auth step, we have PIN already

  // LastReq := trRequestAccess;

  GenerateBaseURL('GET', URLRequestAccess);
  BuildSignature;
  { postvars := 'oauth_consumer_key'     + '=' + ConsumerKey + '&' +
    'oauth_nonce'            + '=' + Nonce       + '&' +
    'oauth_signature_method' + '=' + 'HMAC-SHA1' + '&' +
    'oauth_signature'        + '=' + URLEncode2(Signature) + '' + '&' +
    'oauth_timestamp'        + '=' + TStamp      + '&' +
    'oauth_token'            + '=' + OAuthToken  + '&' +
    'oauth_callback'         + '=' + 'oob'       + '&' +
    'oauth_verifier'         + '=' + AccessPIN   + '&' +
    'oauth_version'          + '=' + '1.0';//       + '&' +
    //'oauth_callback'         + '=' + 'oob' + '&' +
    }

  RecreateSocket(False);

  ExtraHeader := 'Authorization: OAuth oauth_nonce="' + Nonce +
    '", oauth_callback="oob", oauth_token="' + OAuthToken +
    '", oauth_verifier="' + AccessPIN +
    '", oauth_signature_method="HMAC-SHA1", oauth_timestamp="' + TStamp +
    '", oauth_consumer_key="' + ConsumerKey + '", oauth_signature="' +
    UrlEncode2(Signature) + '", oauth_version="1.0"';

  With HTTPClient do
  begin
    Reference := RefURL;
    RcvdStream := TMemoryStream.Create;
    url := URLRequestAccess; // + '?' + postvars;
    ResultStrings.Clear;
    Options := [httpoEnableContentCoding];

    if DebugMode then
      if Assigned(DebugMemo) then
        with TMemo(DebugMemo) do
        begin
          Lines.Add('- Request Access Start -');
          Lines.Add('postvars=' + Postvars);
          Lines.Add('url=' + url);
          Lines.Add('----------------------------------');
        end;

    try
      GetAsync;
    except
      on E: Exception do
      begin
        RcvdStream.Destroy;
        RcvdStream := nil;
        ResultStrings.Text := 'ERROR ' + E.Message;
        LastHttpStatus := HTTPClient.StatusCode;
        FreeAndNil(HTTPClient);
        InternalCallback;
        Exit;
      end;
    end; // try
  end; // with
end;

procedure TwitterCli.xAuthRequestAccess;
begin

  // 2nd auth step, we have PIN already

  // LastReq := trRequestAccess;

  GenerateBaseURL('POST', SSLURLRequestAccess);
  BuildSignature;
  Postvars := 'x_auth_username=' + xUser + '&x_auth_password=' + xPass +
    '&x_auth_mode=client_auth';

  RecreateSocket(True);

  ExtraHeader := 'Authorization: OAuth oauth_nonce="' + Nonce +
    '", oauth_signature_method="HMAC-SHA1", oauth_timestamp="' + TStamp +
    '", oauth_consumer_key="' + ConsumerKey + '", oauth_signature="' +
    UrlEncode2(Signature) + '", oauth_version="1.0"';

  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- xAuth Before Header Send -');
        Lines.Add(ExtraHeader);
        Lines.Add('----------------------------------');
      end;

  With SSLHTTPClient do
  begin
    Reference := RefURL;
    RcvdStream := TMemoryStream.Create;
    SendStream := TMemoryStream.Create;
    SendStream.Write(Postvars[1], length(Postvars));
    SendStream.Seek(0, soFromBeginning);
    url := SSLURLRequestAccess; // + '?' + postvars;
    ResultStrings.Clear;
    Options := [httpoEnableContentCoding];

    if DebugMode then
      if Assigned(DebugMemo) then
        with TMemo(DebugMemo) do
        begin
          Lines.Add('- Request Access Start -');
          Lines.Add('postvars=' + Postvars);
          Lines.Add('url=' + url);
          Lines.Add('----------------------------------');
        end;

    try
      PostAsync;
    except
      on E: Exception do
      begin
        RcvdStream.Destroy;
        RcvdStream := nil;
        SendStream.Destroy;
        SendStream := nil;
        SSLHTTPClient.SslContext.Destroy;
        SSLHTTPClient.SslContext := nil;
        ResultStrings.Text := 'ERROR ' + E.Message;
        LastHttpStatus := SSLHTTPClient.StatusCode;
        FreeAndNil(SSLHTTPClient);
        InternalCallback;
        Exit;
      end;
    end; // try
  end; // with
end;

procedure TwitterCli.SendTwit(twit: string);
begin
  // showmessage(twit);
  // twit := URLEncode2(twit);

  // fix issue, # + unicode fails

  LastReq := trTwit;
  LastInternalReq := trTwit;
  if HasUnicode(twit) then
  begin
    twit := UrlEncodeExceptUnicode(twit);
    // StringReplace(twit,'#','%2523',[rfReplaceAll]);
    SendStatus := twit;
  end
  else
    SendStatus := UrlEncode2(utf8Encode(twit));
  AccessPIN := '';

  GenerateBaseURL('POST', URLTwit);
  BuildSignature;
  { postvars := 'oauth_consumer_key'     + '=' + ConsumerKey + '&' +
    'oauth_nonce'            + '=' + Nonce       + '&' +
    'oauth_signature_method' + '=' + 'HMAC-SHA1' + '&' +
    'oauth_signature'        + '=' + URLEncode2(Signature) + '' + '&' +
    'oauth_timestamp'        + '=' + TStamp      + '&' +
    'oauth_token'            + '=' + AccessToken + '&' +
    'oauth_callback'         + '=' + 'oob'       + '&' +
    'oauth_version'          + '=' + '1.0';
    }

  if HasUnicode(twit) then
    Postvars := 'status=' + { urlencode2 } ((utf8Encode(twit)))
  else
    Postvars := 'status=' + UrlEncode2(twit);

  SendStatus := '';

  RecreateSocket(False);

  ExtraHeader := 'Authorization: OAuth ' + 'oauth_consumer_key="' +
    ConsumerKey +
    '", oauth_signature_method="HMAC-SHA1", oauth_timestamp="' + TStamp +
    '", oauth_nonce="' + Nonce + '", oauth_version="1.0", oauth_token="' +
    AccessToken + '",  oauth_signature="' + UrlEncode2(Signature) + '"';

  With HTTPClient do
  begin
    Reference := RefURL;
    RcvdStream := TMemoryStream.Create;
    SendStream := TMemoryStream.Create;
    SendStream.Write(Postvars[1], length(Postvars));
    SendStream.Seek(0, soFromBeginning);
    url := URLTwit; // + '?' + postvars;
    Options := [httpoEnableContentCoding];
    ResultStrings.Clear;
    if DebugMode then
      if Assigned(DebugMemo) then
        with TMemo(DebugMemo) do
        begin
          Lines.Add('- Request twit Start -');
          Lines.Add('postvars=' + Postvars);
          Lines.Add('url=' + url);
          Lines.Add('----------------------------------');
        end;

    try
      PostAsync;
    except
      on E: Exception do
      begin
        RcvdStream.Destroy;
        RcvdStream := nil;
        SendStream.Destroy;
        SendStream := nil;
        ResultStrings.Text := 'ERROR ' + E.Message;
        LastHttpStatus := HTTPClient.StatusCode;
        FreeAndNil(HTTPClient);
        InternalCallback;
        Exit;
      end;
    end; // try
  end; // with
end;

procedure TwitterCli.TriggerReqDone;
begin
  if Assigned(FOnReqDone) then
    FOnReqDone(Self);
end;

procedure TwitterCli.TriggerBeforeSocketCall;
begin
  if Assigned(FOnBeforeSocketCall) then
    FOnBeforeSocketCall(Self);
end;

procedure TwitterCli.HTTPClientDocEnd(Sender: TObject);
begin
  //
end;

procedure TwitterCli.HTTPClientBeforeHeaderSend(Sender: TObject;
  const Method: string; Headers: TStrings);
begin
  if ExtraHeader <> '' then
  begin
    Headers.Add(ExtraHeader);
    ExtraHeader := '';
  end;

  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- Socket Before Header Send -');
        Lines.Add(Headers.Text);
        Lines.Add('----------------------------------');
      end;
end;

procedure TwitterCli.HTTPClientHeaderEnd(Sender: TObject);
begin
  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- Socket Header End -');
        if Sender is THttpCli then
          Lines.Add(THttpCli(Sender).RcvdHeader.Text)
        else
          Lines.Add(TSslHttpCli(Sender).RcvdHeader.Text);
        Lines.Add('----------------------------------');
      end;
end;

procedure TwitterCli.HTTPClientRequestDone(Sender: TObject;
  RqType: THttpRequest; ErrCode: Word);
Var
  utf8LoadingResult: Byte;
  Err: string;
Label CleanUp;
begin
  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- Request Done Socket DocEnd -');
        Lines.Add('result=' + ResultStrings.Text);
        Lines.Add('status code=' + inttostr(HTTPClient.StatusCode));
        Lines.Add('headers=' + HTTPClient.RcvdHeader.Text);
        Lines.Add('----------------------------------');
      end;

  if (RqType = httpGET) or (RqType = httpPOST) then
  begin
    begin
      HTTPClient.RcvdStream.Position := 0;
      try
        ResultStrings.LoadFromStream(HTTPClient.RcvdStream, TEncoding.UTF8);
      finally
      end;
      if ResultStrings.Count = 0 then
      begin
        HTTPClient.RcvdStream.Position := 0;
        try
          ResultStrings.LoadFromStream(HTTPClient.RcvdStream, TEncoding.UTF8);
        finally
        end;
        if ResultStrings.Count > 0 then
          utf8LoadingResult := 1;
      end;
    end;

    if DebugMode then
      if Assigned(DebugMemo) then
        with TMemo(DebugMemo) do
          Lines.Add('result=' + ResultStrings.Text);

    LastHttpStatus := HTTPClient.StatusCode;

    if (ErrCode <> 0) or (HTTPClient.StatusCode <> 200) then
      Goto CleanUp;
  end
  else
    Exit;

CleanUp :

  HTTPClient.RcvdStream.Destroy;
  HTTPClient.RcvdStream := nil;
  if LastReq = trTwit then
  begin
    HTTPClient.SendStream.Destroy;
    HTTPClient.SendStream := nil;
  end;
  FreeAndNil(HTTPClient);

  InternalCallback;
end;

procedure TwitterCli.SSLHTTPClientRequestDone(Sender: TObject;
  RqType: THttpRequest; ErrCode: Word);
Var
  utf8LoadingResult: Byte;
  Err: string;
Label CleanUp;
begin
  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- Request Done Socket DocEnd -');
        Lines.Add('result=' + ResultStrings.Text);
        Lines.Add('status code=' + inttostr(SSLHTTPClient.StatusCode));
        Lines.Add('headers=' + SSLHTTPClient.RcvdHeader.Text);
        Lines.Add('----------------------------------');
      end;

  if (RqType = httpGET) or (RqType = httpPOST) then
  begin
    begin
      SSLHTTPClient.RcvdStream.Position := 0;
      try
        ResultStrings.LoadFromStream(SSLHTTPClient.RcvdStream, TEncoding.UTF8);
      finally
      end;
      if ResultStrings.Count = 0 then
      begin
        SSLHTTPClient.RcvdStream.Position := 0;
        try
          ResultStrings.LoadFromStream(SSLHTTPClient.RcvdStream,
            TEncoding.UTF8);
        finally
        end;
        if ResultStrings.Count > 0 then
          utf8LoadingResult := 1;
      end;
    end;

    if DebugMode then
      if Assigned(DebugMemo) then
        with TMemo(DebugMemo) do
          Lines.Add('result=' + ResultStrings.Text);

    LastHttpStatus := SSLHTTPClient.StatusCode;

    if (ErrCode <> 0) or (SSLHTTPClient.StatusCode <> 200) then
      Goto CleanUp;
  end
  else
    Exit;

CleanUp :

  SSLHTTPClient.RcvdStream.Destroy;
  SSLHTTPClient.RcvdStream := nil;
  SSLHTTPClient.SslContext.Destroy;
  SSLHTTPClient.SslContext := nil;
  if LastReq = trTwit then
  begin
    SSLHTTPClient.SendStream.Destroy;
    SSLHTTPClient.SendStream := nil;
  end;
  FreeAndNil(SSLHTTPClient);

  InternalCallback;
end;

procedure TwitterCli.RecreateSocket(ssl: Boolean);
begin
  if ssl then
  begin
    SSLHTTPClient := TSslHttpCli.Create(nil);
    With SSLHTTPClient do
    begin
      OnDocEnd := HTTPClientDocEnd;
      OnHeaderEnd := HTTPClientHeaderEnd;
      OnRequestDone := SSLHTTPClientRequestDone;
      OnBeforeHeaderSend := HTTPClientBeforeHeaderSend;
      TriggerBeforeSocketCall;
      SslContext := TSslContext.Create(SSLHTTPClient);
    end;
  end
  else
  begin
    HTTPClient := THttpCli.Create(nil);
    With HTTPClient do
    begin
      OnDocEnd := HTTPClientDocEnd;
      OnHeaderEnd := HTTPClientHeaderEnd;
      OnRequestDone := HTTPClientRequestDone;
      OnBeforeHeaderSend := HTTPClientBeforeHeaderSend;
      TriggerBeforeSocketCall;
    end;
  end;
end;

procedure TwitterCli.ParseTokenandTokenSecret(rawResult: string);
begin
  // parse tokens after request token
  if Pos('oauth_callback_confirmed=true', rawResult) = 0 then
  begin
    LastHttpStatus := 0;
    Exit;
  end;

  try
    Delete(rawResult, 1, Pos('=', rawResult));
    OAuthToken := Copy(rawResult, 1, Pos('&oauth_token_secret=',
        rawResult) - 1);
    Delete(rawResult, 1, Pos('=', rawResult));
    OAuthTokenSecret := Copy(rawResult, 1,
      Pos('&oauth_callback_confirmed=true', rawResult) - 1);
  except
    LastHttpStatus := 0;
  end;

  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- Parse Token and TokenSecret -');
        Lines.Add('Token=' + OAuthToken);
        Lines.Add('TokenSecret=' + OAuthTokenSecret);
        Lines.Add('----------------------------------');
      end;

end;

procedure TwitterCli.RequestPIN;
begin
  ShellExecute(0, nil,
    PChar
      ('https://twitter.com/oauth/authorize?oauth_token=' + OAuthToken), '',
    '', SW_SHOWNORMAL);
end;

function TwitterCli.RequestPinURL: string;
begin
  Result := 'https://twitter.com/oauth/authorize?oauth_token=' + OAuthToken;
end;

procedure TwitterCli.ParseAccessData(rawResult: string);
begin
  // parse tokens after request acccess
  if Pos('user_id', rawResult) = 0 then
  begin
    LastHttpStatus := 0;
    Exit;
  end;

  try
    Delete(rawResult, 1, Pos('=', rawResult));
    AccessToken := Copy(rawResult, 1, Pos('&oauth_token_secret=',
        rawResult) - 1);
    Delete(rawResult, 1, Pos('=', rawResult));
    AccessTokenSecret := Copy(rawResult, 1, Pos('&user_id=', rawResult) - 1);
    Delete(rawResult, 1, Pos('=', rawResult));
    AccessUserID := Copy(rawResult, 1, Pos('&screen_name=', rawResult) - 1);
    Delete(rawResult, 1, Pos('=', rawResult));
    AccessScreenName := rawResult;

    if LoginMode = tlxAuth then
      if Pos('&', AccessScreenName) > 0 then
        AccessScreenName := Copy(AccessScreenName, 1,
          Pos('&', AccessScreenName) - 1);

    OAuthToken := AccessToken;
    OAuthTokenSecret := AccessTokenSecret;
  except
    LastHttpStatus := 0;
  end;

  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        Lines.Add('- Parse Access Data -');
        Lines.Add('AccessToken=' + AccessToken);
        Lines.Add('AccessTokenSecret=' + AccessTokenSecret);
        Lines.Add('AccessUserID=' + AccessUserID);
        Lines.Add('AccessScreenName=' + AccessScreenName);
        Lines.Add('----------------------------------');
      end;

end;

procedure TwitterCli.SetStoredLogin(AToken: string; ATokenSecret: string);
begin
  AccessToken := AToken;
  AccessTokenSecret := ATokenSecret;
  OAuthToken := AccessToken;
  OAuthTokenSecret := AccessTokenSecret;
end;

procedure TwitterCli.RetrievePIN(user, pass: ansistring);
Var
  h: THttpCli;
  pvars, token, oatoken: ansistring;
  ts: TStringList;
  S, x: ansistring;
  a: Integer;
begin

  LastInternalReq := trRequestRawAccess;
  LastHttpStatus := 0;

  FCookie := '';
  ts := TStringList.Create;
  h := THttpCli.Create(nil);
  with h do
  begin
    url := 'http://twitter.com/oauth/authorize?oauth_token=' + OAuthToken;
    RcvdStream := TMemoryStream.Create;
    OnDocEnd := HTTPClientDocEnd;
    OnHeaderEnd := HTTPClientHeaderEnd;
    OnBeforeHeaderSend := HTTPClientBeforeHeaderSend;
    OnCookie := GrabCookie;
    Options := [httpoEnableContentCoding];
    try
      Get;
    except
      on E: Exception do
      begin
        if DebugMode then
          if Assigned(DebugMemo) then
            TMemo(DebugMemo).Lines.Add(E.Message);
        ResultStrings.Text := 'Error: ' + E.Message;
      end;
    end;

    try
      h.RcvdStream.WriteBuffer(#0' ', 1);
      h.RcvdStream.Position := 0;
      ts.LoadFromStream(h.RcvdStream);
    finally
    end;
  end;

  if h.StatusCode <> 200 then
  begin
    LastHttpStatus := h.StatusCode;
    ResultStrings.Text := 'Error in raw authentication on 1st step';
    h.RcvdStream.Free;
    h.RcvdStream := nil;
    FreeAndNil(h);
    FreeAndNil(ts);
    // TriggerReqDone;
    Exit;
  end;

  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
        TMemo(DebugMemo).Lines.Add(h.Cookie);

  h.RcvdStream.Free;
  h.RcvdStream := nil;

  if FCookie[length(FCookie)] = ';' then
    Delete(FCookie, length(FCookie), 1);

  if DebugMode then
    if Assigned(DebugMemo) then
      with TMemo(DebugMemo) do
      begin
        TMemo(DebugMemo).Lines.Add('----------------------------------------');
        TMemo(DebugMemo).Lines.Add('----------------------------------------');
      end;

  S := ts.Text;
  if Pos('twttr.form_authenticity_token', S) > 0 then
  begin
    Delete(S, 1, Pos('twttr.form_authenticity_token', S) + 32);
    S := Copy(S, 1, Pos('''', S) - 1);
  end
  else
  begin
    LastHttpStatus := 0;
    ResultStrings.Text := 'Error in raw authentication prelogin';
    h.RcvdStream.Free;
    h.RcvdStream := nil;
    FreeAndNil(h);
    FreeAndNil(ts);
    // TriggerReqDone;
    Exit;
  end;

  ts.Clear;
  with h do
  begin
    url := 'http://twitter.com/oauth/authorize';
    RcvdStream := TMemoryStream.Create;
    SendStream := TMemoryStream.Create;
    pvars := ('authenticity_token=' + S + '&oauth_token=' + OAuthToken +
        '&session%5Busername_or_email%5D=' + user + '&session%5Bpassword%5D=' +
        pass);
    SendStream.Write(pvars[1], length(pvars));
    SendStream.Seek(0, soFromBeginning);
    OnDocEnd := HTTPClientDocEnd;
    OnHeaderEnd := HTTPClientHeaderEnd;
    OnBeforeHeaderSend := HTTPClientBeforeHeaderSend;
    Cookie := FCookie;
    Options := [httpoEnableContentCoding];
    if DebugMode then
      if Assigned(DebugMemo) then
        with TMemo(DebugMemo) do
          TMemo(DebugMemo).Lines.Add('Cookie before post=' + FCookie);
    ExtraHeader := 'Origin:https://twitter.com' + #13#10 +
      'Referer:http://twitter.com/oauth/authorize?oauth_token=' + OAuthToken;
    try
      Post;
    except
      on E: Exception do
      begin
        if DebugMode then
          if Assigned(DebugMemo) then
            TMemo(DebugMemo).Lines.Add(E.Message);
        ResultStrings.Text := 'Error: ' + E.Message;
      end;
    end;

    try
      h.RcvdStream.WriteBuffer(#0' ', 1);
      h.RcvdStream.Position := 0;
      ts.LoadFromStream(h.RcvdStream);
    finally
    end;

    x := '';
    S := ts.Text;
    if Pos('<div id="oauth_pin">', S) > 0 then
    begin
      Delete(S, 1, Pos('<div id="oauth_pin">', S) + 19);
      S := Copy(S, 1, Pos('<', S));
      for a := 1 to length(S) do
        if (Ord(S[a]) > 47) and (Ord(S[a]) < 58) then
          x := x + S[a];
    end;

    LastHttpStatus := h.StatusCode;

    if x = '' then
      LastHttpStatus := 0
    else
      AccessPIN := x;

    if DebugMode then
      if Assigned(DebugMemo) then
        TMemo(DebugMemo).Lines.Add('PIN=' + x);

    if DebugMode then
      if Assigned(DebugMemo) then
        with TMemo(DebugMemo) do
        begin
          TMemo(DebugMemo).Lines.Add(ts.Text);
          TMemo(DebugMemo).Lines.Add(h.Cookie);
        end;

    if h.StatusCode <> 200 then
      ResultStrings.Text := 'Error in raw authentication on 2nd step';

    FreeAndNil(ts);
    h.RcvdStream.Free;
    h.RcvdStream := nil;
    h.SendStream.Free;
    h.SendStream := nil;
    FreeAndNil(h);
  end;

  // TriggerReqDone;

end;

procedure TwitterCli.GrabCookie(Sender: TObject; const Data: string;
  var Accept: Boolean);
begin
  FCookie := FCookie + Data + ';';
end;

procedure TwitterCli.InternalCallback;
begin
  if LastHttpStatus <> 200 then
  begin
    TriggerReqDone;
    Exit;
  end;

  if LastInternalReq = trRequestToken then
  begin
    ParseTokenandTokenSecret(ResultStrings.Text);

    if LoginMode = tlSimulatexAuth then
    begin
      RetrievePIN(xUser, xPass);
      if LastHttpStatus = 0 then
      begin
        TriggerReqDone;
        Exit;
      end;
      ContinuePINLogin;
      Exit;
    end;

    if LoginMode = tlxAuth then
    begin
      LastInternalReq := trRequestAccess;
      xAuthRequestAccess;
      Exit;
    end;

    if AutoReqPIN then
      RequestPIN;
    TriggerReqDone;
    Exit;
  end;

  if LastInternalReq = trRequestAccess then
    ParseAccessData(ResultStrings.Text);

  TriggerReqDone;
end;

end.
