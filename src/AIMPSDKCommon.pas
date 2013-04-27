{$REGION 'Documentation'}
/// <summary>
/// <para>
/// Common module. It contains a structure which contains information about
/// the file
/// </para>
/// <para>
/// Общий модуль. Он содержит структуру, хранящую информацию о файле.
/// </para>
/// </summary>
/// <remarks>
/// See demo.
/// </remarks>
/// <example>
/// <code lang="Delphi">
/// function ExtractString(var B: PByte; ALength: Integer): WideString;
/// begin
/// SetString(Result, PWideChar(B), ALength);
/// Inc(B, SizeOf(WideChar) * ALength);
/// end;
///
/// var
/// ABuffer: PByte;
/// AFile: Cardinal;
/// AInfo: PAIMPFileInfo;
///
/// begin
/// ListBox1.Items.Clear;
/// AFile := OpenFileMapping(FILE_MAP_READ, True, AIMPRemoteAccessClass);
/// try
/// AInfo := MapViewOfFile(AFile, FILE_MAP_READ, 0, 0, AIMPRemoteAccessMapFileSize);
/// if AInfo &lt;&gt; nil then
/// try
/// if AInfo &lt;&gt; nil then
/// begin
/// ABuffer := Pointer(DWORD(AInfo) + SizeOf(TAIMPFileInfo));
/// Listbox1.Items.Add(Format('%d Hz, %d kbps, %d chans', [AInfo^.SampleRate, AInfo^.BitRate, AInfo^.Channels]));
/// Listbox1.Items.Add(Format('%d seconds, %d bytes', [AInfo^.Duration div 1000, AInfo^.FileSize]));
/// Listbox1.Items.Add('Album: ' + ExtractString(ABuffer, AInfo^.AlbumLength));
/// Listbox1.Items.Add('Artist: ' + ExtractString(ABuffer, AInfo^.ArtistLength));
/// Listbox1.Items.Add('Date: ' + ExtractString(ABuffer, AInfo^.DateLength));
/// Listbox1.Items.Add('FileName: ' + ExtractString(ABuffer, AInfo^.FileNameLength));
/// Listbox1.Items.Add('Genre: ' + ExtractString(ABuffer, AInfo^.GenreLength));
/// Listbox1.Items.Add('Title: ' + ExtractString(ABuffer, AInfo^.TitleLength));
/// end;
/// finally
/// UnmapViewOfFile(AInfo);
/// end;
/// finally
/// CloseHandle(AFile);
///
/// end; </code>
/// </example>
{$ENDREGION}
unit AIMPSDKCommon;

{ ************************************************ }
{ *                                              * }
{ *                AIMP Plugins API              * }
{*             v3.50.1238 (13.03.2013)          *}
{ *                Common Objects                * }
{ *                                              * }
{ *              (c) Artem Izmaylov              * }
{ *                 www.aimp.ru                  * }
{ *             Mail: artem@aimp.ru              * }
{ *              ICQ: 345-908-513                * }
{ *                                              * }
{ ************************************************ }

interface

uses
  Windows;

