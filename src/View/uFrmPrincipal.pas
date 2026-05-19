unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB,
  FireDAC.Comp.Client,
  uPessoaController, uTipoPessoa;

type
  TFrmPrincipal = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    pnlFiltros: TPanel;
    lblBuscaNome: TLabel;
    edtBuscaNome: TEdit;
    lblFiltroTipo: TLabel;
    cbFiltroTipo: TComboBox;
    btnFiltrar: TButton;
    btnLimpar: TButton;
    pnlAcoes: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnAtualizar: TButton;
    btnSair: TButton;
    grdPessoas: TDBGrid;
    DataSourcePessoas: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure grdPessoasDblClick(Sender: TObject);
    procedure edtBuscaNomeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FController: TPessoaController;
    FTipos: TObjectList<TTipoPessoa>;
    FQry: TFDQuery;
    procedure CarregarTipos;
    procedure CarregarLista;
    procedure ConfigurarGrid;
    function IdSelecionado: Integer;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

uses
  uDM, uFrmCadastroPessoa, uPessoa, uConstantes;

{$R *.dfm}

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  Caption := MSG_TITULO_APP;
  FController := TPessoaController.Create;
  CarregarTipos;
  CarregarLista;
  ConfigurarGrid;
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  FQry.Free;
  FTipos.Free;
  FController.Free;
end;

procedure TFrmPrincipal.CarregarTipos;
var
  I: Integer;
begin
  FreeAndNil(FTipos);
  FTipos := FController.ListarTipos;
  cbFiltroTipo.Items.Clear;
  cbFiltroTipo.Items.AddObject('(Todos)', nil);
  for I := 0 to FTipos.Count - 1 do
    cbFiltroTipo.Items.AddObject(FTipos[I].Descricao, FTipos[I]);
  cbFiltroTipo.ItemIndex := 0;
end;

procedure TFrmPrincipal.CarregarLista;
var
  LIdTipo: Integer;
begin
  LIdTipo := 0;
  if (cbFiltroTipo.ItemIndex > 0) and
     Assigned(cbFiltroTipo.Items.Objects[cbFiltroTipo.ItemIndex]) then
    LIdTipo := TTipoPessoa(cbFiltroTipo.Items.Objects[cbFiltroTipo.ItemIndex]).Id;

  FreeAndNil(FQry);
  FQry := FController.Listar(Trim(edtBuscaNome.Text), LIdTipo);
  DataSourcePessoas.DataSet := FQry;
end;

procedure TFrmPrincipal.ConfigurarGrid;
begin
  if FQry.FieldList.IndexOf('ID') >= 0 then
  begin
    FQry.FieldByName('ID').DisplayLabel := 'ID';
    FQry.FieldByName('ID').Visible := False;
    FQry.FieldByName('NOME').DisplayLabel := 'Nome';
    FQry.FieldByName('TIPO').DisplayLabel := 'Tipo';
    FQry.FieldByName('CPF').DisplayLabel := 'CPF';
    FQry.FieldByName('EMAIL').DisplayLabel := 'E-mail';
    FQry.FieldByName('TELEFONE').DisplayLabel := 'Telefone';
    FQry.FieldByName('DATA_NASCIMENTO').DisplayLabel := 'Nascimento';
    FQry.FieldByName('CIDADE').DisplayLabel := 'Cidade';
    FQry.FieldByName('ESTADO').DisplayLabel := 'UF';
  end;
end;

function TFrmPrincipal.IdSelecionado: Integer;
begin
  if Assigned(FQry) and (not FQry.IsEmpty) then
    Result := FQry.FieldByName('ID').AsInteger
  else
    Result := 0;
end;

procedure TFrmPrincipal.btnNovoClick(Sender: TObject);
var
  LFrm: TFrmCadastroPessoa;
begin
  LFrm := TFrmCadastroPessoa.Create(Self);
  try
    if LFrm.Editar(nil) then
      CarregarLista;
  finally
    LFrm.Free;
  end;
end;

procedure TFrmPrincipal.btnEditarClick(Sender: TObject);
var
  LFrm: TFrmCadastroPessoa;
  LPessoa: TPessoa;
  LId: Integer;
begin
  LId := IdSelecionado;
  if LId = 0 then Exit;

  LPessoa := FController.CarregarPorId(LId);
  if not Assigned(LPessoa) then Exit;

  LFrm := TFrmCadastroPessoa.Create(Self);
  try
    if LFrm.Editar(LPessoa) then
      CarregarLista;
  finally
    LFrm.Free;
    LPessoa.Free;
  end;
end;

procedure TFrmPrincipal.btnExcluirClick(Sender: TObject);
var
  LId: Integer;
  LNome: string;
begin
  LId := IdSelecionado;
  if LId = 0 then Exit;
  LNome := FQry.FieldByName('NOME').AsString;

  if MessageDlg(Format(MSG_CONFIRMAR_REMOCAO, [LNome]),
       mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  try
    FController.Excluir(LId);
    CarregarLista;
  except
    on E: Exception do
      MessageDlg('Erro ao excluir: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  CarregarLista;
end;

procedure TFrmPrincipal.btnFiltrarClick(Sender: TObject);
begin
  CarregarLista;
end;

procedure TFrmPrincipal.btnLimparClick(Sender: TObject);
begin
  edtBuscaNome.Text := '';
  cbFiltroTipo.ItemIndex := 0;
  CarregarLista;
end;

procedure TFrmPrincipal.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrincipal.grdPessoasDblClick(Sender: TObject);
begin
  btnEditarClick(Sender);
end;

procedure TFrmPrincipal.edtBuscaNomeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    CarregarLista;
end;

end.
