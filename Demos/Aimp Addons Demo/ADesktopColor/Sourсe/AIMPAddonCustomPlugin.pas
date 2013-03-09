unit AIMPAddonCustomPlugin;

{************************************************}
{*                                              *}
{*                AIMP Plugins API              *}
{*             v3.00.960 (01.12.2011)           *}
{*                 Addons Plugins               *}
{*                                              *}
{*              (c) Artem Izmaylov              *}
{*                 www.aimp.ru                  *}
{*             Mail: artem@aimp.ru              *}
{*              ICQ: 345-908-513                *}
{*                                              *}
{************************************************}

interface

uses
  Windows, AIMPSDKAddons, AIMPSDKCore;

type

  { TAIMPAddonsCustomPlugin }

  TAIMPAddonsCustomPlugin = class(TInterfacedObject, IAIMPAddonPlugin)
  private
    FCoreUnit: IAIMPCoreUnit;
    function GetVersion: TAIMPVersionInfo;
  protected
    // IAIMPAddonPlugin
    function GetPluginAuthor: PWideChar; virtual; stdcall;
    function GetPluginFlags: DWORD; virtual; stdcall;
    function GetPluginInfo: PWideChar; virtual; stdcall;
    function GetPluginName: PWideChar; virtual; stdcall;
    function Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT; virtual; stdcall;
    function Finalize: HRESULT; virtual; stdcall;
    function ShowSettingsDialog(AParentWindow: HWND): HRESULT; virtual; stdcall;
  public
    function CorePropertyGetValueB(APropertyID: DWORD; ADefaultValue: LongBool): LongBool;
    function CorePropertyGetValueI(APropertyID: DWORD; ADefaultValue: Integer): Integer;
    function CorePropertyGetValueS(APropertyID: DWORD; ADefaultValue: Single): Single;
    function CorePropertySetValueB(APropertyID: DWORD; AValue: LongBool): LongBool;
    function CorePropertySetValueI(APropertyID: DWORD; AValue: Integer): LongBool;
    function CorePropertySetValueS(APropertyID: DWORD; AValue: Single): LongBool;
    // Config
    function ConfigReadBoolean(const ASectionName, AItemName: WideString; ADefaultValue: Boolean = False): Boolean;
    function ConfigReadInteger(const ASectionName, AItemName: WideString; ADefaultValue: Integer = 0): Integer;
    function ConfigReadString(const ASectionName, AItemName: WideString): WideString;
    function ConfigWriteBoolean(const ASectionName, AItemName: WideString; AValue: Boolean): Boolean;
    function ConfigWriteInteger(const ASectionName, AItemName: WideString; AValue: Integer): Boolean;
    function ConfigWriteString(const ASectionName, AItemName, AValue: WideString): Boolean;
    function ConfigSectionExists(const ASectionName: WideString): Boolean;
    function ConfigSectionRemove(const ASectionName: WideString): Boolean;
    // Extensions
    function GetMenuManager(out AManager: IAIMPAddonsMenuManager): Boolean;
    function GetOptionsDialog(out ADialog: IAIMPAddonsOptionsDialog): Boolean;
    function GetPlayerManager(out AManager: IAIMPAddonsPlayerManager): Boolean;
    function GetPlaylistManager(out AManager: IAIMPAddonsPlaylistManager): Boolean;
    function GetSkinsManager(out AManager: IAIMPAddonsSkinsManager): Boolean;
    //
    property CoreUnit: IAIMPCoreUnit read FCoreUnit;
    property Version: TAIMPVersionInfo read GetVersion;
  end;

function FormatVersionInfo(const AVersion: TAIMPVersionInfo): WideString;
// Helper routines
function EntryPropertyGetBoolValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSENTRY; APropertyID: Integer): LongBool;
function EntryPropertyGetIntegerValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSENTRY; APropertyID: Integer): Integer;
function EntryPropertyGetStringValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSENTRY; APropertyID: Integer): WideString;
function EntryPropertySetBoolValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSENTRY; APropertyID: Integer; AValue: LongBool): LongBool;
function EntryPropertySetIntegerValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSENTRY; APropertyID: Integer; AValue: Integer): LongBool;
function EntryPropertySetStringValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSENTRY; APropertyID: Integer; const AValue: WideString): LongBool;
//
function GroupPropertyGetBoolValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSGROUP; APropertyID: Integer): LongBool;
function GroupPropertyGetIntegerValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSGROUP; APropertyID: Integer): Integer;
function GroupPropertyGetStringValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSGROUP; APropertyID: Integer): WideString;
function GroupPropertySetBoolValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSGROUP; APropertyID: Integer; AValue: LongBool): LongBool;
function GroupPropertySetIntegerValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSGROUP; APropertyID: Integer; AValue: Integer): LongBool;
function GroupPropertySetStringValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSGROUP; APropertyID: Integer; const AValue: WideString): LongBool;
//
function StoragePropertyGetStringValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLS; APropertyID: Integer): WideString;
implementation

