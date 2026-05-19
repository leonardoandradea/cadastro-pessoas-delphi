# Cadastro de Pessoas

Aplicação desktop em Delphi para gerenciamento de cadastro de pessoas
(clientes, fornecedores, funcionários), com CRUD completo, integração
ViaCEP e persistência local em SQLite.

## Stack

- **Delphi 12 Athens** (Community Edition) — VCL / Windows Desktop
- **FireDAC** + **SQLite** (banco local, arquivo único)
- **System.Net.HttpClient** + **System.JSON** — integração ViaCEP
- Arquitetura **MVC** (Model em estilo *Active Record*)

## Funcionalidades

### CRUD
- Cadastro de pessoas com tipo (Cliente / Fornecedor / Funcionário)
- Listagem com filtro por nome e por tipo
- Edição e exclusão com confirmação
- Duplo clique no grid abre a edição

### Validações
- Campos obrigatórios sinalizados nos labels (`*`)
- CPF único no sistema (UNIQUE no banco + checagem aplicacional)
- Validação de e-mail por expressão regular
- Máscaras de CPF, telefone e CEP

### Integração ViaCEP
- Busca automática ao sair do campo CEP (e via botão)
- Preenchimento de logradouro, bairro, cidade e estado
- Edição manual permitida após o preenchimento automático
- Tratamento de CEP inexistente e falhas de rede

## Como executar

### Pré-requisitos
- Delphi 12 (Athens) Community Edition (ou Delphi 11.x)
- Conexão com a internet (para o ViaCEP)

### Passos
1. Abra `CadastroPessoas.dproj` no Delphi
2. Plataforma alvo: `Win32` (Debug ou Release)
3. **F9** para compilar e executar

Na primeira execução o aplicativo cria automaticamente
`Data/cadastro_pessoas.db` ao lado do executável e popula os tipos
de pessoa padrão.

> Se o `.dproj` apresentar incompatibilidade de versão, crie um novo
> projeto VCL Forms Application, remova o form default e adicione os
> arquivos da pasta `src/`. O Delphi gera um novo `.dproj` automaticamente.

## Estrutura

```
.
├── CadastroPessoas.dpr / .dproj   # Arquivos do projeto Delphi
├── Database/
│   └── script.sql                  # DDL completo do banco
└── src/
    ├── Model/                      # Entidades + persistência (Active Record)
    │   ├── uPessoa.pas
    │   ├── uEndereco.pas
    │   └── uTipoPessoa.pas
    ├── Controller/                 # Validações e orquestração
    │   ├── uPessoaController.pas
    │   └── uViaCEPService.pas
    ├── DataModule/
    │   └── uDM.pas / .dfm          # Conexão FireDAC + SQLite
    ├── View/                       # Forms VCL
    │   ├── uFrmPrincipal.pas / .dfm
    │   └── uFrmCadastroPessoa.pas / .dfm
    └── Utils/
        ├── uConstantes.pas         # Constantes (mensagens, máscaras)
        └── uValidador.pas          # Validações de CPF, e-mail e formatação
```

## Modelo de Dados

Três tabelas normalizadas:

| Tabela        | Relação                              |
|---------------|--------------------------------------|
| `TIPO_PESSOA` | Catálogo de tipos                    |
| `PESSOA`      | FK para `TIPO_PESSOA` · `CPF UNIQUE` |
| `ENDERECO`    | 1:1 com `PESSOA` · `ON DELETE CASCADE` |

Identificadores de banco (tabelas, colunas, aliases, parâmetros)
seguem o padrão **CAIXA ALTA**.

## Decisões de implementação

- **Active Record**: o próprio Model conhece o SQL. Mantém o número
  de camadas baixo, adequado ao escopo.
- **Transações explícitas** em `Salvar` e `Excluir` cobrem múltiplas
  tabelas (pessoa + endereço) atomicamente.
- **`PRAGMA foreign_keys = ON`** habilitado em runtime — SQLite não
  enforce FKs por default.
- **Validações no Controller** para evitar consultas a cada setter.
- **Exceções tipadas** (`EPessoaValidacao`, `EViaCEPException`) para
  a View distinguir erro de usuário de erro de sistema.
- **Auto-setup do banco** na primeira execução via `script.sql`.

## Licença

Projeto desenvolvido para fins acadêmicos.
