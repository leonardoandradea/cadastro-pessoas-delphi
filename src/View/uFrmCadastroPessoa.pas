unit uFrmCadastroPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons,
  uPessoa, uTipoPessoa, uPessoaController;

type
  TFrmCadastroPessoa = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    pnlRodape: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    scrConteudo: TScrollBox;
    lblTipo: TLabel;
    cbTipo: TComboBox;
    lblNome: TLabel;
    edtNome: TEdit;
    lblNascimento: TLabel;
    dtpNascimento: TDateTimePicker;
    lblCPF: TLabel;
    medCPF: TMaskEdit;
    lblRG: TLabel;
    edtRG: TEdit;
    lblEmail: TLabel;
    edtEmail: TEdit;
    lblTelefone: TLabel;
    medTelefone: TMaskEdit;
    grpEndereco: TGroupBox;
    lblCEP: TLabel;
    medCEP: TMaskEdit;
    btnBuscarCEP: TButton;
    lblLogradouro: TLabel;
    edtLogradouro: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    lblComplemento: TLabel;
    edtComplemento: TEdit;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblCidade: TLabel;
    edtCidade: TEdit;
    lblEstado: TLabel;
    edtEstado: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnBuscarCEPClick(Sender: TObject);
    procedure medCEPExit(Sender: TObject);
  private
    FPessoa: TPessoa;
    FController: TPessoaController;
    FTipos: TObjectList<TTipoPessoa>;
    FModoEdicao: Boolean;
    procedure CarregarTipos;
    procedure PreencherCampos;
    procedure CapturarCampos;
    procedure ConsultarCEP;
  public
    // Editar(nil) entra em modo inclus�o; passar uma pessoa entra em edi��o.
    function Editar(APessoa: TPessoa): Boolean;
  end;

implementation

uses
  uValidador, uViaCEPService, uConstantes, uEndereco;

{$R *.dfm}

procedure TFrmCadastroPessoa.FormCreate(Sender: TObject);
begin
  FController := TPessoaController.Create;
  dtpNascimento.MaxDate := Date;

  // Aplica as m�scaras em runtime para sobrescrever qualquer valor cacheado no .dfm.
  medCPF.EditMask      := MASCARA_CPF;
  medTelefone.EditMask := MASCARA_TELEFONE;
  medCEP.EditMask      := MASCARA_CEP;
end;

procedure TFrmCadastroPessoa.FormDestroy(Sender: TObject);
begin
  FTipos.Free;
  FController.Free;
end;

procedure TFrmCadastroPessoa.CarregarTipos;
var
  I: Integer;
begin
  FreeAndNil(FTipos);
  FTipos := FController.ListarTipos;
  cbTipo.Items.Clear;
  for I := 0 to FTipos.Count - 1 do
    cbTipo.Items.AddObject(FTipos[I].Descricao, FTipos[I]);
end;

procedure TFrmCadastroPessoa.PreencherCampos;
var
  I: Integer;
begin
  if not Assigned(FPessoa) then Exit;

  for I := 0 to FTipos.Count - 1 do
    if FTipos[I].Id = FPessoa.TipoPessoa.Id then
    begin
      cbTipo.ItemIndex := I;
      Break;
    end;

  edtNome.Text := FPessoa.Nome;
  if FPessoa.DataNascimento > 0 then
    dtpNascimento.Date := FPessoa.DataNascimento
  else
    dtpNascimento.Date := Date;
  medCPF.Text := TValidador.SomenteNumeros(FPessoa.Cpf);
  edtRG.Text := FPessoa.Rg;
  edtEmail.Text := FPessoa.Email;
  medTelefone.Text := TValidador.SomenteNumeros(FPessoa.Telefone);

  medCEP.Text := TValidador.SomenteNumeros(FPessoa.Endereco.Cep);
  edtLogradouro.Text := FPessoa.Endereco.Logradouro;
  edtNumero.Text := FPessoa.Endereco.Numero;
  edtComplemento.Text := FPessoa.Endereco.Complemento;
  edtBairro.Text := FPessoa.Endereco.Bairro;
  edtCidade.Text := FPessoa.Endereco.Cidade;
  edtEstado.Text := FPessoa.Endereco.Estado;