uses
  SysUtils, Math;

function FormatVersionInfo(const AVersion: TAIMPVersionInfo): WideString;
begin
  Result := Format('v%d.%s build %d', [AVersion.ID div 1000,
    FormatFloat('00', (AVersion.ID mod 1000) div 10), AVersion.BuildNumber]);
  if AVersion.BuildSuffix <> nil then
    Result := Result + ' ' + AVersion.BuildSuffix;
end;

function EntryPropertyGetBoolValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSENTRY; APropertyID: Integer): LongBool;
begin
  if Failed(AManager.EntryPropertyGetValue(ID, APropertyID, @Result, SizeOf(Result))) then
    Result := False;
end;

function EntryPropertyGetIntegerValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSENTRY; APropertyID: Integer): Integer;
begin
  if Failed(AManager.EntryPropertyGetValue(ID, APropertyID, @Result, SizeOf(Result))) then
    Result := 0;
end;

function EntryPropertyGetStringValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSENTRY; APropertyID: Integer): WideString;
var
  B: array[Byte] of WideChar;
begin
  if AManager.EntryPropertyGetValue(ID, APropertyID, @B[0], SizeOf(B)) = S_OK then
    Result := WideString(B)
  else
    Result := '';
end;

function EntryPropertySetBoolValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSENTRY; APropertyID: Integer; AValue: LongBool): LongBool;
begin
  Result := AManager.EntryPropertySetValue(ID, APropertyID, @AValue, SizeOf(AValue)) = S_OK;
end;

function EntryPropertySetIntegerValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSENTRY; APropertyID: Integer; AValue: Integer): LongBool;
begin
  Result := AManager.EntryPropertySetValue(ID, APropertyID, @AValue, SizeOf(AValue)) = S_OK;
end;

function EntryPropertySetStringValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSENTRY; APropertyID: Integer; const AValue: WideString): LongBool;
begin
  Result := AManager.EntryPropertySetValue(ID, APropertyID,
    @AValue[1], Length(AValue) * SizeOf(WideChar)) = S_OK;
end;

function StoragePropertyGetStringValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLS; APropertyID: Integer): WideString;
var
  B: array[Byte] of WideChar;
begin
  if AManager.StoragePropertyGetValue(ID, APropertyID, @B[0], SizeOf(B)) = S_OK then
    Result := WideString(B)
  else
    Result := '';
end;

function GroupPropertyGetBoolValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSGROUP; APropertyID: Integer): LongBool;
begin
  if Failed(AManager.GroupPropertyGetValue(ID, APropertyID, @Result, SizeOf(Result))) then
    Result := False;
end;

function GroupPropertyGetIntegerValue(AManager: IAIMPAddonsPlaylistManager; ID: HPLSGROUP; APropertyID: Integer): Integer;
begin
  if Failed(AManager.GroupPropertyGetValue(ID, APropertyID, @Result, SizeOf(Result))) then
    Result := 0;
end;

function GroupPropertyGetStringValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSGROUP; APropertyID: Integer): WideString;
var
  B: array[Byte] of WideChar;
begin
  if AManager.GroupPropertyGetValue(ID, APropertyID, @B[0], SizeOf(B)) = S_OK then
    Result := WideString(B)
  else
    Result := '';
end;

function GroupPropertySetBoolValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSGROUP; APropertyID: Integer; AValue: LongBool): LongBool;
begin
  Result := AManager.GroupPropertySetValue(ID, APropertyID, @AValue, SizeOf(AValue)) = S_OK;
end;

function GroupPropertySetIntegerValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSGROUP; APropertyID: Integer; AValue: Integer): LongBool;
begin
  Result := AManager.GroupPropertySetValue(ID, APropertyID, @AValue, SizeOf(AValue)) = S_OK;
