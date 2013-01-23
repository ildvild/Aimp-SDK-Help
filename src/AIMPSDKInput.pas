
{$REGION 'Documentation'}
///	<summary>
///	  <para>
///	    The module that contains the objects that implement the Input plugins.
///	  </para>
///	  <para>
///	    Модуль, содержащий объекты, реализующие Input плагины.
///	  </para>
///	</summary>
///	<remarks>
///	  <para>
///	    Export function name: AIMP_QueryInput.
///	  </para>
///	  <para>
///	    Название экспортируемой функции: AIMP_QueryInput.
///	  </para>
///	</remarks>
{$ENDREGION}
unit AIMPSDKInput;

{************************************************}
{*                                              *}
{*                AIMP Plugins API              *}
{*             v3.00.960 (01.12.2011)           *}
{*                 Input Plugins                *}
{*                                              *}
{*              (c) Artem Izmaylov              *}
{*                 www.aimp.ru                  *}
{*             Mail: artem@aimp.ru              *}
{*              ICQ: 345-908-513                *}
{*                                              *}
{************************************************}

interface

uses
  Windows, AIMPSDKCommon;

const
  AIMP_INPUT_BITDEPTH_08BIT      = 1;
  AIMP_INPUT_BITDEPTH_16BIT      = 2;
  AIMP_INPUT_BITDEPTH_24BIT      = 3;
  AIMP_INPUT_BITDEPTH_32BIT      = 4;
  AIMP_INPUT_BITDEPTH_32BITFLOAT = 5;
  AIMP_INPUT_BITDEPTH_64BITFLOAT = 6;

  AIMP_INPUT_FLAG_FILE           = 1; // IAIMPInputHeader.CreateDecoder supports
  AIMP_INPUT_FLAG_ISTREAM        = 2; // IAIMPInputHeader.CreateDecoderEx supports

const
  SID_IAIMPInputStream        = '{41494D50-0033-494E-0000-000000000010}';
  SID_IAIMPInputPluginDecoder = '{41494D50-0033-494E-0000-000000000020}';

  IID_IAIMPInputStream: TGUID = SID_IAIMPInputStream;
  IID_IAIMPInputPluginDecoder: TGUID = SID_IAIMPInputPluginDecoder;

