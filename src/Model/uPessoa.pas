unit uPessoa;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  uTipoPessoa, uEndereco;

type
  TPessoa = class
  private
    FId: Integer;
    FTipoPessoa: TTipoPessoa;
    FNome: string;
    FDataNascimento: TDate;
    FCpf: string;
    FRg: string;
    FEmail: string;
    FTelefone: string;
    FEndereco: TEndereco;
    procedure Inserir;
    procedure Atualizar;
    procedure SalvarEndereco;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Salvar;
    procedure Excluir;

    class function BuscarPorId(AId: Integer): TPessoa;
    class function ExisteCPF(const ACpf: string; AIdIgnorar: Integer = 0): Boolean;
    class function Listar(const AFiltroNome: string = '';
      AIdTipo: Integer = 0): TFDQuery;

    property Id: Integer read FId write FId;
    property TipoPessoa: TTipoPessoa read FTipoPessoa write FTipoPessoa;
    property Nome: string read FNome write FNome;
    property DataNascimento: TDate read FDataNascimento write FDataNascimento;
    property Cpf: string read FCpf write FCpf;
    property Rg: string read FRg write FRg;
    property Email: string read FEmail write FEmail;
    property Telefone: string read FTelefone write FTelefone;
    property Endereco: TEndereco read FEndereco write FEndereco;
  end;

implementation

uses
  uDM;

{ TPessoa }

constructor TPessoa.Create;
begin
  FId := 0;
  FTipoPessoa := TTipoPessoa.Create;
  FEndereco := TEndereco.Create;
end;

destructor TPessoa.Destroy;
begin
  FTipoPessoa.Free;
  FEndereco.Free;
  inherited;
end;

procedure TPessoa.Salvar;
begin
  // Id = 0 sinaliza registro novo (upsert por conven��o).
  DM.IniciarTransacao;
  try
    if FId = 0 then
      Inserir
    else
      Atualizar;
    SalvarEndereco;
    DM.Commit;
  except
    DM.Rollback;
    raise;
  end;
end;

procedure TPessoa.Inserir;
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := DM.FDConnection;
    LQry.SQL.Text :=
      'INSERT INTO PESSOA (ID_TIPO_PESSOA, NOME, DATA_NASCIMENTO, CPF, RG, EMAIL, TELEFONE) ' +
      'VALUES (:ID_TIPO_PESSOA, :NOME, :DATA_NASCIMENTO, :CPF, :RG, :EMAIL, :TELEFONE)';
    LQry.ParamByName('ID_TIPO_PESSOA').AsInteger := FTipoPessoa.Id;
    LQry.ParamByName('NOME').AsString := FNome;
    if FDataNascimento > 0 then
      LQry.ParamByName('DATA_NASCIMENTO').AsDate := FDataNascimento
    else
      LQry.ParamByName('DATA_NASCIMENTO').Clear;
    LQry.ParamByName('CPF').AsString := FCpf;
    LQry.ParamByName('RG').AsString := FRg;
    LQry.ParamByName('EMAIL').AsString := FEmail;
    LQry.ParamByName('TELEFONE').AsString := FTelefone;
    LQry.ExecSQL;

    FId := DM.FDConnection.GetLastAutoGenValue('');
  finally
    LQry.Free;
  end;
end;

procedure TPessoa.Atualizar;
var
  LQry: TFDQuery;
begin
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := DM.FDConnection;
    LQry.SQL.Text :=
      'UPDATE PESSOA SET ID_TIPO_PESSOA = :ID_TIPO_PESSOA, NOME = :NOME, ' +
      'DATA_NASCIMENTO = :DATA_NASCIMENTO, CPF = :CPF, RG = :RG, EMAIL = :EMAIL, ' +
      'TELEFONE = :TELEFONE, ATUALIZADO_EM = CURRENT_TIMESTAMP ' +
      'WHERE ID = :ID';
    LQry.ParamByName('ID_TIPO_PESSOA').AsInteger := FTipoPessoa.Id;
    LQry.ParamByName('NOME').AsString := FNome;
    if FDataNascimento > 0 then
      LQry.ParamByName('DATA_NASCIMENTO').AsDate := FDataNascimento
    else
      LQry.ParamByName('DATA_NASCIMENTO').Clear;
    LQry.ParamByName('CPF').AsString := FCpf;
    LQry.ParamByName('RG').AsString := FRg;
    LQry.ParamByName('EMAIL').AsString := FEmail;
    LQry.ParamByName('TELEFONE').AsString := FTelefone;
    LQry.ParamByName('ID').AsInteger := FId;
    LQry.ExecSQL;
  finally
    LQry.Free;
  end;
