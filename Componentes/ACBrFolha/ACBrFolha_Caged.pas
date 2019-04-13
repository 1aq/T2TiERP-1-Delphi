{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2012   Albert Eije                          }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 01/05/2013: Albert Eije
|*  - Cria��o e distribui��o da Primeira Versao
*******************************************************************************}

unit ACBrFolha_Caged;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils;

type

  {******************************************************************************
  |*  Descri��o dos valores de campos.                                          *
  |* A  = String                                                                *
  |* AN = String                                                                *
  |* N  = String                                                                *
  |* V  = Double                                                                *
  |* D  = DateTime                                                              *
  |* Trata as situa��es com valores e datas.                                    *
  |* Nota: Todas as registros devem conter 360 caracteres                       *
  *******************************************************************************}

  {Registro A (AUTORIZADO)
  Registro do estabelecimento respons�vel pela informa��o no meio magn�tico (autorizado).
  Neste registro, informe o meio f�sico utilizado, a compet�ncia (m�s e ano de refer�ncia das informa��es prestadas), dados cadastrais do
  estabelecimento respons�vel, telefone para contato, total de estabelecimentos e total de movimenta��es informadas no arquivo.}
  TRegistroTipoA = class
  private
    FTipoRegistro:                      String; // 1 A. Define o registro a ser informado. Obrigatoriamente o conte�do � A.
    FTipoLayOut:                        String; // 5 A. Informe qual o layout do arquivo CAGED. Obrigatoriamente o conte�do � L2009.
    // FFiller1:                        String; // 2 A. Deixar em branco. Tratar na gera��o do arquivo
    FCompetencia:                       String; // 6 N. M�s e ano de refer�ncia das informa��es do CAGED. Informar sem m�scara(/.\-,).
    FAlteracao:                         String;  { 1 N. Define se os dados cadastrais informados ir�o ou n�o atualizar o Cadastro de
      Autorizados do CAGED Informatizado. 1. Nada a alterar - 2. Alterar dados cadastrais}
    FSequencia:                         String; // 5 N. N�mero seq�encial no arquivo.
    FTipoIdentificador:                 String; // 1 N. Define o tipo de identificador do estabelecimento a informar. 1. CNPJ - 2. CEI
    FNumeroIdentificadorDoAutorizado:   String; { 14 N. N�mero identificador do estabelecimento. N�o havendo inscri��o do estabelecimento
      no Cadastro Nacional de Pessoa Jur�dica (CNPJ), informar o n�mero de registro no CEI (C�digo Espec�fico do INSS).
      O n�mero do CEI tem 12 posi��es, preencher este campo com 00(zeros) � esquerda.}
    FNomeRazaoSocialDoAutorizado:       String; // 35 A.Nome/Raz�o Social do estabelecimento autorizado.
    FEndereco:                          String; // 40 A.Informar o Endere�o do estabelecimento / autorizado (Rua, Av, Trav, P�) com n�mero e complemento.
    FCep:                               String; {8  N. Informar o C�digo de Endere�amento Postal do estabelecimento conforme a tabela da
      Empresa de Correios e Tel�grafos-ECT. Informar sem  m�scara (/.\-,).}
    FUF:                                String; // 2 A. Informar a Unidade de Federa��o.
    FDDD:                               String; // 4 N. Informar DDD do telefone para contato para contato com o Minist�rio do Trabalho e Emprego.
    FTelefone:                          String; // 8 N. Informar o n�mero do telefone para contato com o respons�vel pelas informa��es contidas no arquivo CAGED.
    FRamal:                             String; // 5 N. Informar o ramal se houver complemento do telefone informado.
    FTotalDeEstabelecimentosInformados: String; // 5 N. Quantidade de registros tipo B (Estabelecimento) informados no arquivo.
    FTotalDeMovimentacoesInformadas:    String; // 5 N. Quantidade de registros tipo C e/ou X (Empregado) informados no arquivo.
    // Filler2:                         String; // 92 A. Deixar em branco. Tratar na gera��o do arquivo.

    FRegistroValido:                    Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido:                    Boolean read FRegistroValido                    write FRegistroValido;
    property TipoRegistro:                      String  read FTipoRegistro                      write FTipoRegistro;
    property TipoLayOut:                        String  read FTipoLayOut                        write  FTipoLayOut;
    /// property FFiller1. Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.
    property Competencia:                       String  read FCompetencia                       write FCompetencia;
    property Alteracao:                         String  read FAlteracao                         write FAlteracao;
    property Sequencia:                         String  read FSequencia                         write FSequencia;
    property TipoIdentificador:                 String  read FTipoIdentificador                 write FTipoIdentificador;
    property NumeroIdentificadorDoAutorizado:   String  read FNumeroIdentificadorDoAutorizado   write FNumeroIdentificadorDoAutorizado;
    property NomeRazaoSocialDoAutorizado:       String  read FNomeRazaoSocialDoAutorizado       write FNomeRazaoSocialDoAutorizado;
    property Endereco:                          String  read FEndereco                          write FEndereco;
    property Cep:                               String  read FCep                               write FCep;
    property UF:                                String  read FUF                                write FUF;
    property DDD:                               String  read FDDD                               write FDDD;
    property Telefone:                          String  read FTelefone                          write FTelefone;
    property Ramal:                             String  read FRamal                             write FRamal;
    property TotalDeEstabelecimentosInformados: String  read FTotalDeEstabelecimentosInformados write FTotalDeEstabelecimentosInformados;
    property TotalDeMovimentacoesInformadas:    String  read FTotalDeMovimentacoesInformadas    write FTotalDeMovimentacoesInformadas;
    /// property FFiller2. Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.
  end;

  {REGISTRO B (ESTABELECIMENTO)
  Registro de estabelecimento informado.
  Informe neste registro os dados cadastrais do estabelecimento que teve movimenta��o (admiss�es e/ou desligamentos) e total de empregados existentes
  no in�cio do primeiro dia do m�s informado (estoque de funcion�rios).}
  TRegistroTipoB = class
  private
    FTipoRegistro:                             String; // 1 A. Define o registro a ser informado. Obrigatoriamente o conte�do � B.
    FTipoIdentificador:                        String; // 1 N. Define o tipo de identificador do estabelecimento a informar. 1. CNPJ - 2. CEI
    FNumeroIdentificadorDoEstabelecimento:     String; { 14 N. N�mero identificador do estabelecimento. N�o havendo inscri��o
      do estabelecimento no Cadastro Nacional de Pessoa Jur�dica (CNPJ), informar o n�mero de registro no CEI (C�digo Espec�fico do INSS).
      O n�mero do CEI tem 12 posi��es, preencher este campo com 00 zeros � esquerda.}
    FSequencia:                                String; // 5 N. N�mero seq�encial no arquivo.
    FPrimeiraDeclaracao:                       String; {  1 N. Define se � ou n�o a primeira declara��o do estabelecimento ao Cadastro
      Geral de Empregados e Desempregados-CAGED-Lei n� 4.923/65. 1. primeira declara��o 2. j� informou ao CAGED anteriormente.}
    FAlteracao:                                String;  { 1 N. Define se os dados cadastrais informados ir�o ou n�o atualizar o Cadastro de
      Autorizados do CAGED Informatizado.
      1. Nada a atualizar
      2. Alterar dados cadastrais do estabelecimento (Raz�o Social, Endere�o, CEP, Bairro, UF, ou Atividade Econ�mica).
      3. Encerramento de Atividades (Fechamento do estabelecimento);}
    FCep:                                      String; {8  N. Informar o C�digo de Endere�amento Postal do estabelecimento conforme a tabela da
      Empresa de Correios e Tel�grafos-ECT. Informar sem  m�scara (/.\-,).}
    // FFiller1, 5 A. Deixar em branco. Tratar na gera��o do arquivo. Obrigatorio
    FNomeRazaoSocialDoEstabelecimento:         String; // 40 A.Nome/Raz�o Social do estabelecimento.
    FEndereco:                                 String; // 40 A.Informar o Endere�o do estabelecimento / autorizado (Rua, Av, Trav, P�) com n�mero e complemento.
    FBairro:                                   String; // 20 A.Informar o bairro correspondente.
    FUF:                                       String; // 2 A. Informar a Unidade de Federa��o.
    FTotalDeEmpregadosExistentesNoPrimeiroDia: String; // 5 N. Total de empregados existentes na empresa no in�cio do primeiro dia do m�s de refer�ncia (compet�ncia).
    FPorteDoEstabelecimento:                   String; {  1 N.Informe se o estabelecimento se enquadra como microempresa, empresa de pequeno porte,
      empresa/�rg�o n�o classificados ou microempreendedor individual, de acordo com a lei Complementar n� . 123, de 14 de dezembro de 2006,
      alterada pela lei Complementar n�. 128, de 19 de dezembro de 2008, utilizando:
      1. Microempresa para a pessoa jur�dica, ou a ela equiparada, que auferir, em cada ano-calend�rio, receita bruta igual ou inferior a
         R$240.000,00 (duzentos e quarenta mil reais).
      2. Empresa de Pequeno Porte para a pessoa jur�dica, ou a ela equiparada, que auferir, em cada ano-calend�rio, receita bruta
         superior a R$240.000,00 (duzentos e quarenta mil reais) e igual ou inferior a R$ 2.400.000,00 (dois milh�es e quatrocentos mil
         reais).
      3. Empresa/�rg�o n�o classificados este campo s� deve ser selecionado se o estabelecimento n�o se enquadrar como microempreendedor
        individual, microempresa ou empresa de pequeno porte.
      4. Microempreendedor Individual para o empres�rio individual que tenha auferido receita bruta, no ano-calend�rio anterior, de at�
         R$36.000,00 (trinta e seis mil reais).}
    FCnae2ComSubClasse:                        String; { 7 N. Informar os primeiros 7algar�smos do CNAE 2.0 conforme exemplo:
      01 - Divis�o
      011 - Grupo
      01113 - Classe
      01113xx - Subclasse.}
    FDDD:                                      String; // 4 N. Informar DDD do telefone para contato para contato com o Minist�rio do Trabalho e Emprego.
    FTelefone:                                 String; // 8 N. Informar o n�mero do telefone para contato com o respons�vel pelas informa��es contidas no arquivo CAGED.
    FEmail:                                    String; { 50 A. Endere�o eletr�nico do estabelecimento ou do respons�vel, utilizado para
      eventuais contatos, todos os caracteres ser�o transformados em min�sculos.}
    // Filler2:                         String; // 27 A. Deixar em branco. Tratar na gera��o do arquivo. Obrigatorio

    FRegistroValido:                    Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido:                           Boolean read FRegistroValido                           write FRegistroValido;
    property TipoIdentificador:                        String  read FTipoRegistro                             write FTipoRegistro;
    property NumeroIdentificadorDoEstabelecimento:     String  read FNumeroIdentificadorDoEstabelecimento     write FNumeroIdentificadorDoEstabelecimento;
    property Sequencia:                                String  read FSequencia                                write FSequencia;
    property PrimeiraDeclaracao:                       String  read FPrimeiraDeclaracao                       write FPrimeiraDeclaracao;
    property Alteracao:                                String  read FAlteracao                                write FAlteracao;
    property Cep:                                      String  read FCep                                      write FCep;
    // property FFiller1, 5 A. Deixar em branco. Tratar na gera��o do arquivo. Obrigatorio
    property NomeRazaoSocialDoEstabelecimento:         String  read FNomeRazaoSocialDoEstabelecimento         write FNomeRazaoSocialDoEstabelecimento;
    property Endereco:                                 String  read FEndereco                                 write FEndereco;
    property Bairro:                                   String  read FBairro                                   write FBairro;
    property UF:                                       String  read FUF                                       write FUF;
    property TotalDeEmpregadosExistentesNoPrimeiroDia: String  read FTotalDeEmpregadosExistentesNoPrimeiroDia write FTotalDeEmpregadosExistentesNoPrimeiroDia;
    property PorteDoEstabelecimento:                   String  read FPorteDoEstabelecimento                   write FPorteDoEstabelecimento;
    property Cnae2ComSubClasse:                        String  read FCnae2ComSubClasse                        write FCnae2ComSubClasse;
    property DDD:                                      String  read FDDD                                      write FDDD;
    property Telefone:                                 String  read FTelefone                                 write FTelefone;
    property Email:                                    String  read FEmail                                    write FEmail;
    /// property FFiller2. Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.

  end;

  { REGISTRO C (MOVIMENTA��O)
    Registro da movimenta��o de empregado para atualizar. Informe a identifica��o do estabelecimento, os dados cadastrais do empregado com a
    respectiva movimenta��o, o tipo de acerto a efetuar e a compet�ncia (m�s e ano de refer�ncia da informa��o).}
  TRegistroTipoC = class
  private
    FTipoRegistro:                             String; // 1 A. Define o registro a ser informado. Obrigatoriamente o conte�do � X.
    FTipoIdentificador:                        String; // 1 N. Define o tipo de identificador do estabelecimento a informar. 1. CNPJ - 2. CEI
    FNumeroIdentificadorDoEstabelecimento:     String; { 14 N. N�mero identificador do estabelecimento. N�o havendo inscri��o
      do estabelecimento no Cadastro Nacional de Pessoa Jur�dica (CNPJ), informar o n�mero de registro no CEI (C�digo Espec�fico do INSS).
      O n�mero do CEI tem 12 posi��es, preencher este campo com 00 zeros � esquerda.}
    FSequencia:                                String; // 5 N. N�mero seq�encial no arquivo.
    FPisPasep:                                 String;  {11 N. N�mero do PIS/PASEP do empregado movimentado. Informar sem m�scara (/.\-,).}
    FSexo:                                     String; { 1  N. Define o sexo do empregado. 1 - Masculino 2 - Feminino.}
    FNascimento:                               TDateTime; // 8 N. Dia, m�s e ano de nascimento do empregado. Informar a data do nascimento sem m�scara (/.\-,).
    FGrauInstrucao:                            String; { 2 N. Define o grau de instru��o do empregado.
      1. Analfabeto inclusive o que, embora tenha recebido instru��o, n�o se alfabetizou.
      2. At� o 5� ano incompleto do Ensino Fundamental (antigo 1� grau ou prim�rio) que se tenha alfabetizado sem ter freq�entado escola
      regular.
      3. 5� ano completo do Ensino Fundamental (antigo 1� grau ou prim�rio).
      4. Do 6� ao 9� ano de Ensino Fundamental (antigo 1� grau ou gin�sio).
      5. Ensino Fundamental completo (antigo 1� grau ou prim�rio e ginasial).
      6. Ensino M�dio incompleto (antigo 2� grau, secund�rio ou colegial).
      7. Ensino M�dio completo (antigo 2� grau, secund�rio ou colegial).
      8. Educa��o Superior incompleta.
      9. Educa��o Superior completa.
      10.Mestrado
      11.Doutorado.}
    // FILLER, caracter, 4 posi��es. Deixar em branco. Obrigat�rio. Tratar quando gerar o arquivo.
    FSalarioMensal:                            String; { 8 N.Informar o sal�rio recebido, ou a receber. Informar com centavos sem
      pontos e sem v�rgulas. Ex: R$ 134,60 informar: 13460.}
    FHorasTrabalhadas:                         String; // 2 N. Informar a quantidade de horas trabalhadas por semana (de 1 at� 44 horas).
    FAdmissao:                                 TDateTime; // 8 N. Dia, m�s e ano de admiss�o do empregado. Informar a data de admiss�o sem m�scara (/.\-,).
    FTipoMovimento:                            String; {  2 N.Define o tipo de movimento.
      ADMISS�O
        10 - Primeiro emprego
        20 - Reemprego
        25 - Contrato por prazo determinado
        35 - Reintegra��o
        70 - Transfer�ncia de entrada
      DESLIGAMENTO
        31 - Dispensa sem justa causa
        32 - Dispensa por justa causa
        40 - A pedido (espont�neo)
        43 - T�rmino de contrato por prazo determinado
        45 - T�rmino de contrato
        50 - Aposentado
        60 - Morte
        80 - Transfer�ncia de sa�da.}
    FDiaDeDesligamento:                        String; { 2 N. Se o tipo de movimento for desligamento, informar o dia da sa�da do empregado se for admiss�o deixar em branco.}
    FNomeDoEmpregado:                          String; // 40 A. Informar o nome do empregado movimentado.
    FNumeroCarteiraTrabalho:                   String; // 8 N. Informar o n�mero da carteira de trabalho e previd�ncia social do empregado.
    FSerieCarteiraTrabalho:                    String; // 4 N. Informar o n�mero de s�rie da carteira de trabalho e previd�ncia social do empregado.
    FRacaCor:                                  String; { 1 N. Informe a ra�a ou cor do empregado, utilizando o c�digo:
      1 - Ind�gena
      2 - Branca
      4 - Preta
      6 - Amarela
      8 - Parda
      9 - N�o informado}
    FPessaoComDeficiencia:                     String; { 1 N. Informe se o empregado � portador de defici�ncia, utilizando:
      1. Para indicar SIM
      2. Para indicar N�O.}
    FCBO2000:                                  String; { 6 N. Informe o c�digo de ocupa��o conforme a Classifica��o Brasileira de
      Ocupa��o - CBO. Informar sem m�scara (/.\-,). Veja o site da CBO.}
    FAprendiz:                                 String; // 1 N. Informar se o empregado � Aprendiz ou n�o. 1. SIM 2. N�O.
    FUFCarteiraDeTrabalho:                     String; { 2 A. Informar a Unidade de Federa��o da carteira de trabalho e previd�ncia
      social do empregado. OBS: Quando se tratar de carteira de trabalho, novo modelo, para o campo s�rie deve ser utilizado uma
      posi��o do campo uf, ficando obrigatoriamente a �ltima em branco.}
    FTipoDeficienciaBeneficiarioReabilitado:   String; {1 A. Informe o tipo de defici�ncia do empregado, conforme as categorias abaixo,
      ou se o mesmo � benefici�rio reabilitado da Previd�ncia Social.
      1. F�sica
      2. Auditiva
      3. Visual
      4. Mental
      5. M�ltipla
      6. Reabilitado.}
    FCpf:                                      String; //11 N, obrigat�rio. C�digo Pessoa F�sica da Receita Federal.
    FCep:                                      String; {8  N. Informar o C�digo de Endere�amento Postal do estabelecimento conforme a tabela da
      Empresa de Correios e Tel�grafos-ECT. Informar sem  m�scara (/.\-,).}
    // Filler2:                         String; // 81 A. Deixar em branco. Tratar na gera��o do arquivo. Obrigatorio

    FRegistroValido:                    Boolean;


  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido:                           Boolean   read FRegistroValido                           write FRegistroValido;
    property TipoIdentificador:                        String    read FTipoRegistro                             write FTipoRegistro;
    property NumeroIdentificadorDoEstabelecimento:     String    read FNumeroIdentificadorDoEstabelecimento     write FNumeroIdentificadorDoEstabelecimento;
    property Sequencia:                                String    read FSequencia                                write FSequencia;
    property PisPasep:                                 String    read FPisPasep                                 write FPisPasep;
    property Sexo:                                     String    read FSexo                                     write FSexo;
    property Nascimento:                               TDateTime read FNascimento                               write FNascimento;
    property GrauInstrucao:                            String    read FGrauInstrucao                            write FGrauInstrucao;
    // property FFiller1, 4 A. Deixar em branco. Tratar na gera��o do arquivo. Obrigatorio
    property SalarioMensal:                            String    read FSalarioMensal                            write FSalarioMensal;
    property HorasTrabalhadas:                         String    read FHorasTrabalhadas                         write FHorasTrabalhadas;
    property Admissao:                                 TDateTime read FAdmissao                                 write FAdmissao;
    property TipoMovimento:                            String    read FTipoMovimento                            write FTipoMovimento;
    property DiaDeDesligamento:                        String    read FDiaDeDesligamento                        write FDiaDeDesligamento;
    property NomeDoEmpregado:                          String    read FNomeDoEmpregado                          write FNomeDoEmpregado;
    property NumeroCarteiraTrabalho:                   String    read FNumeroCarteiraTrabalho                   write FNumeroCarteiraTrabalho;
    property SerieCarteiraTrabalho:                    String    read FSerieCarteiraTrabalho                    write FSerieCarteiraTrabalho;
    property RacaCor:                                  String    read FRacaCor                                  write FRacaCor;
    property PessaoComDeficiencia:                     String    read FPessaoComDeficiencia                     write FPessaoComDeficiencia;
    property CBO2000:                                  String    read FCBO2000                                  write FCBO2000;
    property Aprendiz:                                 String    read FAprendiz                                 write FAprendiz;
    property UFCarteiraDeTrabalho:                     String    read FUFCarteiraDeTrabalho                     write FUFCarteiraDeTrabalho;
    property TipoDeficienciaBeneficiarioReabilitado:   String    read FTipoDeficienciaBeneficiarioReabilitado   write FTipoDeficienciaBeneficiarioReabilitado;
    property Cpf:                                      String    read FCpf                                      write FCpf;
    property Cep:                                      String    read FCep                                      write FCep;
    /// property FFiller2, 81 A. Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.

  end;

  // REGISTRO C - Lista
  TRegistroTipoCList = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipoC;
    procedure SetItem(Index: Integer; const Value: TRegistroTipoC);
  public
    function New: TRegistroTipoC;
    property Items[Index: Integer]: TRegistroTipoC read GetItem write SetItem;
  end;


  {REGISTRO X (ACERTO)
  Registro da movimenta��o de empregado para atualizar. Informe a identifica��o do estabelecimento, os dados cadastrais do empregado com a
  respectiva movimenta��o, o tipo de acerto a efetuar e a compet�ncia (m�s e ano de refer�ncia da informa��o).}
  TRegistroTipoX = class
  private
    FTipoRegistro:                             String; // 1 A. Define o registro a ser informado. Obrigatoriamente o conte�do � X.
    FTipoIdentificador:                        String; // 1 N. Define o tipo de identificador do estabelecimento a informar. 1. CNPJ - 2. CEI
    FNumeroIdentificadorDoEstabelecimento:     String; { 14 N. N�mero identificador do estabelecimento. N�o havendo inscri��o
      do estabelecimento no Cadastro Nacional de Pessoa Jur�dica (CNPJ), informar o n�mero de registro no CEI (C�digo Espec�fico do INSS).
      O n�mero do CEI tem 12 posi��es, preencher este campo com 00 zeros � esquerda.}
    FSequencia:                                String; // 5 N. N�mero seq�encial no arquivo.
    FPisPasep:                                 String;  {11 N. N�mero do PIS/PASEP do empregado movimentado. Informar sem m�scara (/.\-,).}
    FSexo:                                     String; { 1  N. Define o sexo do empregado. 1 - Masculino 2 - Feminino.}
    FNascimento:                               TDateTime; // 8 N. Dia, m�s e ano de nascimento do empregado. Informar a data do nascimento sem m�scara (/.\-,).
    FGrauInstrucao:                            String; { 2 N. Define o grau de instru��o do empregado.
      1. Analfabeto inclusive o que, embora tenha recebido instru��o, n�o se alfabetizou.
      2. At� o 5� ano incompleto do Ensino Fundamental (antigo 1� grau ou prim�rio) que se tenha alfabetizado sem ter freq�entado escola
      regular.
      3. 5� ano completo do Ensino Fundamental (antigo 1� grau ou prim�rio).
      4. Do 6� ao 9� ano de Ensino Fundamental (antigo 1� grau ou gin�sio).
      5. Ensino Fundamental completo (antigo 1� grau ou prim�rio e ginasial).
      6. Ensino M�dio incompleto (antigo 2� grau, secund�rio ou colegial).
      7. Ensino M�dio completo (antigo 2� grau, secund�rio ou colegial).
      8. Educa��o Superior incompleta.
      9. Educa��o Superior completa.
      10.Mestrado
      11.Doutorado.}
    // FILLER, caracter, 4 posi��es. Deixar em branco. Obrigat�rio. Tratar quando gerar o arquivo.
    FSalarioMensal:                            String; { 8 N.Informar o sal�rio recebido, ou a receber. Informar com centavos sem
      pontos e sem v�rgulas. Ex: R$ 134,60 informar: 13460.}
    FHorasTrabalhadas:                         String; // 2 N. Informar a quantidade de horas trabalhadas por semana (de 1 at� 44 horas).
    FAdmissao:                                 TDateTime; // 8 N. Dia, m�s e ano de admiss�o do empregado. Informar a data de admiss�o sem m�scara (/.\-,).
    FTipoMovimento:                            String; {  2 N.Define o tipo de movimento.
      ADMISS�O
        10 - Primeiro emprego
        20 - Reemprego
        25 - Contrato por prazo determinado
        35 - Reintegra��o
        70 - Transfer�ncia de entrada
      DESLIGAMENTO
        31 - Dispensa sem justa causa
        32 - Dispensa por justa causa
        40 - A pedido (espont�neo)
        43 - T�rmino de contrato por prazo determinado
        45 - T�rmino de contrato
        50 - Aposentado
        60 - Morte
        80 - Transfer�ncia de sa�da.}
    FDiaDeDesligamento:                        String; { 2 N. Se o tipo de movimento for desligamento, informar o dia da sa�da do empregado se for admiss�o deixar em branco.}
    FNomeDoEmpregado:                          String; // 40 A. Informar o nome do empregado movimentado.
    FNumeroCarteiraTrabalho:                   String; // 8 N. Informar o n�mero da carteira de trabalho e previd�ncia social do empregado.
    FSerieCarteiraTrabalho:                    String; // 4 N. Informar o n�mero de s�rie da carteira de trabalho e previd�ncia social do empregado.
    FAtualizacao:                              String; { 1 N. Informar o procedimento a ser seguido: 1. Exclus�o de registro
      2. Inclus�o de registro}
    FCompetencia:                              String; // 6 N. M�s e ano de refer�ncia das informa��es do registro. Informar sem m�scara (/.\-,).
    FRacaCor:                                  String; { 1 N. Informe a ra�a ou cor do empregado, utilizando o c�digo:
      1 - Ind�gena
      2 - Branca
      4 - Preta
      6 - Amarela
      8 - Parda
      9 - N�o informado}
    FPessaoComDeficiencia:                     String; { 1 N. Informe se o empregado � portador de defici�ncia, utilizando:
      1. Para indicar SIM
      2. Para indicar N�O.}
    FCBO2000:                                  String; { 6 N. Informe o c�digo de ocupa��o conforme a Classifica��o Brasileira de
      Ocupa��o - CBO. Informar sem m�scara (/.\-,). Veja o site da CBO.}
    FAprendiz:                                 String; // 1 N. Informar se o empregado � Aprendiz ou n�o. 1. SIM 2. N�O.
    FUFCarteiraDeTrabalho:                     String; { 2 A. Informar a Unidade de Federa��o da carteira de trabalho e previd�ncia
      social do empregado. OBS: Quando se tratar de carteira de trabalho, novo modelo, para o campo s�rie deve ser utilizado uma
      posi��o do campo uf, ficando obrigatoriamente a �ltima em branco.}
    FTipoDeficienciaBeneficiarioReabilitado:   String; {1 A. Informe o tipo de defici�ncia do empregado, conforme as categorias abaixo,
      ou se o mesmo � benefici�rio reabilitado da Previd�ncia Social.
      1. F�sica
      2. Auditiva
      3. Visual
      4. Mental
      5. M�ltipla
      6. Reabilitado.}
    FCpf:                                      String; //11 N, obrigat�rio. C�digo Pessoa F�sica da Receita Federal.
    FCep:                                      String; {8  N. Informar o C�digo de Endere�amento Postal do estabelecimento conforme a tabela da
      Empresa de Correios e Tel�grafos-ECT. Informar sem  m�scara (/.\-,).}
    // Filler2:                         String; // 81 A. Deixar em branco. Tratar na gera��o do arquivo. Obrigatorio

    FRegistroValido:                    Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido:                           Boolean   read FRegistroValido                           write FRegistroValido;
    property TipoIdentificador:                        String    read FTipoRegistro                             write FTipoRegistro;
    property NumeroIdentificadorDoEstabelecimento:     String    read FNumeroIdentificadorDoEstabelecimento     write FNumeroIdentificadorDoEstabelecimento;
    property Sequencia:                                String    read FSequencia                                write FSequencia;
    property PisPasep:                                 String    read FPisPasep                                 write FPisPasep;
    property Sexo:                                     String    read FSexo                                     write FSexo;
    property Nascimento:                               TDateTime read FNascimento                               write FNascimento;
    property GrauInstrucao:                            String    read FGrauInstrucao                            write FGrauInstrucao;
    // property FFiller1, 4 A. Deixar em branco. Tratar na gera��o do arquivo. Obrigatorio
    property SalarioMensal:                            String    read FSalarioMensal                            write FSalarioMensal;
    property HorasTrabalhadas:                         String    read FHorasTrabalhadas                         write FHorasTrabalhadas;
    property Admissao:                                 TDateTime read FAdmissao                                 write FAdmissao;
    property TipoMovimento:                            String    read FTipoMovimento                            write FTipoMovimento;
    property DiaDeDesligamento:                        String    read FDiaDeDesligamento                        write FDiaDeDesligamento;
    property NomeDoEmpregado:                          String    read FNomeDoEmpregado                          write FNomeDoEmpregado;
    property NumeroCarteiraTrabalho:                   String    read FNumeroCarteiraTrabalho                   write FNumeroCarteiraTrabalho;
    property SerieCarteiraTrabalho:                    String    read FSerieCarteiraTrabalho                    write FSerieCarteiraTrabalho;
    property RacaCor:                                  String    read FRacaCor                                  write FRacaCor;
    property PessaoComDeficiencia:                     String    read FPessaoComDeficiencia                     write FPessaoComDeficiencia;
    property Atualizacao:                              String    read FAtualizacao                              write FAtualizacao;
    property Competencia:                              String    read FCompetencia                              write FCompetencia;
    property CBO2000:                                  String    read FCBO2000                                  write FCBO2000;
    property Aprendiz:                                 String    read FAprendiz                                 write FAprendiz;
    property UFCarteiraDeTrabalho:                     String    read FUFCarteiraDeTrabalho                     write FUFCarteiraDeTrabalho;
    property TipoDeficienciaBeneficiarioReabilitado:   String    read FTipoDeficienciaBeneficiarioReabilitado   write FTipoDeficienciaBeneficiarioReabilitado;
    property Cpf:                                      String    read FCpf                                      write FCpf;
    property Cep:                                      String    read FCep                                      write FCep;
    /// property FFiller2, 81 A. Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.
  end;

  // REGISTRO X - Lista
  TRegistroTipoXList = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipoX;
    procedure SetItem(Index: Integer; const Value: TRegistroTipoX);
  public
    function New: TRegistroTipoX;
    property Items[Index: Integer]: TRegistroTipoX read GetItem write SetItem;
  end;

