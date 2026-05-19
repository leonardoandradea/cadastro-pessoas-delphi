unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.UI,
  FireDAC.DApt;

type
  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    function ObterCaminhoBanco: string;
    procedure ConfigurarConexao;
    procedure CriarEstruturaBanco;
  public
    procedure IniciarTransacao;
    procedure Commit;
    procedure Rollback;
  end;

var
  DM: TDM;

implementation

uses
  uConstantes;

{$R *.dfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexao;
  FDConnection.Connected := True;
  CriarEstruturaBanco;
end;

function TDM.ObterCaminhoBanco: string;
var
  LPasta: string;
begin
  LPasta := TPath.Combine(ExtractFilePath(ParamStr(0)), DB_PASTA);
  if not TDirectory.Exists(LPasta) then
    TDirectory.CreateDirectory(LPasta);
  Result := TPath.Combine(LPasta, DB_NOME_ARQUIVO);
end;

procedure TDM.ConfigurarConexao;
begin
  FDConnection.Params.Clear;
  FDConnection.Params.DriverID := 'SQLite';
  FDConnection.Params.Database := ObterCaminhoBanco;
  FDConnection.Params.Add('LockingMode=Normal');
  FDConnection.Params.Add('Synchronous=Full');
  FDConnection.Params.Add('SharedCache=False');
  FDConnection.LoginPrompt := False;
end;

procedure TDM.CriarEstruturaBanco;
var
  LScript: TStringList;
  LCaminhoScript: string;
  LComando: string;
  I: Integer;
  LBuffer: TStringBuilder;
begin
  LCaminhoScript := TPath.Combine(ExtractFilePath(ParamStr(0)),
    TPath.Combine('Database', 'script.sql'));

  if not TFile.Exists(LCaminhoScript) then
    Exit;

  // PRAGMA foreign_keys s� vale por sess�o e n�o � habilitado por default no SQLite.
  FDConnection.ExecSQL('PRAGMA foreign_keys = ON');

  LScript := TStringList.Create;
  LBuffer := TStringBuilder.Create;
  try
    LScript.LoadFromFile(LCaminhoScript, TEncoding.UTF8);
    for I := 0 to LScript.Count - 1 do
    begin
      LComando := Trim(LScript[I]);
      if (LComando = '') or LComando.StartsWith('--') then
        Continue;
      LBuffer.Append(LScript[I]).Append(sLineBreak);
      if LComando.EndsWith(';') then
      begin
        try
          FDConnection.ExecSQL(LBuffer.ToString);
        except
          // Comandos idempotentes (CREATE IF NOT EXISTS, INSERT OR IGNORE)
          // podem falhar silenciosamente em re-execu��o.
          on Exception do ;
        end;
        LBuffer.Clear;
      end;
    end;
  finally
    LBuffer.Free;
    LScript.Free;
  end;
end;

procedure TDM.IniciarTransacao;
begin
  if not FDConnection.InTransaction then
    FDConnection.StartTransaction;
end;

procedure TDM.Commit;
begin
  if FDConnection.InTransaction then
    FDConnection.Commit;
end;

procedure TDM.Rollback;
begin
  if FDConnection.InTransaction then
    FDConnection.Rollback;
end;

end.
