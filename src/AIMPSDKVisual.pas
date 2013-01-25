{$REGION 'Documentation'}
/// <summary>
/// <para>
/// The module that contains the objects that implement the visualization.
/// </para>
/// <para>
/// Модуль, содержащий классы и струкуры, реализующие визуализацию.
/// </para>
/// </summary>
/// <remarks>
/// <para>
/// Export function name: <c>AIMP_QueryVisual3.</c>
/// </para>
/// <para>
/// See Visual demo.
/// </para>
/// <para>
/// Название экспортируемой функции: <c>AIMP_QueryVisual3.</c>
/// </para>
/// <para>
/// Смотри пример реализации в демке Visual.
/// </para>
/// </remarks>
/// <example>
/// <code lang="Delphi">
/// library AIMPVisualDemo;
///
/// uses
/// AIMPVisualDemoMain in 'AIMPVisualDemoMain.pas';
///
/// function AIMP_QueryVisual3(out AHeader: IAIMPVisualPlugin3): LongBool; stdcall;
/// begin
/// AHeader := TAIMPVisualPlugin.Create;
/// Result := True;
/// end;
///
/// exports
/// AIMP_QueryVisual3;
///
/// begin
/// end.</code>
/// </example>
{$ENDREGION}
unit AIMPSDKVisual;

{ ************************************************ }
{ *                                              * }
{ *                AIMP Plugins API              * }
{ *             v3.00.960 (01.12.2011)           * }
{ *                 Visual Plugins               * }
{ *                                              * }
{ *              (c) Artem Izmaylov              * }
{ *                 www.aimp.ru                  * }
{ *             Mail: artem@aimp.ru              * }
{ *              ICQ: 345-908-513                * }
{ *                                              * }
{ ************************************************ }

interface

uses
  Windows, AIMPSDKCore;

const
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Flag for IAIMPVisualPlugin3.GetPluginFlags. His defines the data for
  /// wave visualization.
  /// </para>
  /// <para>
  /// Флаг для IAIMPVisualPlugin3.GetPluginFlags. Опредеделяет данные для
  /// визуализации типа волна.
  /// </para>
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// function TAIMPVisualPlugin.GetPluginFlags: DWORD;
  /// begin
  /// Result := AIMP_VISUAL_FLAGS_RQD_DATA_WAVE;
  /// end;</code>
  /// </example>
{$ENDREGION}
  AIMP_VISUAL_FLAGS_RQD_DATA_WAVE = 1;
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Flag for IAIMPVisualPlugin3.GetPluginFlags. His defines the data for
  /// spectrum visualization.
  /// </para>
  /// <para>
  /// Флаг для IAIMPVisualPlugin3.GetPluginFlags. Опредеделяет данные для
  /// визуализации типа спектр.
  /// </para>
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// function TAIMPVisualPlugin.GetPluginFlags: DWORD;
  /// begin
  /// Result := AIMP_VISUAL_FLAGS_RQD_DATA_SPECTRUM;
  /// end;</code>
  /// </example>
{$ENDREGION}
  AIMP_VISUAL_FLAGS_RQD_DATA_SPECTRUM = 2;
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Flag for IAIMPVisualPlugin3.GetPluginFlags.
  /// </para>
  /// <para>
  /// Флаг для IAIMPVisualPlugin3.GetPluginFlags.
  /// </para>
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// function TAIMPVisualPlugin.GetPluginFlags: DWORD;
  /// begin
  /// Result := AIMP_VISUAL_FLAGS_NOT_SUSPEND;
  /// end;</code>
  /// </example>
{$ENDREGION}
  AIMP_VISUAL_FLAGS_NOT_SUSPEND = 4;