implementation

{ TRegistroTipoA }

constructor TRegistroTipoA.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipoA.Destroy;
begin

  inherited;
end;

{ TRegistroTipoB }

constructor TRegistroTipoB.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipoB.Destroy;
begin

  inherited;
end;

{ TRegistroTipoC }

constructor TRegistroTipoC.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipoC.Destroy;
begin

  inherited;
end;

{ TRegistroTipoX }

constructor TRegistroTipoX.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipoX.Destroy;
begin

  inherited;
end;

{ TRegistroTipoCList }

function TRegistroTipoCList.GetItem(Index: Integer): TRegistroTipoC;
begin
  Result := TRegistroTipoC(inherited Items[Index]);
end;

function TRegistroTipoCList.New: TRegistroTipoC;
begin
  Result := TRegistroTipoC.Create;
  Add(Result);
end;

procedure TRegistroTipoCList.SetItem(Index: Integer; const Value: TRegistroTipoC);
begin
  Put(Index, Value);
end;

{ TRegistroTipoXList }

function TRegistroTipoXList.GetItem(Index: Integer): TRegistroTipoX;
begin
  Result := TRegistroTipoX(inherited Items[Index]);
end;

function TRegistroTipoXList.New: TRegistroTipoX;
begin
  Result := TRegistroTipoX.Create;
  Add(Result);
end;

procedure TRegistroTipoXList.SetItem(Index: Integer; const Value: TRegistroTipoX);
begin
  Put(Index, Value);
end;

end.
