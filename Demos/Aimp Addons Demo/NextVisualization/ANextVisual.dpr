library ANextVisual;
{$R *.res}

uses
  AIMPSDKCore,
  AIMPSDKAddons,
  AIMPSDKCommon,
  AIMPSDKRemote,
  Windows,
  Messages, Dialogs,
  AIMPAddonCustomPlugin in 'AIMPAddonCustomPlugin.pas', SysUtils;

type

  { TAIMPHook }
  TAIMPHook = class(TInterfacedObject, IAIMPCoreUnitMessageHook)
  private
    FPlugin: TAIMPAddonsCustomPlugin;
  protected
    procedure CoreMessage(AMessage: DWORD; AParam1: Integer; AParam2: Pointer;
      var AResult: HRESULT); stdcall;
  public
    property Plugin
      : TAIMPAddonsCustomPlugin read FPlugin write FPlugin default nil;
  end;

  { TNextVisual }
  TNextVisual = class(TAIMPAddonsCustomPlugin)
  private
    FHook: TAIMPHook;
  protected
    // IAIMPAddonPlugin
    function GetPluginAuthor: PWideChar; override; stdcall;
    function GetPluginInfo: PWideChar; override; stdcall;
    function GetPluginName: PWideChar; override; stdcall;
    function Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT; override; stdcall;
    function Finalize: HRESULT; override; stdcall;
  end;

function AIMP_QueryAddon3(out AHeader: IAIMPAddonPlugin): LongBool; stdcall;
begin
  AHeader := TNextVisual.Create;
  Result := True;
end;

exports AIMP_QueryAddon3;

{ TNextVisual }
function TNextVisual.Finalize: HRESULT;
begin
  CoreUnit.MessageUnhook(FHook);
  FHook.Plugin := nil;
  FHook := nil;
  //
  Result := inherited Finalize;
end;

function TNextVisual.GetPluginAuthor: PWideChar;
begin
  Result := 'ildvild';
end;

function TNextVisual.GetPluginInfo: PWideChar;
begin
  Result :=
    'Plugin switches visualization to the next visualization when track is change.';
end;

function TNextVisual.GetPluginName: PWideChar;
begin
  Result := 'Next visualization';
end;

function TNextVisual.Initialize(ACoreUnit: IAIMPCoreUnit): HRESULT;
begin
  Result := inherited Initialize(ACoreUnit);
  if Succeeded(Result) then
  begin
    FHook := TAIMPHook.Create;
    FHook.Plugin := Self;
    CoreUnit.MessageHook(FHook);
  end;
end;

{ TAIMPHook }
procedure TAIMPHook.CoreMessage(AMessage: DWORD; AParam1: Integer;
  AParam2: Pointer; var AResult: HRESULT);

begin
  if not Assigned(Plugin) then
    Exit;

  case AMessage of
    AIMP_MSG_EVENT_STREAM_START:
      begin
        Plugin.CoreUnit.MessageSend(AIMP_MSG_CMD_VISUAL_NEXT, 0, nil);
      end;
  end;

end;

begin

end.
