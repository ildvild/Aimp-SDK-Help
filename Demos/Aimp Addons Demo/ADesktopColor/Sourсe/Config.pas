unit Config;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls, ExtCtrls;

type
  TfrmConfig = class(TForm)
    grpConf: TGroupBox;
    chkOnStartConf: TCheckBox;
    chkUseSpecialAlgConf: TCheckBox;
    chkUseTimerConf: TCheckBox;
    lbledtTimeForUseConf: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkUseTimerConfClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
    OnStart: Boolean;
    UseSpecialAlg: Boolean;
    UseTimer: Boolean;
    TimeForUse: SmallInt;
    Time: TTimer;

implementation

{$R *.dfm}

procedure TfrmConfig.chkUseTimerConfClick(Sender: TObject);
begin
lbledtTimeForUseConf.Enabled:= chkUseTimerConf.Checked;
Time.Enabled:=chkUseTimerConf.Checked;
end;

procedure TfrmConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
OnStart:=chkOnStartConf.Checked;
UseSpecialAlg:=chkUseSpecialAlgConf.Checked;
UseTimer:=chkUseTimerConf.Checked;
TimeForUse:=StrToInt(lbledtTimeForUseConf.Text);
UseTimer:= lbledtTimeForUseConf.Enabled;


Time.Interval := TimeForUse*60*1000;
Time.Enabled:=UseTimer;
end;

procedure TfrmConfig.FormShow(Sender: TObject);
begin
chkOnStartConf.Checked:=OnStart;
chkUseSpecialAlgConf.Checked:=UseSpecialAlg;
chkUseTimerConf.Checked:=UseTimer;
lbledtTimeForUseConf.Text:=IntToStr(TimeForUse);
 lbledtTimeForUseConf.Enabled:=  UseTimer;
end;

end.
