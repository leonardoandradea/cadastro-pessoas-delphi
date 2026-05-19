unit uTipoPessoa;

interface

uses
  System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client;

type
  TTipoPessoa = class
  private
    FId: Integer;
    FDescricao: string;
  public
    constructor Create; overload;
    constructor Create(AId: Integer; const ADescricao: string); overload;

    class function ListarTodos: TObjectList<TTipoPessoa>;
    class function BuscarPorId(AId: Integer): TTipoPessoa;

    property Id: Integer read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

uses
  uDM;

{ TTipoPessoa }

constructor TTipoPessoa.Create;
begin
  FId := 0;
  FDescricao := '';
end;

constructor TTipoPessoa.Create(AId: Integer; const ADescricao: string);
begin
  FId := AId;
  FDescricao := ADescricao;
end;

class function TTipoPessoa.ListarTodos: TObjectList<TTipoPessoa>;
var
  LQry: TFDQuery;
begin
  Result := TObjectList<TTipoPessoa>.Create(True);
  try
    LQry := TFDQuery.Create(nil);
    try
      LQry.Connection := DM.FDConnection;
      LQry.SQL.Text := 'SELECT ID, DESCRICAO FROM TIPO_PESSOA ORDER BY DESCRICAO';
      LQry.Open;
      while not LQry.Eof do
      begin
        Result.Add(TTipoPessoa.Create(
          LQry.FieldByName('ID').AsInteger,
          LQry.FieldByName('DESCRICAO').AsString));
        LQry.Next;
      end;
    finally
      LQry.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TTipoPessoa.BuscarPorId(AId: Integer): TTipoPessoa;
var
  LQry: TFDQuery;
begin
  Result := nil;
  LQry := TFDQuery.Create(nil);
  try
    LQry.Connection := DM.FDConnection;
    LQry.SQL.Text := 'SELECT ID, DESCRICAO FROM TIPO_PESSOA WHERE ID = :ID';
    LQry.ParamByName('ID').AsInteger := AId;
    LQry.Open;
    if LQry.Eof then
      Exit;
    Result := TTipoPessoa.Create;
    try
      Result.Id := LQry.FieldByName('ID').AsInteger;
      Result.Descricao := LQry.FieldByName('DESCRICAO').AsString;
    except
      FreeAndNil(Result);
      raise;
    end;
  finally
    LQry.Free;
  end;
end;

end.