end;

procedure TFrmCadastroPessoa.CapturarCampos;
begin
  if cbTipo.ItemIndex >= 0 then
  begin
    FPessoa.TipoPessoa.Id := TTipoPessoa(cbTipo.Items.Objects[cbTipo.ItemIndex]).Id;
    FPessoa.TipoPessoa.Descricao := cbTipo.Items[cbTipo.ItemIndex];
  end
  else
    FPessoa.TipoPessoa.Id := 0;

  FPessoa.Nome := Trim(edtNome.Text);
  FPessoa.DataNascimento := dtpNascimento.Date;
  FPessoa.Cpf := TValidador.SomenteNumeros(medCPF.Text);
  FPessoa.Rg := Trim(edtRG.Text);
  FPessoa.Email := Trim(edtEmail.Text);
  FPessoa.Telefone := TValidador.FormatarTelefone(medTelefone.Text);

  FPessoa.Endereco.Cep := TValidador.FormatarCEP(medCEP.Text);
  FPessoa.Endereco.Logradouro := Trim(edtLogradouro.Text);
  FPessoa.Endereco.Numero := Trim(edtNumero.Text);
  FPessoa.Endereco.Complemento := Trim(edtComplemento.Text);
  FPessoa.Endereco.Bairro := Trim(edtBairro.Text);
  FPessoa.Endereco.Cidade := Trim(edtCidade.Text);
  FPessoa.Endereco.Estado := Trim(edtEstado.Text);
end;

procedure TFrmCadastroPessoa.ConsultarCEP;
var
  LEnd: TEndereco;
  LCep: string;
begin
  LCep := TValidador.SomenteNumeros(medCEP.Text);
  if Length(LCep) <> 8 then
    Exit;

  Screen.Cursor := crHourGlass;
  try
    try
      LEnd := TViaCEPService.ConsultarCEP(LCep);
    except
      on E: EViaCEPException do
      begin
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    if not Assigned(LEnd) then
    begin
      MessageDlg(MSG_CEP_NAO_LOCALIZADO, mtInformation, [mbOK], 0);
      Exit;
    end;

    try
      edtLogradouro.Text := LEnd.Logradouro;
      edtBairro.Text := LEnd.Bairro;
      edtCidade.Text := LEnd.Cidade;
      edtEstado.Text := LEnd.Estado;
      edtNumero.SetFocus;
    finally
      LEnd.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrmCadastroPessoa.btnBuscarCEPClick(Sender: TObject);
begin
  ConsultarCEP;
end;

procedure TFrmCadastroPessoa.medCEPExit(Sender: TObject);
begin
  if Length(TValidador.SomenteNumeros(medCEP.Text)) = 8 then
    ConsultarCEP;
end;

procedure TFrmCadastroPessoa.btnSalvarClick(Sender: TObject);
begin
  try
    CapturarCampos;
    FController.Salvar(FPessoa);
    ModalResult := mrOk;
  except
    on E: EPessoaValidacao do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
    on E: Exception do
      MessageDlg('Erro ao salvar: ' + E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFrmCadastroPessoa.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmCadastroPessoa.FormKeyPress(Sender: TObject; var Key: Char);
begin
  // Converte Enter em Tab para avan�ar entre campos. Bot�es mant�m Enter como clique.
  if (Key = #13) and not (ActiveControl is TButton) then
  begin
    Key := #0;
    SelectNext(ActiveControl, True, True);
  end;
end;

function TFrmCadastroPessoa.Editar(APessoa: TPessoa): Boolean;
begin
  CarregarTipos;
  FModoEdicao := Assigned(APessoa);
  if FModoEdicao then
  begin
    FPessoa := APessoa;
    lblTitulo.Caption := 'Editar Pessoa';
  end
  else
  begin
    FPessoa := TPessoa.Create;
    lblTitulo.Caption := 'Nova Pessoa';
  end;
  try
    PreencherCampos;
    Result := ShowModal = mrOk;
  finally
    // Em inclus�o o pr�prio form � dono do objeto criado; em edi��o, o caller libera.
    if not FModoEdicao then
      FreeAndNil(FPessoa);
  end;
end;

end.
