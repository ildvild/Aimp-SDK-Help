unit AIMPSDKHelpers;

{************************************************}
{*                                              *}
{*                AIMP Plugins API              *}
{*             v3.50.1238 (13.03.2013)          *}
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
    function GetString(AIndex: Integer): UnicodeString;
    procedure SetString(AIndex: Integer; const AValue: UnicodeString);
    function DoGetString(ABuffer: PWideChar; ALength: Integer): UnicodeString;
    procedure DoSetString(ABuffer: PWideChar; ALength: Integer; const AValue: UnicodeString);
  public
    constructor Create; overload; virtual;
    constructor Create(AAlbumSizeInChars, AArtistSizeInChars, ADateSizeInChars: DWORD;
      AFileNameSizeInChars, AGenreSizeInChars, ATitleSizeInChars: DWORD); overload; virtual;
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
    property Album: UnicodeString index 0 read GetString write SetString;
    property Artist: UnicodeString index 1 read GetString write SetString;
    property Date: UnicodeString index 2 read GetString write SetString;
    property FileName: UnicodeString index 3 read GetString write SetString;
    property Genre: UnicodeString index 4 read GetString write SetString;
    property Title: UnicodeString index 5 read GetString write SetString;
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
function SafeCopyBuffer(ASource, ADest: PWideChar; ASourceSizeInChars, ADestSizeInChars: Integer): Boolean;
function SafePutStringToBuffer(const S: UnicodeString; ABuffer: PWideChar; ABufferSizeInChars: Integer): Boolean;
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

    SafeCopyBuffer(ASource^.AlbumBuffer, ADest^.AlbumBuffer, ASource^.AlbumBufferSizeInChars, ADest^.AlbumBufferSizeInChars);
    SafeCopyBuffer(ASource^.ArtistBuffer, ADest^.ArtistBuffer, ASource^.ArtistBufferSizeInChars, ADest^.ArtistBufferSizeInChars);
    SafeCopyBuffer(ASource^.DateBuffer, ADest^.DateBuffer, ASource^.DateBufferSizeInChars, ADest^.DateBufferSizeInChars);
    SafeCopyBuffer(ASource^.FileNameBuffer, ADest^.FileNameBuffer, ASource^.FileNameBufferSizeInChars, ADest^.FileNameBufferSizeInChars);
    SafeCopyBuffer(ASource^.GenreBuffer, ADest^.GenreBuffer, ASource^.GenreBufferSizeInChars, ADest^.GenreBufferSizeInChars);
    SafeCopyBuffer(ASource^.TitleBuffer, ADest^.TitleBuffer, ASource^.TitleBufferSizeInChars, ADest^.TitleBufferSizeInChars);
  except
    Result := False;
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

function SafePutStringToBuffer(const S: UnicodeString; ABuffer: PWideChar; ABufferSizeInChars: Integer): Boolean;
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

constructor TAIMPFileInfoAdapter.Create(AAlbumSizeInChars, AArtistSizeInChars: DWORD;
  ADateSizeInChars, AFileNameSizeInChars, AGenreSizeInChars, ATitleSizeInChars: DWORD);
begin
  inherited Create;
  FFileInfo.StructSize := SizeOf(TAIMPFileInfo);
  FFileInfo.AlbumBufferSizeInChars := AAlbumSizeInChars;
  FFileInfo.AlbumBuffer := AllocMem(AAlbumSizeInChars * SizeOf(WideChar));
  FFileInfo.ArtistBufferSizeInChars := AArtistSizeInChars;
  FFileInfo.ArtistBuffer := AllocMem(AArtistSizeInChars * SizeOf(WideChar));
  FFileInfo.DateBufferSizeInChars := ADateSizeInChars;
  FFileInfo.DateBuffer := AllocMem(ADateSizeInChars * SizeOf(WideChar));
  FFileInfo.FileNameBufferSizeInChars := AFileNameSizeInChars;
  FFileInfo.FileNameBuffer := AllocMem(AFileNameSizeInChars * SizeOf(WideChar));
  FFileInfo.GenreBufferSizeInChars := AGenreSizeInChars;
  FFileInfo.GenreBuffer := AllocMem(AGenreSizeInChars * SizeOf(WideChar));
  FFileInfo.TitleBufferSizeInChars := ATitleSizeInChars;
  FFileInfo.TitleBuffer := AllocMem(ATitleSizeInChars * SizeOf(WideChar));
