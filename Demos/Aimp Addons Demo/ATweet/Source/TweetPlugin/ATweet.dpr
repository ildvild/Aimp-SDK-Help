library ATweet;
{$R *.res}
{$R *.dres}

uses
  AIMPSDKAddons,
  FAtweet in 'FAtweet.pas' { APTweet } ,
  AIMPAddonCustomPlugin in 'AIMPAddonCustomPlugin.pas',
  Atweet_Impl in 'Atweet_Impl.pas',
  Atweet_LangRes in 'Atweet_LangRes.pas',
  Atweet_uses in 'Atweet_uses.pas',
  uLog in 'uLog.pas';

function AIMP_QueryAddon3(out AHeader: IAIMPAddonPlugin): LongBool; stdcall;
begin
  AHeader := TTweetPlugin.Create;
  Result := True;
end;

exports AIMP_QueryAddon3;

begin

end.