type

  { IAIMPInputStream }

  IAIMPInputStream = interface(IUnknown)
  [SID_IAIMPInputStream]

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Get size of Stream.
    ///	  </para>
    ///	  <para>
    ///	    Получить размер потока.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function GetSize: Int64; stdcall;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Get position of Stream.
    ///	  </para>
    ///	  <para>
    ///	    Получить позицию потока.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function GetPosition: Int64; stdcall;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Set position of Stream.
    ///	  </para>
    ///	  <para>
    ///	    Установить позицию потока.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function SetPosition(const AValue: Int64): Int64; stdcall;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Read data from stream.
    ///	  </para>
    ///	  <para>
    ///	    Считать данные из потока.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function ReadData(Buffer: PByte; Size: Integer): Integer; stdcall;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Skip ABytes in stream.
    ///	  </para>
    ///	  <para>
    ///	    Пропустить ABytes в потоке.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function Skip(const ABytes: Int64): Int64; stdcall;
  end;

  { IAIMPInputPluginDecoder }

  IAIMPInputPluginDecoder = interface(IUnknown)
  [SID_IAIMPInputPluginDecoder]
    // Read Info about stream, ABitDepth: See AIMP_INPUT_BITDEPTH_XXX flags

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Read Info about stream.
    ///	  </para>
    ///	  <para>
    ///	    Читает инфу о потоке.
    ///	  </para>
    ///	</summary>
    ///	<remarks>
    ///	  <para>
    ///	    See AIMP_INPUT_BITDEPTH_XXX flags.
    ///	  </para>
    ///	  <para>
    ///	    Смотри флаги AIMP_INPUT_BITDEPTH_XXX.
    ///	  </para>
    ///	</remarks>
    ///	<seealso cref="AIMP_INPUT_BITDEPTH_08BIT">
    ///	  AIMP_INPUT_BITDEPTH_08BIT
    ///	</seealso>
    ///	<seealso cref="AIMP_INPUT_BITDEPTH_16BIT">
    ///	  AIMP_INPUT_BITDEPTH_16BIT
    ///	</seealso>
    ///	<seealso cref="AIMP_INPUT_BITDEPTH_24BIT">
    ///	  AIMP_INPUT_BITDEPTH_24BIT
    ///	</seealso>
    ///	<seealso cref="AIMP_INPUT_BITDEPTH_32BIT">
    ///	  AIMP_INPUT_BITDEPTH_32BIT
    ///	</seealso>
    ///	<seealso cref="AIMP_INPUT_BITDEPTH_32BITFLOAT">
    ///	  AIMP_INPUT_BITDEPTH_32BITFLOAT
    ///	</seealso>
    ///	<seealso cref="AIMP_INPUT_BITDEPTH_64BITFLOAT">
    ///	  AIMP_INPUT_BITDEPTH_64BITFLOAT
    ///	</seealso>
    {$ENDREGION}
    function DecoderGetInfo(out ASampleRate, AChannels, ABitDepth: Integer): LongBool; stdcall;

    // Uncompressed stream position in Bytes

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    The position of the uncompressed stream in bytes.
    ///	  </para>
    ///	  <para>
    ///	    Позиция несжатого потока в байтах.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function DecoderGetPosition: Int64; stdcall;

    // Uncompressed stream size in Bytes

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    The size of the uncompressed stream in bytes.
    ///	  </para>
    ///	  <para>
    ///	    Размер несжатого потока в байтах.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function DecoderGetSize: Int64; stdcall;

    // Read Info about the file

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Reading the information on file.
    ///	  </para>
    ///	  <para>
    ///	    Чтение информации об файле.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function DecoderGetTags(AFileInfo: PAIMPFileInfo): LongBool; stdcall;

    // Size of Buffer in Bytes

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Read a size of Buffer in Bytes.
    ///	  </para>
    ///	  <para>
    ///	    Чтение размера Буфера в Байтах.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function DecoderRead(Buffer: PByte; Size: Integer): Integer; stdcall;

    // Uncompressed stream position in Bytes

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Position of Uncompressed stream in Bytes.
    ///	  </para>
    ///	  <para>
    ///	    Позиция несжатого потока в Байтах.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function DecoderSetPosition(const AValue: Int64): LongBool; stdcall;
    // Is DecoderSetPosition supports?

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Is DecoderSetPosition supports?
    ///	  </para>
    ///	  <para>
    ///	   Поддерживается ли DecoderSetPosition?
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function DecoderIsSeekable: LongBool; stdcall;
    // Is speed, tempo and etc supports?
    // RealTime streams doesn't supports speed control
    function DecoderIsRealTimeStream: LongBool; stdcall;
    // Return format type for current file, (MP3, OGG, AAC+, FLAC and etc)

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Return format type for current file, (MP3, OGG, AAC+, FLAC and etc).
    ///	  </para>
    ///	  <para>
    ///	    Возвращает формат текущего файла.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function DecoderGetFormatType: PWideChar; stdcall;
  end;

  { IAIMPInputPluginHeader }

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  <para>
  ///	    Interface that implements the getting information about the plugin.
  ///	  </para>
  ///	  <para>
  ///	    Интерфейс, реализующий получение информации об плагине.
  ///	  </para>
  ///	</summary>
  {$ENDREGION}
  IAIMPInputPluginHeader = interface(IUnknown)

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Returns the name of the author of the plugin.
    ///	  </para>
    ///	  <para>
    ///	    Возвращает имя автора плагина.
    ///	  </para>
    ///	</summary>
    ///	<example>
    ///	  <code lang="Delphi">
    ///	 function TAIMPInputPlugin.GetPluginAuthor: PWideChar;
    ///	 begin
    ///	   Result := 'Artem Izmaylov';
    ///	 end;</code>
    ///	</example>
    {$ENDREGION}
    function GetPluginAuthor: PWideChar; stdcall;

    {$REGION 'Documentation'}
      ///	<summary>
    ///	  <para>
    ///	    Returns information about the plugin.
    ///	  </para>
    ///	  <para>
    ///	    Возвращает информацию о плагине.
    ///	  </para>
    ///	</summary>
    ///	<example>
    ///	  <code lang="Delphi">
    ///	 function TAIMPInputPlugin.GetPluginAuthor: PWideChar;
    ///	 begin
    ///	   Result := 'Artem Izmaylov';
    ///	 end;</code>
    ///	</example>
    {$ENDREGION}
    function GetPluginInfo: PWideChar; stdcall;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///     Returns the name of the plugin.
    ///	  </para>
    ///	  <para>
    ///	    Возвращает имя плагина.
    ///	  </para>
    ///	</summary>
    ///	<example>
    ///	  <code lang="Delphi">
    ///	 function TInputPlugin.GetPluginName: PWideChar;
    ///	 begin
    ///	   Result := 'The Visual Plugin';
    ///	 end;</code>
    ///	</example>
    {$ENDREGION}
    function GetPluginName: PWideChar; stdcall;

    // Combination of the flags, See AIMP_INPUT_FLAG_XXX

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Sets the used flags.
    ///	  </para>
    ///	  <para>
    ///	    Задает используемые флаги.
    ///	  </para>
    ///	</summary>
    ///	<remarks>
    ///	  <para>
    ///	    See AIMP_INPUT_FLAG_XXX
    ///	  </para>
    ///	  <para>
    ///	    Смотри AIMP_INPUT_FLAG_XXX.
    ///	  </para>
    ///	</remarks>
    ///	<example>
    ///	  <code lang="Delphi">
    ///	function TAIMPInputPlugin.GetPluginFlags: DWORD;
    ///	begin
    ///	  Result := AIMP_INPUT_FLAG_FILE;
    ///	end;</code>
    ///	</example>
    ///	<seealso cref="AIMP_INPUT_FLAG_FILE">
    ///	  AIMP_INPUT_FLAG_FILE
    ///	</seealso>
    ///	<seealso cref="AIMP_INPUT_FLAG_ISTREAM">
    ///	  AIMP_INPUT_FLAG_ISTREAM
    ///	</seealso>
    {$ENDREGION}
    function GetPluginFlags: DWORD; stdcall;
    // Initialize / Finalize Plugin

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Initialization of the plugin.
    ///	  </para>
    ///	  <para>
    ///	    Инициализация плагина.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function Initialize: LongBool; stdcall;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Finalization of the visualization.
    ///	  </para>
    ///	  <para>
    ///	    Завершение визуализации.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function Finalize: LongBool; stdcall;
    // Create decoder for the file / Stream

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Creation of a decoder for the File / Stream.
    ///	  </para>
    ///	  <para>
    ///	    Создание декодера для Файла / Потока.
    ///	  </para>
    ///	</summary>
    ///	<seealso cref="CreateDecoderEx">
    ///	  CreateDecoderEx
    ///	</seealso>
    {$ENDREGION}
    function CreateDecoder(AFileName: PWideChar; out ADecoder: IAIMPInputPluginDecoder): LongBool; stdcall;

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Creation of a decoder for the File / Stream.
    ///	  </para>
    ///	  <para>
    ///	    Создание декодера для Файла / Потока.
    ///	  </para>
    ///	</summary>
    ///	<seealso cref="CreateDecoder">
    ///	  CreateDecoder
    ///	</seealso>
    {$ENDREGION}
    function CreateDecoderEx(AStream: IAIMPInputStream; out ADecoder: IAIMPInputPluginDecoder): LongBool; stdcall;
    // Get FileInfo

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Geting Info about File.
    ///	  </para>
    ///	  <para>
    ///	    Получение информации о файле.
    ///	  </para>
    ///	</summary>
    {$ENDREGION}
    function GetFileInfo(AFileName: PWideChar; AFileInfo: PAIMPFileInfo): LongBool; stdcall;
    // Return string format: "My Custom Format1|*.fmt1;*.fmt2;|"

    {$REGION 'Documentation'}
    ///	<summary>
    ///	  <para>
    ///	    Returns a list of the supported formats.
    ///	  </para>
    ///	  <para>
    ///	    Возвращает список поддерживаемых форматов.
    ///	  </para>
    ///	</summary>
    ///	<remarks>
    ///	  <para>
    ///	    Return string format: "My Custom Format1|*.fmt1;*.fmt2;|".
    ///	  </para>
    ///	  <para>
    ///	    Возвращает строку формата : "My Custom Format1|*.fmt1;*.fmt2;|".
    ///	  </para>
    ///	</remarks>
    {$ENDREGION}
    function GetSupportsFormats: PWideChar; stdcall;
  end;

  TAIMPInputPluginHeaderProc = function (out AHeader: IAIMPInputPluginHeader): LongBool; stdcall;
  // Export function name: AIMP_QueryInput

implementation

end.
