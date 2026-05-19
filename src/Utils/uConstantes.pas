unit uConstantes;

interface

const
  DB_NOME_ARQUIVO   = 'cadastro_pessoas.db';
  DB_PASTA          = 'Data';

  VIACEP_URL_BASE   = 'https://viacep.com.br/ws/%s/json/';
  VIACEP_TIMEOUT_MS = 5000;

  // O caractere "9" permite d�gito opcional - sem ele o TMaskEdit
  // bloqueia a sa�da do campo com conte�do parcial.
  MASCARA_CPF      = '999\.999\.999\-99;0;_';
  MASCARA_TELEFONE = '!\(99\)99999\-9999;0;_';
  MASCARA_CEP      = '99999\-999;0;_';

  MSG_TITULO_APP         = 'Cadastro de Pessoas';
  MSG_CONFIRMAR_REMOCAO  = 'Deseja realmente excluir o registro de "%s"?';
  MSG_CPF_INVALIDO       = 'CPF informado � inv�lido.';
  MSG_CPF_DUPLICADO      = 'J� existe uma pessoa cadastrada com este CPF.';
  MSG_EMAIL_INVALIDO     = 'E-mail informado � inv�lido.';
  MSG_CEP_NAO_LOCALIZADO = 'CEP n�o localizado.';
  MSG_ERRO_VIACEP        = 'N�o foi poss�vel consultar o ViaCEP: %s';
  MSG_OBRIGATORIO        = 'O campo "%s" � obrigat�rio.';

implementation

end.
