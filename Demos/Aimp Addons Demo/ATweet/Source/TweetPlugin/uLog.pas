unit uLog;

interface

procedure sLog(aLogFileName: String; aMessage: String; aLevel: integer = 1;
  aRewrite: boolean = false; aIncludeDateTime: boolean = true);

var
  LogLevel: integer = 1;
  EnableMessages: boolean = False;
  LogFileName: String;
  // 1 - мегаважный
  // 2 - информационный (запустился, ...)
  // 3 - отладочный

implementation

uses SysUtils, Dialogs, DateUtils;

procedure sLog(aLogFileName: String; aMessage: String; aLevel: integer = 1;
  aRewrite: boolean = false; aIncludeDateTime: boolean = true);
var
  Y, M, D, H, Min, Sec, MSec: word;
  LF: Text;
  S: String;
  S1: String;
  N: TDateTime;
begin
{$I-}
  if aLogFileName = '' then
    aLogFileName := LogFileName;
  if aLevel <= LogLevel then
  begin
    S := '';
    AssignFile(LF, aLogFileName);
    if FileExists(aLogFileName) then
    begin
      if aRewrite then
        Rewrite(LF)
      else
        append(LF);
      if IOResult <> 0 then
        if EnableMessages then
          ShowMessage('error appending message ' + aMessage);
    end
    else
    begin
      Rewrite(LF);
      if IOResult <> 0 then
        if EnableMessages then
          ShowMessage('error rewriting message ' + aMessage);
    end;
    if aIncludeDateTime then
    begin
      N := Now;
      DecodeDateTime(N, Y, M, D, H, Min, Sec, MSec);
      S1 := ' [' + IntToStr(MSec) + '] ';
      while Length(S1) < 7 do
        S1 := S1 + ' ';
      S := DateTimeToStr(N) + S1;
    end;
    S := S + aMessage;
    writeln(LF, S);
    if IOResult <> 0 then
      if EnableMessages then
        ShowMessage('error writing message ' + aMessage);
    closeFile(LF);
    if IOResult <> 0 then
      if EnableMessages then
        ShowMessage('error closing message ' + aMessage);
  end;
{$I+}
end;

end.
