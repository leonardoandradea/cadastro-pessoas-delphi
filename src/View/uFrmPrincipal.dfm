object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Cadastro de Pessoas'
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    Color = 4144959
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 20
      Top = 14
      Width = 174
      Height = 28
      Caption = 'Cadastro de Pessoas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlFiltros: TPanel
    Left = 0
    Top = 56
    Width = 1000
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblBuscaNome: TLabel
      Left = 16
      Top = 8
      Width = 90
      Height = 15
      Caption = 'Pesquisar por nome'
    end
    object lblFiltroTipo: TLabel
      Left = 360
      Top = 8
      Width = 78
      Height = 15
      Caption = 'Tipo de pessoa'
    end
    object edtBuscaNome: TEdit
      Left = 16
      Top = 28
      Width = 336
      Height = 23
      TabOrder = 0
      OnKeyDown = edtBuscaNomeKeyDown
    end
    object cbFiltroTipo: TComboBox
      Left = 360
      Top = 28
      Width = 200
      Height = 23
      Style = csDropDownList
      TabOrder = 1
    end
    object btnFiltrar: TButton
      Left = 576
      Top = 26
      Width = 89
      Height = 27
      Caption = 'Filtrar'
      TabOrder = 2
      OnClick = btnFiltrarClick
    end
    object btnLimpar: TButton
      Left = 671
      Top = 26
      Width = 89
      Height = 27
      Caption = 'Limpar'
      TabOrder = 3
      OnClick = btnLimparClick
    end
  end
  object pnlAcoes: TPanel
    Left = 0
    Top = 543
    Width = 1000
    Height = 57
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnNovo: TButton
      Left = 16
      Top = 13
      Width = 100
      Height = 32
      Caption = 'Novo'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnEditar: TButton
      Left = 122
      Top = 13
      Width = 100
      Height = 32
      Caption = 'Editar'
      TabOrder = 1
      OnClick = btnEditarClick
    end
    object btnExcluir: TButton
      Left = 228
      Top = 13
      Width = 100
      Height = 32
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = btnExcluirClick
    end
    object btnAtualizar: TButton
      Left = 334
      Top = 13
      Width = 100
      Height = 32
      Caption = 'Atualizar'
      TabOrder = 3
      OnClick = btnAtualizarClick
    end
    object btnSair: TButton
      Left = 884
      Top = 13
      Width = 100
      Height = 32
      Caption = 'Sair'
      TabOrder = 4
      OnClick = btnSairClick
    end
  end
  object grdPessoas: TDBGrid
    Left = 0
    Top = 128
    Width = 1000
    Height = 415
    Align = alClient
    DataSource = DataSourcePessoas
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick]
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI Semibold'
    TitleFont.Style = [fsBold]
    OnDblClick = grdPessoasDblClick
  end
  object DataSourcePessoas: TDataSource
    Left = 880
    Top = 160
  end
end
