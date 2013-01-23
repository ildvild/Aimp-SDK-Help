unit AIMPSDKCommon;

{************************************************}
{*                                              *}
{*                AIMP Plugins API              *}
{*             v3.00.960 (01.12.2011)           *}
{*                Common Objects                *}
{*                                              *}
{*              (c) Artem Izmaylov              *}
{*                 www.aimp.ru                  *}
{*             Mail: artem@aimp.ru              *}
{*              ICQ: 345-908-513                *}
{*                                              *}
{************************************************}

interface

uses
  Windows;

type

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  <para>
  ///	    A pointer to the structure TAIMPFileInfo.
  ///	  </para>
  ///	  <para>
  ///	    Указатель на структуру TAIMPFileInfo.
  ///	  </para>
  ///	</summary>
  ///	<remarks>
  ///	  <para>
  ///	    See Remote demo.
  ///	  </para>
  ///	  <para>
  ///	    Пример использования смотри в демке Remote.
  ///	  </para>
  ///	</remarks>
  ///	<example>
  ///	  <code lang="Delphi">
  ///	procedure TForm.RefreshTrackInfo;
  ///	 function ExtractString(var B: PByte; ALength: Integer): WideString;
  ///	 begin
  ///	 SetString(Result, PWideChar(B), ALength);
  ///	 Inc(B, SizeOf(WideChar) * ALength);
  ///	 end;
  ///
  ///	var
  ///	ABuffer: PByte;
  ///	AFile: Cardinal;
  ///	AInfo: PAIMPFileInfo;
  ///
  ///	begin
  ///
  ///	ListBox1.Items.Clear;
  ///	AFile := OpenFileMapping(FILE_MAP_READ, True, AIMPRemoteAccessClass);
  ///	try
  ///	 AInfo := MapViewOfFile(AFile, FILE_MAP_READ, 0, 0, AIMPRemoteAccessMapFileSize);
  ///	 if AInfo &lt;&gt; nil then
  ///	 try
  ///	 if AInfo &lt;&gt; nil  then
  ///	  begin
  ///	  ABuffer := Pointer(DWORD(AInfo) + SizeOf(TAIMPFileInfo));
  ///	  Listbox.Items.Add(Format('%d Hz, %d kbps, %d chans', [AInfo^.SampleRate, AInfo^.BitRate, AInfo^.Channels]));
  ///	  Listbox.Items.Add(Format('%d seconds, %d bytes', [AInfo^.Duration div 1000, AInfo^.FileSize]));
  ///	  Listbox.Items.Add('Album: ' + ExtractString(ABuffer, AInfo^.AlbumLength));
  ///	  Listbox.Items.Add('Artist: ' + ExtractString(ABuffer, AInfo^.ArtistLength));
  ///	  Listbox.Items.Add('Date: ' + ExtractString(ABuffer, AInfo^.DateLength));
  ///	  Listbox.Items.Add('FileName: ' + ExtractString(ABuffer, AInfo^.FileNameLength));
  ///	  Listbox.Items.Add('Genre: ' + ExtractString(ABuffer, AInfo^.GenreLength));
  ///	  Listbox.Items.Add('Title: ' + ExtractString(ABuffer, AInfo^.TitleLength));
  ///	  end;
  ///	 finally UnmapViewOfFile(AInfo);
  ///	 end;
  ///	finally
  ///	CloseHandle(AFile);
  ///	end;
  ///	end;</code>
  ///	</example>
  ///	<seealso cref="TAIMPFileInfo">
  ///	  TAIMPFileInfo
  ///	</seealso>
  {$ENDREGION}
  PAIMPFileInfo = ^TAIMPFileInfo;

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  <para>
  ///	    The structure that stores information about the file.
  ///	  </para>
  ///	  <para>
  ///	    Структура, хранящая информацию о файле.
  ///	  </para>
  ///	</summary>
  ///	<remarks>
  ///	  <para>
  ///	    See Remote demo.
  ///	  </para>
  ///	  <para>
  ///	    Пример использования смотри в демке Remote.
  ///	  </para>
  ///	</remarks>
  {$ENDREGION}
  TAIMPFileInfo = packed record

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Size Of TAIMPFileInfo.
    ///	  </para>
    ///	  <para>
    ///	    Размер структуры TAIMPFileInfo.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    StructSize: DWORD; // SizeOf(TAIMPFileInfo)
    //

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Active?
    ///	  </para>
    ///	  <para>
    ///	    Активный?
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Active: LongBool;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    BitRate.
    ///	  </para>
    ///	  <para>
    ///	    Битрейт.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    BitRate: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Channels.
    ///	  </para>
    ///	  <para>
    ///	    Каналы.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Channels: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Duration.
    ///	  </para>
    ///	  <para>
    ///	    Длительность.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Duration: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Size of File.
    ///	  </para>
    ///	  <para>
    ///	    Размер файла.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    FileSize: Int64;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Mark.
    ///	  </para>
    ///	  <para>
    ///	    Метка.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Mark: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  SampleRate. 
	///   Частота дискретизации.
    ///	</summary>
    {$ENDREGION}
    SampleRate: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Number of Track.
    ///	  </para>
    ///	  <para>
    ///	    Номер трека.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    TrackNumber: DWORD;
    //

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Length of Name Album.
    ///	  </para>
    ///	  <para>
    ///	    Размер названия альбома.
    ///	  </para>
    ///	</summary>
    ///	<seealso cref="Album">
    ///	  Album
    ///	</seealso>
    {$ENDREGION}
    AlbumLength: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Length of Name Artist.
    ///	  </para>
    ///	  <para>
    ///	    Размер имени артиста.
    ///	  </para>
    ///	</summary>
    ///	<seealso cref="Artist">
    ///	  Artist
    ///	</seealso>
    {$ENDREGION}
    ArtistLength: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Length of Date.
    ///	  </para>
    ///	  <para>
    ///	    Размер даты.
    ///	  </para>
    ///	</summary>
    ///	<seealso cref="Date">
    ///	  Date
    ///	</seealso>
    {$ENDREGION}
    DateLength: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Length of File Name.
    ///	  </para>
    ///	  <para>
    ///	    Размер имени файла.
    ///	  </para>
    ///	</summary>
    ///	<seealso cref="FileName">
    ///	  FileName
    ///	</seealso>
    {$ENDREGION}
    FileNameLength: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Length of genre.
    ///	  </para>
    ///	  <para>
    ///	    Размер жанра.
    ///	  </para>
    ///	</summary>
    ///	<seealso cref="Genre">
    ///	  Genre
    ///	</seealso>
    {$ENDREGION}
    GenreLength: DWORD;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Length of title.
    ///	  </para>
    ///	  <para>
    ///	    Длига заголовка.
    ///	  </para>
    ///	</summary>
    ///	<seealso cref="Title">
    ///	  Title
    ///	</seealso>
    {$ENDREGION}
    TitleLength: DWORD;
    //

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Album name.
    ///	  </para>
    ///	  <para>
    ///	    Название альбома.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Album: PWideChar;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Artist.
    ///	  </para>
    ///	  <para>
    ///	    Имя артиста.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Artist: PWideChar;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Date.
    ///	  </para>
    ///	  <para>
    ///	    Дата.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Date: PWideChar;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    File name.
    ///	  </para>
    ///	  <para>
    ///	    Имя файла.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    FileName: PWideChar;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Genre.
    ///	  </para>
    ///	  <para>
    ///	    Жанр.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Genre: PWideChar;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Title.
    ///	  </para>
    ///	  <para>
    ///	    Заголовок файла.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    Title: PWideChar;
  end;

implementation

end.
