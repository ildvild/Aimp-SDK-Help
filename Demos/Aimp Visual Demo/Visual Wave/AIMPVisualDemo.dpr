library AIMPVisualDemo;

uses
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
