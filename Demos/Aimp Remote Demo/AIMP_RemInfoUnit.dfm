object Form1: TForm1
  Left = 192
  Top = 152
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Aimp Remote Demo'
  ClientHeight = 626
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 568
    Top = 60
    Width = 170
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Image1: TImage
    Left = 376
    Top = 47
    Width = 161
    Height = 142
    Center = True
    Proportional = True
    Stretch = True
  end
  object Label2: TLabel
    Left = 568
    Top = 23
    Width = 170
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 568
    Top = 148
    Width = 170
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label4: TLabel
    Left = 568
    Top = 220
    Width = 170
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label5: TLabel
    Left = 568
    Top = 292
    Width = 170
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label6: TLabel
    Left = 568
    Top = 380
    Width = 170
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label7: TLabel
    Left = 568
    Top = 452
    Width = 170
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object ListBox1: TListBox
    Left = 8
    Top = 316
    Width = 345
    Height = 154
    ItemHeight = 13
    TabOrder = 1
  end
  object Button1: TButton
    Left = 568
    Top = 84
    Width = 170
    Height = 29
    Caption = 'Jump To Time'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button7: TButton
    Left = 8
    Top = 8
    Width = 161
    Height = 33
    Caption = 'Start / Resume playback '
    TabOrder = 2
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 8
    Top = 45
    Width = 161
    Height = 33
    Caption = 'Pause / Start playback'
    TabOrder = 3
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 8
    Top = 82
    Width = 161
    Height = 33
    Caption = 'Pause / Resume playback'
    TabOrder = 4
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 8
    Top = 119
    Width = 161
    Height = 33
    Caption = 'Stop playback'
    TabOrder = 5
    OnClick = Button10Click
  end
  object Button11: TButton
    Left = 8
    Top = 156
    Width = 161
    Height = 33
    Caption = 'Next Track'
    TabOrder = 6
    OnClick = Button11Click
  end
  object Button12: TButton
    Left = 8
    Top = 193
    Width = 161
    Height = 33
    Caption = 'Previous Track'
    TabOrder = 7
    OnClick = Button12Click
  end
  object Button13: TButton
    Left = 8
    Top = 230
    Width = 161
    Height = 33
    Caption = 'Next Visualization'
    TabOrder = 8
    OnClick = Button13Click
  end
  object Button14: TButton
    Left = 8
    Top = 267
    Width = 161
    Height = 33
    Caption = 'Previous Visualization'
    TabOrder = 9
    OnClick = Button14Click
  end
  object Button15: TButton
    Left = 192
    Top = 8
    Width = 161
    Height = 33
    Caption = 'Close the program'
    TabOrder = 10
    OnClick = Button15Click
  end
  object Button16: TButton
    Left = 192
    Top = 45
    Width = 161
    Height = 33
    Caption = 'Execute "Add files" dialog'
    TabOrder = 11
    OnClick = Button16Click
  end
  object Button17: TButton
    Left = 192
    Top = 82
    Width = 161
    Height = 33
    Caption = 'Execute "Add folders" dialog'
    TabOrder = 12
    OnClick = Button17Click
  end
  object Button18: TButton
    Left = 192
    Top = 119
    Width = 161
    Height = 33
    Caption = 'Execute "Add Playlists" dialog'
    TabOrder = 13
    OnClick = Button18Click
  end
  object Button19: TButton
    Left = 192
    Top = 156
    Width = 161
    Height = 33
    Caption = 'Execute "Add URL" dialog'
    TabOrder = 14
    OnClick = Button19Click
  end
  object Button20: TButton
    Left = 192
    Top = 193
    Width = 161
    Height = 33
    Caption = 'Execute "Open Files" dialog'
    TabOrder = 15
    OnClick = Button20Click
  end
  object Button21: TButton
    Left = 192
    Top = 230
    Width = 161
    Height = 33
    Caption = 'Execute "Open Folders" dialog'
    TabOrder = 16
    OnClick = Button21Click
  end
  object Button22: TButton
    Left = 192
    Top = 267
    Width = 161
    Height = 33
    Caption = 'Execute "Open Playlist" dialog'
    TabOrder = 17
    OnClick = Button22Click
  end
  object Button2: TButton
    Left = 376
    Top = 8
    Width = 161
    Height = 33
    Caption = 'CoverArt Request'
    TabOrder = 18
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 568
    Top = 172
    Width = 170
    Height = 29
    Caption = 'Set Volume'
    TabOrder = 19
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 568
    Top = 244
    Width = 170
    Height = 29
    Caption = 'Set Mute State'
    TabOrder = 20
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 568
    Top = 316
    Width = 170
    Height = 29
    Caption = 'Set Track Repeat State'
    TabOrder = 21
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 568
    Top = 404
    Width = 170
    Height = 29
    Caption = 'Set Track Shuffle State'
    TabOrder = 22
    OnClick = Button6Click
  end
  object Button23: TButton
    Left = 568
    Top = 476
    Width = 170
    Height = 29
    Caption = 'Set Radio Capture State'
    TabOrder = 23
    OnClick = Button23Click
  end
end
