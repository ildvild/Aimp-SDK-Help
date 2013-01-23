unit AIMPSDKHelpers;

{************************************************}
{*                                              *}
{*                AIMP Plugins API              *}
{*             v3.00.943 (26.10.2011)           *}
{*      Helper Classes for Delphi Developers    *}
{*                                              *}
{*              (c) Artem Izmaylov              *}
{*                 www.aimp.ru                  *}
{*             Mail: artem@aimp.ru              *}
{*              ICQ: 345-908-513                *}
{*                                              *}
{************************************************}

interface

uses
  Windows, Classes, AIMPSDKInput, AIMPSDKCommon, Contnrs, AIMPSDKAddons;

type

  { TAIMPInputBuffer }

  TAIMPInputBuffer = class(TObject)
  private
    FData: PByte;
    FSize: Integer;
    FUsed: Integer;
  public
    constructor Create(ASize: Integer);
    destructor Destroy; override;
    procedure Remove(ACount: Cardinal);
    //
    property Data: PByte read FData;
    property Size: Integer read FSize;
    property Used: Integer read FUsed write FUsed;
  end;

  { TAIMPInputStreamAdapter }

  TAIMPInputStreamAdapter = class(TInterfacedObject, IAIMPInputStream)
  private
    FAutoFreeStream: Boolean;
    FStream: TStream;
  public
    constructor Create(AStream: TStream; AAutoFreeStream: Boolean = True);
    destructor Destroy; override;
    // IAIMPInputStream
    function GetSize: Int64; stdcall;
    function GetPosition: Int64; stdcall;
    function SetPosition(const AValue: Int64): Int64; stdcall;
    function ReadData(Buffer: PByte; Size: Integer): Integer; stdcall;
    function Skip(const ABytes: Int64): Int64; stdcall;
    //
    property Stream: TStream read FStream;
  end;

  { TAIMPFileInfoAdapter }

  TAIMPFileInfoAdapter = class(TObject)
  private
    FFileInfo: TAIMPFileInfo;
    function GetHandle: PAIMPFileInfo;
    function GetString(AIndex: Integer): WideString;
    procedure SetString(AIndex: Integer; const AValue: WideString);
    function DoGetString(ABuffer: PWideChar; ALength: Integer): WideString;
    procedure DoSetString(ABuffer: PWideChar; ALength: Integer; const AValue: WideString);
  public
    constructor Create; overload; virtual;
    constructor Create(AAlbumLength, AArtistLength, ADateLength: DWORD;
      AFileNameLength, AGenreLength, ATitleLength: DWORD); overload; virtual;
    destructor Destroy; override;
    procedure Assign(AInfo: PAIMPFileInfo);
    procedure Reset;
    //
    property Active: LongBool read FFileInfo.Active write FFileInfo.Active;
    property BitRate: DWORD read FFileInfo.BitRate write FFileInfo.BitRate;
    property Channels: DWORD read FFileInfo.Channels write FFileInfo.Channels;
    property Duration: DWORD read FFileInfo.Duration write FFileInfo.Duration;
    property FileSize: Int64 read FFileInfo.FileSize write FFileInfo.FileSize;
    property SampleRate: DWORD read FFileInfo.SampleRate write FFileInfo.SampleRate;
    property TrackNumber: DWORD read FFileInfo.TrackNumber write FFileInfo.TrackNumber;
    //
    property Album: WideString index 0 read GetString write SetString;
    property Artist: WideString index 1 read GetString write SetString;
    property Date: WideString index 2 read GetString write SetString;
    property FileName: WideString index 3 read GetString write SetString;
    property Genre: WideString index 4 read GetString write SetString;
    property Title: WideString index 5 read GetString write SetString;
    //
    property Handle: PAIMPFileInfo read GetHandle;
  end;

  { TAIMPAddonsPlaylistStrings }

  TAIMPAddonsPlaylistStrings = class(TInterfacedObject, IAIMPAddonsPlaylistStrings)
  private
    FList: TObjectList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    // IAIMPAddonsPlaylistStrings
    function ItemAdd(AFileName: PWideChar; AInfo: PAIMPFileInfo): HRESULT; stdcall;
    function ItemGetCount: Integer; stdcall;
    function ItemGetFileName(AIndex: Integer; ABuffer: PWideChar; ABufferSizeInChars: Integer): HRESULT; stdcall;
    function ItemGetInfo(AIndex: Integer; AInfo: PAIMPFileInfo): HRESULT; stdcall;
  end;

