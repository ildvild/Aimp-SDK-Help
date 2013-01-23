library Aimp_Input_Demo;

{$R *.res}

uses
  AIMPSDKCore,
  AIMPSDKAddons,
  AIMPSDKCommon,
  AIMPSDKInput,
  windows;

type
  { TDemoPlugin 0 }
  TInputPlugin = class(TInterfacedObject, IAIMPInputPluginHeader)

  protected
    function GetPluginAuthor: PWideChar; virtual; stdcall;
    function GetPluginInfo: PWideChar; virtual; stdcall;
    function GetPluginName: PWideChar; virtual; stdcall;
    function GetPluginFlags: DWORD; virtual; stdcall;

    function Initialize: LongBool; virtual;stdcall;
    function Finalize: LongBool; virtual;stdcall;
    function CreateDecoder(AFileName: PWideChar;
      out ADecoder: IAIMPInputPluginDecoder): LongBool;virtual; stdcall;

    function CreateDecoderEx(AStream: IAIMPInputStream;
      out ADecoder: IAIMPInputPluginDecoder): LongBool; virtual;stdcall;

    function GetFileInfo(AFileName: PWideChar; AFileInfo: PAIMPFileInfo)
      : LongBool; virtual;stdcall;

    function GetSupportsFormats: PWideChar; virtual;stdcall;

  end;



function TInputPlugin.CreateDecoder(AFileName: PWideChar;
  out ADecoder: IAIMPInputPluginDecoder): LongBool;
begin
Result
end;

function TInputPlugin.CreateDecoderEx(AStream: IAIMPInputStream;
  out ADecoder: IAIMPInputPluginDecoder): LongBool;
begin

end;

function TInputPlugin.Finalize: LongBool;
begin
   Result:=true;
end;

function TInputPlugin.GetFileInfo(AFileName: PWideChar;
  AFileInfo: PAIMPFileInfo): LongBool;
begin
Result:=true;
end;

function TInputPlugin.GetPluginAuthor: PWideChar;
begin
  Result := 'ildvild';
end;

function TInputPlugin.GetPluginFlags: DWORD;
begin
  Result := 0;
end;

function TInputPlugin.GetPluginInfo: PWideChar;
begin
  Result := 'Input Demo Plugin';
end;

function TInputPlugin.GetPluginName: PWideChar;
begin
  Result := 'Input Plugin';
end;

function TInputPlugin.GetSupportsFormats: PWideChar;
begin
 Result:='Format1|*.fmt1;*.fmt2;|';
end;

function TInputPlugin.Initialize: LongBool;
begin
 Result:=false;
end;

function AIMP_QueryInput(out AHeader: IAIMPInputPluginHeader)
  : LongBool; stdcall;
begin
  AHeader := TInputPlugin.Create;
  Result := True;
end;

exports
  AIMP_QueryInput;

begin

end.