end;

function GroupPropertySetStringValue(AManager: IAIMPAddonsPlaylistManager;
  ID: HPLSGROUP; APropertyID: Integer; const AValue: WideString): LongBool;
begin
  Result := AManager.GroupPropertySetValue(ID, APropertyID,
    @AValue[1], Length(AValue) * SizeOf(WideChar)) = S_OK;
end;

{ TAIMPAddonsCustomPlugin }

function TAIMPAddonsCustomPlugin.Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT;
begin
  FCoreUnit := ACoreUnit;
  if FCoreUnit <> nil then
    Result := S_OK
  else
    Result := E_FAIL;
end;

function TAIMPAddonsCustomPlugin.Finalize: HRESULT;
begin
  FCoreUnit := nil;
  Result := S_OK;
end;

function TAIMPAddonsCustomPlugin.ShowSettingsDialog(AParentWindow: HWND): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TAIMPAddonsCustomPlugin.CorePropertyGetValueB(APropertyID: DWORD; ADefaultValue: LongBool): LongBool;
begin
  if CoreUnit.MessageSend(APropertyID, AIMP_MSG_PROPVALUE_GET, @Result) <> S_OK then
    Result := ADefaultValue;
end;

function TAIMPAddonsCustomPlugin.CorePropertyGetValueI(APropertyID: DWORD; ADefaultValue: Integer): Integer;
begin
  if CoreUnit.MessageSend(APropertyID, AIMP_MSG_PROPVALUE_GET, @Result) <> S_OK then
    Result := ADefaultValue;
end;

function TAIMPAddonsCustomPlugin.CorePropertyGetValueS(APropertyID: DWORD; ADefaultValue: Single): Single;
begin
  if CoreUnit.MessageSend(APropertyID, AIMP_MSG_PROPVALUE_GET, @Result) <> S_OK then
    Result := ADefaultValue;
end;

function TAIMPAddonsCustomPlugin.CorePropertySetValueB(APropertyID: DWORD; AValue: LongBool): LongBool;
begin
  Result := CoreUnit.MessageSend(APropertyID, AIMP_MSG_PROPVALUE_SET, @AValue) = S_OK;
end;

function TAIMPAddonsCustomPlugin.CorePropertySetValueI(APropertyID: DWORD; AValue: Integer): LongBool;
begin
  Result := CoreUnit.MessageSend(APropertyID, AIMP_MSG_PROPVALUE_SET, @AValue) = S_OK;
end;

function TAIMPAddonsCustomPlugin.CorePropertySetValueS(APropertyID: DWORD; AValue: Single): LongBool;
begin
  Result := CoreUnit.MessageSend(APropertyID, AIMP_MSG_PROPVALUE_SET, @AValue) = S_OK;
end;

function TAIMPAddonsCustomPlugin.ConfigReadBoolean(
  const ASectionName, AItemName: WideString; ADefaultValue: Boolean = False): Boolean;
begin
  Result := ConfigReadInteger(ASectionName, AItemName, Integer(ADefaultValue)) <> 0;
end;

function TAIMPAddonsCustomPlugin.ConfigReadInteger(
  const ASectionName, AItemName: WideString; ADefaultValue: Integer = 0): Integer;
var
  AConfig: IAIMPAddonsConfigFile;
begin
  Result := ADefaultValue;
  if Supports(CoreUnit, IAIMPAddonsConfigFile, AConfig) then
  try
    if AConfig.ReadInteger(PWideChar(ASectionName), PWideChar(AItemName),
      Length(ASectionName), Length(AItemName), Result) <> S_OK
    then
      Result := ADefaultValue;
  finally
    AConfig := nil;
  end;
end;

function TAIMPAddonsCustomPlugin.ConfigReadString(
  const ASectionName, AItemName: WideString): WideString;
var
  ABuffer: array[Byte] of WideChar;
  AConfig: IAIMPAddonsConfigFile;
begin
  Result := '';
  if Supports(CoreUnit, IAIMPAddonsConfigFile, AConfig) then
  try
    if AConfig.ReadString(
        PWideChar(ASectionName), PWideChar(AItemName), @ABuffer[0],
        Length(ASectionName), Length(AItemName), Length(ABuffer)) = S_OK
    then
      Result := ABuffer
    else
      Result := '';
  finally
    AConfig := nil;
  end;