function FileInfoCopy(ASource, ADest: PAIMPFileInfo): Boolean;
function FileInfoIsValid(AInfo: PAIMPFileInfo): Boolean;
function SafeCopyBuffer(ASource, ADest: PWideChar; ASourceSizeInChars, ADestSizeInChars: Integer): Boolean;
function SafePutStringToBuffer(const S: WideString; ABuffer: PWideChar; ABufferSizeInChars: Integer): Boolean;
implementation

uses
  Math, SysUtils;

procedure FreeMemAndNil(var P: Pointer);
begin
  if P <> nil then
  begin
    FreeMem(P);
    P := nil;
  end;
end;

function FileInfoCopy(ASource, ADest: PAIMPFileInfo): Boolean;
begin
  Result := FileInfoIsValid(ASource) and FileInfoIsValid(ADest);
  if Result then
  try
    ADest^.Active := ASource^.Active;
    ADest^.BitRate := ASource^.BitRate;
    ADest^.Channels := ASource^.Channels;
    ADest^.Duration := ASource^.Duration;
    ADest^.FileSize := ASource^.FileSize;
    ADest^.Mark := ASource^.Mark;
    ADest^.SampleRate := ASource^.SampleRate;
    ADest^.TrackNumber := ASource^.TrackNumber;

    SafeCopyBuffer(ASource^.Album, ADest^.Album, ASource^.AlbumLength, ADest^.AlbumLength);
    SafeCopyBuffer(ASource^.Artist, ADest^.Artist, ASource^.ArtistLength, ADest^.ArtistLength);
    SafeCopyBuffer(ASource^.Date, ADest^.Date, ASource^.DateLength, ADest^.DateLength);
    SafeCopyBuffer(ASource^.FileName, ADest^.FileName, ASource^.FileNameLength, ADest^.FileNameLength);
    SafeCopyBuffer(ASource^.Genre, ADest^.Genre, ASource^.GenreLength, ADest^.GenreLength);
    SafeCopyBuffer(ASource^.Title, ADest^.Title, ASource^.TitleLength, ADest^.TitleLength);
  except
    Result := False;
  end;
end;

function FileInfoIsValid(AInfo: PAIMPFileInfo): Boolean;
begin
  try
    Result := Assigned(AInfo) and not IsBadReadPtr(AInfo, 4) and (AInfo^.StructSize = SizeOf(TAIMPFileInfo));
  except
    Result := False
  end;
end;

function SafeCopyBuffer(ASource, ADest: PWideChar; ASourceSizeInChars, ADestSizeInChars: Integer): Boolean;
begin
  Result := False;
  if (ASource <> nil) and (ADest <> nil) then
  begin
    if IsBadReadPtr(ASource, ASourceSizeInChars * SizeOf(WideChar)) or
       IsBadWritePtr(ADest, ADestSizeInChars * SizeOf(WideChar))
    then
      Exit;

    ZeroMemory(ADest, ADestSizeInChars * SizeOf(WideChar));
    Move(ASource^, ADest^, Min(ASourceSizeInChars, ADestSizeInChars) * SizeOf(WideChar));
    Result := True;
  end;
end;

function SafePutStringToBuffer(const S: WideString; ABuffer: PWideChar; ABufferSizeInChars: Integer): Boolean;
begin
  Result := SafeCopyBuffer(@S[1], ABuffer, Length(S), ABufferSizeInChars);
end;

{ TAIMPInputBuffer }

constructor TAIMPInputBuffer.Create(ASize: Integer);
begin
  inherited Create;
  FSize := ASize;
  FData := AllocMem(ASize);
end;

destructor TAIMPInputBuffer.Destroy;
begin
  FreeMem(Data, Size);
  inherited Destroy;
end;

procedure TAIMPInputBuffer.Remove(ACount: Cardinal);
begin
  ACount := Min(ACount, Used);
  Dec(FUsed, ACount);
  if Used > 0 then
    Move(PByte(NativeUInt(Data) + ACount)^, Data^, Used);
end;

{ TAIMPInputStreamAdapter}

