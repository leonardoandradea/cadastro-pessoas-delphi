unit uPessoaController;

interface

uses
  System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client,
  uPessoa, uTipoPessoa;

type
  EPessoaValidacao = class(Exception);

  TPessoaController = class
  private
    procedure ValidarPessoa(APessoa: TPessoa);
  public
    function Salvar(APessoa: TPessoa): Integer;
    procedure Excluir(AId: Integer);
    function CarregarPorId(AId: Integer): TPessoa;
    function Listar(const AFiltroNome: string = '';
      AIdTipo: Integer = 0): TFDQuery;
    function ListarTipos: TObjectList<TTipoPessoa>;
  end;

implementation

uses
  uValidador, uConstantes;

{ TPessoaController }

procedure TPessoaController.ValidarPessoa(APessoa: TPessoa);
begin
  if APessoa.TipoPessoa.Id <= 0 then
    raise EPessoaValidacao.CreateFmt(MSG_OBRIGATORIO, ['Tipo de pessoa']);

  if Trim(APessoa.Nome) = '' then
    raise EPessoaValidacao.CreateFmt(MSG_OBRIGATORIO, ['Nome completo']);

  if Trim(APessoa.Cpf) = '' then
    raise EPessoaValidacao.CreateFmt(MSG_OBRIGATORIO, ['CPF']);

  if not TValidador.ValidarCPF(APessoa.Cpf) then
    raise EPessoaValidacao.Create(MSG_CPF_INVALIDO);

  // Persiste o CPF formatado para garantir consist�ncia visual no banco.
  APessoa.Cpf := TValidador.FormatarCPF(APessoa.Cpf);

  if (Trim(APessoa.Email) <> '') and not TValidador.ValidarEmail(APessoa.Email) then
    raise EPessoaValidacao.Create(MSG_EMAIL_INVALIDO);

  if TPessoa.ExisteCPF(APessoa.Cpf, APessoa.Id) then
    raise EPessoaValidacao.Create(MSG_CPF_DUPLICADO);
end;

function TPessoaController.Salvar(APessoa: TPessoa): Integer;
begin
  ValidarPessoa(APessoa);
  APessoa.Salvar;
  Result := APessoa.Id;
end;

procedure TPessoaController.Excluir(AId: Integer);
var
  LPessoa: TPessoa;
begin
  LPessoa := TPessoa.BuscarPorId(AId);
  if not Assigned(LPessoa) then
    Exit;
  try
    LPessoa.Excluir;
  finally
    LPessoa.Free;
  end;
end;

function TPessoaController.CarregarPorId(AId: Integer): TPessoa;
begin
  Result := TPessoa.BuscarPorId(AId);
end;

function TPessoaController.Listar(const AFiltroNome: string;
  AIdTipo: Integer): TFDQuery;
begin
  Result := TPessoa.Listar(AFiltroNome, AIdTipo);
end;

function TPessoaController.ListarTipos: TObjectList<TTipoPessoa>;
begin
  Result := TTipoPessoa.ListarTodos;
end;

end.
