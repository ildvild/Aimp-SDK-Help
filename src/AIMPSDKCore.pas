unit AIMPSDKCore;

{************************************************}
{*                                              *}
{*                AIMP Plugins API              *}
{*             v3.50.1238 (13.03.2013)          *}
{*                CoreUnit Objects              *}
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

const
//==============================================================================
// Commands
//==============================================================================

  AIMP_MSG_CMD_BASE = 0;
  // AParam1: Command ID (see AIMP_MSG_CMD_XXX)
  // Result: S_OK, if enabled
  AIMP_MSG_CMD_STATE_GET = AIMP_MSG_CMD_BASE + 1;

  // Show "Quick File Info" card for now playing file
  // AParam1:
  //    LoWord: DisplayTime (in milliseconds), 0 - default
  //    HiWord: 0 - Popup near system tray,
  //            1 - Popup near mouse cursor
  // AParam2: unused
  AIMP_MSG_CMD_SHOW_CURRENT_QFI = AIMP_MSG_CMD_BASE + 2;

  // Show custom text in display of RunningString element
  // AParam1: 0 - Hide text automaticly after 2 seconds
  //          1 - Text will be hidden manually (put nil to AParam2 to hide previous text)
  // AParam2: Pointer to WideChar array
  AIMP_MSG_CMD_RUNSTR_SHOW_TEXT = AIMP_MSG_CMD_BASE + 3;

  // For Backward compatibility
  // AParam1: unused
  // AParam2: Pointer to Single value, New Track Position
  //!!! REMOVED: AIMP_MSG_CMD_RUNSTR_SEEKING_HINT = AIMP_MSG_CMD_BASE + 4;

  AIMP_MSG_CMD_TOGGLE_PARTREPEAT = AIMP_MSG_CMD_BASE + 5;

  // Show "About" window
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_ABOUT = AIMP_MSG_CMD_BASE + 6;

  // Show "Options" Dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_OPTIONS = AIMP_MSG_CMD_BASE + 7;

  // Show "Options" Dialog with active "plugins" sheet
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLUGINS = AIMP_MSG_CMD_BASE + 8;

  // Close the program
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_QUIT = AIMP_MSG_CMD_BASE + 9;

  // Minimize / Restore program from / to tray
  // AParam1, AParam2: unused
  // !! For backward compatibility, see AIMP_MSG_PROPERTY_MINIMIZED_TO_TRAY
  AIMP_MSG_CMD_TRAY_MINIMIZE_RESTORE = AIMP_MSG_CMD_BASE + 10;

  // Show Simple Scheduler Options Dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_SCHEDULER = AIMP_MSG_CMD_BASE + 11;

  // Switch to next visualization
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_VISUAL_NEXT = AIMP_MSG_CMD_BASE + 12;

  // Switch to previous visualization
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_VISUAL_PREV = AIMP_MSG_CMD_BASE + 13;

  // Start / Resume playback
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLAY = AIMP_MSG_CMD_BASE + 14;

  // Pause / Start playback
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLAYPAUSE = AIMP_MSG_CMD_BASE + 15;

  // Start playback of previous playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLAY_PREV_PLAYLIST = AIMP_MSG_CMD_BASE + 16;

  // Resume / Pause playback
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PAUSE = AIMP_MSG_CMD_BASE + 17;

  // Stop playback
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_STOP = AIMP_MSG_CMD_BASE + 18;

  // Next Track
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_NEXT = AIMP_MSG_CMD_BASE + 19;

  // Previous Track
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PREV = AIMP_MSG_CMD_BASE + 20;

  // Execute "Open Files" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_OPEN_FILES = AIMP_MSG_CMD_BASE + 21;

  // Execute "Open Folders" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_OPEN_FOLDERS = AIMP_MSG_CMD_BASE + 22;

  // Execute "Open Playlist" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_OPEN_PLAYLISTS  = AIMP_MSG_CMD_BASE + 23;

  // Execute "Save Playlist" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_SAVE_PLAYLISTS  = AIMP_MSG_CMD_BASE + 24;

  // Execute "Bookmarks" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_BOOKMARKS = AIMP_MSG_CMD_BASE + 25;

  // Add Now playing file to Bookmarks
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_BOOKMARKS_ADD = AIMP_MSG_CMD_BASE + 26;

  // Rescan tags in active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_RESCAN  = AIMP_MSG_CMD_BASE + 27;

  // Jump focus in playlist to now playing file
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_FOCUS_NOWPLAYING = AIMP_MSG_CMD_BASE + 28;

  // Delete all items from active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_ALL = AIMP_MSG_CMD_BASE + 29;

  // Delete non exists items from active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_NON_EXISTS = AIMP_MSG_CMD_BASE + 30;

  // Delete non selected items from active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_NON_SELECTED = AIMP_MSG_CMD_BASE + 31;

  // Delete Playing Item from playlist and disk
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_PLAYING_FROM_HDD = AIMP_MSG_CMD_BASE + 32;

  // Delete selected items from active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_SELECTED = AIMP_MSG_CMD_BASE + 33;

  // Delete selected items from active playlist and disk
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_SELECTED_FROM_HDD = AIMP_MSG_CMD_BASE + 34;

  // Delete switched off items from active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_SWITCHEDOFF = AIMP_MSG_CMD_BASE + 35;

  // Delete switched off items from active playlist and disk
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_SWITCHEDOFF_FROM_HDD = AIMP_MSG_CMD_BASE + 36;

  // Delete duplicates from active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_DELETE_DUPLICATES = AIMP_MSG_CMD_BASE + 37;

  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_SORT_BY_ARTIST = AIMP_MSG_CMD_BASE + 38;

  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_SORT_BY_TITLE = AIMP_MSG_CMD_BASE + 39;

  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_SORT_BY_FOLDER = AIMP_MSG_CMD_BASE + 40;

  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_SORT_BY_DURATION = AIMP_MSG_CMD_BASE + 41;

  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_SORT_RANDOMIZE = AIMP_MSG_CMD_BASE + 42;

  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_SORT_INVERT = AIMP_MSG_CMD_BASE + 43;

  // Switch on autoplaying markers for selected items in active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_SWITCH_ON = AIMP_MSG_CMD_BASE + 44;

  // Switch on autoplaying markers for selected items in active playlist
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_SWITCH_OFF = AIMP_MSG_CMD_BASE + 45;

  // Execute "Add files" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_ADD_FILES = AIMP_MSG_CMD_BASE + 46;

  // Execute "Add folders" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_ADD_FOLDERS = AIMP_MSG_CMD_BASE + 47;

  // Execute "Add Playlists" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_ADD_PLAYLISTS = AIMP_MSG_CMD_BASE + 48;

  // Execute "Add URL" dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_ADD_URL = AIMP_MSG_CMD_BASE + 49;

  // Execute "Online Radio Browser"
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_RADIOCAT = AIMP_MSG_CMD_BASE + 50;

  // Execute "Quick Tag Editor" for now playing file
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_QTE_NOWPLAYING_FILE = AIMP_MSG_CMD_BASE + 51;

  // Show Advanced Search Dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_SEARCH = AIMP_MSG_CMD_BASE + 52;

  // Show DSP Manager Dialog
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_DSPMANAGER = AIMP_MSG_CMD_BASE + 53;

  // Show DSP Manager Dialog with active "Equalizer" page
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_DSPMANAGER_EQ = AIMP_MSG_CMD_BASE + 54;

  // Sync active playlist with preimage
  // AParam1, AParam2: unused
  AIMP_MSG_CMD_PLS_RELOAD_FROM_PREIMAGE = AIMP_MSG_CMD_BASE + 55;