constructor TAIMPInputStreamAdapter.Create(AStream: TStream; AAutoFreeStream: Boolean = True);
begin
  inherited Create;
  FStream := AStream;
  FAutoFreeStream := AAutoFreeStream;
end;

destructor TAIMPInputStreamAdapter.Destroy;
begin
  if FAutoFreeStream then
    FreeAndNil(FStream);
  inherited Destroy;
end;

function TAIMPInputStreamAdapter.GetSize: Int64; stdcall;
begin
  Result := Stream.Size;
end;

function TAIMPInputStreamAdapter.GetPosition: Int64; stdcall;
begin
  Result := Stream.Position;
end;

function TAIMPInputStreamAdapter.SetPosition(const AValue: Int64): Int64; stdcall;
begin
  Result := Stream.Seek(AValue, soBeginning);
end;

function TAIMPInputStreamAdapter.ReadData(Buffer: PByte; Size: Integer): Integer; stdcall;
begin
  Result := Stream.Read(Buffer^, Size);
end;

function TAIMPInputStreamAdapter.Skip(const ABytes: Int64): Int64; stdcall;
begin
  Result := Stream.Seek(ABytes, soCurrent);
end;

{ TAIMPFileInfoAdapter }

constructor TAIMPFileInfoAdapter.Create;
begin
  Create(128, 128, 16, MAX_PATH, 32, MAX_PATH);
end;

constructor TAIMPFileInfoAdapter.Create(AAlbumLength, AArtistLength: DWORD;
  ADateLength, AFileNameLength, AGenreLength, ATitleLength: DWORD);
begin
  inherited Create;
  FFileInfo.StructSize := SizeOf(TAIMPFileInfo);
  FFileInfo.AlbumLength := AAlbumLength;
  FFileInfo.Album := AllocMem(AAlbumLength * SizeOf(WideChar));
  FFileInfo.ArtistLength := AArtistLength;
  FFileInfo.Artist := AllocMem(AArtistLength * SizeOf(WideChar));
  FFileInfo.DateLength := ADateLength;
  FFileInfo.Date := AllocMem(ADateLength * SizeOf(WideChar));
  FFileInfo.FileNameLength := AFileNameLength;
  FFileInfo.FileName := AllocMem(AFileNameLength * SizeOf(WideChar));
  FFileInfo.GenreLength := AGenreLength;
  FFileInfo.Genre := AllocMem(AGenreLength * SizeOf(WideChar));
  FFileInfo.TitleLength := ATitleLength;
  FFileInfo.Title := AllocMem(ATitleLength * SizeOf(WideChar));
end;

destructor TAIMPFileInfoAdapter.Destroy;
begin
  FreeMemAndNil(Pointer(FFileInfo.Album));
  FreeMemAndNil(Pointer(FFileInfo.Artist));
  FreeMemAndNil(Pointer(FFileInfo.Date));
  FreeMemAndNil(Pointer(FFileInfo.FileName));
  FreeMemAndNil(Pointer(FFileInfo.Genre));
  FreeMemAndNil(Pointer(FFileInfo.Title));
  inherited Destroy;
end;

procedure TAIMPFileInfoAdapter.Assign(AInfo: PAIMPFileInfo);
begin
  FileInfoCopy(AInfo, Handle);
end;

procedure TAIMPFileInfoAdapter.Reset;

  procedure DoResetBuffer(B: PWideChar; ALength: Integer);
  begin
    if B <> nil then
      ZeroMemory(B, ALength * SizeOf(WideChar));
  end;

begin
  FFileInfo.Mark := 0;
  FFileInfo.Active := False;
  FFileInfo.BitRate := 0;
  FFileInfo.Channels := 0;
  FFileInfo.Duration := 0;
  FFileInfo.FileSize := 0;
  FFileInfo.SampleRate := 0;
  FFileInfo.TrackNumber := 0;
  DoResetBuffer(FFileInfo.Album, FFileInfo.AlbumLength);
  DoResetBuffer(FFileInfo.Artist, FFileInfo.ArtistLength);
  DoResetBuffer(FFileInfo.Date, FFileInfo.DateLength);
  DoResetBuffer(FFileInfo.FileName, FFileInfo.FileNameLength);
  DoResetBuffer(FFileInfo.Genre, FFileInfo.GenreLength);
  DoResetBuffer(FFileInfo.Title, FFileInfo.TitleLength);