type
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Array of wave's data.
  /// </para>
  /// <para>
  /// Массив, содержащий значения для волны: 2 канала по 512 значений.
  /// </para>
  /// </summary>
{$ENDREGION}
  TWaveForm = array [0 .. 1, 0 .. 511] of ShortInt;
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Array of spectrum's data.
  /// </para>
  /// <para>
  /// Массив, содержащий значения для спектра: 2 канала по 256 значений.
  /// </para>
  /// </summary>
{$ENDREGION}
  TSpectrum = array [0 .. 1, 0 .. 255] of Byte;
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Pointer on TAIMPVisualData's structure.
  /// </para>
  /// <para>
  /// Указатель на структуру TAIMPVisualData.
  /// </para>
  /// </summary>
  /// <seealso cref="TAIMPVisualData">
  /// TAIMPVisualData
  /// </seealso>
{$ENDREGION}
  PAIMPVisualData = ^TAIMPVisualData;
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// The structure which contains Visualization data.
  /// </para>
  /// <para>
  /// Структура, которая содержит данные для визуализации(уровни, данные
  /// для спектра и волны)
  /// </para>
  /// </summary>
  /// <example>
  /// <para>
  /// See Aimp Visual Demo.
  /// </para>
  /// <para>
  /// Пример смотри в демке.
  /// </para>
  /// </example>
{$ENDREGION}

  TAIMPVisualData = packed record
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Value of right level.
    /// </para>
    /// <para>
    /// Значение правого уровня.<br />
    /// </para>
    /// </summary>
{$ENDREGION}
    LevelR: Integer;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Value of left level.
    /// </para>
    /// <para>
    /// Значение левого уровня.<br />
    /// </para>
    /// </summary>
{$ENDREGION}
    LevelL: Integer;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Array for  spectrum's data.
    /// </para>
    /// <para>
    /// Массив, содержащий значения для спектра.
    /// </para>
    /// </summary>
{$ENDREGION}
    Spectrum: TSpectrum;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Array for  wave's data.
    /// </para>
    /// <para>
    /// Массив, содержащий значения для волны.
    /// </para>
    /// </summary>
{$ENDREGION}
    WaveForm: TWaveForm;
  end;

  { IAIMPVisualPlugin3 }
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// The main interface, which implements the visualization.
  /// </para>
  /// <para>
  /// Основной интерфейс, реализующий визуализацию.
  /// </para>
  /// </summary>
  /// <remarks>
  /// <para>
  /// Must be implemented by visualization.
  /// </para>
  /// <para>
  /// Должен быть реализован визуализацией.
  /// </para>
  /// </remarks>
{$ENDREGION}

  IAIMPVisualPlugin3 = interface(IUnknown)
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Returns the name of the author of the visualization.
    /// </para>
    /// <para>
    /// Возвращает имя автора визуализации.
    /// </para>
    /// </summary>
    /// <example>
    /// <code lang="Delphi">
    /// function TAIMPVisualPlugin.GetPluginAuthor: PWideChar;
    /// begin
    /// Result := 'Artem Izmaylov';
    /// end;</code>
    /// </example>
{$ENDREGION}
    function GetPluginAuthor: PWideChar; stdcall;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Returns information about the visualization.
    /// </para>
    /// <para>
    /// Возвращает информацию о визуализации.
    /// </para>
    /// </summary>
    /// <example>
    /// <code lang="Delphi">
    /// function TAIMPVisualPlugin.GetPluginAuthor: PWideChar;
    /// begin
    /// Result := 'Artem Izmaylov';
    /// end;</code>
    /// </example>
{$ENDREGION}
    function GetPluginInfo: PWideChar; stdcall;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Returns the name of the visualization.
    /// </para>
    /// <para>
    /// Возвращает имя визуализации.
    /// </para>
    /// </summary>
    /// <example>
    /// <code lang="Delphi">
    /// function TAIMPVisualPlugin.GetPluginName: PWideChar;
    /// begin
    /// Result := 'The Visual Plugin';
    /// end;</code>
    /// </example>
{$ENDREGION}
    function GetPluginName: PWideChar; stdcall;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Sets the used flags.
    /// </para>
    /// <para>
    /// Задает используемые флаги.
    /// </para>
    /// </summary>
    /// <remarks>
    /// <para>
    /// See AIMP_VISUAL_FLAGS_XXX.
    /// </para>
    /// <para>
    /// Смотри AIMP_VISUAL_FLAGS_XXX.
    /// </para>
    /// <para>
    /// <see cref="AIMP_VISUAL_FLAGS_RQD_DATA_WAVE" />
    /// </para>
    /// <para>
    /// <see cref="AIMP_VISUAL_FLAGS_RQD_DATA_SPECTRUM" />
    /// </para>
    /// <para>
    /// <see cref="AIMP_VISUAL_FLAGS_NOT_SUSPEND" />
    /// </para>
    /// </remarks>
    /// <example>
    /// <code lang="Delphi">
    /// function TAIMPVisualPlugin.GetPluginFlags: DWORD;
    /// begin
    /// Result := AIMP_VISUAL_FLAGS_RQD_DATA_WAVE;
    /// end;</code>
    /// </example>
    /// <seealso cref="AIMP_VISUAL_FLAGS_RQD_DATA_WAVE">
    /// AIMP_VISUAL_FLAGS_RQD_DATA_WAVE
    /// </seealso>
    /// <seealso cref="AIMP_VISUAL_FLAGS_RQD_DATA_SPECTRUM">
    /// AIMP_VISUAL_FLAGS_RQD_DATA_SPECTRUM
    /// </seealso>
    /// <seealso cref="AIMP_VISUAL_FLAGS_NOT_SUSPEND">
    /// AIMP_VISUAL_FLAGS_NOT_SUSPEND
    /// </seealso>
{$ENDREGION}
    function GetPluginFlags: DWORD; stdcall; // See AIMP_VISUAL_FLAGS_XXX
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Initialize of the visualization.
    /// </para>
    /// <para>
    /// Инициализация визуализации.
    /// </para>
    /// </summary>
    /// <example>
    /// <code lang="Delphi">
    /// function TAIMPVisualPlugin.Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT;
    /// begin
    /// FWaveLinePen := CreatePen(PS_SOLID, 1, $FFFFFF);
    /// Result := S_OK;
    /// end;  </code>
    /// </example>
{$ENDREGION}
    function Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT; stdcall;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Finalize of the visualization.
    /// </para>
    /// <para>
    /// Завершение визуализации.
    /// </para>
    /// </summary>
    /// <example>
    /// <code lang="Delphi">
    /// function TAIMPVisualPlugin.Finalize: HRESULT;
    /// begin
    /// DeleteObject(WaveLinePen);
    /// Result := S_OK;
    /// end;</code>
    /// </example>
{$ENDREGION}
    function Finalize: HRESULT; stdcall;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// The event is called when the Onclick event.
    /// </para>
    /// <para>
    /// Событие, возникающее при клику по окну визуализации.
    /// </para>
    /// </summary>
    /// <param name="X">
    /// <para>
    /// Coordinate X.
    /// </para>
    /// <para>
    /// Координата X, где произошел клик.
    /// </para>
    /// </param>
    /// <param name="Y">
    /// <para>
    /// Coordinate Y.
    /// </para>
    /// <para>
    /// Координата Y, где произошел клик.
    /// </para>
    /// </param>
    /// <example>
    /// <code lang="Delphi">
    /// procedure TAIMPVisualPlugin.DisplayClick(X, Y: Integer);
    /// begin
    /// DeleteObject(WaveLinePen);
    /// FWaveLinePen := CreatePen(PS_SOLID, 1, random($fffff));
    /// end; </code>
    /// </example>
{$ENDREGION}
    procedure DisplayClick(X, Y: Integer); stdcall;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// Display render.
    /// </para>
    /// <para>
    /// Отображение визуализации.
    /// </para>
    /// </summary>
    /// <param name="DC">
    /// <para>
    /// Handle of visualization's display.
    /// </para>
    /// <para>
    /// Хендл окна визуализации.
    /// </para>
    /// </param>
    /// <param name="AData">
    /// <para>
    /// The pointer on TAIMPVisualData.
    /// </para>
    /// <para>
    /// Указатель на структуру TAIMPVisualData.
    /// </para>
    /// </param>
    /// <example>
    /// <code lang="Delphi">
    /// procedure TAIMPVisualPlugin.DisplayRender(DC: HDC; AData: PAIMPVisualData);
    /// var
    /// APrevObject: HGDIOBJ;
    /// ASaveIndex: Integer;
    /// I, ADisplayMiddleY, AChannelHeight: Integer;
    /// begin
    /// FillRect(DC, Rect(0, 0, DisplaySize.cx, DisplaySize.cy), GetStockObject(BLACK_BRUSH));
    ///
    /// ASaveIndex := SaveDC(DC);
    /// try
    /// IntersectClipRect(DC, 0, 0, DisplaySize.cx, DisplaySize.cy);
    /// APrevObject := SelectObject(DC, WaveLinePen);
    /// try
    /// AChannelHeight := DisplaySize.cy div 4;
    ///
    /// // Draw Left Channel
    /// ADisplayMiddleY := DisplaySize.cy div 4;
    /// MoveToEx(DC, -IntervalBetweenValues, ADisplayMiddleY, nil);
    /// for I := 0 to 511 do
    /// begin
    /// LineTo(DC, I * IntervalBetweenValues, ADisplayMiddleY +
    /// MulDiv(AData^.WaveForm[0, I], AChannelHeight, MAXCHAR {127}));
    /// end;
    ///
    /// // Draw Right Channel
    /// ADisplayMiddleY := MulDiv(DisplaySize.cy, 3, 4);
    /// MoveToEx(DC, -IntervalBetweenValues, ADisplayMiddleY, nil);
    /// for I := 0 to 511 do
    /// begin
    /// LineTo(DC, I * IntervalBetweenValues, ADisplayMiddleY +
    /// MulDiv(AData^.WaveForm[1, I], AChannelHeight, MAXCHAR {127}));
    /// end;
    /// finally
    /// SelectObject(DC, APrevObject);
    /// end;
    /// finally
    /// RestoreDC(DC, ASaveIndex);
    /// end;
    /// end;  </code>
    /// </example>
    /// <seealso cref="TAIMPVisualData">
    /// TAIMPVisualData
    /// </seealso>
{$ENDREGION}
    procedure DisplayRender(DC: HDC; AData: PAIMPVisualData); stdcall;
{$REGION 'Documentation'}
    /// <summary>
    /// <para>
    /// The event is called when the visualization's display resize.
    /// </para>
    /// <para>
    /// Событие, возникающее при изменении размера окна визуализации.
    /// </para>
    /// </summary>
    /// <param name="AWidth">
    /// <para>
    /// Width of display.
    /// </para>
    /// <para>
    /// Ширина окна визуализации.
    /// </para>
    /// </param>
    /// <param name="AHeight">
    /// <para>
    /// Height of display.
    /// </para>
    /// <para>
    /// Высота окна визуализации.
    /// </para>
    /// </param>
    /// <example>
    /// <code lang="Delphi">
    /// procedure TAIMPVisualPlugin.DisplayResize(AWidth, AHeight: Integer);
    /// begin
    /// FDisplaySize.cx := AWidth;
    /// FDisplaySize.cy := AHeight;
    ///
    /// // 512 Wave Points, refer to TWaveForm structure declared in AIMPSDKVisual
    /// FIntervalBetweenValues := Round(AWidth / 512 + 0.5);
    /// end;
    /// </code>
    /// </example>
{$ENDREGION}
    procedure DisplayResize(AWidth, AHeight: Integer); stdcall;
  end;
{$REGION 'Documentation'}
  /// <summary>
  /// The export function.
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// function AIMP_QueryVisual3(out AHeader: IAIMPVisualPlugin3): LongBool; stdcall;
  /// begin
  /// AHeader := TAIMPVisualPlugin.Create;
  /// Result := True;
  /// end;</code>
  /// </example>
{$ENDREGION}

  TAIMPVisualPluginProc = function(out AHeader: IAIMPVisualPlugin3): LongBool;
    stdcall;

implementation

end.