//==============================================================================
// Properties
//==============================================================================

  AIMP_MSG_PROPERTY_BASE = $1000;

  // Flags for AParam1
  AIMP_MSG_PROPVALUE_GET = 0;
  AIMP_MSG_PROPVALUE_SET = 1;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to 32-bit floating-point variable, Range [0.0 .. 1.0]
  AIMP_MSG_PROPERTY_VOLUME = AIMP_MSG_PROPERTY_BASE + 1;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit Boolean) variable
  AIMP_MSG_PROPERTY_MUTE = AIMP_MSG_PROPERTY_BASE + 2;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [-1.0 .. +1.0], Default: 0.0
  AIMP_MSG_PROPERTY_BALANCE = AIMP_MSG_PROPERTY_BASE + 3;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [0.0 .. 1.0], Default: 0.0 (switched off)
  AIMP_MSG_PROPERTY_CHORUS = AIMP_MSG_PROPERTY_BASE + 4;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [0.0 .. 1.0], Default: 0.0 (switched off)
  AIMP_MSG_PROPERTY_ECHO = AIMP_MSG_PROPERTY_BASE + 5;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [1.0 .. 4.0], Default: 1.0 (switched off)
  AIMP_MSG_PROPERTY_ENHANCER = AIMP_MSG_PROPERTY_BASE + 6;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [0.0 .. 1.0], Default: 0.0 (switched off)
  AIMP_MSG_PROPERTY_FLANGER = AIMP_MSG_PROPERTY_BASE + 7;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [0.0 .. 1.0], Default: 0.0 (switched off)
  AIMP_MSG_PROPERTY_REVERB = AIMP_MSG_PROPERTY_BASE + 8;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [-10.0 .. +10.0], Default: 0.0 (switched off)
  AIMP_MSG_PROPERTY_PITCH = AIMP_MSG_PROPERTY_BASE + 9;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [0.5 .. 1.5], Default: 1.0 (switched off)
  AIMP_MSG_PROPERTY_SPEED = AIMP_MSG_PROPERTY_BASE + 10;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [0.8 .. 1.5], Default: 1.0 (switched off)
  AIMP_MSG_PROPERTY_TEMPO = AIMP_MSG_PROPERTY_BASE + 11;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [0.0 .. 2.0], Default: 0.0 (switched off)
  AIMP_MSG_PROPERTY_TRUEBASS = AIMP_MSG_PROPERTY_BASE + 12;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [-15.0 .. 15.0] (in db), Default: 0.0 (switched off)
  AIMP_MSG_PROPERTY_PREAMP = AIMP_MSG_PROPERTY_BASE + 13;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  //          Default: False (switched off)
  AIMP_MSG_PROPERTY_EQUALIZER =  AIMP_MSG_PROPERTY_BASE + 14;

  // AParam1: LoWord: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  //          HiWord: Band Index [0..17]
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          [-15.0 .. 15.0] (in db), Default: 0.0 (switched off)
  // !!!NOTE: AParam2 in AIMP_MSG_EVENT_PROPERTY_VALUE will be nil;
  AIMP_MSG_PROPERTY_EQUALIZER_BAND = AIMP_MSG_PROPERTY_BASE + 15;

  // !!!ReadOnly property
  // AParam1: AIMP_MSG_PROPVALUE_GET
  // AParam2: Pointer to Integer variable
  //          0 = Stopped
  //          1 = Paused
  //          2 = Playing
  // See AIMP_MSG_EVENT_PLAYER_STATE event
  AIMP_MSG_PROPERTY_PLAYER_STATE = AIMP_MSG_PROPERTY_BASE + 16;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  //          New position in Seconds
  // See AIMP_MSG_EVENT_PROPERTY_VALUE and AIMP_MSG_EVENT_PLAYER_UPDATE_POSITION
  AIMP_MSG_PROPERTY_PLAYER_POSITION = AIMP_MSG_PROPERTY_BASE + 17;

  // !!!ReadOnly property
  // AParam1: AIMP_MSG_PROPVALUE_GET
  // AParam2: Pointer to Single (32-bit floating point value) variable
  AIMP_MSG_PROPERTY_PLAYER_DURATION = AIMP_MSG_PROPERTY_BASE + 18;

  // !!!ReadOnly property
  // AParam1: AIMP_MSG_PROPVALUE_GET
  // AParam2: Pointer to Integer variable
  //    0 = Disabled,
  //    1 = Point A assigned,
  //    2 = Point B assigned, repeat started
  AIMP_MSG_PROPERTY_PARTREPEAT = AIMP_MSG_PROPERTY_BASE + 19;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  AIMP_MSG_PROPERTY_REPEAT = AIMP_MSG_PROPERTY_BASE + 20;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  AIMP_MSG_PROPERTY_SHUFFLE = AIMP_MSG_PROPERTY_BASE + 21;

  // !!!ReadOnly property
  // AParam1: One of AIMP_MPH_XXX flags
  // AParam2: Pointer to HWND
  AIMP_MSG_PROPERTY_HWND = AIMP_MSG_PROPERTY_BASE + 22;
    AIMP_MPH_MAINFORM      = 0;
    AIMP_MPH_APPLICATION   = 1;
    AIMP_MPH_TRAYCONTROL   = 2;
    AIMP_MPH_PLAYLISTFORM  = 3;
    AIMP_MPH_EQUALIZERFORM = 4;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  AIMP_MSG_PROPERTY_STAYONTOP = AIMP_MSG_PROPERTY_BASE + 23;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  AIMP_MSG_PROPERTY_REVERSETIME = AIMP_MSG_PROPERTY_BASE + 24;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  AIMP_MSG_PROPERTY_MINIMIZED_TO_TRAY = AIMP_MSG_PROPERTY_BASE + 25;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  AIMP_MSG_PROPERTY_REPEAT_SINGLE_FILE_PLAYLISTS = AIMP_MSG_PROPERTY_BASE + 26;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to Integer variable
  //   0 - Jump to next playlist
  //   1 - Repeat playlist
  //   2 - Do nothing
  AIMP_MSG_PROPERTY_ACTION_ON_END_OF_PLAYLIST = AIMP_MSG_PROPERTY_BASE + 27;

  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  AIMP_MSG_PROPERTY_STOP_AFTER_TRACK = AIMP_MSG_PROPERTY_BASE + 28;

  // Start / Stop Internet Radio capture
  // AParam1: AIMP_MSG_PROPVALUE_GET / AIMP_MSG_PROPVALUE_SET
  // AParam2: Pointer to LongBool (32-bit boolean value) variable
  AIMP_MSG_PROPERTY_RADIOCAP = AIMP_MSG_PROPERTY_BASE + 29;

