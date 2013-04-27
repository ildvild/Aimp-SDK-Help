{$REGION 'Documentation'}
/// <summary>
/// <para>
/// The module that contains the constants that implement the remote control.
/// </para>
/// <para>
/// Модуль, содержащий константы, необходимые для дистанционного управления плеером.
/// </para>
///
/// </summary>
/// <remarks>
/// <para>
/// See Aimp Remote Demo.
/// </para>
/// <para>
/// Смотри пример реализации в демке Aimp Remote Demo.
/// </para>
/// </remarks>
{$ENDREGION}
unit AIMPSDKRemote;

{ ************************************************ }
{ *                                              * }
{ *                AIMP Plugins API              * }
{*             v3.50.1238 (13.03.2013)          *}
{ *                  Remote Access               * }
{ *                                              * }
{ *              (c) Artem Izmaylov              * }
{ *                 www.aimp.ru                  * }
{ *             Mail: artem@aimp.ru              * }
{ *              ICQ: 345-908-513                * }
{ *                                              * }
{ ************************************************ }

interface

uses
  Messages;

const
  AIMPRemoteAccessClass = 'AIMP2_RemoteInfo';
  AIMPRemoteAccessMapFileSize = 2048;

  // Messages, which you can send to window with "AIMPRemoteAccessClass" class
  // You can receive Window Handle via FindWindow function (see MSDN for details)
  WM_AIMP_COMMAND = WM_USER + $75;
  WM_AIMP_NOTIFY = WM_USER + $76;
  WM_AIMP_PROPERTY = WM_USER + $77;

  // See AIMP_RA_CMD_GET_COVER_ART command
  WM_AIMP_COPYDATA_COVER_ID = $41495043;

  // ==============================================================================
  // + How to:
  // GET:  SendMessage(Handle, WM_AIMP_PROPERTY, PropertyID or AIMP_RA_PROPVALUE_GET, 0);
  // SET:  SendMessage(Handle, WM_AIMP_PROPERTY, PropertyID or AIMP_RA_PROPVALUE_SET, NewValue);
  //
  // Receive Change Notification:
  // 1) You should register notification hook using AIMP_RA_CMD_REGISTER_NOTIFY command
  // 2) When property will change you receive WM_AIMP_NOTIFY message with following params:
  // WParam: AIMP_RA_NOTIFY_PROPERTY (Notification ID)
  // LParam: Property ID
  //
  // Properties ID:
  // ==============================================================================

  AIMP_RA_PROPVALUE_GET = 0;
  AIMP_RA_PROPVALUE_SET = 1;

  AIMP_RA_PROPERTY_MASK = $FFFFFFF0;

  // !! ReadOnly
  // Returns player version:
  // HiWord: Version ID (for example: 301 -> v3.01)
  // LoWord: Build Number

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  <para>
  ///	    Returns player version
  ///	  </para>
  ///	  <para>
  ///	    Возвращает информацию о версии плеера.
  ///	  </para>
  ///	</summary>
  ///	<remarks>
  ///	  <para>
  ///	    ReadOnly!!!
  ///	  </para>
  ///	  <para>
  ///	    HiWord: Version ID (Версия плеера)(for example: 301 -&gt; v3.01)
  ///	  </para>
  ///	  <para>
  ///	    LoWord: Build Number (Номер сборки)
  ///	  </para>
  ///	</remarks>
  ///	<example>
  ///	  <code lang="Delphi">
  ///	AVersion := AIMPGetPropertyValue(AIMP_RA_PROPERTY_VERSION);
  ///	Caption := FormatFloat(' 0.00', HiWord(AVersion) / 100) + ' Build ' + IntToStr(LoWord(AVersion));</code>
  ///	</example>
  {$ENDREGION}
  AIMP_RA_PROPERTY_VERSION = $10;

  // GET: Returns current position of now playing track (in msec)
  // SET: LParam: position (in msec)
  AIMP_RA_PROPERTY_PLAYER_POSITION = $20;

  // !! ReadOnly
  // Returns duration of now playing track (in msec)
  AIMP_RA_PROPERTY_PLAYER_DURATION = $30;

  // !! ReadOnly
  // Returns current player state
  // 0 = Stopped
  // 1 = Paused
  // 2 = Playing
{$REGION 'Documentation'}
  /// <summary>
  /// Returns current player state
  /// </summary>
  /// <remarks>
  /// <para>
  /// 0 = Stopped
  /// </para>
  /// <para>
  /// 1 = Paused
  /// </para>
  /// <para>
  /// 2 = Playing
  /// </para>
  /// </remarks>
{$ENDREGION}
  AIMP_RA_PROPERTY_PLAYER_STATE = $40;

  // GET: Return current volume [0..100] (%)
  // SET: LParam: volume [0..100] (%)
  // Returns 0, if fails

  {$REGION 'Documentation'}
  ///	<summary>
  ///	  <para>
  ///	    Methods:<br />GET: Return current volume [0..100] (%)<br />SET(LParam)
  ///	     : Set volume [0..100] (%)
  ///	  </para>
  ///	  <para>
  ///	    Методы:<br />GET: Возвращает текущее значение громкости [0..100] (%)
  ///	    <br />SET(LParam): Устанавливает значение громкости [0..100] (%)
  ///	  </para>
  ///	</summary>
  ///	<remarks>
  ///	  Returns 0, if fails. See AIMP Remote Demo.
  ///	</remarks>
  ///	<example>
  ///	  <code lang="Delphi">
  ///	Get:
  ///	Label.Caption := IntToStr(AIMPGetPropertyValue(AIMP_RA_PROPERTY_VOLUME)) + '%';
  ///
  ///	Set:
  ///	if InputQuery('Current Volume', 'Enter volume (in percent)', S)
  ///	  then AIMPSetPropertyValue(AIMP_RA_PROPERTY_VOLUME, StrToInt(S));</code>
  ///	</example>
  ///	<seealso cref="AIMP_RA_PROPVALUE_GET">
  ///	  AIMP_RA_PROPVALUE_GET
  ///	</seealso>
  ///	<seealso cref="AIMP_RA_PROPVALUE_SET">
  ///	  AIMP_RA_PROPVALUE_SET
  ///	</seealso>
  {$ENDREGION}
  AIMP_RA_PROPERTY_VOLUME = $50;

  // GET: Return current mute state [0..1]
  // SET: LParam: Mute state [0..1]
  // Returns 0, if fails
  AIMP_RA_PROPERTY_MUTE = $60;

  // GET: Return track repeat state [0..1]
  // SET: LParam: Track Repeat state [0..1]
  // Returns 0, if fails
  AIMP_RA_PROPERTY_TRACK_REPEAT = $70;

  // GET: Return shuffle state [0..1]
  // SET: LParam: shuffle state [0..1]
  // Returns 0, if fails
  AIMP_RA_PROPERTY_TRACK_SHUFFLE = $80;

  // GET: Return radio capture state [0..1]
  // SET: LParam: radio capture state [0..1]
  // Returns 0, if fails
  AIMP_RA_PROPERTY_RADIOCAP = $90;

  // ==============================================================================
  // Commands ID for WM_AIMP_COMMAND message: (Command ID must be defined in WParam)
  // ==============================================================================

  AIMP_RA_CMD_BASE = 10;

  // LParam: Window Handle, which will receive WM_AIMP_NOTIFY message from AIMP
  // See description for WM_AIMP_NOTIFY message for details
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Registration notify
  /// </para>
  /// <para>
  /// Регистрация уведомлений
  /// </para>
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.FormCreate(Sender: TObject);
  /// begin
  /// FAIMPWindow := AIMPGetHandle;
  /// if FAIMPWindow = 0 then
  /// begin
  /// MessageDlg('AIMP not running!', mtWarning, [mbOK], 0);
  /// Exit;
  /// end;
  /// // hook notifications
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, AIMP_RA_CMD_REGISTER_NOTIFY, Handle);
  /// end;</code>
  /// </example>
{$ENDREGION}
  AIMP_RA_CMD_REGISTER_NOTIFY = AIMP_RA_CMD_BASE + 1;

  // LParam: Window Handle
  AIMP_RA_CMD_UNREGISTER_NOTIFY = AIMP_RA_CMD_BASE + 2;

  // Start / Resume playback
  // See AIMP_RA_PROPERTY_PLAYER_STATE
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Start / Resume playback
  /// </para>
  /// <para>
  /// Начать / Возобновить воспроизведение
  /// </para>
  /// </summary>
  /// <remarks>
  /// See AIMP_RA_PROPERTY_PLAYER_STATE
  /// </remarks>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_PLAY);
  /// end;
  /// </code>
  /// </example>
  /// <seealso cref="AIMP_RA_PROPERTY_PLAYER_STATE">
  /// AIMP_RA_PROPERTY_PLAYER_STATE
  /// </seealso>
{$ENDREGION}
  AIMP_RA_CMD_PLAY = AIMP_RA_CMD_BASE + 3;

  // Pause / Start playback
  // See AIMP_RA_PROPERTY_PLAYER_STATE
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Pause / Start playback
  /// </para>
  /// <para>
  /// Пауза / Запуск воспроизведения
  /// </para>
  /// </summary>
  /// <remarks>
  /// See AIMP_RA_PROPERTY_PLAYER_STATE
  /// </remarks>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_PLAYPAUSE);
  /// end;
  /// </code>
  /// </example>
  /// <seealso cref="AIMP_RA_PROPERTY_PLAYER_STATE">
  /// AIMP_RA_PROPERTY_PLAYER_STATE
  /// </seealso>
{$ENDREGION}
  AIMP_RA_CMD_PLAYPAUSE = AIMP_RA_CMD_BASE + 4;

  // Pause / Resume playback
  // See AIMP_RA_PROPERTY_PLAYER_STATE
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Pause / Resume playback
  /// </para>
  /// <para>
  /// Пауза / Возобновление воспроизведения
  /// </para>
  /// </summary>
  /// <remarks>
  /// See AIMP_RA_PROPERTY_PLAYER_STATE
  /// </remarks>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_PAUSE);
  /// end;
  /// </code>
  /// </example>
  /// <seealso cref="AIMP_RA_PROPERTY_PLAYER_STATE">
  /// AIMP_RA_PROPERTY_PLAYER_STATE
  /// </seealso>
{$ENDREGION}
  AIMP_RA_CMD_PAUSE = AIMP_RA_CMD_BASE + 5;

  // Stop playback
  // See AIMP_RA_PROPERTY_PLAYER_STATE
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Stop playback
  /// </para>
  /// <para>
  /// Остановка воспроизведения
  /// </para>
  /// </summary>
  /// <remarks>
  /// See AIMP_RA_PROPERTY_PLAYER_STATE
  /// </remarks>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_STOP);
  /// end;
  /// </code>
  /// </example>
  /// <seealso cref="AIMP_RA_PROPERTY_PLAYER_STATE">
  /// AIMP_RA_PROPERTY_PLAYER_STATE
  /// </seealso>
{$ENDREGION}
  AIMP_RA_CMD_STOP = AIMP_RA_CMD_BASE + 6;

  // Next Track
{$REGION 'Documentation'}
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_NEXT);
  /// end;
  /// </code>
  /// </example>
{$ENDREGION}
  AIMP_RA_CMD_NEXT = AIMP_RA_CMD_BASE + 7;

  // Previous Track
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Previous Track
  /// </para>
  /// <para>
  /// Предыдущий трек
  /// </para>
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_PREV);
  /// end;
  /// </code>
  /// </example>
{$ENDREGION}
  AIMP_RA_CMD_PREV = AIMP_RA_CMD_BASE + 8;

  // Next Visualization
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Next Visualization
  /// </para>
  /// <para>
  /// Следующая визуализация
  /// </para>
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_VISUAL_NEXT);
  /// end;
  /// </code>
  /// </example>
{$ENDREGION}
  AIMP_RA_CMD_VISUAL_NEXT = AIMP_RA_CMD_BASE + 9;

  // Previous Visualization
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Previous Visualization
  /// </para>
  /// <para>
  /// Предыдущая визуализация
  /// </para>
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_VISUAL_PREV);
  /// end;
  /// </code>
  /// </example>
{$ENDREGION}
  AIMP_RA_CMD_VISUAL_PREV = AIMP_RA_CMD_BASE + 10;

  // Close the program
{$REGION 'Documentation'}
  /// <summary>
  /// <para>
  /// Close the program
  /// </para>
  /// <para>
  /// Закрыть программу
  /// </para>
  /// </summary>
  /// <example>
  /// <code lang="Delphi">
  /// procedure TForm.AIMPExecuteCommand(ACommand: Integer);
  /// begin
  /// if FAIMPWindow &lt;&gt; 0 then
  /// SendMessage(FAIMPWindow, WM_AIMP_COMMAND, ACommand, 0);
  /// end;
  ///
  /// procedure TForm.ButtonClick(Sender: TObject);
  /// begin
  /// AIMPExecuteCommand(AIMP_RA_CMD_QUIT);
  /// end;
  /// </code>
  /// </example>
{$ENDREGION}
  AIMP_RA_CMD_QUIT = AIMP_RA_CMD_BASE + 11;

  // Execute "Add files" dialog
  AIMP_RA_CMD_ADD_FILES = AIMP_RA_CMD_BASE + 12;

  // Execute "Add folders" dialog
  AIMP_RA_CMD_ADD_FOLDERS = AIMP_RA_CMD_BASE + 13;

  // Execute "Add Playlists" dialog
  AIMP_RA_CMD_ADD_PLAYLISTS = AIMP_RA_CMD_BASE + 14;

  // Execute "Add URL" dialog
  AIMP_RA_CMD_ADD_URL = AIMP_RA_CMD_BASE + 15;

  // Execute "Open Files" dialog
  AIMP_RA_CMD_OPEN_FILES = AIMP_RA_CMD_BASE + 16;

  // Execute "Open Folders" dialog
  AIMP_RA_CMD_OPEN_FOLDERS = AIMP_RA_CMD_BASE + 17;

  // Execute "Open Playlist" dialog
  AIMP_RA_CMD_OPEN_PLAYLISTS = AIMP_RA_CMD_BASE + 18;

  // CoverArt Request
  // LParam: Window Handle, which will process WM_COPYDATA message from AIMP with CoverArt data
  // Result: 0, if player doesn't play anything or cover art unavailable
  //
  // How to use it:
  //
  // 1. You should send request to AIMP
  //
  // SendMessage(AIMPWndHandle, WM_AIMP_COMMAND, AIMP_RA_CMD_GET_COVER_ART, Form1.Handle);
  //
  // 2. And AIMP will answer to you via WM_COPYDATA message:
  //
  // CopyDataStruct.dwData: SyncWord - must be WM_AIMP_COPYDATA_COVER_ID
  // CopyDataStruct.lpData: Pointer to Image Data (in PNG format)
  // CopyDataStruct.cbData: Size Of Image Data (in bytes)
  //
  // procedure TForm1.WMCopyData(var Message: TWMCopyData);
  // var
  // AImage: TPngImage;
  // AStream: TMemoryStream;
  // begin
  // if Message.CopyDataStruct^.dwData = WM_AIMP_COPYDATA_COVER_ID then
  // begin
  // AStream := TMemoryStream.Create;
  // try
  // AStream.WriteBuffer(Message.CopyDataStruct^.lpData^, Message.CopyDataStruct^.cbData);
  // AStream.Position := 0;
  // AImage := TPngImage.Create;
  // try
  // AImage.LoadFromStream(AStream);
  // Image1.Picture.Graphic := AImage;
  // except
  // Image1.Picture.Graphic := nil;
  // AImage.Free;
  // end;
  // finally
  // AStream.Free;
  // end;
  // end;
  // end;
  //
  AIMP_RA_CMD_GET_COVER_ART = AIMP_RA_CMD_BASE + 19;

  // ==============================================================================
  // Notifications ID for WM_AIMP_NOTIFY message: (Notification ID in WParam)
  // ==============================================================================

  AIMP_RA_NOTIFY_BASE = 0;

  // Called, if information about now playing file has been changed
  // You can read the information in the following manner:
  //
  // var
  // AInfo: PAIMPFileInfo;
  // begin
  // AFile := OpenFileMapping(FILE_MAP_READ, True, AIMPRemoteAccessClass);
  // AInfo := MapViewOfFile(AFile, FILE_MAP_READ, 0, 0, AIMPRemoteAccessMapFileSize);
  // ...
  AIMP_RA_NOTIFY_TRACK_INFO = AIMP_RA_NOTIFY_BASE + 1;

  // Called, when audio stream starts playing or when an Internet radio station changes the track
  AIMP_RA_NOTIFY_TRACK_START = AIMP_RA_NOTIFY_BASE + 2;

  // Called, when property has been changed
  // LParam: Property ID
  AIMP_RA_NOTIFY_PROPERTY = AIMP_RA_NOTIFY_BASE + 3;

implementation

end.