type
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// A pointer to the structure TAIMPFileInfo.
  /// </para>
  /// <para>
  /// Указатель на структуру TAIMPFileInfo.
  /// </para>
  /// </summary>
  /// <remarks>
  /// <para>
  /// See Remote demo.
  /// </para>
  /// <para>
  /// Пример использования смотри в демке Remote.
  /// </para>
  /// </remarks>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.RefreshTrackInfo;
  /// function ExtractString(var B: PByte; ALength: Integer): WideString;
  /// begin
  /// SetString(Result, PWideChar(B), ALength);
  /// Inc(B, SizeOf(WideChar) * ALength);
  /// end;
  ///
  /// var
  /// ABuffer: PByte;
  /// AFile: Cardinal;
  /// AInfo: PAIMPFileInfo;
  ///
  /// begin
  ///
  /// ListBox1.Items.Clear;
  /// AFile := OpenFileMapping(FILE_MAP_READ, True, AIMPRemoteAccessClass);
  /// try
  /// AInfo := MapViewOfFile(AFile, FILE_MAP_READ, 0, 0, AIMPRemoteAccessMapFileSize);
  /// if AInfo &lt;&gt; nil then
  /// try
  /// if AInfo &lt;&gt; nil  then
  /// begin
  /// ABuffer := Pointer(DWORD(AInfo) + SizeOf(TAIMPFileInfo));
  /// Listbox.Items.Add(Format('%d Hz, %d kbps, %d chans', [AInfo^.SampleRate, AInfo^.BitRate, AInfo^.Channels]));
  /// Listbox.Items.Add(Format('%d seconds, %d bytes', [AInfo^.Duration div 1000, AInfo^.FileSize]));
  /// Listbox.Items.Add('Album: ' + ExtractString(ABuffer, AInfo^.AlbumLength));
  /// Listbox.Items.Add('Artist: ' + ExtractString(ABuffer, AInfo^.ArtistLength));
  /// Listbox.Items.Add('Date: ' + ExtractString(ABuffer, AInfo^.DateLength));
  /// Listbox.Items.Add('FileName: ' + ExtractString(ABuffer, AInfo^.FileNameLength));
  /// Listbox.Items.Add('Genre: ' + ExtractString(ABuffer, AInfo^.GenreLength));
  /// Listbox.Items.Add('Title: ' + ExtractString(ABuffer, AInfo^.TitleLength));
  /// end;
  /// finally UnmapViewOfFile(AInfo);
  /// end;
  /// finally
  /// CloseHandle(AFile);
  /// end;
  /// end;</code>
  /// </example>
  /// <seealso cref="TAIMPFileInfo">
  /// TAIMPFileInfo
  /// </seealso>
{$ENDREGION}
  PAIMPFileInfo = ^TAIMPFileInfo;
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// The structure that stores information about the file.
  /// </para>
  /// <para>
  /// Структура, хранящая информацию о файле.
  /// </para>
  /// </summary>
  /// <remarks>
  /// <para>
  /// See demo.
  /// </para>
  /// <para>
  /// Пример использования смотри в демке.
  /// </para>
  /// </remarks>
{$ENDREGION}

  TAIMPFileInfo = packed record
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Size Of TAIMPFileInfo.
    /// </para>
    /// <para>
    /// Размер объекта TAIMPFileInfo.
    /// </para>
    /// </summary>
    /// <remarks>
    /// <note type="delphi">
    /// SizeOf(TAIMPFileInfo)
    /// </note>
    /// </remarks>
{$ENDREGION}
    StructSize: DWORD; // SizeOf(TAIMPFileInfo)
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Track is Active? (True or False)
    /// </para>
    /// <para>
    /// Трек активен?
    /// </para>
    /// </summary>
{$ENDREGION}
    Active: LongBool;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Bitrate.
    /// </para>
    /// <para>
    /// Битрейт.
    /// </para>
    /// </summary>
{$ENDREGION}
    BitRate: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Channels.
    /// </para>
    /// <para>
    /// Каналы.
    /// </para>
    /// </summary>
{$ENDREGION}
    Channels: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Duration of the track.
    /// </para>
    /// <para>
    /// Длительность трека.
    /// </para>
    /// </summary>
{$ENDREGION}
    Duration: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Size of file.
    /// </para>
    /// <para>
    /// Размер файла.
    /// </para>
    /// </summary>
{$ENDREGION}
    FileSize: Int64;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Mark.
    /// </para>
    /// <para>
    /// Метка.
    /// </para>
    /// </summary>
{$ENDREGION}
    Mark: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Sample rate.
    /// </para>
    /// <para>
    /// Частота дискретизации.
    /// </para>
    /// </summary>
{$ENDREGION}
    SampleRate: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Number of track.
    /// </para>
    /// <para>
    /// Номер трека.
    /// </para>
    /// </summary>
{$ENDREGION}
    TrackNumber: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Length of album name.
    /// </para>
    /// <para>
    /// Длина названия альбома.
    /// </para>
    /// </summary>
    /// <seealso cref="Album">
    /// Album
    /// </seealso>
{$ENDREGION}
    AlbumBufferSizeInChars: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Length of artist name of the track.
    /// </para>
    /// <para>
    /// Длина имени исполнителя.
    /// </para>
    /// </summary>
    /// <seealso cref="Artist">
    /// Artist
    /// </seealso>
{$ENDREGION}
    ArtistBufferSizeInChars: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Length of date of the track.
    /// </para>
    /// <para>
    /// Длина даты трека.
    /// </para>
    /// </summary>
    /// <seealso cref="Date">
    /// Date
    /// </seealso>
{$ENDREGION}
    DateBufferSizeInChars: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Length of name file of the track.
    /// </para>
    /// <para>
    /// Длина названия файла трека.
    /// </para>
    /// </summary>
    /// <seealso cref="FileName">
    /// FileName
    /// </seealso>
{$ENDREGION}
    FileNameBufferSizeInChars: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Length of genre of the track.
    /// </para>
    /// <para>
    /// Длина жанра трека.
    /// </para>
    /// </summary>
    /// <seealso cref="Genre">
    /// Genre
    /// </seealso>
{$ENDREGION}
    GenreBufferSizeInChars: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Length of title of track.
    /// </para>
    /// <para>
    /// Длина названия трека.
    /// </para>
    /// </summary>
    /// <seealso cref="Title">
    /// Title
    /// </seealso>
{$ENDREGION}
    TitleBufferSizeInChars: DWORD;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Name of album.
    /// </para>
    /// <para>
    /// Название альбома.
    /// </para>
    /// </summary>
{$ENDREGION}
    AlbumBuffer: PWideChar;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Name of artist.
    /// </para>
    /// <para>
    /// Исполнитель трека.
    /// </para>
    /// </summary>
{$ENDREGION}
    ArtistBuffer: PWideChar;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Date of the track.
    /// </para>
    /// <para>
    /// Дата трека.
    /// </para>
    /// </summary>
{$ENDREGION}
    DateBuffer: PWideChar;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// File name of the track.
    /// </para>
    /// <para>
    /// Имя файла трека.
    /// </para>
    /// </summary>
{$ENDREGION}
    FileNameBuffer: PWideChar;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Genre of the track.
    /// </para>
    /// <para>
    /// Жанр трека.
    /// </para>
    /// </summary>
{$ENDREGION}
    GenreBuffer: PWideChar;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Title of the track.
    /// </para>
    /// <para>
    /// Название трека.
    /// </para>
    /// </summary>
{$ENDREGION}
    TitleBuffer: PWideChar;
  end;