//==============================================================================
// Events
//==============================================================================

  AIMP_MSG_EVENT_BASE = $2000;

  // Called, when Command state changed; AParam1: Command ID (see AIMP_MSG_CMD_XXX)
  AIMP_MSG_EVENT_CMD_STATE = AIMP_MSG_EVENT_BASE + 1;

  // Called, when Options has been changed
  AIMP_MSG_EVENT_OPTIONS = AIMP_MSG_EVENT_BASE + 2;

  // Called, when audio stream starts playing
  AIMP_MSG_EVENT_STREAM_START = AIMP_MSG_EVENT_BASE + 3;
  // Similar to AIMP_MSG_EVENT_STREAM_START event, but called when an Internet radio station changes the track
  AIMP_MSG_EVENT_STREAM_START_SUBTRACK = AIMP_MSG_EVENT_BASE + 4;
  // Called, when audio stream has been finished
  AIMP_MSG_EVENT_STREAM_END = AIMP_MSG_EVENT_BASE + 5;
    // AParam1 contains combination of next flags:
    AIMP_MES_END_OF_QUEUE    = 1;
    AIMP_MES_END_OF_PLAYLIST = 2;

  // Called, when player state has been changed (Played / Paused / Stopped)
  // AParam1: 0 = Stopped; 1 = Paused; 2 = Playing
  AIMP_MSG_EVENT_PLAYER_STATE = AIMP_MSG_EVENT_BASE + 6;

  // Called, when property value has been changed
  // AParam1: PropertyID (see AIMP_MSG_PROPERTY_XXX)
  // AParam2: like AParam2 for each PropertyID
  AIMP_MSG_EVENT_PROPERTY_VALUE = AIMP_MSG_EVENT_BASE + 7;

  // Called, when options frame added / removed
  // AParam1, AParam2: unused
  AIMP_MSG_EVENT_OPTIONS_FRAME_LIST = AIMP_MSG_EVENT_BASE + 8;

  // Called, when options frame content changed
  // AParam1, AParam2: unused
  AIMP_MSG_EVENT_OPTIONS_FRAME_MODIFIED = AIMP_MSG_EVENT_BASE + 9;

  // Internal event message (for backward compatibility)
  AIMP_MSG_EVENT_MODULES = AIMP_MSG_EVENT_BASE + 10;

  // Called, when swithing between visual plugins
  // AParam1, AParam2: unused
  AIMP_MSG_EVENT_VISUAL_PLUGIN = AIMP_MSG_EVENT_BASE + 11;

  // Called, when mark of file has been changed
  // AParam1: New Mark Value (0..5)
  // AParam2: FileName (Pointer to WideChar)
  // !!!WARNING: You must not fire this event manually!
  AIMP_MSG_EVENT_FILEMARK = AIMP_MSG_EVENT_BASE + 12;

  // Called, when statistics of the file changed
  // AParam2: FileName (Pointer to WideChar)
  // !!!Note: If filename is empty or AParam2 is nil - statistics for all files has been changed
  // !!!WARNING: You must not fire this event manually!
  AIMP_MSG_EVENT_STATISTICS_CHANGED = AIMP_MSG_EVENT_BASE + 14;

  // Called after skin changed
  // AParam1, AParam2: unused
  AIMP_MSG_EVENT_SKIN = AIMP_MSG_EVENT_BASE + 15;

  // Called every second by timer
  //    (Unlike AIMP_MSG_EVENT_PROPERTY_VALUE event for AIMP_MSG_PROPERTY_PLAYER_POSITION property,
  //     Which fires only if user change position of the track)
  // AParam1, AParam2: unused
  AIMP_MSG_EVENT_PLAYER_UPDATE_POSITION = AIMP_MSG_EVENT_BASE + 16;

  // Called, when inteface language has been changed
  // AParam1, AParam2: unused
  AIMP_MSG_EVENT_LANGUAGE = AIMP_MSG_EVENT_BASE + 17;

  // Called, when AIMP completely loaded
  // AParam1, AParam2: unused
  AIMP_MSG_EVENT_LOADED = AIMP_MSG_EVENT_BASE + 18;

