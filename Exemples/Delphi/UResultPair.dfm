object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 509
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 92
    Width = 684
    Height = 417
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 83
    ExplicitWidth = 678
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Exemplo Success'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 39
    Width = 177
    Height = 25
    Caption = 'Exemplo Failure'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 191
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Exemplo Future (await)'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 191
    Top = 39
    Width = 177
    Height = 25
    Caption = 'Exemplo Future (no await)'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 499
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Clear Memo'
    TabOrder = 5
    OnClick = Button5Click
  end
end
