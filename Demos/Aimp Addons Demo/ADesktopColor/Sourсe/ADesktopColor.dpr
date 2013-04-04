library ADesktopColor;
{$R *.res}
{$R *.dres}

uses
  EAppDLL,
  AIMPSDKCore,
  AIMPSDKAddons,
  AIMPAddonCustomPlugin in 'AIMPAddonCustomPlugin.pas',
  SysUtils,
  Windows,
  Graphics,
  Registry,
  jpeg,
  Config in 'Config.pas' { frmConfig } ,
  ExtCtrls,
  Math;

type
  TRGB32 = packed record
    Blue, Green, Red: Byte;
  end;

  TRGB32Array = packed array [0 .. MaxInt div SizeOf(TRGB32) - 1] of TRGB32;
  PRGB32Array = ^TRGB32Array;

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
  PluginVers = '1.2';

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
  Result := PluginName + ' ' + PluginVers;
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

// RGB, each 0 to 255, to HSV.
// H = 0 to 360 (corresponding to 0..360 degrees around hexcone)
// S = 0 (shade of gray) to 255 (pure color)
// V = 0 (black) to 255 {white)
  PROCEDURE RGBTripleToHSV(CONST RGBTriple: TRGB32;
    { r, g and b IN [0..255] }
    VAR H, S, V: INTEGER); { h IN 0..359; s,v IN 0..255 }
  VAR
    Delta: INTEGER;
    Min: INTEGER;
  BEGIN
    WITH RGBTriple DO
    BEGIN
      Min := MinIntValue([Red, Green, Blue]);
      V := MaxIntValue([Red, Green, Blue])
    END;

    Delta := V - Min;

    // Calculate saturation:  saturation is 0 if r, g and b are all 0
    IF V = 0 THEN
      S := 0
    ELSE
      S := MulDiv(Delta, 255, V);

    IF S = 0 THEN
      H := 0 // Achromatic:  When s = 0, h is undefined but assigned the value 0
    ELSE
    BEGIN // Chromatic

      WITH RGBTriple DO
      BEGIN
        IF Red = V THEN // degrees -- between yellow and magenta
          H := MulDiv(Green - Blue, 60, Delta)
        ELSE IF Green = V THEN // between cyan and yellow
          H := 120 + MulDiv(Blue - Red, 60, Delta)
        ELSE IF Blue = V THEN // between magenta and cyan
          H := 240 + MulDiv(Red - Green, 60, Delta);
      END;

      IF H < 0 THEN
        H := H + 360;
    END
  END { RGBTripleToHSV } ;

  function GetMaxColorBmp(Bmp: TBitmap): TColor;

  Var
    Line: PRGB32Array;
    i, j, Pix: INTEGER;
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
        _r := _r + Line[i].Red;
        _g := _g + Line[i].Green;
        _b := _b + Line[i].Blue;
      end;
    end;
    Pix := Bmp.Width * Bmp.Height;
    Result := rgb(ROUND(_r / Pix), ROUND(_g / Pix), ROUND(_b / Pix));
  end;

  function GetMaxColorBmpUseSpecAlg(Bmp: TBitmap): TColor;
  Var
    Line: PRGB32Array;
    i, j: INTEGER;
    _r, _g, _b: Extended;
    Temp: TRGB32;
    H, S, V: INTEGER;
    PixNum: Extended;
  begin
    _r := 0;
    _g := 0;
    _b := 0;
    PixNum := 0;
    Bmp.PixelFormat := pf24bit;

    For j := 0 To Bmp.Height - 1 Do
    begin
      Line := Bmp.ScanLine[j];
      For i := 0 To Bmp.Width - 1 Do
      begin
        Temp := Line[i];

        RGBTripleToHSV(Temp, H, S, V);

        if (S > 100) and (V > 100) then
        begin
          _r := _r + Line[i].Red;
          _g := _g + Line[i].Green;
          _b := _b + Line[i].Blue;
          PixNum := PixNum + 1; ;
        end;

      end;
    end;

    Result := rgb(ROUND(_r / PixNum), ROUND(_g / PixNum), ROUND(_b / PixNum));
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

  function Value255ToPercent(value: Byte): Byte;
  begin
    Result := ROUND(value * 100 / 255);
  end;

  function GetColorValFromReg(var ColorString: string): Byte;
  var
    Temp: string;
  begin
    Temp := ColorString;
    if pos(' ', ColorString) > 0 then
    begin
      Temp := Copy(ColorString, 1, pos(' ', ColorString) - 1);
      Delete(ColorString, 1, pos(' ', ColorString));
    end;
    Result := StrToInt(Temp);
  end;

const
  BufferLength = 512;

var
  AManager: IAIMPAddonsSkinsManager;
  ASkinLocalFileName: WideString;
  n1, n2: INTEGER;

  Path, ColorBackg: string;
  Bmp: TBitmap;
  SetH, SetS, SetL: Byte;
  RGBcolor: TRGB32;
  GetColor: TColor;
begin
  Path := TRegIniFile.Create('Control Panel').ReadString('desktop',
    'Wallpaper', '');

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

          if UseSpecialAlg then
            GetColor := GetMaxColorBmpUseSpecAlg(Bmp)
          else
            GetColor := GetMaxColorBmp(Bmp);

          RGBcolor.Red := GetRValue(GetColor);
          RGBcolor.Green := GetGValue(GetColor);
          RGBcolor.Blue := GetBValue(GetColor);
        end
        else
        begin
          ColorBackg := TRegIniFile.Create('Control Panel').ReadString
            ('Colors', 'Background', '0 0 0');
          RGBcolor.Red := GetColorValFromReg(ColorBackg);
          RGBcolor.Green := GetColorValFromReg(ColorBackg);
          RGBcolor.Blue := GetColorValFromReg(ColorBackg);
        end;

        if not((RGBcolor.Red = RGBcolor.Blue) and
            (RGBcolor.Red = RGBcolor.Green)) then

        begin
          if AManager.RGBToHSL(RGBcolor.Red, RGBcolor.Green, RGBcolor.Blue,
            SetH, SetS, SetL) = S_OK then
          begin
            AManager.Select(PWideChar(ASkinLocalFileName), SetH,
              Value255ToPercent(SetS));
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
