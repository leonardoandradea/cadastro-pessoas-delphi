object FrmCadastroPessoa: TFrmCadastroPessoa
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Pessoa'
  ClientHeight = 560
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    Color = 4144959
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 16
      Top = 12
      Width = 154
      Height = 25
      Caption = 'Cadastro de Pessoa'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 511
    Width = 640
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnSalvar: TButton
      Left = 448
      Top = 10
      Width = 89
      Height = 30
      Caption = 'Salvar'
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 543
      Top = 10
      Width = 89
      Height = 30
      Cancel = True
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object scrConteudo: TScrollBox
    Left = 0
    Top = 48
    Width = 640
    Height = 463
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 2
    object lblTipo: TLabel
      Left = 16
      Top = 16
      Width = 88
      Height = 15
      Caption = 'Tipo de pessoa *'
    end
    object lblNome: TLabel
      Left = 16
      Top = 64
      Width = 84
      Height = 15
      Caption = 'Nome completo *'
    end
    object lblNascimento: TLabel
      Left = 16
      Top = 112
      Width = 100
      Height = 15
      Caption = 'Data de nascimento'
    end
    object lblCPF: TLabel
      Left = 232
      Top = 112
      Width = 32
      Height = 15
      Caption = 'CPF *'
    end
    object lblRG: TLabel
      Left = 408
      Top = 112
      Width = 16
      Height = 15
      Caption = 'RG'
    end
    object lblEmail: TLabel
      Left = 16
      Top = 160
      Width = 38
      Height = 15
      Caption = 'E-mail'
    end
    object lblTelefone: TLabel
      Left = 320
      Top = 160
      Width = 49
      Height = 15
      Caption = 'Telefone'
    end
    object cbTipo: TComboBox
      Left = 16
      Top = 32
      Width = 280
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object edtNome: TEdit
      Left = 16
      Top = 80
      Width = 600
      Height = 23
      TabOrder = 1
    end
    object dtpNascimento: TDateTimePicker
      Left = 16
      Top = 128
      Width = 200
      Height = 23
      Date = 45000.000000000000000000
      Time = 0.000000000000000000
      TabOrder = 2
    end
    object medCPF: TMaskEdit
      Left = 232
      Top = 128
      Width = 160
      Height = 23
      EditMask = '999\.999\.999\-99;0;_'
      MaxLength = 14
      TabOrder = 3
      Text = '           '
    end
    object edtRG: TEdit
      Left = 408
      Top = 128
      Width = 208
      Height = 23
      TabOrder = 4
    end
    object edtEmail: TEdit
      Left = 16
      Top = 176
      Width = 280
      Height = 23
      TabOrder = 5
    end
    object medTelefone: TMaskEdit
      Left = 320
      Top = 176
      Width = 160
      Height = 23
      EditMask = '!\(99\)99999\-9999;0;_'
      MaxLength = 14
      TabOrder = 6
      Text = '(  )     -    '
    end
    object grpEndereco: TGroupBox
      Left = 16
      Top = 224
      Width = 600
      Height = 221
      Caption = ' Endere'#231'o '
      TabOrder = 7
      object lblCEP: TLabel
        Left = 16
        Top = 28
        Width = 25
        Height = 15
        Caption = 'CEP'
      end
      object lblLogradouro: TLabel
        Left = 16
        Top = 76
        Width = 64
        Height = 15
        Caption = 'Logradouro'
      end
      object lblNumero: TLabel
        Left = 432
        Top = 76
        Width = 47
        Height = 15
        Caption = 'N'#250'mero'
      end
      object lblComplemento: TLabel
        Left = 16
        Top = 124
        Width = 79
        Height = 15
        Caption = 'Complemento'
      end
      object lblBairro: TLabel
        Left = 304
        Top = 124
        Width = 34
        Height = 15
        Caption = 'Bairro'
      end
      object lblCidade: TLabel
        Left = 16
        Top = 172
        Width = 38
        Height = 15
        Caption = 'Cidade'
      end
      object lblEstado: TLabel
        Left = 432
        Top = 172
        Width = 40
        Height = 15
        Caption = 'Estado'
      end
      object medCEP: TMaskEdit
        Left = 16
        Top = 44
        Width = 120
        Height = 23
        EditMask = '99999\-999;0;_'
        MaxLength = 9
        TabOrder = 0
        Text = '        '
        OnExit = medCEPExit
      end
      object btnBuscarCEP: TButton
        Left = 144
        Top = 43
        Width = 121
        Height = 25
        Caption = 'Buscar CEP'
        TabOrder = 1
        OnClick = btnBuscarCEPClick
      end
      object edtLogradouro: TEdit
        Left = 16
        Top = 92
        Width = 400
        Height = 23
        TabOrder = 2
      end
      object edtNumero: TEdit
        Left = 432
        Top = 92
        Width = 144
        Height = 23
        TabOrder = 3
      end
      object edtComplemento: TEdit
        Left = 16
        Top = 140
        Width = 272
        Height = 23
        TabOrder = 4
      end
      object edtBairro: TEdit
        Left = 304
        Top = 140
        Width = 272
        Height = 23
        TabOrder = 5
      end
      object edtCidade: TEdit
        Left = 16
        Top = 188
        Width = 400
        Height = 23
        TabOrder = 6
      end
      object edtEstado: TEdit
        Left = 432
        Top = 188
        Width = 60
        Height = 23
        CharCase = ecUpperCase
        MaxLength = 2
        TabOrder = 7
      end
    end
  end
end
