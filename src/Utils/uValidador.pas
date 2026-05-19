unit uValidador;

interface

uses
  System.SysUtils, System.RegularExpressions, System.StrUtils;

type
  TValidador = class
  public
    class function SomenteNumeros(const AValor: string): string; static;
    class function ValidarCPF(const ACpf: string): Boolean; static;
    class function FormatarCPF(const ACpf: string): string; static;
    class function ValidarEmail(const AEmail: string): Boolean; static;
    class function FormatarCEP(const ACep: string): string; static;
    class function FormatarTelefone(const ATelefone: string): string; static;
  end;

implementation

{ TValidador }

class function TValidador.SomenteNumeros(const AValor: string): string;
var
  C: Char;
begin
  Result := '';
  for C in AValor do
    if CharInSet(C, ['0'..'9']) then
      Result := Result + C;
end;

class function TValidador.ValidarCPF(const ACpf: string): Boolean;
begin
  // Aceita qualquer combina��o de 11 d�gitos - n�o valida o c�lculo
  // dos d�gitos verificadores. CPFs fict�cios (111.111.111-11) passam.
  Result := Length(SomenteNumeros(ACpf)) = 11;
end;

class function TValidador.FormatarCPF(const ACpf: string): string;
var
  LCpf: string;
begin
  LCpf := SomenteNumeros(ACpf);
  if Length(LCpf) <> 11 then
    Exit(ACpf);
  Result := Copy(LCpf, 1, 3) + '.' + Copy(LCpf, 4, 3) + '.' +
            Copy(LCpf, 7, 3) + '-' + Copy(LCpf, 10, 2);
end;

class function TValidador.ValidarEmail(const AEmail: string): Boolean;
const
  REGEX_EMAIL = '^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$';
begin
  if Trim(AEmail) = '' then
    Exit(False);
  Result := TRegEx.IsMatch(AEmail, REGEX_EMAIL);
end;

class function TValidador.FormatarCEP(const ACep: string): string;
var
  LCep: string;
begin
  LCep := SomenteNumeros(ACep);
  if Length(LCep) <> 8 then
    Exit(ACep);
  Result := Copy(LCep, 1, 5) + '-' + Copy(LCep, 6, 3);
end;

class function TValidador.FormatarTelefone(const ATelefone: string): string;
var
  LTel: string;
begin
  LTel := SomenteNumeros(ATelefone);
  case Length(LTel) of
    10: Result := Format('(%s) %s-%s',
          [Copy(LTel, 1, 2), Copy(LTel, 3, 4), Copy(LTel, 7, 4)]);
    11: Result := Format('(%s) %s-%s',
          [Copy(LTel, 1, 2), Copy(LTel, 3, 5), Copy(LTel, 8, 4)]);
  else
    Result := ATelefone;
  end;
end;

end.
