library ADesktopColor;
{$R *.res}
{$R *.dres}

uses
  AIMPSDKCore,
  AIMPSDKAddons,
  AIMPAddonCustomPlugin in 'AIMPAddonCustomPlugin.pas',
  SysUtils,
  Windows,
  Graphics,
  Registry,
  jpeg,
  pngimage,
  Config in 'Config.pas' { frmConfig } ,
  ExtCtrls;

type
  { TADesktopColor }
  TADesktopColor = class(TAIMPAddonsCustomPlugin)
  private
    FMenuHandle: HAIMPMENU;
    ConfigForm: TfrmConfig;
    //
    procedure SetThemeColor;
    //
    procedure MenuInitialize;
    procedure MenuFinalize;
    //
    procedure SaveSetting;
    procedure LoadSetting;
    //
    procedure SetTimer(Sender: TObject);
  protected
    // IAIMPAddonPlugin
    function GetPluginAuthor: PWideChar; override; stdcall;
    function GetPluginInfo: PWideChar; override; stdcall;
    function GetPluginName: PWideChar; override; stdcall;
    function GetPluginFlags: DWORD; override; stdcall;
    function ShowSettingsDialog(AParentWindow: HWND): HRESULT; override;
      stdcall;
    function Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT; override; stdcall;
    function Finalize: HRESULT; override; stdcall;
  end;

const
  PluginName = 'ADesktopColor';

function AIMP_QueryAddon3(out AHeader: IAIMPAddonPlugin): LongBool; stdcall;
begin
  AHeader := TADesktopColor.Create;
  Result := True;
end;

exports AIMP_QueryAddon3;

procedure _MenuClick(AUserData: TADesktopColor; AHandle: HAIMPMENU); stdcall;
begin
  AUserData.SetThemeColor;
end;

{ TADesktopColor }
function TADesktopColor.Finalize: HRESULT;
begin
  SaveSetting;
  FreeAndNil(ConfigForm);
  FreeAndNil(Time);
  MenuFinalize;
  Result := inherited Finalize;
end;

function TADesktopColor.GetPluginAuthor: PWideChar;
begin
  Result := 'ildvild';
end;

function TADesktopColor.GetPluginFlags: DWORD;
begin
  Result := 1;
end;

function TADesktopColor.GetPluginInfo: PWideChar;
begin
  Result := 'Plugin set the color scheme of the player like on desktop.';
end;

function TADesktopColor.GetPluginName: PWideChar;
begin
  Result := PluginName;
end;

function TADesktopColor.Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT;
begin
  Result := inherited Initialize(ACoreUnit);

  if Succeeded(Result) then
  begin
    MenuInitialize;
    ConfigForm := TfrmConfig.Create(nil);
    LoadSetting;

    Time := TTimer.Create(nil);
    Time.OnTimer := SetTimer;
    Time.Interval := TimeForUse * 60 * 1000;
    Time.Enabled := UseTimer;

    if OnStart then
      SetThemeColor;

  end;
end;

procedure TADesktopColor.LoadSetting;
begin
  OnStart := ConfigReadBoolean(PluginName, 'OnStart', True);
  UseSpecialAlg := ConfigReadBoolean(PluginName, 'UseSpecialAlg', false);
  UseTimer := ConfigReadBoolean(PluginName, 'UseTimer', false);
  TimeForUse := ConfigReadInteger(PluginName, 'TimeForUse', 30);
end;

procedure TADesktopColor.MenuFinalize;
var
  AMenuManager: IAIMPAddonsMenuManager;
begin
  if GetMenuManager(AMenuManager) then
    try
      AMenuManager.MenuRemove(FMenuHandle);
      FMenuHandle := nil;
    finally
      AMenuManager := nil;
    end;
end;

procedure TADesktopColor.MenuInitialize;
var
  AMenuInfo: TAIMPMenuItemInfo;
  AMenuManager: IAIMPAddonsMenuManager;

begin
  if GetMenuManager(AMenuManager) then
    try
      ZeroMemory(@AMenuInfo, SizeOf(AMenuInfo));
      AMenuInfo.StructSize := SizeOf(AMenuInfo);
      AMenuInfo.Bitmap := LoadBitmap(HInstance, 'ICON');
      AMenuInfo.Caption := 'Обновить цветовую схему';
      AMenuInfo.Flags := AIMP_MENUITEM_ENABLED;
      AMenuInfo.Proc := @_MenuClick;
      AMenuInfo.UserData := Self;
      FMenuHandle := AMenuManager.MenuCreate(4, @AMenuInfo);
    finally
      AMenuManager := nil;
    end;