end;

procedure TPessoa.SalvarEndereco;
var
  LQry: TFDQuery;
  LExiste: Boolean;
begin
  if (FEndereco.Cep = '') and (FEndereco.Logradouro = '') then
    Exit;

  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := DM.FDConnection;

    LQry.SQL.Text := 'SELECT ID FROM ENDERECO WHERE ID_PESSOA = :ID_PESSOA';
    LQry.ParamByName('ID_PESSOA').AsInteger := FId;
    LQry.Open;
    LExiste := not LQry.IsEmpty;
    LQry.Close;

    if LExiste then
      LQry.SQL.Text :=
        'UPDATE ENDERECO SET CEP = :CEP, LOGRADOURO = :LOGRADOURO, NUMERO = :NUMERO, ' +
        'COMPLEMENTO = :COMPLEMENTO, BAIRRO = :BAIRRO, CIDADE = :CIDADE, ESTADO = :ESTADO ' +
        'WHERE ID_PESSOA = :ID_PESSOA'
    else
      LQry.SQL.Text :=
        'INSERT INTO ENDERECO (ID_PESSOA, CEP, LOGRADOURO, NUMERO, COMPLEMENTO, ' +
        'BAIRRO, CIDADE, ESTADO) VALUES ' +
        '(:ID_PESSOA, :CEP, :LOGRADOURO, :NUMERO, :COMPLEMENTO, :BAIRRO, :CIDADE, :ESTADO)';

    LQry.ParamByName('ID_PESSOA').AsInteger := FId;
    LQry.ParamByName('CEP').AsString := FEndereco.Cep;
    LQry.ParamByName('LOGRADOURO').AsString := FEndereco.Logradouro;
    LQry.ParamByName('NUMERO').AsString := FEndereco.Numero;
    LQry.ParamByName('COMPLEMENTO').AsString := FEndereco.Complemento;
    LQry.ParamByName('BAIRRO').AsString := FEndereco.Bairro;
    LQry.ParamByName('CIDADE').AsString := FEndereco.Cidade;
    LQry.ParamByName('ESTADO').AsString := FEndereco.Estado;
    LQry.ExecSQL;

    if not LExiste then
    begin
      FEndereco.Id := DM.FDConnection.GetLastAutoGenValue('');
      FEndereco.IdPessoa := FId;
    end;
  finally
    LQry.Free;
  end;
end;

procedure TPessoa.Excluir;
var
  LQry: TFDQuery;
begin
  // O ON DELETE CASCADE remove o endere�o vinculado.
  LQry := TFDQuery.Create(nil);
  try
    DM.IniciarTransacao;
    try
      LQry.Connection := DM.FDConnection;
      LQry.SQL.Text := 'DELETE FROM PESSOA WHERE ID = :ID';
      LQry.ParamByName('ID').AsInteger := FId;
      LQry.ExecSQL;
      DM.Commit;
    except
      DM.Rollback;
      raise;
    end;
  finally
    LQry.Free;
  end;
end;

class function TPessoa.ExisteCPF(const ACpf: string;
  AIdIgnorar: Integer): Boolean;
var
  LQry: TFDQuery;
begin
  // AIdIgnorar permite editar a pr�pria pessoa sem se considerar duplicata.
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := DM.FDConnection;
    LQry.SQL.Text := 'SELECT 1 FROM PESSOA WHERE CPF = :CPF AND ID <> :ID';
    LQry.ParamByName('CPF').AsString := ACpf;
    LQry.ParamByName('ID').AsInteger := AIdIgnorar;
    LQry.Open;
    Result := not LQry.IsEmpty;
  finally
    LQry.Free;
  end;
end;

class function TPessoa.BuscarPorId(AId: Integer): TPessoa;
var
  LQry: TFDQuery;
