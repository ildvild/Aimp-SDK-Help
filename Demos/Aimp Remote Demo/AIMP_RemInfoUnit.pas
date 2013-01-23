unit AIMP_RemInfoUnit;

interface

uses
  AIMPSDKRemote, AIMPSDKCommon,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ToolWin,jpeg ;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Button1: TButton;
    Image1: TImage;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Button3: TButton;
    Label4: TLabel;
    Button4: TButton;
    Label5: TLabel;
    Button5: TButton;
    Label6: TLabel;
    Button6: TButton;
    Label7: TLabel;
    Button23: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
  protected
    FAIMPWindow: HWND;
    procedure RefreshTrackInfo;
    procedure RefreshTrackPositionInfo;
    procedure RefreshTrackState;
    procedure RefreshVolumeState;
    procedure RefreshMuteState;
    procedure RefreshTrackRepeatState;
    procedure RefreshTrackShuffleState;
    procedure RefreshRadiocapState;
    procedure WMAIMPNotify(var Message: TMessage); message WM_AIMP_NOTIFY;
    procedure WMCopyData(var Message: TWMCopyData); message WM_COPYDATA;
    //
    function AIMPGetPropertyValue(APropertyID: Integer): Integer;
    function AIMPSetPropertyValue(APropertyID, AValue: Integer): Boolean;
    procedure AIMPExecuteCommand(ACommand: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  pngimage;

function AIMPGetHandle: HWND;
begin
  Result := FindWindow(AIMPRemoteAccessClass, AIMPRemoteAccessClass)
end;

{ TForm1 }

//Get
function TForm1.AIMPGetPropertyValue(APropertyID: Integer): Integer;
begin
  if FAIMPWindow <> 0 then
    Result := SendMessage(FAIMPWindow, WM_AIMP_PROPERTY, APropertyID or AIMP_RA_PROPVALUE_GET, 0)
  else
    Result := 0;
end;
//Set
function TForm1.AIMPSetPropertyValue(APropertyID, AValue: Integer): Boolean;
begin
  if FAIMPWindow <> 0 then
    Result := SendMessage(FAIMPWindow, WM_AIMP_PROPERTY, APropertyID or AIMP_RA_PROPVALUE_SET, AValue) <> 0
  else
    Result := False
end;
//Execute WM_AIMP_COMMAND
procedure TForm1.AIMPExecuteCommand(ACommand: Integer);
begin
  if FAIMPWindow <> 0 then
    SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_STOP);
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_NEXT);
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_PREV);
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_VISUAL_NEXT);
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_VISUAL_PREV);
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_QUIT);
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_ADD_FILES);
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_ADD_FOLDERS);
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_ADD_PLAYLISTS);
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_ADD_URL);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  S: string;
begin
  S := '0';
  if InputQuery('Jump To Time', 'Enter time (in seconds)', S) then
    AIMPSetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION, StrToInt(S) * 1000);
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_OPEN_FILES);
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_OPEN_FOLDERS);
end;

procedure TForm1.Button22Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_OPEN_PLAYLISTS);
end;

procedure TForm1.Button23Click(Sender: TObject);
var
  S: string;
begin
  S := '0';
  if InputQuery('Radio Capture State', 'Enter radio capture state( 0 or 1 )', S) then
    AIMPSetPropertyValue(AIMP_RA_PROPERTY_RADIOCAP, StrToInt(S));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if SendMessage(FAIMPWindow, WM_AIMP_COMMAND, AIMP_RA_CMD_GET_COVER_ART, Handle) = 0 then
          Image1.Picture.LoadFromFile('NOCOVER.jpg');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  S: string;
begin
  S := '0';
  if InputQuery('Current Volume', 'Enter volume (in percent)', S) then
    AIMPSetPropertyValue(AIMP_RA_PROPERTY_VOLUME, StrToInt(S));
end;


procedure TForm1.Button4Click(Sender: TObject);
var
  S: string;