end;

function TAIMPFileInfoAdapter.GetHandle: PAIMPFileInfo;
begin
  Result := @FFileInfo;
end;

function TAIMPFileInfoAdapter.DoGetString(ABuffer: PWideChar; ALength: Integer): WideString;
begin
  if ABuffer = nil then
    raise Exception.Create(ClassName + ': Buffer is not allocated');
  Result := ABuffer;
end;

procedure TAIMPFileInfoAdapter.DoSetString(
  ABuffer: PWideChar; ALength: Integer; const AValue: WideString);
begin
  if ABuffer = nil then
    raise Exception.Create(ClassName + ': Buffer is not allocated');
  ZeroMemory(ABuffer, ALength * SizeOf(WideChar));
  Move(AValue[1], ABuffer^, Min(Length(AValue), ALength) * SizeOf(WideChar));
end;

function TAIMPFileInfoAdapter.GetString(AIndex: Integer): WideString;
begin
  case AIndex of
    0: Result := DoGetString(FFileInfo.Album, FFileInfo.AlbumLength);
    1: Result := DoGetString(FFileInfo.Artist, FFileInfo.ArtistLength);
    2: Result := DoGetString(FFileInfo.Date, FFileInfo.DateLength);
    3: Result := DoGetString(FFileInfo.FileName, FFileInfo.FileNameLength);
    4: Result := DoGetString(FFileInfo.Genre, FFileInfo.GenreLength);
    5: Result := DoGetString(FFileInfo.Title, FFileInfo.TitleLength);
    else
      Result := '';
  end;
end;

procedure TAIMPFileInfoAdapter.SetString(AIndex: Integer; const AValue: WideString);
begin
  case AIndex of
    0: DoSetString(FFileInfo.Album, FFileInfo.AlbumLength, AValue);
    1: DoSetString(FFileInfo.Artist, FFileInfo.ArtistLength, AValue);
    2: DoSetString(FFileInfo.Date, FFileInfo.DateLength, AValue);
    3: DoSetString(FFileInfo.FileName, FFileInfo.FileNameLength, AValue);
    4: DoSetString(FFileInfo.Genre, FFileInfo.GenreLength, AValue);
    5: DoSetString(FFileInfo.Title, FFileInfo.TitleLength, AValue);
  end;
end;

{ TAIMPAddonsPlaylistStrings }

constructor TAIMPAddonsPlaylistStrings.Create;
begin
  inherited Create;
  FList := TObjectList.Create;
end;

destructor TAIMPAddonsPlaylistStrings.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

function TAIMPAddonsPlaylistStrings.ItemAdd(AFileName: PWideChar; AInfo: PAIMPFileInfo): HRESULT;
var
  AItem: TAIMPFileInfoAdapter;
begin
  AItem := TAIMPFileInfoAdapter.Create;
  try
    AItem.Assign(AInfo);
    AItem.FileName := AFileName;
    FList.Add(AItem);
    Result := S_OK;
  except
    FreeAndNil(AItem);
    Result := E_POINTER;
  end;
end;

function TAIMPAddonsPlaylistStrings.ItemGetCount: Integer;
begin
  Result := FList.Count;
end;

function TAIMPAddonsPlaylistStrings.ItemGetFileName(
  AIndex: Integer; ABuffer: PWideChar; ABufferSizeInChars: Integer): HRESULT;
begin
  Result := E_INVALIDARG;
  if (AIndex >= 0) and (AIndex < ItemGetCount) then
  try
    if SafePutStringToBuffer(TAIMPFileInfoAdapter(FList[AIndex]).FileName, ABuffer, ABufferSizeInChars) then
      Result := S_OK;
  except
    Result := E_POINTER;
  end;
end;

function TAIMPAddonsPlaylistStrings.ItemGetInfo(AIndex: Integer; AInfo: PAIMPFileInfo): HRESULT;
begin
  Result := E_INVALIDARG;
  if (AIndex >= 0) and (AIndex < ItemGetCount) then
  try
    if FileInfoCopy(TAIMPFileInfoAdapter(FList[AIndex]).Handle, AInfo) then
      Result := S_OK;
  except
    Result := E_POINTER;
  end;
end;

end.