const
  SID_IAIMPCoreUnitMessageHook = '{FC6FB524-A959-4089-AA0A-EA40AB7374CD}';
  IID_IAIMPCoreUnitMessageHook: TGUID = SID_IAIMPCoreUnitMessageHook;

type
  { TAIMPVersionInfo }

  TAIMPVersionInfo = packed record
    ID: Integer;
    BuildNumber: Integer;
    BuildDate: Integer; // OS date-and-time format
    BuildSuffix: PWideChar; // can be nil!
  end;

  { IAIMPCoreUnitMessageHook }

  IAIMPCoreUnitMessageHook = interface(IUnknown)
  [SID_IAIMPCoreUnitMessageHook]
    procedure CoreMessage(AMessage: DWORD; AParam1: Integer; AParam2: Pointer; var AResult: HRESULT); stdcall;
  end;

  { IAIMPCoreUnit }

  IAIMPCoreUnit = interface(IUnknown)
    function GetVersion(out AVersion: TAIMPVersionInfo): HRESULT; stdcall;
    function MessageHook(AHook: IAIMPCoreUnitMessageHook): HRESULT; stdcall;
    function MessageRegister(AMessageName: PWideChar): DWORD; stdcall;
    function MessageSend(AMessage: DWORD; AParam1: Integer; AParam2: Pointer): HRESULT; stdcall;
    function MessageUnhook(AHook: IAIMPCoreUnitMessageHook): HRESULT; stdcall;
  end;

implementation

end.
