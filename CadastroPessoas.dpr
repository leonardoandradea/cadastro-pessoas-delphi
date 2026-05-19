program CadastroPessoas;

uses
  Vcl.Forms,
  uFrmPrincipal in 'src\View\uFrmPrincipal.pas' {FrmPrincipal},
  uFrmCadastroPessoa in 'src\View\uFrmCadastroPessoa.pas' {FrmCadastroPessoa},
  uDM in 'src\DataModule\uDM.pas' {DM: TDataModule},
  uPessoa in 'src\Model\uPessoa.pas',
  uEndereco in 'src\Model\uEndereco.pas',
  uTipoPessoa in 'src\Model\uTipoPessoa.pas',
  uPessoaController in 'src\Controller\uPessoaController.pas',
  uViaCEPService in 'src\Controller\uViaCEPService.pas',
  uValidador in 'src\Utils\uValidador.pas',
  uConstantes in 'src\Utils\uConstantes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Cadastro de Pessoas';
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