end;

function TADesktopColor.ShowSettingsDialog(AParentWindow: HWND): HRESULT;
begin
  ConfigForm.ShowModal;
  Result := S_OK;
end;

procedure TADesktopColor.SaveSetting;
begin
  ConfigWriteBoolean(PluginName, 'OnStart', OnStart);
  ConfigWriteBoolean(PluginName, 'UseSpecialAlg', UseSpecialAlg);
  ConfigWriteBoolean(PluginName, 'UseTimer', UseTimer);
  ConfigWriteInteger(PluginName, 'TimeForUse', TimeForUse);
end;

procedure TADesktopColor.SetThemeColor;

  function GetMaxColorBmp(Bmp: TBitmap): TColor;
  Type
    PRGBArray = ^TRGBArray;
    TRGBArray = Array [0 .. 65535] of TRGBTriple;
  Var
    Line: PRGBArray;
    i, j, Pix: Integer;
    _r, _g, _b: Extended;
  begin
    _r := 0;
    _g := 0;
    _b := 0;
    Bmp.PixelFormat := pf24bit;
    For j := 0 To Bmp.Height - 1 Do
    begin
      Line := Bmp.ScanLine[j];
      For i := 0 To Bmp.Width - 1 Do
      begin
        _r := _r + Line[i].rgbtRed;
        _g := _g + Line[i].rgbtGreen;
        _b := _b + Line[i].rgbtBlue;
      end;
    end;
    Pix := Bmp.Width * Bmp.Height;
    Result := RGB(Round(_r / Pix), Round(_g / Pix), Round(_b / Pix));
  end;

  procedure JPEGtoBMP(const FileName: TFileName; var Bmp: TBitmap);
  var
    jpeg: TJPEGImage;
  begin
    jpeg := TJPEGImage.Create;
    try
      jpeg.CompressionQuality := 100; { Default Value }
      jpeg.LoadFromFile(FileName);
      Bmp.Assign(jpeg);
    finally
      jpeg.Free
    end;
  end;

  function Value255ToPercent(Val: byte): byte;
  begin
    Result := Round(Val * 100 / 255);
  end;

const
  BufferLength = 512;

var
  AManager: IAIMPAddonsSkinsManager;
  ASkinLocalFileName: WideString;
  n1, n2: Integer;

  Path: string;
  Bmp: TBitmap;
  SetH, SetS, SetL: byte;
  RGBcolor: TRGBTriple;
  GetColor: TColor;
begin
  Path := TRegIniFile.Create('Control Panel').ReadString('desktop',
    'Wallpaper', '');
  if Path = '' then
    Exit;
  if GetSkinsManager(AManager) then
  begin
    Bmp := TBitmap.Create;
    try

      SetLength(ASkinLocalFileName, BufferLength);

      if AManager.GetCurrentSettings(PWideChar(ASkinLocalFileName),
        BufferLength, @n1, @n2) = S_OK then
      begin

        if FileExists(Path) then
        begin

          if ExtractFileExt(Path) = '.jpg' then
            JPEGtoBMP(Path, Bmp)
          else
            Bmp.LoadFromFile(Path);

          GetColor := GetMaxColorBmp(Bmp);
          RGBcolor.rgbtRed := GetRValue(GetColor);
          RGBcolor.rgbtGreen := GetGValue(GetColor);
          RGBcolor.rgbtBlue := GetBValue(GetColor);

          if not((RGBcolor.rgbtRed = RGBcolor.rgbtBlue) and
              (RGBcolor.rgbtRed = RGBcolor.rgbtGreen)) then

          begin
            if AManager.RGBToHSL(RGBcolor.rgbtRed, RGBcolor.rgbtGreen,
              RGBcolor.rgbtBlue, SetH, SetS, SetL) = S_OK then
            begin
              // CodeSite.Send('SetH', SetH);
              // CodeSite.Send('SetS', SetS);
              // CodeSite.Send('SetS', SetL);

              AManager.Select(PWideChar(ASkinLocalFileName), SetH,
                Value255ToPercent(SetS));
            end;
          end;

        end;

      end;

    finally
      Bmp.Free;
      AManager := nil;
    end;
  end;
end;

procedure TADesktopColor.SetTimer(Sender: TObject);
begin
  SetThemeColor;
end;

begin

end.
