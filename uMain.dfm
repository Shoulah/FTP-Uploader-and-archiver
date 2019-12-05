object frMain: TfrMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FTP Uploader and Archiver'
  ClientHeight = 441
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 422
    Width = 426
    Height = 19
    Panels = <>
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 409
    Height = 409
    TabOrder = 1
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 377
      Height = 129
      Caption = 'Connection Settings'
      TabOrder = 0
      object Label1: TLabel
        Left = 17
        Top = 24
        Width = 67
        Height = 16
        Caption = 'Host Name:'
      end
      object Label2: TLabel
        Left = 17
        Top = 54
        Width = 68
        Height = 16
        Caption = 'User Name:'
      end
      object Label3: TLabel
        Left = 17
        Top = 84
        Width = 64
        Height = 16
        Caption = 'Password :'
      end
      object Edit1: TEdit
        Left = 104
        Top = 21
        Width = 257
        Height = 24
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 104
        Top = 51
        Width = 257
        Height = 24
        TabOrder = 1
      end
      object Edit3: TEdit
        Left = 104
        Top = 81
        Width = 257
        Height = 24
        PasswordChar = '*'
        TabOrder = 2
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 151
      Width = 377
      Height = 98
      Caption = 'Local Files'
      TabOrder = 1
      object Label4: TLabel
        Left = 17
        Top = 24
        Width = 56
        Height = 16
        Caption = 'Directory:'
      end
      object Label5: TLabel
        Left = 17
        Top = 57
        Width = 134
        Height = 16
        Caption = 'Tatget Files Extension :'
      end
      object Edit4: TEdit
        Left = 79
        Top = 24
        Width = 258
        Height = 24
        ReadOnly = True
        TabOrder = 0
      end
      object Button1: TButton
        Left = 339
        Top = 24
        Width = 35
        Height = 25
        Caption = '...'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Edit5: TEdit
        Left = 277
        Top = 54
        Width = 60
        Height = 24
        TabOrder = 2
      end
    end
    object GroupBox4: TGroupBox
      Left = 16
      Top = 255
      Width = 374
      Height = 105
      Caption = 'Startup Settings'
      TabOrder = 2
      object CheckBox1: TCheckBox
        Left = 17
        Top = 32
        Width = 320
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Automatic startup with windows'
        TabOrder = 0
        OnClick = CheckBox1Click
      end
    end
    object Button2: TButton
      Left = 336
      Top = 366
      Width = 57
      Height = 25
      Caption = 'Save'
      TabOrder = 3
      OnClick = Button2Click
    end
  end
  object IdFTP1: TIdFTP
    IPVersion = Id_IPv4
    ConnectTimeout = 0
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 40
    Top = 360
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 15000
    OnTimer = Timer1Timer
    Left = 80
    Top = 360
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 128
    Top = 360
  end
end