end;

destructor TAIMPFileInfoAdapter.Destroy;
begin
  FreeMemAndNil(Pointer(FFileInfo.AlbumBuffer));
  FreeMemAndNil(Pointer(FFileInfo.ArtistBuffer));
  FreeMemAndNil(Pointer(FFileInfo.DateBuffer));
  FreeMemAndNil(Pointer(FFileInfo.FileNameBuffer));
  FreeMemAndNil(Pointer(FFileInfo.GenreBuffer));
  FreeMemAndNil(Pointer(FFileInfo.TitleBuffer));
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
  DoResetBuffer(FFileInfo.AlbumBuffer, FFileInfo.AlbumBufferSizeInChars);
  DoResetBuffer(FFileInfo.ArtistBuffer, FFileInfo.ArtistBufferSizeInChars);
  DoResetBuffer(FFileInfo.DateBuffer, FFileInfo.DateBufferSizeInChars);
  DoResetBuffer(FFileInfo.FileNameBuffer, FFileInfo.FileNameBufferSizeInChars);
  DoResetBuffer(FFileInfo.GenreBuffer, FFileInfo.GenreBufferSizeInChars);
  DoResetBuffer(FFileInfo.TitleBuffer, FFileInfo.TitleBufferSizeInChars);
end;

function TAIMPFileInfoAdapter.GetHandle: PAIMPFileInfo;
begin
  Result := @FFileInfo;
end;

function TAIMPFileInfoAdapter.DoGetString(ABuffer: PWideChar; ALength: Integer): UnicodeString;
begin
  if ABuffer = nil then
    raise Exception.Create(ClassName + ': Buffer is not allocated');
  Result := ABuffer;
end;

procedure TAIMPFileInfoAdapter.DoSetString(
  ABuffer: PWideChar; ALength: Integer; const AValue: UnicodeString);
begin
  if ABuffer = nil then
    raise Exception.Create(ClassName + ': Buffer is not allocated');
  ZeroMemory(ABuffer, ALength * SizeOf(WideChar));
  Move(AValue[1], ABuffer^, Min(Length(AValue), ALength) * SizeOf(WideChar));
end;

function TAIMPFileInfoAdapter.GetString(AIndex: Integer): UnicodeString;
begin
  case AIndex of
    0: Result := DoGetString(FFileInfo.AlbumBuffer, FFileInfo.AlbumBufferSizeInChars);
    1: Result := DoGetString(FFileInfo.ArtistBuffer, FFileInfo.ArtistBufferSizeInChars);
    2: Result := DoGetString(FFileInfo.DateBuffer, FFileInfo.DateBufferSizeInChars);
    3: Result := DoGetString(FFileInfo.FileNameBuffer, FFileInfo.FileNameBufferSizeInChars);
    4: Result := DoGetString(FFileInfo.GenreBuffer, FFileInfo.GenreBufferSizeInChars);
    5: Result := DoGetString(FFileInfo.TitleBuffer, FFileInfo.TitleBufferSizeInChars);
    else
      Result := '';
  end;
end;

procedure TAIMPFileInfoAdapter.SetString(AIndex: Integer; const AValue: UnicodeString);
begin
  case AIndex of
    0: DoSetString(FFileInfo.AlbumBuffer, FFileInfo.AlbumBufferSizeInChars, AValue);
    1: DoSetString(FFileInfo.ArtistBuffer, FFileInfo.ArtistBufferSizeInChars, AValue);
    2: DoSetString(FFileInfo.DateBuffer, FFileInfo.DateBufferSizeInChars, AValue);
    3: DoSetString(FFileInfo.FileNameBuffer, FFileInfo.FileNameBufferSizeInChars, AValue);
    4: DoSetString(FFileInfo.GenreBuffer, FFileInfo.GenreBufferSizeInChars, AValue);
    5: DoSetString(FFileInfo.TitleBuffer, FFileInfo.TitleBufferSizeInChars, AValue);
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