begin
  S := '0';
  if InputQuery('Mute State', 'Enter mute state( 0 or 1 )', S) then
    AIMPSetPropertyValue(AIMP_RA_PROPERTY_MUTE, StrToInt(S));
end;


procedure TForm1.Button5Click(Sender: TObject);
var
  S: string;
begin
  S := '0';
  if InputQuery('Track Repeat State', 'Enter Track Repeat state( 0 or 1 )', S) then
    AIMPSetPropertyValue(AIMP_RA_PROPERTY_TRACK_REPEAT, StrToInt(S));
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  S: string;
begin
  S := '0';
  if InputQuery('Track shuffle State', 'Enter shuffle state( 0 or 1 )', S) then
    AIMPSetPropertyValue(AIMP_RA_PROPERTY_TRACK_SHUFFLE, StrToInt(S));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_PLAY);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_PLAYPAUSE);
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
AIMPExecuteCommand(AIMP_RA_CMD_PAUSE);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  AVersion: Integer;
begin
  FAIMPWindow := AIMPGetHandle;
  if FAIMPWindow = 0 then
  begin
    MessageDlg('AIMP not running!', mtWarning, [mbOK], 0);
    Exit;
  end;

  AVersion := AIMPGetPropertyValue(AIMP_RA_PROPERTY_VERSION);
  Caption :=  Caption+FormatFloat(' 0.00', HiWord(AVersion) / 100) + ' Build ' + IntToStr(LoWord(AVersion));

  // hook notifications
  SendMessage(FAIMPWindow, WM_AIMP_COMMAND, AIMP_RA_CMD_REGISTER_NOTIFY, Handle);
  // Refresh Info
  RefreshTrackInfo;
  RefreshTrackState;
  RefreshVolumeState;
  RefreshMuteState;
  RefreshTrackRepeatState;
  RefreshTrackShuffleState;
  RefreshRadiocapState;
end;

procedure TForm1.WMAIMPNotify(var Message: TMessage);
begin
  case Message.WParam of
    AIMP_RA_NOTIFY_TRACK_INFO:
      begin
        RefreshTrackInfo;
        if SendMessage(FAIMPWindow, WM_AIMP_COMMAND, AIMP_RA_CMD_GET_COVER_ART, Handle) = 0 then
          Image1.Picture.LoadFromFile('NOCOVER.jpg');
      end;
      AIMP_RA_NOTIFY_TRACK_START:
      begin

      end;
    AIMP_RA_NOTIFY_PROPERTY:
      case Message.LParam of
        AIMP_RA_PROPERTY_PLAYER_POSITION, AIMP_RA_PROPERTY_PLAYER_DURATION:   RefreshTrackPositionInfo;
        AIMP_RA_PROPERTY_PLAYER_STATE: RefreshTrackState;
        AIMP_RA_PROPERTY_VOLUME: RefreshVolumeState;
        AIMP_RA_PROPERTY_MUTE: RefreshMuteState;
        AIMP_RA_PROPERTY_TRACK_REPEAT: RefreshTrackRepeatState ;
        AIMP_RA_PROPERTY_TRACK_SHUFFLE: RefreshTrackShuffleState;
        AIMP_RA_PROPERTY_RADIOCAP: RefreshRadiocapState;
      end;
  end;
end;

procedure TForm1.WMCopyData(var Message: TWMCopyData);
var
  AImage: TPngImage;
  AStream: TMemoryStream;
begin
  if Message.CopyDataStruct^.dwData = WM_AIMP_COPYDATA_COVER_ID then
  begin
    AStream := TMemoryStream.Create;
    try
      AStream.WriteBuffer(Message.CopyDataStruct^.lpData^, Message.CopyDataStruct^.cbData);
      AStream.Position := 0;
      AImage := TPngImage.Create;
      try
        AImage.LoadFromStream(AStream);
        Image1.Picture.Graphic := AImage;
      except
        Image1.Picture.Graphic := nil;
        AImage.Free;
      end;
    finally
      AStream.Free;
    end;
  end;
end;

