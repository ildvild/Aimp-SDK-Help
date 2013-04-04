object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 182
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grpConf: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 412
    Height = 176
    Align = alClient
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object chkOnStartConf: TCheckBox
      Left = 24
      Top = 32
      Width = 273
      Height = 17
      Caption = #1042#1099#1087#1086#1083#1085#1103#1090#1100' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1087#1083#1072#1075#1080#1085#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object chkUseSpecialAlgConf: TCheckBox
      Left = 24
      Top = 64
      Width = 369
      Height = 17
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1086#1089#1082' '#1082#1086#1085#1090#1088#1072#1089#1090#1085#1099#1093' '#1084#1077#1089#1090' ('#1084#1077#1076#1083#1077#1085#1085#1077#1077')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object chkUseTimerConf: TCheckBox
      Left = 24
      Top = 96
      Width = 185
      Height = 25
      Caption = #1054#1073#1085#1086#1074#1083#1103#1090#1100' '#1087#1086' '#1090#1072#1081#1084#1077#1088#1091
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = chkUseTimerConfClick
    end
    object lbledtTimeForUseConf: TLabeledEdit
      Left = 223
      Top = 128
      Width = 73
      Height = 26
      BiDiMode = bdRightToLeft
      EditLabel.Width = 178
      EditLabel.Height = 18
      EditLabel.BiDiMode = bdRightToLeft
      EditLabel.Caption = #1055#1077#1088#1080#1086#1076' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103' ('#1084#1080#1085')'
      EditLabel.ParentBiDiMode = False
      LabelPosition = lpLeft
      ParentBiDiMode = False
      TabOrder = 3
      Text = '30'
    end
  end
end
