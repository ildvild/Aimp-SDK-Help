library AIMPVisualDemo;

uses
  AIMPSDKCore in '..\..\AIMPSDKCore.pas',
  AIMPSDKVisual in '..\..\AIMPSDKVisual.pas',
  AIMPVisualDemoMain in 'AIMPVisualDemoMain.pas';

function AIMP_QueryVisual3(out AHeader: IAIMPVisualPlugin3): LongBool; stdcall;
begin
  AHeader := TAIMPVisualPlugin.Create;
  Result := True;
end;

exports
  AIMP_QueryVisual3;

begin
end.
