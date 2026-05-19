unit uEndereco;

interface

type
  TEndereco = class
  private
    FId: Integer;
    FIdPessoa: Integer;
    FCep: string;
    FLogradouro: string;
    FNumero: string;
    FComplemento: string;
    FBairro: string;
    FCidade: string;
    FEstado: string;
  public
    constructor Create;

    property Id: Integer read FId write FId;
    property IdPessoa: Integer read FIdPessoa write FIdPessoa;
    property Cep: string read FCep write FCep;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property Cidade: string read FCidade write FCidade;
    property Estado: string read FEstado write FEstado;
  end;

implementation

constructor TEndereco.Create;
begin
  FId := 0;
  FIdPessoa := 0;
end;

end.