begin
  Result := nil;
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := DM.FDConnection;
    LQry.SQL.Text :=
      'SELECT P.ID, P.ID_TIPO_PESSOA, T.DESCRICAO AS TIPO_DESCRICAO, P.NOME, ' +
      'P.DATA_NASCIMENTO, P.CPF, P.RG, P.EMAIL, P.TELEFONE, ' +
      'E.ID AS END_ID, E.CEP, E.LOGRADOURO, E.NUMERO, E.COMPLEMENTO, ' +
      'E.BAIRRO, E.CIDADE, E.ESTADO ' +
      'FROM PESSOA P ' +
      'INNER JOIN TIPO_PESSOA T ON T.ID = P.ID_TIPO_PESSOA ' +
      'LEFT JOIN ENDERECO E ON E.ID_PESSOA = P.ID ' +
      'WHERE P.ID = :ID';
    LQry.ParamByName('ID').AsInteger := AId;
    LQry.Open;
    if LQry.IsEmpty then
      Exit;

    Result := TPessoa.Create;
    try
      Result.FId := LQry.FieldByName('ID').AsInteger;
      Result.FTipoPessoa.Id := LQry.FieldByName('ID_TIPO_PESSOA').AsInteger;
      Result.FTipoPessoa.Descricao := LQry.FieldByName('TIPO_DESCRICAO').AsString;
      Result.FNome := LQry.FieldByName('NOME').AsString;
      if not LQry.FieldByName('DATA_NASCIMENTO').IsNull then
        Result.FDataNascimento := LQry.FieldByName('DATA_NASCIMENTO').AsDateTime;
      Result.FCpf := LQry.FieldByName('CPF').AsString;
      Result.FRg := LQry.FieldByName('RG').AsString;
      Result.FEmail := LQry.FieldByName('EMAIL').AsString;
      Result.FTelefone := LQry.FieldByName('TELEFONE').AsString;

      if not LQry.FieldByName('END_ID').IsNull then
      begin
        Result.FEndereco.Id := LQry.FieldByName('END_ID').AsInteger;
        Result.FEndereco.IdPessoa := Result.FId;
        Result.FEndereco.Cep := LQry.FieldByName('CEP').AsString;
        Result.FEndereco.Logradouro := LQry.FieldByName('LOGRADOURO').AsString;
        Result.FEndereco.Numero := LQry.FieldByName('NUMERO').AsString;
        Result.FEndereco.Complemento := LQry.FieldByName('COMPLEMENTO').AsString;
        Result.FEndereco.Bairro := LQry.FieldByName('BAIRRO').AsString;
        Result.FEndereco.Cidade := LQry.FieldByName('CIDADE').AsString;
        Result.FEndereco.Estado := LQry.FieldByName('ESTADO').AsString;
      end;
    except
      FreeAndNil(Result);
      raise;
    end;
  finally
    LQry.Free;
  end;
end;

class function TPessoa.Listar(const AFiltroNome: string;
  AIdTipo: Integer): TFDQuery;
var
  LSQL: string;
begin
  // O caller assume ownership do TFDQuery retornado.
  LSQL :=
    'SELECT P.ID, P.NOME, T.DESCRICAO AS TIPO, P.CPF, P.EMAIL, P.TELEFONE, ' +
    'P.DATA_NASCIMENTO, E.CIDADE, E.ESTADO ' +
    'FROM PESSOA P ' +
    'INNER JOIN TIPO_PESSOA T ON T.ID = P.ID_TIPO_PESSOA ' +
    'LEFT  JOIN ENDERECO E ON E.ID_PESSOA = P.ID ' +
    'WHERE 1=1 ';

  if AFiltroNome <> '' then
    LSQL := LSQL + 'AND LOWER(P.NOME) LIKE LOWER(:NOME) ';
  if AIdTipo > 0 then
    LSQL := LSQL + 'AND P.ID_TIPO_PESSOA = :ID_TIPO ';

  LSQL := LSQL + 'ORDER BY P.NOME';

  Result := TFDQuery.Create(nil);
  try
    Result.Connection := DM.FDConnection;
    Result.SQL.Text := LSQL;
    if AFiltroNome <> '' then
      Result.ParamByName('NOME').AsString := '%' + AFiltroNome + '%';
    if AIdTipo > 0 then
      Result.ParamByName('ID_TIPO').AsInteger := AIdTipo;
    Result.Open;
  except
    Result.Free;
    raise;
  end;
end;

end.
