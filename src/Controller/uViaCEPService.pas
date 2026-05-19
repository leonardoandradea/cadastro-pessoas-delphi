unit uViaCEPService;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  System.Net.HttpClient, System.Net.URLClient,
  uEndereco;

type
  EViaCEPException = class(Exception);

  TViaCEPService = class
  public
    // Retorna nil quando o CEP n�o existe (erro:true na resposta).
    // Levanta EViaCEPException em falhas de rede ou HTTP.
    class function ConsultarCEP(const ACep: string): TEndereco;
  end;

implementation

uses
  uConstantes, uValidador;

{ TViaCEPService }

class function TViaCEPService.ConsultarCEP(const ACep: string): TEndereco;
var
  LHttp: THTTPClient;
  LResp: IHTTPResponse;
  LCepLimpo, LUrl, LBody: string;
  LJson: TJSONObject;
  function Get(const AKey: string): string;
  var
    LVal: TJSONValue;
  begin
    LVal := LJson.GetValue(AKey);
    if Assigned(LVal) then
      Result := LVal.Value
    else
      Result := '';
  end;
begin
  Result := nil;

  LCepLimpo := TValidador.SomenteNumeros(ACep);
  if Length(LCepLimpo) <> 8 then
    raise EViaCEPException.Create('CEP deve conter 8 d�gitos.');

  LUrl := Format(VIACEP_URL_BASE, [LCepLimpo]);

  LHttp := THTTPClient.Create;
  try
    LHttp.ConnectionTimeout := VIACEP_TIMEOUT_MS;
    LHttp.ResponseTimeout := VIACEP_TIMEOUT_MS;
    try
      LResp := LHttp.Get(LUrl);
    except
      on E: Exception do
        raise EViaCEPException.CreateFmt(MSG_ERRO_VIACEP, [E.Message]);
    end;

    if LResp.StatusCode <> 200 then
      raise EViaCEPException.CreateFmt(MSG_ERRO_VIACEP,
        [IntToStr(LResp.StatusCode) + ' ' + LResp.StatusText]);

    LBody := LResp.ContentAsString(TEncoding.UTF8);
    LJson := TJSONObject.ParseJSONValue(LBody) as TJSONObject;
    if not Assigned(LJson) then
      raise EViaCEPException.Create('Resposta inv�lida do ViaCEP.');

    try
      if (LJson.GetValue('erro') <> nil) and
         (LowerCase(LJson.GetValue('erro').Value) = 'true') then
        Exit(nil);

      Result := TEndereco.Create;
      Result.Cep := TValidador.FormatarCEP(LCepLimpo);
      Result.Logradouro := Get('logradouro');
      Result.Bairro := Get('bairro');
      Result.Cidade := Get('localidade');
      Result.Estado := Get('uf');
    finally
      LJson.Free;
    end;
  finally
    LHttp.Free;
  end;
end;

end.
