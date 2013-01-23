program AIMP_Remote_Demo;

uses
  Forms,
  AIMP_RemInfoUnit in 'AIMP_RemInfoUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