end;

function TAIMPAddonsCustomPlugin.ConfigSectionExists(const ASectionName: WideString): Boolean;
var
  AConfig: IAIMPAddonsConfigFile;
begin
  Result := False;
  if Supports(CoreUnit, IAIMPAddonsConfigFile, AConfig) then
  try
    Result := AConfig.SectionExists(PWideChar(ASectionName), Length(ASectionName)) = S_OK;
  finally
    AConfig := nil;
  end;
end;

function TAIMPAddonsCustomPlugin.ConfigSectionRemove(const ASectionName: WideString): Boolean;
var
  AConfig: IAIMPAddonsConfigFile;
begin
  Result := False;
  if Supports(CoreUnit, IAIMPAddonsConfigFile, AConfig) then
  try
    Result := AConfig.SectionRemove(PWideChar(ASectionName), Length(ASectionName)) = S_OK;
  finally
    AConfig := nil;
  end;
end;

function TAIMPAddonsCustomPlugin.ConfigWriteBoolean(
  const ASectionName, AItemName: WideString; AValue: Boolean): Boolean;
begin
  Result := ConfigWriteInteger(ASectionName, AItemName, Integer(AValue));
end;

function TAIMPAddonsCustomPlugin.ConfigWriteInteger(
  const ASectionName, AItemName: WideString; AValue: Integer): Boolean;
var
  AConfig: IAIMPAddonsConfigFile;
begin
  Result := False;
  if Supports(CoreUnit, IAIMPAddonsConfigFile, AConfig) then
  try
    Result := AConfig.WriteInteger(PWideChar(ASectionName),
      PWideChar(AItemName), Length(ASectionName), Length(AItemName), AValue) = S_OK;
  finally
    AConfig := nil;
  end;
end;

function TAIMPAddonsCustomPlugin.ConfigWriteString(
  const ASectionName, AItemName, AValue: WideString): Boolean;
var
  AConfig: IAIMPAddonsConfigFile;
begin
  Result := False;
  if Supports(CoreUnit, IAIMPAddonsConfigFile, AConfig) then
  try
    Result := AConfig.WriteString(
      PWideChar(ASectionName), PWideChar(AItemName), PWideChar(AValue),
      Length(ASectionName), Length(AItemName), Length(AValue)) = S_OK;
  finally
    AConfig := nil;
  end;
end;

function TAIMPAddonsCustomPlugin.GetMenuManager(out AManager: IAIMPAddonsMenuManager): Boolean;
begin
  Result := Supports(CoreUnit, IAIMPAddonsMenuManager, AManager);
end;

function TAIMPAddonsCustomPlugin.GetOptionsDialog(out ADialog: IAIMPAddonsOptionsDialog): Boolean;
begin
  Result := Supports(CoreUnit, IAIMPAddonsOptionsDialog, ADialog);
end;

function TAIMPAddonsCustomPlugin.GetPlayerManager(out AManager: IAIMPAddonsPlayerManager): Boolean;
begin
  Result := Supports(CoreUnit, IAIMPAddonsPlayerManager, AManager);
end;

function TAIMPAddonsCustomPlugin.GetPlaylistManager(out AManager: IAIMPAddonsPlaylistManager): Boolean;
begin
  Result := Supports(CoreUnit, IAIMPAddonsPlaylistManager, AManager);
end;

function TAIMPAddonsCustomPlugin.GetSkinsManager(out AManager: IAIMPAddonsSkinsManager): Boolean;
begin
  Result := Supports(CoreUnit, IAIMPAddonsSkinsManager, AManager);
end;

function TAIMPAddonsCustomPlugin.GetPluginAuthor: PWideChar;
begin
  Result := 'Author';
end;

function TAIMPAddonsCustomPlugin.GetPluginFlags: DWORD;
begin
  Result := 0;
end;

function TAIMPAddonsCustomPlugin.GetPluginInfo: PWideChar;
begin
  Result := 'Custom Addon Plugin Template';
end;

function TAIMPAddonsCustomPlugin.GetPluginName: PWideChar;
begin
  Result := 'Name';
end;

function TAIMPAddonsCustomPlugin.GetVersion: TAIMPVersionInfo;
begin
  ZeroMemory(@Result, SizeOf(Result));
  if CoreUnit <> nil then
    CoreUnit.GetVersion(Result);
end;

end.