procedure TForm1.RefreshMuteState;
begin
if AIMPGetPropertyValue(AIMP_RA_PROPERTY_MUTE)=0 then
     Label4.Caption := 'Volume On'
else
    Label4.Caption := 'Volume Off'
end;

procedure TForm1.RefreshRadiocapState;
begin
if AIMPGetPropertyValue(AIMP_RA_PROPERTY_RADIOCAP)=0 then
     Label7.Caption := 'Radio capture  Off'
else
    Label7.Caption := 'Radio capture  On'
end;

procedure TForm1.RefreshTrackInfo;

  function ExtractString(var B: PByte; ALength: Integer): WideString;
  begin
    SetString(Result, PWideChar(B), ALength);
    Inc(B, SizeOf(WideChar) * ALength);
  end;

var
  ABuffer: PByte;
  AFile: Cardinal;
  AInfo: PAIMPFileInfo;
begin
  ListBox1.Items.Clear;
  AFile := OpenFileMapping(FILE_MAP_READ, True, AIMPRemoteAccessClass);
  try
    AInfo := MapViewOfFile(AFile, FILE_MAP_READ, 0, 0, AIMPRemoteAccessMapFileSize);
    if AInfo <> nil then
    try
      if AInfo <> nil then
      begin
        ABuffer := Pointer(DWORD(AInfo) + SizeOf(TAIMPFileInfo));
        Listbox1.Items.Add(Format('%d Hz, %d kbps, %d chans', [AInfo^.SampleRate, AInfo^.BitRate, AInfo^.Channels]));
        Listbox1.Items.Add(Format('%d seconds, %d bytes', [AInfo^.Duration div 1000, AInfo^.FileSize]));
        Listbox1.Items.Add('Album: ' + ExtractString(ABuffer, AInfo^.AlbumLength));
        Listbox1.Items.Add('Artist: ' + ExtractString(ABuffer, AInfo^.ArtistLength));
        Listbox1.Items.Add('Date: ' + ExtractString(ABuffer, AInfo^.DateLength));
        Listbox1.Items.Add('FileName: ' + ExtractString(ABuffer, AInfo^.FileNameLength));
        Listbox1.Items.Add('Genre: ' + ExtractString(ABuffer, AInfo^.GenreLength));
        Listbox1.Items.Add('Title: ' + ExtractString(ABuffer, AInfo^.TitleLength));
      end;
    finally
      UnmapViewOfFile(AInfo);
    end;
  finally
    CloseHandle(AFile);
  end;


end;

procedure TForm1.RefreshTrackPositionInfo;
begin
  Label1.Caption :=
    IntToStr(AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_POSITION) div 1000) + ' / ' +
    IntToStr(AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_DURATION) div 1000) + ' seconds'+
    ' ';
end;

procedure TForm1.RefreshTrackRepeatState;
begin
 if AIMPGetPropertyValue(AIMP_RA_PROPERTY_TRACK_REPEAT)=0 then
     Label5.Caption := 'Repeat Off'
else
    Label5.Caption := 'Repeat On'
end;

procedure TForm1.RefreshTrackShuffleState;
begin
if AIMPGetPropertyValue(AIMP_RA_PROPERTY_TRACK_SHUFFLE)=0 then
   Label6.Caption := 'Shuffle Off'
else
   Label6.Caption := 'Shuffle On';
end;

procedure TForm1.RefreshTrackState;
begin
    case AIMPGetPropertyValue(AIMP_RA_PROPERTY_PLAYER_STATE)  of
    0:   Label2.Caption:='Stopped';
    1:   Label2.Caption:='Paused';
    2:   Label2.Caption:='Playing';
    end;
end;

procedure TForm1.RefreshVolumeState;
begin
    Label3.Caption :=
    IntToStr(AIMPGetPropertyValue(AIMP_RA_PROPERTY_VOLUME)) + ' %';
end;

procedure TForm1.ToolButton11Click(Sender: TObject);
begin
    AIMPExecuteCommand(AIMP_RA_CMD_PREV);
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  AIMPExecuteCommand(AIMP_RA_CMD_PREV);
end;

end.