procedure FileInfoClear(AInfo: PAIMPFileInfo);
function FileInfoIsValid(AInfo: PAIMPFileInfo): Boolean;
implementation

procedure FileInfoClearBuffer(ABuffer: PWideChar; ASizeInChars: Integer);
begin
  if ABuffer <> nil then
    ZeroMemory(ABuffer, ASizeInChars * SizeOf(WideChar));
end;

procedure FileInfoClear(AInfo: PAIMPFileInfo);
begin
  if FileInfoIsValid(AInfo) then
  begin
    AInfo.Active := False;
    AInfo.BitRate := 0;
    AInfo.Channels := 0;
    AInfo.Duration := 0;
    AInfo.FileSize := 0;
    AInfo.Mark := 0;
    AInfo.SampleRate := 0;
    AInfo.TrackNumber := 0;

    FileInfoClearBuffer(AInfo.AlbumBuffer, AInfo.AlbumBufferSizeInChars);
    FileInfoClearBuffer(AInfo.ArtistBuffer, AInfo.ArtistBufferSizeInChars);
    FileInfoClearBuffer(AInfo.DateBuffer, AInfo.DateBufferSizeInChars);
    FileInfoClearBuffer(AInfo.FileNameBuffer, AInfo.FileNameBufferSizeInChars);
    FileInfoClearBuffer(AInfo.GenreBuffer, AInfo.GenreBufferSizeInChars);
    FileInfoClearBuffer(AInfo.TitleBuffer, AInfo.TitleBufferSizeInChars);
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

end.
