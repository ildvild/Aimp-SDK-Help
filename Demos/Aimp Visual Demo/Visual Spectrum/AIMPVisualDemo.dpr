library AIMPVisualDemo;

uses
  AIMPSDKVisual,
  AIMPVisualDemoSpectrum in 'AIMPVisualDemoSpectrum.pas';

function AIMP_QueryVisual3(out AHeader: IAIMPVisualPlugin3): LongBool; stdcall;
begin
  AHeader := TAIMPVisualPlugin.Create;
  Result := True;
end;

exports
  AIMP_QueryVisual3;

begin
end.
