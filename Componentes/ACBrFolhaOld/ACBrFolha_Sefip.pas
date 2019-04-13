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

unit ACBrFolha_Sefip;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils;
{******************************************************************************
|*  Descri��o dos valores de campos.
|* A  = String
|* AN = String
|* N  = String
|* V  = Double
|* D  = DateTime
|* Trata as situa��es com valores e datas.
|* Nota: Todas as registros devem conter 360 caracteres
*******************************************************************************}

type
  // REGISTRO TIPO 00 � Informa��es do Respons�vel (Cabe�alho do arquivo)

  { A compet�ncia 13 destina-se exclusivamente � gera��o de informa��es � Previd�ncia Social.
    A compet�ncia 13 admite as categorias de trabalhador 01, 04, 05, 07, 11, 12, 19, 20, 21 e 26.
    Os c�digos de recolhimento 418 e 604, a aus�ncia de fato gerador e a exclus�o de informa��es devem
    ser utilizados exclusivamente na Entrada de dados do SEFIP. }

  TRegistroTipo00 = class
  private
    FTipoRegistro: String; // 2 N - Campo obrigat�rio. Sempre �00�.
    /// Brancos. 51 AN - Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.
    FTipoRemessa: String; { 1 N - (Para indicar se o arquivo referese a recolhimento mensal ou recolhimento espec�fico do FGTS). Campo obrigat�rio.
      S� pode ser 1 (GFIP), ou 3 (DERF). A op��o 3 ser� implementada futuramente e somente dever� ser utilizada quando autorizada pela CAIXA. }
    FTipoInscricaoResponsavel: String; { 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ), 2 (CEI) ou 3 (CPF) S� pode ser igual a 3 (CPF), para o
      c�digo de recolhimento 418. }
    FInscricaoResponsavel: String; { 14 N - Campo obrigat�rio. Deve ser informada a inscri��o (CNPJ/CEI) do certificado respons�vel pela transmiss�o
      do arquivo pelo Conectividade. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido.
      Se Tipo Inscri��o = 3, ent�o n�mero esperado CPF v�lido. }
    FNomeResponsavelRazaoSocial: String; { 30 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FNomePessoaContato: String; { 20 A - Campo obrigat�rio. N�o pode conter n�mero. N�o pode conter caracteres especiais.N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos.
      A primeira posi��o n�o pode ser branco. Pode conter apenas caracteres de A a Z. }
    FLogradouro: String; { 50 AN - Rua, n�, andar,apartamento. Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FBairro: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FCep: String; // 8 N - Campo obrigat�rio. N�mero de CEP v�lido. Permitido apenas, n�meros diferentes de 20000000, 30000000, 70000000 ou 80000000.
    FCidade: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FUnidadeFederacao: String; // 2 A - Campo obrigat�rio. Deve constar da tabela de unidades da federa��o
    FTelefoneContato: String; // 12 N - Campo obrigat�rio. Deve conter no m�nimo 02 d�gitos v�lidos no DDD e 07 d�gitos no telefone.
    FEnderecoInternetContato: String; // 60 AN - Campo opcional. Endere�o INTERNET v�lido.
    FCompetencia: TDateTime; { 6 D -  Campo obrigat�rio. Formato AAAAMM, onde AAAA indica o ano e MM o m�s da compet�ncia. O m�s informado deve ser de 1 a 13
      O ano informado deve maior ou igual a 1967. Acatar o m�s de compet�ncia 13 para ano maior ou igual a 1999.
      N�o pode ser informado compet�ncia 13 para os c�digos de recolhimento 130, 135, 145, 211, 307,317, 327, 337, 345, 640, 650 e 660.
      Acatar apenas compet�ncia maior ou igual a 03/2000 para c�digo de recolhimento 211.
      Acatar apenas compet�ncia menor que 10/1988 para o c�digo de recolhimento 640.
      Acatar apenas compet�ncia maior ou igual a 03/2000 para empregador dom�stico. }
    FCodigoRecolhimento: String; { 3 N - Campo obrigat�rio. Os c�digos de recolhimento 418 e 604 s�o utilizados exclusivamente na Entrada de Dados do SEFIP.
      Informa��o deve estar contida na tabela de C�digo de Recolhimento. }
    FIndicadorRecolhimentoFGTS: String; { 1 N - (Para identificar se o recolhimento ser� realizado no prazo, em atraso, se mediante a��o fiscal ou ainda se refere-se �
      individualiza��o de valores j� recolhidos). Pode ser 1 (GRF no prazo), 2 (GRF em atraso), 3 (GRF em atraso � A��o Fiscal),5 (Individualiza��o) 6 (Individualiza��o � A��o Fiscal) ou branco.
      Campo obrigat�rio para os c�digos de recolhimento 115, 130, 135, 145, 150, 155, 307, 317, 327,337, 345, 608, 640, 650 e 660.
      Os c�digos de recolhimento 145, 307, 317, 327, 337, 345 e 640 n�o aceitam indicador igual a 1(GRF no prazo).
      N�o pode ser informado para o c�digo de recolhimento 211. N�o pode ser informado na compet�ncia 13.
      Sempre que n�o informado o campo deve ficar em branco. }
    FModalidadeArquivo: String; { 1 N - (Para identificar a que tipo de modalidade o arquivo se refere) Pode ser: Branco � Recolhimento ao FGTS e Declara��o � Previd�ncia. 1 - Declara��o ao FGTS e � Previd�ncia
      9 - Confirma��o Informa��es anteriores � Rec/Decl ao FGTS e Decl � Previd�ncia. Para compet�ncia anterior a 10/1998 deve ser igual a branco ou 1.
      A modalidade 9 n�o pode ser informada para compet�ncias anteriores a 10/1998. Para os c�digos 145, 307, 317, 327, 337, 345 e 640 deve ser igual a branco.
      Para o c�digo 211 deve ser igual a 1 ou 9. Para o FPAS 868 deve igual a branco ou 9. Para a compet�ncia 13, deve ser igual a 1 ou 9.
      Ser�o acatadas at� tr�s cargas consecutivas de SEFIP.RE. Dever� existir apenas um arquivo SEFIP.RE para cada modalidade. }
    FDataRecolhimentoFGTS: TDateTime; { 8 D - (Indicar a data efetiva de recolhimento do FGTS, sempre que o recolhimento for realizado em atraso (Indicador 2 e 3) e no caso de
      individualiza��o (Indicador 5 e 6)) Obs.: Os campos C�digo de Recolhimento e Indicador de Recolhimento FGTS determinam a
      obrigatoriedade desta data. Formato DDMMAAAA. A tabela contendo o edital para recolhimento em atraso, � disponibilizada em arquivo, nas ag�ncias
      da Caixa ou no site www.caixa.gov.br. N�o pode ser informado quando o indicador de recolhimento do FGTS for igual a 1 (GRF no prazo).
      Sempre que n�o informado o campo deve ficar em branco. }
    FIndicadorRecolhimentoPrevidenciaSocial: String; { 1 N -(Para identificar se o recolhimento da Previd�ncia Social ser� realizado no prazo ou em atraso)Campo obrigat�rio. S� pode ser 1 (no prazo), 2 (em atraso) ou 3 (n�o gera GPS).
      Deve ser igual a 3, para compet�ncia anterior a 10/1998 e para os c�digos de recolhimento exclusivos do FGTS (145, 307, 317, 327, 337, 345, 640 e 660). }
    FDataRecolhimentoPrevidenciaSocial: TDateTime; { 8 D - (Indicar a data efetiva de recolhimento da Previd�ncia Social, sempre que o recolhimento for realizado em atraso)
      Obs.: O Indicador de Recolhimento da Previd�ncia Social determina a obrigatoriedade desta data. Formato DDMMAAAA.
      S� pode ser informado se Indicador de Recolhimento Previd�ncia Social for igual a 2 e a data informada for posterior ao dia 10 do m�s seguinte ao da compet�ncia.
      Para c�digo de recolhimento 650 deve ser posterior ao dia 02 do m�s seguinte ao da compet�ncia. Para compet�ncia 13, deve ser posterior a 20/12/AAAA, onde AAAA � o ano a que se refere a
      compet�ncia. Sempre que n�o informado o campo deve ficar em branco. }
    FIndiceRecolhimentoAtrasoPrevidenciaSocial: String; { 7 N - (Para recolhimentos efetuados a partir do 2� m�s seguinte ao do vencimento.
      Referente � taxa SELIC + 2%). Campo deve ficar em branco. A tabela para recolhimento de GPS em atraso (SELIC) ser� disponibilizada, mensalmente, no site
      www.caixa.gov.br e www.previdenciasocial.gov.br. }
    FTipoInscricaoFornecedorFolhaPagamento: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ), 2 (CEI) ou 3 (CPF).
    FInscricaoFornecedorFolhaPagamento: String; { 14 N - Campo obrigat�rio.
      Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido. Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido.
      Se Tipo Inscri��o = 3, ent�o n�mero esperado CPF v�lido. }
    /// Brancos. 18 AN - Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.
    /// Final de Linha 1 AN - Deve ser uma constante �*� para marcar fim de linha. Tratar dele no momento de gerar o registro.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    /// property Brancos. Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.
    property TipoRemessa: String read FTipoRemessa write FTipoRemessa;
    property TipoInscricaoResponsavel: String read FTipoInscricaoResponsavel write  FTipoInscricaoResponsavel;
    property InscricaoResponsavel: String read FInscricaoResponsavel write FInscricaoResponsavel;
    property NomeResponsavelRazaoSocial: String read FNomeResponsavelRazaoSocial write FNomeResponsavelRazaoSocial;
    property NomePessoaContato: String read FNomePessoaContato write FNomePessoaContato;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Bairro: String read FBairro write FBairro;
    property Cep: String read FCep write FCep;
    property Cidade: String read FCidade write FCidade;
    property UnidadeFederacao: String read FUnidadeFederacao write FUnidadeFederacao;
    property TelefoneContato: String read FTelefoneContato write FTelefoneContato;
    property EnderecoInternetContato: String read FEnderecoInternetContato write FEnderecoInternetContato;
    property Competencia: TDateTime read FCompetencia write FCompetencia;
    property CodigoRecolhimento: String read FCodigoRecolhimento write FCodigoRecolhimento;
    property IndicadorRecolhimentoFGTS: String read FIndicadorRecolhimentoFGTS write FIndicadorRecolhimentoFGTS;
    property ModalidadeArquivo: String read FModalidadeArquivo write FModalidadeArquivo;
    property DataRecolhimentoFGTS: TDateTime read FDataRecolhimentoFGTS write FDataRecolhimentoFGTS;
    property IndicadorRecolhimentoPrevidenciaSocial: String read FIndicadorRecolhimentoPrevidenciaSocial write FIndicadorRecolhimentoPrevidenciaSocial;
    property DataRecolhimentoPrevidenciaSocial: TDateTime read FDataRecolhimentoPrevidenciaSocial write FDataRecolhimentoPrevidenciaSocial;
    property IndiceRecolhimentoAtrasoPrevidenciaSocial: String read FIndiceRecolhimentoAtrasoPrevidenciaSocial write FIndiceRecolhimentoAtrasoPrevidenciaSocial;
    property TipoInscricaoFornecedorFolhaPagamento: String read FTipoInscricaoFornecedorFolhaPagamento write FTipoInscricaoFornecedorFolhaPagamento;
    property InscricaoFornecedorFolhaPagamento: String read FInscricaoFornecedorFolhaPagamento write FInscricaoFornecedorFolhaPagamento;
    /// property Brancos. Campo obrigat�rio. Preencher com brancos Tratar dele no momento de gerar o registro.
    /// property Final de Linha Deve ser uma constante �*� para marcar fim de linha. Tratar dele no momento de gerar o registro.
  end;


  // REGISTRO TIPO 10 � Informa��es da Empresa (Cabe�alho da empresa )

  TRegistroTipo10 = class
  private
    FTipoRegistro: String; // 2 N - Campo obrigat�rio. Sempre �10�.
    FTipoInscricaoEmpresa: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI). Para empregador dom�stico s� pode ser 2(CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. Para empregador dom�stico s� pode acatar 2 (CEI). }
    /// Zeros. 36 N - Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    FNomeEmpresaRazaoSocial: String; { 40 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos.
      A primeira posi��o n�o pode ser branco. Permitido apenas caracteres de A a Z e n�meros de 0 a 9. }
    FLogradouro: String; { 50 AN - Rua, n�, andar,apartamento. Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FBairro: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FCep: String; // 8 N - Campo obrigat�rio. N�mero de CEP v�lido. Permitido apenas, n�meros diferentes de 20000000, 30000000, 70000000 ou 80000000.
    FCidade: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FUnidadeFederacao: String; // 2 A - Campo obrigat�rio. Deve constar da tabela de unidades da federa��o
    FTelefoneContato: String; // 12 N - Campo obrigat�rio. Deve conter no m�nimo 02 d�gitos v�lidos no DDD e 07 d�gitos no telefone.
    FIndicadorAlteracaoEndereco: String; { 1 A - Campo obrigat�rio. S� pode ser �S� ou �s� quando a empresa desejar alterar o endere�o e �N� ou �n� quando n�o
      desejar modific�-lo. Para a compet�ncia 13, preencher com �N� ou �n�. }
    FCNAE: String; // 7 N - Campo obrigat�rio. N�mero v�lido de CNAE. Para empregador dom�stico utilizar o n�mero 9700500.
    FIndicadorAlteracaoCNAE: String; { 1 A - Campo obrigat�rio. Para os c�digos 145, 307, 317, 327, 337, 345, e 660 e compet�ncias at� 05/2008 pode ser:
      - �S� ou �s� se desejar alterar o CNAE - �N� ou �n� se n�o desejar alterar .
      � Para compet�ncias a partir de 06/2008 pode ser: - �S� ou �s� se desejar alterar o CNAE - �N� ou �n� se n�o desejar alterar .
      - �A� ou �a� se desejar alterar e for CNAE preponderante. - �P� ou �p� se n�o desejar alterar e for CNAE preponderante.
      Para a compet�ncia 13, preencher com �N� ou �n�. }
    FAliquotaRAT: String; { 2 N - (Informar al�quota para o c�lculo da contribui��o destinada ao financiamento dos benef�cios concedidos em raz�o de
      incid�ncia de incapacidade laborativa decorrente dos riscos ambientais do trabalho � RAT). Campo obrigat�rio.
      Campo com uma posi��o inteira e uma decimal. Campo obrigat�rio para compet�ncia maior ou igual a 10/1998.
      N�o pode ser informado para compet�ncias anteriores a 10/1998.
      N�o pode ser informado para compet�ncias anteriores a 04/99 quando o FPAS for 639.
      N�o pode ser informado para os c�digos de recolhimento 145, 307, 317, 327, 337, 345, 640 e 660.
      Ser� zeros para FPAS 604, 647, 825, 833 e 868 (empregador dom�stico) e para a empresa optante pelo SIMPLES.
      N�o pode ser informado para FPAS 604 com recolhimento de c�digo 150 em compet�ncias posteriores a 10/2001.
      Sempre que n�o informado o campo deve ficar em branco. }
    FCodigoCentralizacao: String; { 1 N - (Para indicar as empresas que centralizam o recolhimento do FGTS ). Campo obrigat�rio.
      S� pode ser 0 (n�o centraliza), 1 (centralizadora) ou 2 (centralizada).
      Deve ser igual a zero (0), para os c�digos de recolhimento 130, 135, 150, 155, 211, 317, 337, 608 e para empregador dom�stico (FPAS 868).
      Quando existir empresa centralizadora deve existir, no m�nimo, uma empresa centralizada e viceversa. Quando existir centraliza��o,
      as oito primeiras posi��es do CNPJ da centralizadora e da centralizada devem ser iguais. Empresa com inscri��o CEI n�o possui centraliza��o. }
    FSIMPLES: String; { 1 N -(Para indicar se a empresa � ou n�o optante pelo SIMPLES - Lei n� 9.317, de 05/12/96 e para determinar a isen��o da Contribui��o Social).
      Campo obrigat�rio. S� pode ser 1 - N�o Optante; 2 � Optante; 3 � Optante - faturamento anual superior a R$1.200.000,00 ;
      4 � N�o Optante - Produtor Rural Pessoa F�sica (CEI e FPAS 604 ) com faturamento anual superior a R$1.200.000,00.
      5 � N�o Optante � Empresa com Liminar para n�o recolhimento da Contribui��o Social � Lei Complementar 110/01, de 26/06/2001.
      6 � Optante - faturamento anual superior a R$1.200.000,00 - Empresa com Liminar para n�o recolhimento da Contribui��o Social � Lei Complementar 110/01, de 26/06/2001.
      Deve sempre ser igual a 1ou 5 para FPAS 582, 639, 663, 671, 680 e 736. Deve sempre ser igual a 1 para o FPAS 868 (empregador dom�stico).
      N�o pode ser informado para o c�digo de recolhimento 640. N�o pode ser informado para compet�ncia anterior a 12/1996.
      Os c�digos 3, 4, 5 e 6 n�o podem ser informados a partir da compet�ncia 01/2007. Sempre que n�o informado o campo deve ficar em branco. }
    FFPAS: String; { 3 N - (Informar o c�digo referente � atividade econ�mica principal do empregador/contribuinte que identifica as contribui��es ao FPAS e a outras entidades e fundos - terceiros)
      Campo obrigat�rio. Deve ser um FPAS v�lido. Deve ser diferente de 744 e 779, pois as GPS desses c�digos ser�o geradas automaticamente,
      sempre que forem informados os respectivos fatos geradores dessas contribui��es. Deve ser diferente de 620, pois a informa��o das categorias 15, 16, 18, 23 e 25 indica os
      respectivos fatos geradores dessas contribui��es. Deve ser diferente de 663 e 671 a partir da compet�ncia 04/2004. Deve ser igual a 868 para empregador dom�stico. }
    FCodigoOutrasEntidades: String; { 4 N - (Informar o c�digo de outras entidades e fundos para as quais a empresa est� obrigada a contribuir)
      Campo obrigat�rio para os c�digos de recolhimento 115, 130, 135, 150, 155, 211, 608 e 650, N�o pode ser informado para os c�digos de recolhimento 145, 307, 317, 327, 337, 345, 640 e 660.
      N�o pode ser informado para compet�ncias anteriores a 10/1998. N�o pode ser informado para compet�ncias anteriores a 04/99 para o c�digo FPAS 639.
      Deve estar contido na tabela de terceiros, inclusive zeros se SIMPLES for igual a 1, 4 ou 5. Deve ficar em branco quando o SIMPLES for igual a 2 , 3 ou 6.
      Sempre que n�o informado o campo deve ficar em branco. }
    FCodigoPagamentoGPS: String; { 4 N - (Informar o c�digo de pagamento da GPS, conforme tabela divulgada pelo INSS). Campo obrigat�rio para compet�ncia maior ou igual a 10/1998.
      Acatar apenas para os c�digos de recolhimento 115, 150, 211 e 650. N�o pode ser informado para os c�digos de recolhimento 145, 307, 327, 345, 640 e 660.
      Para FPAS 868 (empregador dom�stico) acatar apenas os c�digos GPS 1600 e 1651. Sempre que n�o informado o campo deve ficar em branco. }
    FPercentualIsencaoFilantropia: String; { 5 N - (Informar o percentual de isen��o conforme Lei 9.732/98) Valor deve ser composto de tr�s inteiros e duas decimais.
      S� pode ser informado quando o FPAS for igual a 639. Sempre que n�o informado o campo deve ficar em branco. }
    FSalarioFamilia: Double; { 15 V - (Informar o total pago pela empresa a t�tulo de sal�riofam�lia.O valor informado ser� deduzido na GPS) Opcional para os c�digos de recolhimento 115 e 211.
      N�o pode ser informado para os c�digos de recolhimento 145, 307, 327, 345, 640, 650, 660 e FPAS 868 (empregador dom�stico).
      N�o pode ser informado para a compet�ncia 13. N�o pode ser informado para compet�ncias anteriores a 10/1998. Sempre que n�o informado preencher com zeros. }
    FSalarioMaternidade: Double; { 15 V - (Indicar o total pago pela empresa a t�tulo de sal�rio-maternidade no m�s em refer�ncia. O valor ser� deduzido na GPS).
      Opcional para o c�digo de recolhimento 115. Opcional para os c�digos de recolhimento 150, 155 e 608, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      N�o pode ser informado para os c�digos de recolhimento 130, 135, 145, 211, 307, 317, 327, 337, 345, 640, 650, 660 e para empregador dom�stico (FPAS 868).
      N�o pode ser informado para compet�ncias anteriores a 10/1998. N�o pode ser informado para as compet�ncias 06/2000 a 08/2003.
      N�o pode ser informado para licen�a maternidade iniciada a partir de 01.12.1999 e com benef�cios requeridos at� 31/08/2003.
      N�o pode ser informado para a compet�ncia 13. Sempre que n�o informado preencher com zeros. }
    FContribDescEmpregadoReferenteCompetencia13: Double; { 15 V - (Informar o valor total da contribui��o descontada dos segurados na compet�ncia 13).
      N�o dever� ser informado Preencher com zeros. }
    FIndicadorValorNegativoPositivo: Double; { 1 V - (Para indicar se o valor devido � Previd�ncia Social - campo 26 - �(0) positivo ou (1) negativo).
      N�o dever� ser informado. Preencher com zeros. }
    FValorDevidoPrevidenciaSocialReferenteComp13: Double; { 14 V - (Informar o valor total devido � Previd�ncia Social, na compet�ncia 13).
      N�o dever� ser informado. Preencher com zeros. }
    FBanco: String; // 3 N - �Para d�bito em conta corrente. Implementa��o futura� Campo opcional. Se informado, deve ser v�lido. Sempre que n�o informado o campo deve ficar em branco.
    FAgencia: String; // 4 N - �Para d�bito em conta corrente. Implementa��o futura� Campo opcional. Se informado, deve ser v�lido. Sempre que n�o informado o campo deve ficar em branco.
    FContaCorrente: String; // 9 AN - �Para d�bito em conta corrente. Implementa��o futura� Campo opcional. Se informado, deve ser v�lido. Sempre que n�o informado o campo deve ficar em branco.
    /// Zeros 45 V - Para implementa��o futura. Tratar dele no momento de gerar o registro.
    /// Brancos 4 AN -  Preencher com brancos. Tratar dele no momento de gerar o registro.
    /// Final de Linha 1 AN Deve ser uma constante �*� para marcar fim de linha. Tratar dele no momento de gerar o registro.

    FRegistroValido: Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    /// Zeros. Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    property NomeEmpresaRazaoSocial: String read FNomeEmpresaRazaoSocial write FNomeEmpresaRazaoSocial;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Bairro: String read FBairro write FBairro;
    property Cep: String read FCep write FCep;
    property Cidade: String read FCidade write FCidade;
    property UnidadeFederacao: String read FUnidadeFederacao write FUnidadeFederacao;
    property TelefoneContato: String read FTelefoneContato write FTelefoneContato;
    property IndicadorAlteracaoEndereco: String read FIndicadorAlteracaoEndereco write FIndicadorAlteracaoEndereco;
    property CNAE: String read FCNAE write FCNAE;
    property IndicadorAlteracaoCNAE: String read FIndicadorAlteracaoCNAE write FIndicadorAlteracaoCNAE;
    property AliquotaRAT: String read FAliquotaRAT write FAliquotaRAT;
    property CodigoCentralizacao: String read FCodigoCentralizacao write FCodigoCentralizacao;
    property SIMPLES: String read FSIMPLES write FSIMPLES;
    property FPAS: String read FFPAS write FFPAS;
    property CodigoOutrasEntidades: String read FCodigoOutrasEntidades write FCodigoOutrasEntidades;
    property CodigoPagamentoGPS: String read FCodigoPagamentoGPS write FCodigoPagamentoGPS;
    property PercentualIsencaoFilantropia: String read FPercentualIsencaoFilantropia write FPercentualIsencaoFilantropia;
    property SalarioFamilia: Double read FSalarioFamilia write FSalarioFamilia;
    property SalarioMaternidade: Double read FSalarioMaternidade write FSalarioMaternidade;
    property ContribDescEmpregadoReferenteCompetencia13: Double read FContribDescEmpregadoReferenteCompetencia13 write FContribDescEmpregadoReferenteCompetencia13;
    property IndicadorValorNegativoPositivo: Double read FIndicadorValorNegativoPositivo write FIndicadorValorNegativoPositivo;
    property ValorDevidoPrevidenciaSocialReferenteComp13: Double read FValorDevidoPrevidenciaSocialReferenteComp13 write FValorDevidoPrevidenciaSocialReferenteComp13;
    property Banco: String read FBanco write FBanco;
    property Agencia: String read FAgencia write FAgencia;
    property ContaCorrente: String read FContaCorrente write FContaCorrente;
    /// Zeros Para implementa��o futura. Tratar dele no momento de gerar o registro.
    /// Brancos. Preencher com brancos. Tratar dele no momento de gerar o registro.
    /// Final de Linha Deve ser uma constante �*� para marcar fim de linha. Tratar dele no momento de gerar o registro.

  end;


  // REGISTRO TIPO 12 � Informa��es Adicionais do Recolhimento da Empresa
  // Obrigat�rio para os c�digos de recolhimento 650 e 660.

  TRegistroTipo12 = class
  private
    FTipoRegistro: String; // 2 N -  Campo obrigat�rio. Sempre �12�.
    FTipoInscricaoEmpresa: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI). Para empregador dom�stico s� pode ser 2(CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. A inscri��o esperada deve ser igual � do registro tipo 10 imediatamente anterior. }
    /// Zeros 36 N - Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    FDeducao13SalarioLicencaMaternidade: Double; { 15 V - (Informar o valor da parcela de 13� sal�rio referente ao per�odo em que a trabalhadora esteve em
      licen�a maternidade, nos casos em que o empregador/contribuinte for respons�vel pelo pagamento do sal�rio-maternidade. A informa��o deve ser prestada
      nas seguintes situa��es: - na compet�ncia 13, referente ao valor pago durante o ano.
      - na compet�ncia da rescis�o do contrato de trabalho (exceto rescis�o por justa causa), aposentadoria sem continuidade de v�nculo ou falecimento )
      Opcional para a compet�ncia 13. Opcional para o c�digo de recolhimento 115.
      Opcional para os c�digos de recolhimento 150, 155 e 608, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      Deve ser informado quando houver movimenta��o por rescis�o de contrato de trabalho (exceto rescis�o com justa causa), aposentadoria sem continuidade de v�nculo, aposentadoria por invalidez
      ou falecimento, para empregada que possuir afastamento por motivo de licen�a maternidade no ano. N�o pode ser informado para os c�digos de recolhimento 130, 135, 145, 211, 307, 317, 327, 337,
      345, 640, 650, 660 e para empregador dom�stico (FPAS 868). N�o pode ser informado para licen�a maternidade iniciada a partir de 01/12/1999 e com benef�cios
      requeridos at� 31/08/2003. N�o pode ser informado para compet�ncias anteriores a 10/1998. N�o pode ser informado para as compet�ncias 01/2001 a 08/2003.
      Sempre que n�o informado preencher com zeros. }
    FReceitaEventoDesportivoPatrocinio: Double; { 15 v - (Informar o valor total da receita bruta de espet�culos desportivos em qualquer modalidade,
      realizado com qualquer associa��o desportiva que mantenha equipe de futebol profissional ou valor total pago a t�tulo de patroc�nio, licenciamento
      de marcas e s�mbolos, publicidade, propaganda e transmiss�o de espet�culos celebrados com essas associa��es desportivas)
      Campo opcional para c�digo de recolhimento 115 Campo opcional para os c�digos de recolhimento 150 e 155, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      N�o pode ser informado para os c�digos de recolhimento 130, 135, 145, 211, 307, 317, 327, 337,345, 608, 640, 650, 660 e para empregador dom�stico (FPAS 868).
      N�o pode ser informado para a compet�ncia 13. Sempre que n�o informado preencher com zeros. }
    FIndicativoOrigemReceita: String; { 1 AN - (Indicar a origem da receita de evento desportivo/patroc�nio). Deve ser preenchido se o valor da Receita de Evento Desportivo/Patroc�nio for informada. Se
      informado, s� pode ser: �E� (receita referente a arrecada��o de eventos); �P� (receita referente a patroc�nio); �A� (receita referente � arrecada��o de eventos e patroc�nio).
      Sempre que o campo for �P� ser� gerada automaticamente a GPS com c�digo de pagamento 2500. N�o pode ser informado para a compet�ncia 13.
      Sempre que n�o informado o campo deve ficar em branco. }
    FComercializacaoProducaoPessoaFisica: Double; { 15 V - (Informar o valor da comercializa��o da produ��o no m�s de compet�ncia, realizada com produtor rural pessoa f�sica)
      Campo opcional para c�digo de recolhimento 115. Campo opcional para os c�digos de recolhimento 150 e 155, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      N�o pode ser informado para os c�digos de recolhimento 130, 135, 145, 211, 307, 317, 327, 337,345, 608, 640, 650, 660 e para empregador dom�stico (FPAS 868).
      N�o pode ser informado quando FPAS for 604 e c�digo de recolhimento 150, em compet�ncias posteriores a 10/2001.
      N�o pode ser informado para a compet�ncia 13. Sempre que informado, ser� gerada GPS com os c�digos de pagamento 2607, 2704 ou 2437,conforme o caso.
      N�o pode ser informado para compet�ncia anterior a OUT de 1998. Sempre que n�o informado preencher com zeros. }
    FComercializacaoProducaoPessoaJuridica: Double; { 15 V - (Informar o valor da comercializa��o da produ��o realizada no m�s de compet�ncia por produtor pessoa jur�dica)
      Campo opcional para os c�digos de recolhimento 115. Campo opcional para os c�digos de recolhimento 150 e 155, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      N�o pode ser informado para os c�digos de recolhimento 130, 135,145, 211, 307, 317, 327, 337,345, 608, 640, 650, 660 e para empregador dom�stico (FPAS 868).
      N�o pode ser informado quando FPAS for 604 e c�digo de recolhimento for 150, em compet�ncias posteriores a 10/2001.
      N�o pode ser informado para a compet�ncia 13. N�o pode ser informado para empresa optante pelo SIMPLES. Sempre que informado,
      ser� gerada GPS com os c�digos de pagamento 2607 ou 2704, conforme o caso. N�o pode ser informado para compet�ncia anterior a 10/1998.
      Sempre que n�o informado preencher com zeros. }
    FOutrasInformacoesProcesso: String; { 11 N - Campo obrigat�rio para os c�digos de recolhimento 650 e 660.  N�o pode ser informado para os demais c�digos.
      Sempre que n�o informado o campo deve ficar em branco. }
    FOutrasInformacoesProcessoAno: String; { 4 N - Formato AAAA. Campo obrigat�rio para o c�digo de recolhimento 650 e 660. N�o pode ser informado para os demais c�digos.
      Sempre que n�o informado o campo deve ficar em branco. }
    FOutrasInformacoesVaraJCJ: String; { 5 N - Campo obrigat�rio para os c�digos de recolhimento 650 e 660 .  N�o pode ser informado para os demais c�digos.
      Sempre que n�o informado o campo deve ficar em branco. }
    FOutrasInformacoesPeriodoInicio: TDateTime; { 6 D - Formato AAAAMM. Campo obrigat�rio para os c�digos de recolhimento 650 e 660. N�o pode ser informado para os demais c�digos.
      Sempre que n�o informado o campo deve ficar em branco. }
    FOutrasInformacoesPeriodoFim: TDateTime; { 6 D - Formato AAAAMM.  Campo obrigat�rio, para os c�digos de recolhimento 650 e 660. Per�odo Fim deve ser posterior ou igual ao Per�odo In�cio.
      N�o pode ser informado para os demais c�digos. Sempre que n�o informado o campo deve ficar em branco. }
    FCompensacaoValorCorrigido: Double; { 15 V - (Informar o valor corrigido, recolhido indevidamente ou a maior em compet�ncias anteriores e que a empresa deseja
      compensar na atual GPS - Guia da Previd�ncia Social). Campo opcional para c�digos de recolhimento 115 e 650. N�o pode ser informado para os c�digos de recolhimento 145, 211, 307, 327, 345, 640 e 660.
      S� deve ser informado se Indicador de Recolhimento da Previd�ncia Social (campo 20 do registro 00) for igual a 1 (GPS no prazo).
      N�o pode ser informado para compet�ncia anterior a outubro de 1998. Sempre que n�o informado preencher com zeros. }
    FCompensacaoPeriodoInicio: TDateTime; { 6 D - (Para informa��o AAAAMM de in�cio das compet�ncias recolhidas indevidamente ou a maior) Formato AAAAMM.
      S� deve ser informado se o campo �Compensa��o - Valor Corrigido� for diferente de zero. N�o pode ser informado para compet�ncia anterior a outubro de 1998.
      N�o pode ser informado para os c�digos de recolhimento 145, 211, 307, 327, 345, 640 e 660. Opcional para os c�digos de recolhimento 115 e 650.
      Deve ser menor ou igual � compet�ncia informada. Sempre que n�o informado o campo deve ficar em branco. }
    FCompensacaoPeriodoFim: TDateTime; { 6 D - (Para informa��o do AAAAMM final das compet�ncias recolhidas indevidamente ou a maior) Formato AAAAMM.
      S� deve ser informado se o campo �Compensa��o - Valor Corrigido� for diferente de zero. Obrigat�rio caso o campo �Compensa��o � Per�odo in�cio� estiver preenchido.
      Per�odo Fim deve ser maior ou igual ao Per�odo In�cio e menor ou igual que o m�s de compet�ncia. N�o pode ser informado para compet�ncia anterior a outubro de 1998.
      N�o pode ser informado para os c�digos de recolhimento 145, 211, 307, 327, 345, 640 e 660. Opcional para os c�digos de recolhimento 115 e 650.
      Sempre que n�o informado o campo deve ficar em branco. }
    FRecolhimentoCompetenciasAnterioresValorINSSFolhaPagamento: Double; { 15 V - (Informar os valores de contribui��es de compet�ncias anteriores n�o recolhidas por n�o
      terem atingido o valor m�nimo estabelecido pela Previd�ncia Social. Neste campo informar o total do campo 6 da GPS) Campo opcional para c�digos de recolhimento 115, 211e 650.
      N�o pode ser informado para os c�digos de recolhimento 145, 307, 327, 345, 640 e 660. S� deve ser informado se
      Indicador de Recolhimento da Previd�ncia Social (campo 20 do registro 00) for igual a 1 (GPS no prazo) ou 2 (GPS em atraso).
      N�o pode ser informado para compet�ncia anterior a outubro de 1998. Sempre que n�o informado preencher com zeros. }
    FRecolhimentoCompetenciasAnterioresOutrasEntidadesFolhaPagamento: Double; { 15 V - (Informar os valores de contribui��es de compet�ncias anteriores n�o recolhidas por n�o
      terem atingido o valor m�nimo estabelecido pela Previd�ncia Social. Neste campo informar o total do campo 9 da GPS)
      Campo opcional para c�digos de recolhimento 115, 211e 650. N�o pode ser informado para os c�digos de recolhimento 145, 307, 327, 345, 640 e 660.
      S� deve ser informado se Indicador de Recolhimento da Previd�ncia Social (campo 20 do registro 00) for igual a 1 (GPS no prazo) ou 2 (GPS em atraso).
      N�o pode ser informado para compet�ncia anterior a outubro de 1998. Sempre que n�o informado preencher com zeros. }
    FRecolhimentoCompetenciasAnterioresComercializacaoProducaoValorINSS: Double; { 15 V - (informa��o os valores de contribui��es de compet�ncias anteriores n�o recolhidas por n�o
      terem atingido o valor m�nimo estabelecido pela Previd�ncia Social. Neste campo informar o total do campo 6 da GPS de c�digos de pagamento 2607, 2704 ou 2437).
      Campo opcional para c�digo de recolhimento 115. Campo opcional para os c�digos de recolhimento 150 e 155, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      N�o pode ser informado para os c�digos de recolhimento 130, 135, 145, 211, 307, 317, 327, 337, 345, 608, 640, 650 e 660.
      N�o pode ser informado quando o FPAS for 868 (empregador dom�stico).
      S� deve ser informado se Indicador de Recolhimento da Previd�ncia Social (campo 20 do registro 00) for igual a 1 (GPS no prazo) ou 2 (GPS em atraso).
      N�o pode ser informado na compet�ncia 13. N�o pode ser informado para compet�ncia anterior a outubro de 1998.
      Sempre que n�o informado preencher com zeros. }
    FRecolhimentoCompetenciasAnterioresComercializacaoProducaoOutrasEntidades: Double; { 15 V -  (Informar os valores de contribui��es de compet�ncias anteriores n�o recolhidas por n�o
      terem atingido o valor m�nimo estabelecido pela Previd�ncia Social. Neste campo informar o total do campo 9 da GPS de c�digos de pagamento 2607 , 2704 ou 2437).
      Campo opcional para c�digos de recolhimento 115. Campo opcional para os c�digos de recolhimento 150 e 155, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      N�o pode ser informado para os c�digos de recolhimento 130, 135, 145, 211, 307, 317, 327, 337,345, 608, 640, 650 e 660.
      N�o pode ser informado quando o FPAS for 868 (empregador dom�stico).
      S� deve ser informado se Indicador de Recolhimento da Previd�ncia Social (campo 20 do registro 00) for igual a 1 (GPS no prazo) ou 2 (GPS em atraso).
      N�o pode ser informado na compet�ncia 13. N�o pode ser informado para compet�ncia anterior a outubro de 1998.
      Sempre que n�o informado preencher com zeros. }
    FRecolhimentoCompetenciasAnterioresReceitaEventoDesportivoPatroc�nioValorINSS: Double; { 15 V -  (Informar os valores de contribui��es de compet�ncias anteriores n�o recolhidas por n�o
      terem atingido o valor m�nimo estabelecido pela Previd�ncia Social. Neste campo informar o total do campo 6 da GPS de c�digo de pagamento 2500).
      Campo opcional para c�digo de recolhimento 115. Campo opcional para os c�digos de recolhimento 150 e 155, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      N�o pode ser informado para os c�digos de recolhimento 130, 135, 145, 211, 307, 317, 327, 337,345, 608, 640, 650 e 660. N�o deve ser informado quando o FPAS for 868 (empregador dom�stico).
      S� deve ser informado se Indicador de Recolhimento da Previd�ncia Social (campo 20 do registro 00) for igual a 1 (GPS no prazo) ou 2 (GPS em atraso).
      N�o pode ser informado na compet�ncia 13. N�o pode ser informado para compet�ncia anterior a outubro de 1998.
      Sempre que n�o informado preencher com.zeros. }
    FParcelamentoFGTSSomatorioRemuneracoesCategorias0102030506: Double; { 15 V -  (Informar o valor total das remunera��es das categorias 01,02, 03, 05 e 06)
      Para implementa��o futura. Campo obrigat�rio para os c�digos de recolhimento 307 e 327. At� autoriza��o da CAIXA preencher com zeros. }
    FParcelamentoFGTSSomatorioRemuneracaoCategorias0407: Double; { 15 V -  (Informar o valor total das remunera��es das categorias 04 e 07)
      Para implementa��o futura. Campo obrigat�rio para os c�digos de recolhimento 307 e 327, quando possuir trabalhador categoria 04 ou 07.
      At� autoriza��o da CAIXA preencher com zeros. }
    FParcelamentoFGTSValorRecolhido: Double; {  15 V -  Informar o valor total recolhido ao FGTS (Dep�sito + JAM + Multa) Para implementa��o futura.
      Campo obrigat�rio para os c�digos de recolhimento 307 e 327. At� autoriza��o da CAIXA preencher com zeros. }
    FValoresPagosCooperativasTrabalhoServicosPrestados: Double; {  15 V -  (Informar o montante dos valores brutos das notas fiscais ou faturas de presta��o de servi�os emitidas
      pelas cooperativas no decorrer do m�s, que � base de c�lculo da contribui��o). Campo opcional para os c�digo de recolhimento 115.
      Campo opcional para os c�digos de recolhimento 150 e 155, quando o CNPJ da empresa for igual ao CNPJ do tomador.
      N�o pode ser informado para FPAS 604 no c�digo de recolhimento 150, quando compet�ncia posterior a 10/2001.
      N�o pode ser informado para os c�digos de recolhimento 130, 135, 145, 211, 307, 317, 327, 337, 345, 608, 640, 650 e 660.
      N�o pode ser informado para compet�ncias anteriores a 03/2000. N�o pode ser informado na compet�ncia 13.
      N�o pode ser informado para os c�digos de recolhimento 150 e 155 quando for exclusivo de reten��o.
      N�o pode ser informado para o c�digo de recolhimento 115 quando for exclusivo de Receita de Comercializa��o de Produ��o/Patroc�nio e Eventos desportivo.
      N�o pode ser informado se FPAS da empresa for igual a 868 (empregador dom�stico).
      Sempre que n�o informado preencher com zeros. }

    /// Implementa��o futura  45 V - Para implementa��o futura. At� autoriza��o da CAIXA, preencher com zeros.
    /// Brancos 6 AN - Preencher com brancos.
    /// Final de Linha  1 AN - Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    /// Zeros. Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    property Deducao13SalarioLicencaMaternidade: Double read FDeducao13SalarioLicencaMaternidade write FDeducao13SalarioLicencaMaternidade;
    property ReceitaEventoDesportivoPatrocinio: Double read FReceitaEventoDesportivoPatrocinio write FReceitaEventoDesportivoPatrocinio;
    property IndicativoOrigemReceita: String read FIndicativoOrigemReceita write FIndicativoOrigemReceita;
    property ComercializacaoProducaoPessoaFisica: Double read FComercializacaoProducaoPessoaFisica write FComercializacaoProducaoPessoaFisica;
    property ComercializacaoProducaoPessoaJuridica: Double read FComercializacaoProducaoPessoaJuridica write FComercializacaoProducaoPessoaJuridica;
    property OutrasInformacoesProcesso: String read FOutrasInformacoesProcesso write FOutrasInformacoesProcesso;
    property OutrasInformacoesProcessoAno: String read FOutrasInformacoesProcessoAno write FOutrasInformacoesProcessoAno;
    property OutrasInformacoesVaraJCJ: String read FOutrasInformacoesVaraJCJ write FOutrasInformacoesVaraJCJ;
    property OutrasInformacoesPeriodoInicio: TDateTime read FOutrasInformacoesPeriodoInicio write FOutrasInformacoesPeriodoInicio;
    property OutrasInformacoesPeriodoFim: TDateTime read FOutrasInformacoesPeriodoFim write FOutrasInformacoesPeriodoFim;
    property CompensacaoValorCorrigido: Double read FCompensacaoValorCorrigido write FCompensacaoValorCorrigido;
    property CompensacaoPeriodoInicio: TDateTime read FCompensacaoPeriodoInicio write FCompensacaoPeriodoInicio;
    property CompensacaoPeriodoFim: TDateTime read FCompensacaoPeriodoFim write FCompensacaoPeriodoFim;
    property RecolhimentoCompetenciasAnterioresValorINSSFolhaPagamento: Double read FRecolhimentoCompetenciasAnterioresValorINSSFolhaPagamento write FRecolhimentoCompetenciasAnterioresValorINSSFolhaPagamento;
    property RecolhimentoCompetenciasAnterioresOutrasEntidadesFolhaPagamento: Double read FRecolhimentoCompetenciasAnterioresOutrasEntidadesFolhaPagamento write FRecolhimentoCompetenciasAnterioresOutrasEntidadesFolhaPagamento;
    property RecolhimentoCompetenciasAnterioresComercializacaoProducaoValorINSS: Double read FRecolhimentoCompetenciasAnterioresComercializacaoProducaoValorINSS write FRecolhimentoCompetenciasAnterioresComercializacaoProducaoValorINSS;
    property RecolhimentoCompetenciasAnterioresComercializacaoProducaoOutrasEntidades: Double read FRecolhimentoCompetenciasAnterioresComercializacaoProducaoOutrasEntidades write FRecolhimentoCompetenciasAnterioresComercializacaoProducaoOutrasEntidades;
    property RecolhimentoCompetenciasAnterioresReceitaEventoDesportivoPatroc�nioValorINSS: Double read FRecolhimentoCompetenciasAnterioresReceitaEventoDesportivoPatroc�nioValorINSS write FRecolhimentoCompetenciasAnterioresReceitaEventoDesportivoPatroc�nioValorINSS;
    property ParcelamentoFGTSSomatorioRemuneracoesCategorias0102030506: Double read FParcelamentoFGTSSomatorioRemuneracoesCategorias0102030506 write FParcelamentoFGTSSomatorioRemuneracoesCategorias0102030506;
    property ParcelamentoFGTSSomatorioRemuneracaoCategorias0407: Double read FParcelamentoFGTSSomatorioRemuneracaoCategorias0407 write FParcelamentoFGTSSomatorioRemuneracaoCategorias0407;
    property ParcelamentoFGTSValorRecolhido: Double read FParcelamentoFGTSValorRecolhido write FParcelamentoFGTSValorRecolhido;
    property ValoresPagosCooperativasTrabalhoServicosPrestados: Double read FValoresPagosCooperativasTrabalhoServicosPrestados write FValoresPagosCooperativasTrabalhoServicosPrestados;
    /// Implementa��o futura Para implementa��o futura. At� autoriza��o da CAIXA, preencher com zeros.
    /// Brancos Preencher com brancos.
    /// Final de Linha Deve ser uma constante �*� para marcar fim de linha.
  end;

  // Registro Tipo 12 - Lista
  TRegistroTipo12List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo12;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo12);
  public
    function New: TRegistroTipo12;
    property Items[Index: Integer]: TRegistroTipo12 read GetItem write SetItem;
  end;

  // REGISTRO TIPO 13 � Altera��o Cadastral Trabalhador
  { N�o pode ser informado para a compet�ncia 13.
    N�o ser�o acatadas 03 ou mais altera��es cadastrais para o mesmo trabalhador em campos sens�veis: Nome, CTPS, PIS e Data de Admiss�o.
    Deve existir somente 01 registro 13 por trabalhador (PIS + Data de Admiss�o + Categoria + Empresa) por c�digo de altera��o cadastral.
    N�o pode ser informado para as categorias 11, 12, 13, 14, 15, 16, 17 , 18, 19, 20, 21, 22, 23, 24 , 25 e 26.
    N�o pode ser informado para os c�digos de recolhimento 130, 135, 150, 155, 317, 337, 608, se houver somente altera��o cadastral no arquivo. }

  TRegistroTipo13 = class
  private
    FTipoRegistro: String; //  2 N -  Campo obrigat�rio. Sempre �13�.
    FTipoInscricao: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido. Se Tipo Inscri��o = 2,
      ent�o n�mero esperado CEI v�lido. }
    /// Zeros 36 N -  Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    FPISPASEPCI: String; // 11 N - Campo obrigat�rio. O n�mero informado deve ser v�lido.
    FDataAdmissao: TDateTime; { 8 D - Formato DDMMAAAA. Deve ser informado para as categorias de trabalhadores 01, 03, 04, 05, 06 e 07. Deve conter uma data v�lida.
      N�o pode ser informado para a categoria 02. Deve ser menor ou igual a compet�ncia informada. Deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04.
      Deve ser maior ou igual a 20/12/2000 para a categoria de trabalhador 07. }
    FCategoriaTrabalhador: String; // 2 N - (C�digo deve estar contido na tabela categoria do trabalhador). Campo obrigat�rio. Acatar somente as categorias 01, 02, 03, 04, 05, 06 e 07.
    FMatriculaTrabalhador: String; { 11 N - N�mero de matr�cula atribu�do pela empresa ao trabalhador, quando houver. N�o pode ser informado para a categoria 06.
      Sempre que n�o informado o campo deve ficar em branco. }
    FNumeroCTPS: String; { 7 N - Obrigat�rio para as categorias de trabalhadores 01, 03, 04, 06 e 07. Opcional para a categoria de trabalhador 02.
      N�o pode ser informado para a categoria 05. Sempre que n�o informado o campo deve ficar em branco. }
    FSerieCTPS: String; { 5 N - Obrigat�rio para as categorias de trabalhadores 01, 03, 04, 06 e 07. Opcional para a categoria de trabalhador 02.
      N�o pode ser informado para a categoria 05. Sempre que n�o informado o campo deve ficar em branco. }
    FNomeTrabalhador: String; { 70 A - Campo obrigat�rio. N�o pode conter n�mero. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados. N�o � permitido mais de um espa�o entre os nomes.
      N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco. Pode conter apenas caracteres de A a Z. }
    FCodigoEmpresaCaixa: String; { 14 N - Campo opcional. Se informado dever� ser v�lido, fornecido pela CAIXA, e pertencer � empresa em quest�o.
      Se informado o campo 13 (registro 13) deve ser preenchido. Sempre que n�o informado o campo deve ficar em branco. }
    FCodigoTrabalhadorCaixa: String; { 11 N - Campo opcional. Se informado dever� ser v�lido, fornecido pela CAIXA, e pertencer ao empregado em quest�o.
      Sempre que n�o informado o campo deve ficar em branco. }
    FCodigoAlteracaoCadastral: String; // 3 N - Campo obrigat�rio. Deve estar contido na tabela de tipos de altera��o do trabalhador.
    FNovoConteudoCampo: String; // 70 AN - Campo obrigat�rio. Critica conforme as regras estabelecidas para os campos alterados.
    /// Brancos  94 AN - Preencher com brancos.
    /// Final de Linha 1 AN - Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricao: String read FTipoInscricao write FTipoInscricao;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    /// Zeros. Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    property PISPASEPCI: String read FPISPASEPCI write FPISPASEPCI;
    property DataAdmissao: TDateTime read FDataAdmissao write FDataAdmissao;
    property CategoriaTrabalhador: String read FCategoriaTrabalhador write FCategoriaTrabalhador;
    property MatriculaTrabalhador: String read FMatriculaTrabalhador write FMatriculaTrabalhador;
    property NumeroCTPS: String read FNumeroCTPS write FNumeroCTPS;
    property SerieCTPS: String read FSerieCTPS write FSerieCTPS;
    property NomeTrabalhador: String read FNomeTrabalhador write FNomeTrabalhador;
    property CodigoEmpresaCaixa: String read FCodigoEmpresaCaixa write FCodigoEmpresaCaixa;
    property CodigoTrabalhadorCaixa: String read FCodigoTrabalhadorCaixa write FCodigoTrabalhadorCaixa;
    property CodigoAlteracaoCadastral: String read FCodigoAlteracaoCadastral write FCodigoAlteracaoCadastral;
    property NovoConteudoCampo: String read FNovoConteudoCampo write FNovoConteudoCampo;
    /// Brancos Preencher com brancos.
    /// Final de Linha Deve ser uma constante �*� para marcar fim de linha.

  end;

  // REGISTRO TIPO 13  - Lista
  TRegistroTipo13List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo13;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo13);
  public
    function New: TRegistroTipo13;
    property Items[Index: Integer]: TRegistroTipo13 read GetItem write SetItem;
  end;

  // REGISTRO TIPO 14 � Inclus�o/Altera��o Endere�o do Trabalhador
  { Categorias permitidas: 01, 02, 03, 04, 05, 06 e 07.
   Para as demais categorias n�o h� registro tipo 14.
   N�o pode ser informado para a compet�ncia 13.
   S� deve existir um registro tipo 14 por trabalhador (PIS + Data de Admiss�o + Categoria + Empresa).
   N�o pode ser informado para os c�digos de recolhimento 130, 135, 150, 155, 317, 337 e 608, se houver somente informa��o de endere�o no arquivo.}

  TRegistroTipo14 = class
  private
    FTipoRegistro: String; // 2 N -  Campo obrigat�rio. Sempre �14�.
    FTipoInscricaoEmpresa: String;  // 1 N - Campo obrigat�rio. C�digo informado s� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. A inscri��o esperada deve ser igual a do registro 10 imediatamente anterior. }
    /// Zeros 36 N - Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    FPISPASEPCI: String; // 11 N - Campo obrigat�rio. O n�mero informado deve ser v�lido.
    FDataAdmissao: TDateTime; { 8 D - Formato DDMMAAAA. Campo obrigat�rio para as categorias de trabalhadores 01, 03, 04, 05, 06, 07. Deve conter uma data v�lida.
      Deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04. Deve ser maior ou igual a 20/12/2000 para a categoria de trabalhador 07.
      N�o pode ser informado para categoria 02. Deve ser menor ou igual a compet�ncia informada.
      Sempre que n�o informado o campo deve ficar em branco. }
    FCategoriaTrabalhador: String; // 2 N - (C�digo deve estar contido na tabela categoria do trabalhador). Campo obrigat�rio para as categorias de trabalhadores 01, 02, 03, 04, 05, 06 e 07.
    FNomeTrabalhador: String; { 70 A - Campo obrigat�rio. N�o pode conter n�mero. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados. N�o � permitido mais de um espa�o entre os nomes.
      N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco. Pode conter apenas caracteres de A a Z. }
    FNumeroCTPS: String; { 7 N - Obrigat�rio para as categorias de trabalhadores 01, 03, 04, 06 e 07. Opcional para a categoria de trabalhador 02.
      N�o pode ser informado para a categoria 05. Sempre que n�o informado o campo deve ficar em branco. }
    FSerieCTPS: String; { 5 N - Obrigat�rio para as categorias de trabalhadores 01, 03, 04, 06 e 07. Opcional para a categoria de trabalhador 02.
      N�o pode ser informado para a categoria 05. Sempre que n�o informado o campo deve ficar em branco. }
    FLogradouro: String; { 50 AN - Rua, n�, andar,apartamento. Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FBairro: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FCep: String; // 8 N - Campo obrigat�rio. N�mero de CEP v�lido. Permitido apenas, n�meros diferentes de 20000000, 30000000, 70000000 ou 80000000.
    FCidade: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FUnidadeFederacao: String; // 2 A - Campo obrigat�rio. Deve constar da tabela de unidades da federa��o
    /// Brancos 103 AN - Preencher com brancos.
    /// Final de Linha  1 AN - Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    /// Zeros. Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    property PISPASEPCI: String read FPISPASEPCI write FPISPASEPCI;
    property DataAdmissao: TDateTime read FDataAdmissao write FDataAdmissao;
    property CategoriaTrabalhador: String read FCategoriaTrabalhador write FCategoriaTrabalhador;
    property NomeTrabalhador: String read FNomeTrabalhador write FNomeTrabalhador;
    property NumeroCTPS: String read FNumeroCTPS write FNumeroCTPS;
    property SerieCTPS: String read FSerieCTPS write FSerieCTPS;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Bairro: String read FBairro write FBairro;
    property Cep: String read FCep write FCep;
    property Cidade: String read FCidade write FCidade;
    property UnidadeFederacao: String read FUnidadeFederacao write FUnidadeFederacao;
    /// Brancos Preencher com brancos.
    /// Final de Linha Deve ser uma constante �*� para marcar fim de linha.
  end;

  // REGISTRO TIPO 14  - Lista
  TRegistroTipo14List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo14;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo14);
  public
    function New: TRegistroTipo14;
    property Items[Index: Integer]: TRegistroTipo14 read GetItem write SetItem;
  end;

  // REGISTRO TIPO 20 � Registro do Tomador de Servi�o/Obra de Constru��o Civil
  { Obrigat�rio para os c�digos de recolhimento:130, 135, 150, 155 , 211, 317, 337, 608.
   Para o c�digo de recolhimento 608 s� deve existir um tomador}

  TRegistroTipo20 = class
  private
    FTipoRegistro: String; //  2 N -  Campo obrigat�rio. Sempre �20�.
    FTipoInscricaoEmpresa: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoEmpresa: String; { 14 N -  Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.Se Tipo Inscri��o = 2,
      ent�o n�mero esperado CEI v�lido. A inscri��o da empresa deve ser a mesma do registro 10, imediatamente anterior. }
    FTipoInscricaoTomadorObraConstCivil: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoTomadorObraConstCivil: String; { 14 N - (Destinado � informa��o da inscri��o da empresa tomadora de servi�o nos recolhimentos de
      trabalhadores avulsos, presta��o de servi�os, obra de constru��o civil e dirigente sindical).
      Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido. Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. }
    // Zeros 21 AN - Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    FNomeTomadorObraConstCivil: String; { 40 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos.
      A primeira posi��o n�o pode ser branco. Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FLogradouro: String; { 50 AN - Rua, n�, andar,apartamento. Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FBairro: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FCep: String; // 8 N - Campo obrigat�rio. N�mero de CEP v�lido. Permitido apenas, n�meros diferentes de 20000000, 30000000, 70000000 ou 80000000.
    FCidade: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FUnidadeFederacao: String; // 2 A - Campo obrigat�rio. Deve constar da tabela de unidades da federa��o
    FCodigoPagamentoGPS: String; { 4 N - (Informar o c�digo de pagamento da GPS, conforme tabela divulgada pelo INSS.)
      Campo obrigat�rio para compet�ncia maior ou igual a 10/1998. Acatar apenas para os c�digos de recolhimento130, 135, 155 e 608.
      N�o pode ser informado para os c�digos de recolhimento 211, 317e 337. Sempre que n�o informado o campo deve ficar em branco. }
    FSalarioFamilia: Double; { 15 V - (Indicar o total pago pela empresa a t�tulo de sal�rio fam�lia. O valor informado ser� deduzido na GPS.)
      Campo opcional. N�o pode ser informado para compet�ncia anterior a outubro de 1998. N�o pode ser informado para a compet�ncia 13.
      N�o pode ser informado quando o FPAS for 868 (empregador dom�stico). S� pode ser informado para os c�digos de recolhimento 150, 155 e 608.
      N�o pode ser informado para os c�digos de recolhimento 130, 135, 211, 317 e 337. Sempre que n�o informado preencher com zeros. }
    FContribDescEmpregadoReferentecompetencia13: Double;{ 15 V - (Informar o valor total da contribui��o descontada dos segurados na compet�ncia 13.)
      N�o dever� ser informado. Preencher com zeros. }
    FIndicadorValorNegativoPositivo: Double; { 15 V - (Para indicar se o valor devido � Previd�ncia Social - campo 17 - � (0) positivo) ou (1) negativo.)
      N�o dever� ser informado� Preencher com zero. }
    FValorDevidoPrevidenciaSocialReferenteCompetencia13: Double; { 15 V - (Informar o valor total devido � Previd�ncia Social, na compet�ncia 13.)
      N�o dever� ser informado. Preencher com zeros. }
    FValorRetencaoLei971198: Double; { 15 V - (informar o valor correspondente ao montante das reten��es (Lei n� 9.711/98) ocorridas durante o m�s,
      incluindo o acr�scimo de 2%, 3% ou 4%, correspondente aos servi�os prestados em condi��es que permitam a concess�o de aposentadoria
      especial (art. 6� da Lei n� 10.666, de 08/05/2003). O valor informado ser� deduzido na GPS.)
      Campo opcional para os c�digos de recolhimento 150 e 155. S� deve ser informado para compet�ncia maior ou igual a 02/1999.
      N�o pode ser informado para o c�digo 155 quando for recolhimento de pessoal administrativo. N�o pode ser informado para empresa de FPAS 604
      no recolhimento 150 em compet�ncias posteriores a outubro de 2001. N�o pode ser informado para os demais c�digos de recolhimento.
      Sempre que n�o informado preencher com zeros. }
    FValorFaturasEmitidasTomador: Double; { 15 V - (Informar o montante dos valores brutos das notas fiscais ou faturas de presta��o de servi�os emitidas
      a cada contratante no decorrer do m�s, em raz�o da contribui��o institu�da pelo art. 22, inciso IV, da Lei n� 8.212/91, com a reda��o
      dada pela Lei n� 9.876/99). Campo obrigat�rio para o c�digo de recolhimento 211. N�o pode ser informado para os demais c�digos de recolhimento.
      N�o pode ser informado para compet�ncias anteriores a 03/2000. Sempre que n�o informado preencher com zeros. }
    /// Zeros 45 V - Para implementa��o futura. At� autoriza��o da CAIXA preencher com zeros.
    /// Brancos  42 AN - Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha 1 AN - Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read fRegistroValido write fRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    /// Zeros. Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    property TipoInscricaoTomadorObraConstCivil: String read FTipoInscricaoTomadorObraConstCivil write FTipoInscricaoTomadorObraConstCivil;
    property InscricaoTomadorObraConstCivil: String read FInscricaoTomadorObraConstCivil write FInscricaoTomadorObraConstCivil;
    property NomeTomadorObraConstCivil: String read FNomeTomadorObraConstCivil write FNomeTomadorObraConstCivil;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Bairro: String read FBairro write FBairro;
    property Cep: String read FCep write FCep;
    property Cidade: String read FCidade write FCidade;
    property UnidadeFederacao: String read FUnidadeFederacao write FUnidadeFederacao;
    property CodigoPagamentoGPS: String read FCodigoPagamentoGPS write FCodigoPagamentoGPS;
    property SalarioFamilia: Double read FSalarioFamilia write FSalarioFamilia;
    property ContribDescEmpregadoReferentecompetencia13: Double read FContribDescEmpregadoReferentecompetencia13 write FContribDescEmpregadoReferentecompetencia13;
    property IndicadorValorNegativoPositivo: Double read FIndicadorValorNegativoPositivo write FIndicadorValorNegativoPositivo;
    property ValorDevidoPrevidenciaSocialReferenteCompetencia13: Double read FValorDevidoPrevidenciaSocialReferenteCompetencia13 write FValorDevidoPrevidenciaSocialReferenteCompetencia13;
    property ValorRetencaoLei971198: Double read FValorRetencaoLei971198 write FValorRetencaoLei971198;
    property ValorFaturasEmitidasTomador: Double read FValorFaturasEmitidasTomador write FValorFaturasEmitidasTomador;
    /// Zeros Para implementa��o futura. At� autoriza��o da CAIXA preencher com zeros.
    /// Brancos Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha. Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

  end;

  // REGISTRO TIPO 20 � Lista
  TRegistroTipo20List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo20;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo20);
  public
    function New: TRegistroTipo20;
    property Items[Index: Integer]: TRegistroTipo20 read GetItem write SetItem;
  end;


  // REGISTRO TIPO 21 - Registro de informa��es adicionais do Tomador de Servi�o/Obra de Const. Civil
  // Opcional para os c�digos de recolhimento:130, 135, 150, 155, 211, 317, 337 e 608.

  TRegistroTipo21 = class
  private
    FTipoRegistro: String; //  2 N - Campo obrigat�rio. Sempre �21�.
    FTipoInscricaoEmpresa: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido. Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido.
      A inscri��o da empresa deve ser a mesma do registro 10, imediatamente anterior. }
    FTipoInscricaoTomadorObraConstCivil: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoTomadorObraConstCivil: String; { 14 N - (Destinado � informa��o da inscri��o da empresa tomadora de servi�o nos recolhimentos de
      trabalhadores avulsos, presta��o de servi�os, obra de constru��o civil e dirigente sindical).
      Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido. Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. }
    // Zeros 21 N - Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    FCompensacaoValorCorrigido: Double; { 15 V - (Informar o valor corrigido a compensar , na hip�tese de pagamento ou recolhimento indevido ao INSS em compet�ncias anteriores e que a
      empresa deseja compensar na atual GPS - Guia de Recolhimento da Previd�ncia Social ). 54 68 15 V � Campo opcional para os c�digos de recolhimento 130, 135, 150, 155, 211 e 608.
      N�o pode ser informado para os c�digo de recolhimento 317 e 337. N�o pode ser informado na compet�ncia 13. S� deve ser informado se o Indicador de Recolhimento
      da Previd�ncia Social (campo 20 do registro 00) for igual a 1 (GPS no prazo). N�o pode ser informado para compet�ncia anterior a outubro de 1998.
      Sempre que n�o informado preencher com zeros. }
    FCompensacaoPeriodoInicio: TDateTime; { 6 D -(Para informa��o AAAAMM de in�cio das compet�ncias recolhidas indevidamente ou a maior). Formato AAAAMM.
      N�o pode ser informado na compet�ncia 13. S� deve ser informado se o campo �Compensa��o - Valor Corrigido� for diferente de zero.
      N�o pode ser informado para compet�ncia anterior a outubro de 1998. N�o pode ser informado para os c�digos de recolhimento 317 e 337.
      Opcional para os c�digos de recolhimento 130, 135, 150, 155, 211 e 608. Deve ser menor ou igual � compet�ncia informada.
      Sempre que n�o informado o campo deve ficar em branco.  }
    FCompensacaoPeriodoFim: TDateTime; { 6 D - (Para informa��o do AAAAMM final das compet�ncias recolhidas indevidamente ou a maior). Formato AAAAMM.
      S� deve ser informado se o campo �Compensa��o - Valor Corrigido� for diferente de zero.
      Obrigat�rio caso o campo �Compensa��o � Per�odo in�cio� estiver preenchido. Deve ser posterior ou igual ao per�odo in�cio da compensa��o
      Per�odo Fim deve ser maior ou igual ao Per�odo In�cio e menor ou igual que o m�s de compet�ncia. N�o pode ser informado para compet�ncia 13.
      N�o pode ser informado para compet�ncia anterior a outubro de 1998. N�o pode ser informado para os c�digos de recolhimento 317 e 337.
      Opcional para os c�digos de recolhimento 130, 135, 150, 155, 211 e 608. Sempre que n�o informado o campo deve ficar em branco. }
    FRecolhimentoCompetenciasAnterioresValorINSSFolhaPagamento: Double; { 15 V - (Informar os valores de contribui��es de compet�ncias anteriores n�o recolhidas por n�o
      terem atingido o valor m�nimo estabelecido pela Previd�ncia Social.Neste campo informar o total do campo 6 da GPS.)
      Campo opcional para os c�digos de recolhimento 130, 135, 150, 155 e 608. N�o pode ser informado para c�digo de recolhimento 211, 317 e 337.
      S� deve ser informado quando o Indicador de Recolhimento da Previd�ncia Social(campo 20 do registro 00) for igual a 1 (GPS no prazo) ou 2 (GPS em atraso).
      Sempre que n�o informado preencher com zeros. }
    FRecolhimentoCompetenciasAnterioresOutrasEntidadesFolhaPagamento: Double; { 15 V - (Informar os valores de contribui��es de compet�ncias anteriores n�o recolhidas por n�o
      terem atingido o valor m�nimo estabelecido pela Previd�ncia Social. Neste campo informar o total do campo 9 da GPS.)
      Campo opcional para os c�digos de recolhimento 130, 135, 150, 155 e 608. N�o pode ser informado para c�digo de recolhimento 211, 317 e 337.
      S� deve ser informado quando o Indicador de Recolhimento da Previd�ncia Social(campo 20 do registro 00) for igual a 1 (GPS no prazo) ou 2 (GPS em atraso).
      Sempre que n�o informado preencher com zeros. }
    FParcelamentoFGTSSomatorioRemuneracoesCategorias0102030506: Double; { 15 V - Para implementa��o futura. Campo obrigat�rio para os c�digos de recolhimento 317 e 337.
      At� autoriza��o da CAIXA preencher com zeros. }
    FParcelamentoFGTSSomatorioRemuneracoesCategorias0407: Double; { 15 V - Para implementa��o futura. Campo obrigat�rio para os c�digos de recolhimento 317 e 337.
      At� autoriza��o da CAIXA preencher com zeros. }
    FParcelamentoFGTSValorRecolhido: Double; { 15 V -  Para implementa��o futura. Campo obrigat�rio para os c�digos de recolhimento 317 e 337.
      At� autoriza��o da CAIXA preencher com zeros. }
    /// Brancos 204 AN - Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha 1 AN - Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read fRegistroValido write fRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    property TipoInscricaoTomadorObraConstCivil: String read FTipoInscricaoTomadorObraConstCivil write FTipoInscricaoTomadorObraConstCivil;
    property InscricaoTomadorObraConstCivil: String read FInscricaoTomadorObraConstCivil write FInscricaoTomadorObraConstCivil;
    /// Zeros. Campo obrigat�rio. Preencher com zeros. Tratar dele no momento de gerar o registro.
    property CompensacaoValorCorrigido: Double read FCompensacaoValorCorrigido write FCompensacaoValorCorrigido;
    property CompensacaoPeriodoInicio: TDateTime read FCompensacaoPeriodoInicio write FCompensacaoPeriodoInicio;
    property CompensacaoPeriodoFim: TDateTime read FCompensacaoPeriodoFim write FCompensacaoPeriodoFim;
    property RecolhimentoCompetenciasAnterioresValorINSSFolhaPagamento: Double read FRecolhimentoCompetenciasAnterioresValorINSSFolhaPagamento write FRecolhimentoCompetenciasAnterioresValorINSSFolhaPagamento;
    property RecolhimentoCompetenciasAnterioresOutrasEntidadesFolhaPagamento: Double read FRecolhimentoCompetenciasAnterioresOutrasEntidadesFolhaPagamento write FRecolhimentoCompetenciasAnterioresOutrasEntidadesFolhaPagamento;
    property ParcelamentoFGTSSomatorioRemuneracoesCategorias0102030506: Double read FParcelamentoFGTSSomatorioRemuneracoesCategorias0102030506 write FParcelamentoFGTSSomatorioRemuneracoesCategorias0102030506;
    property ParcelamentoFGTSSomatorioRemuneracoesCategorias0407: Double read FParcelamentoFGTSSomatorioRemuneracoesCategorias0407 write FParcelamentoFGTSSomatorioRemuneracoesCategorias0407;
    property ParcelamentoFGTSValorRecolhido: Double read FParcelamentoFGTSValorRecolhido write FParcelamentoFGTSValorRecolhido;
    /// Brancos Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha. Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

  end;

  // REGISTRO TIPO 21 - Lista
  TRegistroTipo21List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo21;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo21);
  public
    function New: TRegistroTipo21;
    property Items[Index: Integer]: TRegistroTipo21 read GetItem write SetItem;
  end;

  // REGISTRO TIPO 30 - Registro do Trabalhador
  { Acatar categoria 14 e 16 apenas para compet�ncias anteriores a 03/2000.
   Acatar categoria 17, 18, 24 e 25 apenas para c�digo de recolhimento 211.
   Acatar categoria 06 apenas para compet�ncia maior ou igual a 03/2000.
   Acatar categoria 07 apenas para compet�ncia maior ou igual a 12/2000.}

  TRegistroTipo30 = class
  private
    FTipoRegistro: String; // 2 N -  Campo obrigat�rio. Sempre �30�.
    FTipoInscricaoEmpresa: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. }
    FTipoInscricaoTomadorObraConstCivil: String; { 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI). Obrigat�rio para os c�digos de recolhimento 130, 135, 211, 150, 155, 317, 337 e 608.
      Sempre que n�o informado, campo deve ficar em branco. }
    FInscricaoTomadorObraConstCivil: String; { 14 N - (Destinado � informa��o da inscri��o da empresa tomadora de servi�o nos recolhimentos de trabalhadores avulsos, presta��o
      de servi�os, obra de constru��o civil e dirigente sindical). Campo obrigat�rio. Obrigat�rio para os c�digos de recolhimento 130, 135, 150, 155, 211, 317, 337 e 608.
      Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido. Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido.
      Sempre que n�o informado, campo deve ficar em branco. }
    FPISPASEPCI: String; // 11 N - Campo obrigat�rio. O n�mero informado deve ser v�lido.
    FDataAdmissao: TDateTime; { 8 D - Formato DDMMAAAA. Obrigat�rio para as categorias de trabalhadores 01, 03, 04, 05, 06, 07, 11, 12, 19, 20, 21 e 26.
      Deve conter uma data v�lida. N�o pode ser informado para as demais categorias. Deve ser menor ou igual a compet�ncia informada.
      Deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04. Deve ser maior ou igual a 20/12/2000 para a categoria de trabalhador 07.
      Sempre que n�o informado o campo deve ficar em branco. }
    FCategoriaTrabalhador: String; // 2 N - C�digo deve estar na tabela categoria do trabalhador. Campo obrigat�rio.
    FNomeTrabalhador: String; { 70 A - Campo obrigat�rio. N�o pode conter n�mero. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos.
      A primeira posi��o n�o pode ser branco. Pode conter apenas caracteres de A a Z. }
    FMatriculaEmpregado: String; { 11 N - N�mero de matr�cula atribu�do pela empresa ao trabalhador, quando houver. N�o pode ser informado para as categorias 06, 13, 14, 15, 16 , 17, 18, 22, 23, 24 ou 25.
      Sempre que n�o informado o campo deve ficar em branco. }
    FNumeroCTPS: String; { 7 N - Obrigat�rio para as categorias de trabalhadores 01, 03 , 04, 06, 07 e 26. Opcional para a categoria de trabalhador 02.
      N�o pode ser informado para as demais categorias. Sempre que n�o informado o campo deve ficar em branco. }
    FSerieCTPS: String; { 5 N - Obrigat�rio para as categorias de trabalhadores 01, 03 , 04, 06, 07 e 26. Opcional para a categoria de trabalhador 02.
      N�o pode ser informado para as demais categorias. Sempre que n�o informado o campo deve ficar em branco. }
    FDataOpcao: TDateTime; { 8 D - (Indicar a data em que o trabalhador optou pelo FGTS). Formato DDMMAAAA. Obrigat�rio para as
      categorias de trabalhadores 01, 03, 04 , 05, 06 e 07 e deve conter uma data v�lida. N�o pode ser informado para as demais categorias.
      Deve ser maior ou igual a data de admiss�o e limitada a 05/10/1988 quando a data de admiss�o for menor que 05/10/1988, para as categorias 1 e 3.
      Deve ser igual a data de admiss�o quando a mesma for maior ou igual a 05/10/1988, para as categorias 1 e 3.
      Deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04. Deve ser maior ou igual a 02/06/1981 para a categoria de trabalhador 05.
      Deve ser maior ou igual a 01/03/2000 para a categoria de trabalhador 06. Deve ser maior ou igual a 20/12/2000 e igual a data de admiss�o para categoria de trabalhador 07.
      N�o pode ser informado para o c�digo de recolhimento 640. N�o pode ser menor que 01/01/1967. Sempre que n�o informado o campo deve ficar em branco. }
    FDataNascimento: TDateTime; { 8 D - Formato DDMMAAAA. Campo obrigat�rio para as categorias de trabalhadores 01, 02, 03, 04, 05, 06, 07, 12, 19, 20, 21 e 26
      deve conter uma data v�lida. N�o pode ser informado para as demais categorias. Deve ser menor que a data de admiss�o.
      Deve ser maior a 01/01/1900. Sempre que n�o informado o campo deve ficar em branco. }
    FCBO: String; { 5 AN - C�digo Brasileiro de Ocupa��o. Campo Obrigat�rio. Utilizar os quatro primeiros d�gitos do grupo �Fam�lia� do novo CBO,
      acrescentando zero a esquerda.(0 + XXXX onde XXXX � o c�digo da fam�lia do novo CBO a qual pertence o trabalhador).
      Deve ser igual a 05121 para empregado dom�stico (categoria 06). C�digo �fam�lia� deve estar contido na tabela do novo CBO. }
    FRemuneracaoSem13: Double; { 15 V - (Destinado � informa��o da remunera��o paga, devida ou creditada ao trabalhador no m�s, conforme base de incid�ncia.
      Excluir do valor da remunera��o o 13� sal�rio pago no m�s). Campo obrigat�rio para as categorias 05, 11, 13, 14, 15, 16, 17, 18, 22, 23, 24 e 25.
      Opcional para as categorias 01, 02, 03, 04, 06, 07, 12, 19, 20, 21 e 26. As remunera��es pagas ap�s rescis�o do contrato de trabalho e
      conforme determina��o do Art. 466 da CLT, n�o devem vir acompanhadas das respectivas movimenta��es. Se informado deve ter 2 casas decimais v�lidas.
      N�o pode ser informado para a compet�ncia 13. Sempre que n�o informado preencher com zeros. }
    FRemuneracao13: Double; { 15 V - (Destinado � informa��o da parcela de 13� sal�rio pago no m�s ao trabalhador). N�o pode ser informado para a compet�ncia 13.
      Campo obrigat�rio para categoria 02. Campo opcional para as categorias de trabalhadores 01, 03, 04, 06, 07, 12, 19, 20, 21 e 26.
      As remunera��es pagas ap�s rescis�o do contrato de trabalho e conforme determina��o do Art. 466 da CLT, n�o devem vir acompanhadas
      das respectivas movimenta��es. Sempre que n�o informado preencher com zeros. }
    FClasseContribuicao: String; { 2 N - (Indicar a classe de contribui��o do aut�nomo, quando a empresa opta por contribuir sobre seu sal�rio-base e os
      classifica como categoria 14 ou 16. A classe deve estar compreendida em tabela fornecida pelo INSS).
      Campo obrigat�rio para as categorias 14 e 16 (apenas em recolhimentos de compet�ncias anteriores a 03/2000). N�o pode ser informado para as demais categorias.
      N�o pode ser informado para a compet�ncia 13. Sempre que n�o informado o campo deve ficar em branco. }
    FOcorrencia: String; { 2 N - (Destinado � informa��o de exposi��o do trabalhador a agente nocivo e/ou para indica��o de multiplicidade de v�nculos para
      um mesmo trabalhador). Campo opcional para as categorias 01, 03, 04, 06, 07, 12, 19, 20 e 21.
      Campo opcional para as categorias 05, 11, 13,15, 17, 18, 22, 23, 24 e 25 a partir da compet�ncia 04/2003.
      Campo opcional para a categoria 02 a partir da compet�ncia 04/1999. Deve ficar em branco se trabalhador n�o esteve exposto a agente nocivo
      e n�o possui mais de um v�nculo empregat�cio. Para empregado dom�stico (Cat 06) e diretor n�o empregado (Cat 05) permitido apenas branco ou 05.
      Para as categorias 02, 22 e 23 permitido apenas branco, 01, 02, 03 e 04. Obrigat�rio para categoria 26, devendo ser informado 05, 06, 07 ou 08.
      N�o pode ser informado para as demais categorias. Deve ser uma ocorr�ncia v�lida (ver tabela).
      Sempre que n�o informado o campo deve ficar em branco. }
    FValorDescontadoSegurado: Double; { 15 V - (Destinado � informa��o do valor da contribui��o do trabalhador com mais de um v�nculo empregat�cio;
      ou quando tratarse de recolhimento de trabalhador avulso, diss�dio coletivo ou reclamat�ria trabalhista, ou, ainda nos meses de afastamento e
      retorno de licen�a maternidade) O valor informado ser� considerado como contribui��o do segurado.
      Campo opcional para as ocorr�ncias 05, 06, 07 e 08.
      Campo opcional para as categorias de trabalhadores igual a 01, 02, 04, 06, 07, 12, 19, 20, 21 e 26.
      Campo opcional para as categorias de trabalhadores igual a 05, 11, 13, 15, 17, 18, 24 e 25 a partir da compet�ncia 04/2003.
      Campo opcional para os c�digos de recolhimento 130, 135 e 650.
      Campo opcional para compet�ncia maior ou igual a 12/1999 para afastamentos por motivo de licen�a-maternidade
      iniciada a partir de 01/12/1999 e com benef�cios requeridos at� 31/08/2003.
      N�o pode ser informado para compet�ncia anterior a outubro de 1998. Sempre que n�o informado preencher com zeros. }
    FRemuneracaoBaseCalculoContribuicaoPrevidenciaria: Double; { 15 V -  (Destinado � informa��o da parcela de remunera��o sobre a qual incide
      contribui��o previdenci�ria, quando o trabalhador estiver afastado por motivo de acidente de trabalho e/ou presta��o de servi�o militar
      obrigat�rio ou na informa��o de Recolhimento Complementar de FGTS). Campo obrigat�rio para as movimenta��es (registro 32) por O1, O2, R, Z2, Z3 e Z4.
      Campo obrigat�rio quando o Indicativo �C� de Recolhimento Complementar de FGTS for informado (registro Tipo 32 � campo 12).
      Campo opcional para as categorias 01, 02, 04, 05, 06, 07,11, 12, 19, 20, 21 e 26. N�o pode ser informado na compet�ncia 13.
      N�o pode ser informado para compet�ncia anterior a outubro de 1998. N�o pode ser informado para os c�digos de recolhimento
      145, 307, 317, 327, 337, 345, 640 e 660. Sempre que n�o informado preencher com zeros. }
    FBaseCalculo13SalarioPrevidenciaSocialReferenteCompetenciaMovimento: Double; {  15 V -  (Na compet�ncia em que ocorreu o afastamento definitivo �
      informar o valor total do 13� pago no ano ao trabalhador. Na compet�ncia 12 � Indicar eventuais diferen�as de gratifica��o
      natalina de empregados que recebem remunera��o vari�vel � Art. 216, Par�grafo 25, Decreto 3.265 de 29.11.1999) Na compet�ncia 13,
      para a gera��o da GPS, indicar o valor total do 13� sal�rio pago no ano ao trabalhador). Obrigat�rio para a compet�ncia 13.
      Obrigat�rio no m�s de rescis�o para quem trabalhou mais de 15 dias no ano e possui c�digo de
      movimenta��o por motivo rescis�o (exceto rescis�o com justa causa), aposentadoria com quebra de v�nculo ou falecimento.
      Obrigat�rio para os c�digos de recolhimento 130 e 135. Obrigat�rio para os c�digos de recolhimento 608 quando houver trabalhador
      da categoria 02 no arquivo. Opcional para os c�digos de recolhimento 650.
      S� pode ser informado para as categorias 01, 02, 04 ,06 , 07, 12, 19, 20, 21 e 26. Campo opcional para as categorias 01, 04 , 06 , 07, 12, 19,
      20, 21 e 26 na compet�ncia 12. Sempre que n�o informado preencher com zeros. }
    FBaseCalculo13SalarioPrevidenciaReferenteGPSCompetencia13: Double; { 15 V -  Deve ser utilizado apenas na compet�ncia 12, informando o valor
      da base de c�lculo do 13� dos empregados que recebem remunera��o vari�vel, em rela��o a remunera��o apurada at� 20/12 sobre
      a qual j� houve recolhimento em GPS). Campo opcional para a compet�ncia 12. N�o pode ser informado nas demais compet�ncias.
      Campo opcional para as categorias 01, 04 , 06, 07, 12, 19, 20, 21 e 26. Se informado o campo 22 (registro 30) deve ser diferente de zeros.
      Sempre que n�o informado preencher com zeros. }
    /// Brancos Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha. Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    property TipoInscricaoTomadorObraConstCivil: String read FTipoInscricaoTomadorObraConstCivil write FTipoInscricaoTomadorObraConstCivil;
    property InscricaoTomadorObraConstCivil: String read FInscricaoTomadorObraConstCivil write FInscricaoTomadorObraConstCivil;
    property PISPASEPCI: String read FPISPASEPCI write FPISPASEPCI;
    property DataAdmissao: TDateTime read FDataAdmissao write FDataAdmissao;
    property CategoriaTrabalhador: String read FCategoriaTrabalhador write FCategoriaTrabalhador;
    property NomeTrabalhador: String read FNomeTrabalhador write FNomeTrabalhador;
    property MatriculaEmpregado: String read FMatriculaEmpregado write FMatriculaEmpregado;
    property NumeroCTPS: String read FNumeroCTPS write FNumeroCTPS;
    property SerieCTPS: String read FSerieCTPS write FSerieCTPS;
    property DataOpcao: TDateTime read FDataOpcao write FDataOpcao;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property CBO: String read FCBO write FCBO;
    property RemuneracaoSem13: Double read FRemuneracaoSem13 write FRemuneracaoSem13;
    property Remuneracao13: Double read FRemuneracao13 write FRemuneracao13;
    property ClasseContribuicao: String read FClasseContribuicao write FClasseContribuicao;
    property Ocorrencia: String read FOcorrencia write FOcorrencia;
    property ValorDescontadoSegurado: Double read FValorDescontadoSegurado write FValorDescontadoSegurado;
    property RemuneracaoBaseCalculoContribuicaoPrevidenciaria: Double read FRemuneracaoBaseCalculoContribuicaoPrevidenciaria write FRemuneracaoBaseCalculoContribuicaoPrevidenciaria;
    property BaseCalculo13SalarioPrevidenciaSocialReferenteCompetenciaMovimento: Double read FBaseCalculo13SalarioPrevidenciaSocialReferenteCompetenciaMovimento write FBaseCalculo13SalarioPrevidenciaSocialReferenteCompetenciaMovimento;
    property BaseCalculo13SalarioPrevidenciaReferenteGPSCompetencia13: Double read FBaseCalculo13SalarioPrevidenciaReferenteGPSCompetencia13 write FBaseCalculo13SalarioPrevidenciaReferenteGPSCompetencia13;
    /// Brancos 98 AN - Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha 1 AN - Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

  end;

  // REGISTRO TIPO 30 - Lista
  TRegistroTipo30List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo30;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo30);
  public
    function New: TRegistroTipo30;
    property Items[Index: Integer]: TRegistroTipo30 read GetItem write SetItem;
  end;

  // REGISTRO TIPO 32 � Movimenta��o do Trabalhador
  { Permitido para as categorias de trabalhador 01, 02, 03, 04 , 05, 06, 07, 11 , 12, 19, 20, 21 e 26
   N�o pode ser informado para compet�ncia 13
   Obrigat�rio informar as movimenta��es I1, I2, I3, I4 e L , no m�s anterior a rescis�o e no m�s da rescis�o com a remunera��o devida no respectivo m�s.
   Os c�digos de recolhimento 145, 307, 317, 327, 337 e 345 acatam apenas o c�digo de movimenta��oV3.}

  TRegistroTipo32 = class
  private
    FTipoRegistro: String; // 2 N -  Campo obrigat�rio. Sempre �32�.
    FTipoInscricaoEmpresa: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. }
    FTipoInscricaoTomadorObraConstCivil: String; { 1 N - Campo obrigat�rio. Para os c�digos de recolhimento 130, 135, 150, 155 e 608 tipo informado s� pode
      ser 1 (CNPJ) ou 2 (CEI). Para os demais c�digos de recolhimento, campo deve ficar em branco. }
    FInscricaoTomadorObraConstCivil: String; { 14 N - (Destinado � informa��o da inscri��o da empresa tomadora de servi�o nos recolhimentos de trabalhadores avulsos, presta��o
      de servi�os, obra de constru��o civil e dirigente sindical). Campo obrigat�rio. Obrigat�rio para os c�digos de recolhimento 130, 135, 150, 155, 211, 317, 337 e 608.
      Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido. Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido.
      Sempre que n�o informado, campo deve ficar em branco. }
    FPISPASEPCI: String; // 11 N - Campo obrigat�rio. O n�mero informado deve ser v�lido.
    FDataAdmissao: TDateTime; { 8 D - Formato DDMMAAAA. Obrigat�rio para as categorias de trabalhadores 01, 03, 04, 05, 06, 07, 11, 12, 19, 20, 21 e 26.
      Deve conter uma data v�lida. N�o pode ser informado para as demais categorias. Deve ser menor ou igual a compet�ncia informada.
      Deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04. Deve ser maior ou igual a 20/12/2000 para a categoria de trabalhador 07.
      Sempre que n�o informado o campo deve ficar em branco. }
    FCategoriaTrabalhador: String; // 2 N - C�digo deve estar na tabela categoria do trabalhador. Campo obrigat�rio.
    FNomeTrabalhador: String; { Campo obrigat�rio. N�o pode conter n�mero. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos.
      A primeira posi��o n�o pode ser branco. Pode conter apenas caracteres de A a Z. }
    FCodigoMovimentacao: String; { 2 AN - Campo obrigat�rio para as categorias trabalhador 01, 02, 03, 04, 05, 06, 07, 11, 12, 19,20, 21 e 26.
      N�o pode ser informado mais de uma movimenta��o definitiva por trabalhador. Deve ser informado o c�digo e a data do afastamento sempre que houver
      a informa��o de uma movimenta��o de retorno. Devem ser informadas as movimenta��es H, I1, I2, I3, J, K, L, O1, O2, Q1, Q2, Q3, Q4, Q5, Q6, R,
      Z1, Z2, Z3 e Z4 em todos os tomadores (c�digos de recolhimento 150 e 155,) em que o trabalhador estiver alocado, quando ocorrer a movimenta��o.
      Os c�digos de recolhimento 145, 307, 317, 327, 337 e 345 acatam apenas o c�digo de movimenta��o V3. O c�digo de movimenta��o V3 n�o permite a
      informa��o de outra movimenta��o para o mesmo trabalhador. }
    FDataMovimentacao: TDateTime; { 8 D - Campo obrigat�rio para movimenta��o do trabalhador. Formato DDMMAAAA. Deve ser uma data v�lida. Deve ser maior que data de admiss�o.
      Para movimenta��o tempor�ria, informar como data de afastamento o dia imediatamente anterior ao efetivo afastamento e como data de retorno o �ltimo dia do afastamento.
      Para movimenta��o definitiva (rescis�o, falecimento e aposentadoria sem continuidade de v�nculo), informar como data de afastamento o �ltimo dia trabalhado.
      Deve estar compreendida no m�s imediatamente anterior ou no m�s da compet�ncia, para os c�digos de movimenta��o H, J, K, M, N1, N2, S2, S3 e U1.
      Deve estar compreendida no m�s da compet�ncia, se o c�digo de movimenta��o for Z1, Z2, Z3, Z4, Z5 e Z6. Deve estar compreendida no m�s anterior,
      no m�s da compet�ncia ou no m�s posterior (se o recolhimento do FGTS j� tiver sido efetuado) e o c�digo de movimenta��o for I1, I2, I3 , I4 ou L.
      Deve ser menor ou igual ao m�s de compet�ncia , para c�digos de movimenta��o O1, O2, O3, P1, P2, Q1, Q2, Q3, Q4, Q5, Q6, R, U3. W, X e Y.
      Deve ser informada para os c�digos de movimenta��o O1, O2, O3, Q1, Q2, Q3, Q4, Q5, Q6 e R, mensalmente, at� que se d� o efetivo retorno.
      Sempre que informado o c�digo de movimenta��o V3 a data de movimenta��o a ser informada � a do afastamento definitivo. }
    FIndicativoRecolhimentoFGTS: String; { 1 AN - (Utiliza-se �S� ou �N� para indicar se o empregador j� efetuou arrecada��o FGTS na Guia de Recolhimento
      Rescis�rio para trabalhadores com movimenta��o c�digo I1, I2, I3, I4 ou L. Se indicativo for igual a �S� o valor da remunera��o ser� considerado
      apenas para c�lculo da contribui��o previdenci�ria. Utiliza-se �C� para indicar a Remunera��o Complementar do FGTS, sendo que a base de c�lculo da
      Previd�ncia Social dever� ser diferente da remunera��o para c�lculo do FGTS.). Caracteres poss�veis: �S� ou �s�, �N� ou �n�, �C� ou �c� e �Branco�.
      S� deve ser informado �S� ou �N� para compet�ncia maior que 01/1998. Obrigat�rio �S� ou �N� para c�digos de movimenta��o I1, I2, I3, I4 ou L.
      N�o pode ser informado �S� ou �N� para os demais c�digos de movimenta��o. Deve ser informado �S� apenas para as categorias 01, 03, 04, 05, 06 e 07.
      S� deve ser informado �C� para compet�ncia maior ou igual a 10/1998. N�o deve ser informado �C� para os c�digos 640 e 660.
      Deve ser informado �C� apenas para as categorias 01, 02, 03, 04, 05, 06 e 07. N�o pode ser informado �S�, �N� ou �C para a compet�ncia 13.
      Sempre que n�o informado campo deve ficar em branco. }
    /// Brancos 225 AN - Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha 1 AN - Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    property TipoInscricaoTomadorObraConstCivil: String read FTipoInscricaoTomadorObraConstCivil write FTipoInscricaoTomadorObraConstCivil;
    property InscricaoTomadorObraConstCivil: String read FInscricaoTomadorObraConstCivil write FInscricaoTomadorObraConstCivil;
    property PISPASEPCI: String read FPISPASEPCI write FPISPASEPCI;
    property DataAdmissao: TDateTime read FDataAdmissao write FDataAdmissao;
    property CategoriaTrabalhador: String read FCategoriaTrabalhador write FCategoriaTrabalhador;
    property NomeTrabalhador: String read FNomeTrabalhador write FNomeTrabalhador;
    property CodigoMovimentacao: String read FCodigoMovimentacao write FCodigoMovimentacao;
    property DataMovimentacao: TDateTime read FDataMovimentacao write FDataMovimentacao;
    property IndicativoRecolhimentoFGTS: String read FIndicativoRecolhimentoFGTS write FIndicativoRecolhimentoFGTS;
    /// Brancos Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha. Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

  end;

  // REGISTRO TIPO 32 - Lista
  TRegistroTipo32List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo32;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo32);
  public
    function New: TRegistroTipo32;
    property Items[Index: Integer]: TRegistroTipo32 read GetItem write SetItem;
  end;


  // REGISTRO TIPO 50� Empresa Com Recolhimento pelos c�digos 027, 046, 604 e 736 (Header da empresa )
  //(PARA IMPLEMENTA��O FUTURA)

  TRegistroTipo50 = class
  private
    FTipoRegistro: String; // 2 N -  Campo obrigat�rio. Sempre �50�.
    FTipoInscricaoEmpresa: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. }
    /// Zeros 36 N - (Campo obrigat�rio.  Preencher com zeros.
    FNomeEmpresaRazaoSocial: String; // 40 AN - Campo obrigat�rio. A primeira posi��o n�o pode ser branco. Permitido apenas caracteres de A a Z e n�meros de 0 a 9.
    FTipoInscricaoTomador: String; // 1 N - S� pode ser 1 (CNPJ) ou 2 (CEI). Para os demais c�digos de recolhimento, campo deve ficar em branco.
    FInscricaoTomador: String; { 14 N - (Destinado � informa��o da inscri��o da empresa tomadora de servi�o nos recolhimentos de trabalhadores avulsos,
      presta��o de servi�os, obra de constru��o civil e dirigente sindical). 95 108 14 N � Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. CNPJ do tomador n�o pode ser igual ao da empresa. }
    FNomeTomadorServicoObraConstCivil: String; { 40 AN -  N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados. N�o � permitido mais de um espa�o entre os nomes.
      N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FLogradouro: String; { 50 AN - Rua, n�, andar,apartamento. Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FBairro: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FCep: String; // 8 N - Campo obrigat�rio. N�mero de CEP v�lido. Permitido apenas, n�meros diferentes de 20000000, 30000000, 70000000 ou 80000000.
    FCidade: String; { 20 AN - Campo obrigat�rio. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser branco.
      Pode conter apenas caracteres de A a Z e n�meros de 0 a 9. }
    FUnidadeFederacao: String; // 2 AN - Campo obrigat�rio. Deve constar da tabela de unidades da federa��o
    FTelefone: String; // 12 N - Campo obrigat�rio. Deve conter no m�nimo 02 d�gitos v�lidos no DDD e 06 d�gitos no telefone.
    FCNAE: String; // 7 N - Campo obrigat�rio. N�mero v�lido de CNAE.
    FCodigoCentralizacao: String; { 1 N - (Para indicar as empresas que centralizam o recolhimento do FGTS ). Campo obrigat�rio. S� pode ser 0 (n�o centraliza), 1 (centralizadora) ou 2 (centralizada).
      Quando existir empresa centralizadora deve existir, no m�nimo, uma empresa centralizada e viceversa.
      Quando existir centraliza��o, as oito primeiras posi��es do CNPJ da centralizadora e da centralizada devem ser iguais.
      Empresa com inscri��o CEI n�o possui centraliza��o. }
    FValorMulta: Double; // 15 V - Informar o valor total da multa a ser recolhida. Campo opcional. Sempre que n�o informado preencher com zeros.
    /// Brancos 76 AN - Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha 1 AN -  Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    /// Zeros (Campo obrigat�rio.  Preencher com zeros.
    property TipoInscricaoTomador: String read FTipoInscricaoTomador write FTipoInscricaoTomador;
    property InscricaoTomador: String read FInscricaoTomador write FInscricaoTomador;
    property NomeTomadorServicoObraConstCivil: String read FNomeTomadorServicoObraConstCivil write FNomeTomadorServicoObraConstCivil;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Bairro: String read FBairro write FBairro;
    property Cep: String read FCep write FCep;
    property Cidade: String read FCidade write FCidade;
    property UnidadeFederacao: String read FUnidadeFederacao write FUnidadeFederacao;
    property Telefone: String read FTelefone write FTelefone;
    property CNAE: String read FCNAE write FCNAE;
    property CodigoCentralizacao: String read FCodigoCentralizacao write FCodigoCentralizacao;
    property ValorMulta: Double read FValorMulta write FValorMulta;
    /// Brancos Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha. Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

  end;

  // REGISTRO TIPO 50 - Lista
  TRegistroTipo50List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo50;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo50);
  public
    function New: TRegistroTipo50;
    property Items[Index: Integer]: TRegistroTipo50 read GetItem write SetItem;
  end;

  // REGISTRO TIPO 51 - Registro de Individualiza��o de valores recolhidos pelos c�digos 027, 046, 604 e 736
  //(PARA IMPLEMENTA��O FUTURA)

  TRegistroTipo51 = class
  private
    FTipoRegistro: String; // 2 N -  Campo obrigat�rio. Sempre �51�.
    FTipoInscricaoEmpresa: String; // 1 N - Campo obrigat�rio. S� pode ser 1 (CNPJ) ou 2 (CEI).
    FInscricaoEmpresa: String; { 14 N - Campo obrigat�rio. Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. }
    FTipoInscricaoTomador: String; // 1 N - S� pode ser 1 (CNPJ) ou 2 (CEI). Para os demais c�digos de recolhimento, campo deve ficar em branco.
    FInscricaoTomador: String; { 14 N - (Destinado � informa��o da inscri��o da empresa tomadora de servi�o nos recolhimentos de trabalhadores avulsos,
      presta��o de servi�os, obra de constru��o civil e dirigente sindical). 95 108 14 N � Se Tipo Inscri��o = 1, ent�o n�mero esperado CNPJ v�lido.
      Se Tipo Inscri��o = 2, ent�o n�mero esperado CEI v�lido. CNPJ do tomador n�o pode ser igual ao da empresa. }
    FPISPASEP: String; // 11 N - Campo obrigat�rio. O n�mero informado deve ser v�lido
    FDataAdmissao: TDateTime; { 8 D - Formato DDMMAAAA. Obrigat�rio para as categorias de trabalhadores 01, 03, 04 e 05 e deve conter uma data v�lida.
      N�o pode ser informado para a categoria 02. Deve ser menor ou igual a compet�ncia informada. Deve ser maior ou igual a 22/01/1998 para a
      categoria de trabalhador 04. Sempre que n�o informado o campo deve ficar em branco. }
    FCategoriaTrabalhador: String; // 2 N - C�digo deve estar na tabela categoria do trabalhador. Campo obrigat�rio.
    FNomeTrabalhador: String; { 70 A - Campo obrigat�rio. N�o pode conter n�mero. N�o pode conter caracteres especiais. N�o pode haver caracteres acentuados.
      N�o � permitido mais de um espa�o entre os nomes. N�o � permitido tr�s ou mais caracteres iguais consecutivos. A primeira posi��o n�o pode ser
      branco. Pode conter apenas caracteres de A a Z. }
    FMatriculaEmpregado: String; // 11 N - N�mero de matr�cula atribu�do pela empresa ao trabalhador, quando houver.
    FNumeroCTPS: String; { 7 N - Obrigat�rio para as categorias de trabalhadores 01, 03 e 04. Opcional para a categoria de trabalhador 02.
      N�o pode ser informado para a categoria 05. Sempre que n�o informado o campo deve ficar em branco. }
    FSerieCTPS: String; { 5 N - Obrigat�rio para as categorias de trabalhadores 01, 03 e 04. Opcional para a categoria de trabalhador 02.
      N�o pode ser informado para a categoria 05. Sempre que n�o informado o campo deve ficar em branco. }
    FDataOpcao: TDateTime; { 8 D - (Indicar a data em que o trabalhador optou pelo FGTS). Formato DDMMAAAA. Obrigat�rio para as categorias de trabalhadores
      optantes 01, 03, 04, 05, 06 e 07 e deve conter uma data v�lida. � N�o pode ser informado para a categoria 02. Deve ser maior ou igual que a data
      de admiss�o. Deve ser maior ou igual que a data de admiss�o e limitada a 05/10/1988 quando a data de admiss�o for menor que 05/10/1988.
      Deve ser igual a admiss�o quando a data de admiss�o for maior ou igual a 05/10/1988. Deve ser maior ou igual a data de admiss�o, para a categoria
      de trabalhador 05. N�o pode ser informado para o c�digo de recolhimento 046. N�o pode ser menor que 01/01/1967.
      Sempre que n�o informado o campo deve ficar em branco. }
    FDataNascimento: TDateTime; { 8 D - Formato DDMMAAAA. Deve ser informado para as categorias de trabalhadores 01, 02, 03, 04 e 05 e deve conter uma data
      v�lida. Deve ser menor que a data de admiss�o. Deve ser maior a 01/01/1900. }
    FCBO: String; { 5 AN - C�digo Brasileiro de Ocupa��o. Campo Obrigat�rio. Utilizar os quatro primeiros d�gitos do grupo �Fam�lia� do novo CBO,
      acrescentando zero a esquerda.(0 + XXXX onde XXXX � o c�digo da fam�lia do novo CBO a qual pertence o trabalhador).
      Deve ser igual a 05121 para empregado dom�stico (categoria 06). C�digo �fam�lia� deve estar contido na tabela do novo CBO. }
    FValorDepositoSem13Salario: Double; { 15 V - (Destinado � informa��o do valor do dep�sito efetuado, sem a parcela do 13� . 168 182 15 V � Campo opcional.
      Se informado deve ter 2 casas decimais v�lidas. Sempre que n�o informado preencher com zeros. }
    FValorDepositoSobre13Salario: Double; { 15 V - (Destinado � informa��o do valor do dep�sito sobre a parcela do 13� 173 197 15 V � Campo opcional.
      Sempre que n�o informado preencher com zeros. }
    FValorJAM: Double; // 15 V - (Informar o valor de juros e atualiza��o monet�ria ). Campo opcional. Sempre que n�o informado preencher com zeros.
    /// Brancos 147 AN - Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha 1 AN - Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property TipoInscricaoEmpresa: String read FTipoInscricaoEmpresa write FTipoInscricaoEmpresa;
    property InscricaoEmpresa: String read FInscricaoEmpresa write FInscricaoEmpresa;
    property TipoInscricaoTomador: String read FTipoInscricaoTomador write FTipoInscricaoTomador;
    property InscricaoTomador: String read FInscricaoTomador write FInscricaoTomador;
    property PISPASEP: String read FPISPASEP write FPISPASEP;
    property DataAdmissao: TDateTime read FDataAdmissao write FDataAdmissao;
    property CategoriaTrabalhador: String read FCategoriaTrabalhador write FCategoriaTrabalhador;
    property NomeTrabalhador: String read FNomeTrabalhador write FNomeTrabalhador;
    property MatriculaEmpregado: String read FMatriculaEmpregado write FMatriculaEmpregado;
    property NumeroCTPS: String read FNumeroCTPS write FNumeroCTPS;
    property SerieCTPS: String read FSerieCTPS write FSerieCTPS;
    property DataOpcao: TDateTime read FDataOpcao write FDataOpcao;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property CBO: String read FCBO write FCBO;
    property ValorDepositoSem13Salario: Double read FValorDepositoSem13Salario write FValorDepositoSem13Salario;
    property ValorDepositoSobre13Salario: Double read FValorDepositoSobre13Salario write FValorDepositoSobre13Salario;
    property ValorJAM: Double read FValorJAM write FValorJAM;
    /// Brancos Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha. Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

  end;

  // REGISTRO TIPO 51 - Lista
  TRegistroTipo51List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroTipo51;
    procedure SetItem(Index: Integer; const Value: TRegistroTipo51);
  public
    function New: TRegistroTipo51;
    property Items[Index: Integer]: TRegistroTipo51 read GetItem write SetItem;
  end;

  // REGISTRO TIPO 90 � Registro Totalizador do Arquivo
  TRegistroTipo90 = class
  private
    FTipoRegistro: String; // 2 N -  Campo obrigat�rio.  Sempre �90�.
    FMarcaFinalRegistro: String ; // 51 AN - Campo obrigat�rio. De 3 a 53 deve ser �9�.
    /// Brancos 306 AN - Campo obrigat�rio. Preencher com brancos.
   /// Final de Linha 1 AN - Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property TipoRegistro: String read FTipoRegistro write FTipoRegistro;
    property MarcaFinalRegistro: String read FMarcaFinalRegistro write FMarcaFinalRegistro;
    /// Brancos. Campo obrigat�rio. Preencher com brancos.
    /// Final de Linha. Campo obrigat�rio. Deve ser uma constante �*� para marcar fim de linha.

  end;

implementation

{ TRegistroTipo00 }

constructor TRegistroTipo00.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo00.Destroy;
begin
  inherited;
end;

{ TRegistroTipo10 }

constructor TRegistroTipo10.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo10.Destroy;
begin
  inherited;
end;

{ TRegistroTipo12List }

function TRegistroTipo12List.GetItem(Index: Integer): TRegistroTipo12;
begin
  Result := TRegistroTipo12(inherited Items[Index]);
end;

function TRegistroTipo12List.New: TRegistroTipo12;
begin
  Result := TRegistroTipo12.Create;
  Add(Result);
end;

procedure TRegistroTipo12List.SetItem(Index: Integer; const Value: TRegistroTipo12);
begin
  Put(Index, Value);
end;

{ TRegistroTipo12 }

constructor TRegistroTipo12.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo12.Destroy;
begin
  inherited;
end;

{ TRegistroTipo13List }

function TRegistroTipo13List.GetItem(Index: Integer): TRegistroTipo13;
begin
  Result := TRegistroTipo13(inherited Items[Index]);
end;

function TRegistroTipo13List.New: TRegistroTipo13;
begin
  Result := TRegistroTipo13.Create;
  Add(Result);
end;

procedure TRegistroTipo13List.SetItem(Index: Integer; const Value: TRegistroTipo13);
begin
  Put(Index, Value);
end;

{ TRegistroTipo13 }

constructor TRegistroTipo13.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo13.Destroy;
begin
  inherited;
end;

{ TRegistroTipo14List }

function TRegistroTipo14List.GetItem(Index: Integer): TRegistroTipo14;
begin
  Result := TRegistroTipo14( inherited Items[Index]);
end;

function TRegistroTipo14List.New: TRegistroTipo14;
begin
  Result := TRegistroTipo14.Create;
  Add(Result);
end;

procedure TRegistroTipo14List.SetItem(Index: Integer; const Value: TRegistroTipo14);
begin
  Put(Index, Value);
end;

{ TRegistroTipo14 }

constructor TRegistroTipo14.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo14.Destroy;
begin
  inherited;
end;

{ TRegistroTipo20List }

function TRegistroTipo20List.GetItem(Index: Integer): TRegistroTipo20;
begin
  Result := TRegistroTipo20(inherited Items[Index]);
end;

function TRegistroTipo20List.New: TRegistroTipo20;
begin
  Result := TRegistroTipo20.Create;
  Add(Result);
end;

procedure TRegistroTipo20List.SetItem(Index: Integer; const Value: TRegistroTipo20);
begin
  Put(Index, Value);
end;

{ TRegistroTipo20 }

constructor TRegistroTipo20.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo20.Destroy;
begin
  inherited;
end;

{ TRegistroTipo21List }

function TRegistroTipo21List.GetItem(Index: Integer): TRegistroTipo21;
begin
  Result := TRegistroTipo21(inherited Items[Index]);
end;

function TRegistroTipo21List.New: TRegistroTipo21;
begin
  Result := TRegistroTipo21.Create;
  Add(Result);
end;

procedure TRegistroTipo21List.SetItem(Index: Integer; const Value: TRegistroTipo21);
begin
  Put(Index, Value);
end;

{ TRegistroTipo21 }

constructor TRegistroTipo21.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo21.Destroy;
begin
  inherited;
end;

{ TRegistroTipo30List }

function TRegistroTipo30List.GetItem(Index: Integer): TRegistroTipo30;
begin
  Result := TRegistroTipo30(inherited Items[Index]);
end;

function TRegistroTipo30List.New: TRegistroTipo30;
begin
  Result := TRegistroTipo30.Create;
  Add(Result);
end;

procedure TRegistroTipo30List.SetItem(Index: Integer; const Value: TRegistroTipo30);
begin
  Put(Index, Value);
end;

{ TRegistroTipo30 }

constructor TRegistroTipo30.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo30.Destroy;
begin
  inherited;
end;

{ TRegistroTipo32List }

function TRegistroTipo32List.GetItem(Index: Integer): TRegistroTipo32;
begin
  Result := TRegistroTipo32(inherited Items[Index]);
end;

function TRegistroTipo32List.New: TRegistroTipo32;
begin
  Result := TRegistroTipo32.Create;
  Add(Result);
end;

procedure TRegistroTipo32List.SetItem(Index: Integer; const Value: TRegistroTipo32);
begin
  Put(Index, Value);
end;

{ TRegistroTipo32 }

constructor TRegistroTipo32.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo32.Destroy;
begin
  inherited;
end;

{ TRegistroTipo50List }

function TRegistroTipo50List.GetItem(Index: Integer): TRegistroTipo50;
begin
  Result := TRegistroTipo50(inherited Items[Index]);
end;

function TRegistroTipo50List.New: TRegistroTipo50;
begin
  Result := TRegistroTipo50.Create;
  Add(Result);
end;

procedure TRegistroTipo50List.SetItem(Index: Integer; const Value: TRegistroTipo50);
begin
  Put(Index, Value);
end;

{ TRegistroTipo50 }

constructor TRegistroTipo50.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo50.Destroy;
begin
  inherited;
end;

{ TRegistroTipo51List }

function TRegistroTipo51List.GetItem(Index: Integer): TRegistroTipo51;
begin
  Result := TRegistroTipo51(inherited Items[Index]);
end;

function TRegistroTipo51List.New: TRegistroTipo51;
begin
  Result := TRegistroTipo51.Create;
  Add(Result);
end;

procedure TRegistroTipo51List.SetItem(Index: Integer; const Value: TRegistroTipo51);
begin
  Put(Index, Value);
end;

{ TRegistroTipo51 }

constructor TRegistroTipo51.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo51.Destroy;
begin
  inherited;
end;

{ TRegistroTipo90 }

constructor TRegistroTipo90.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistroTipo90.Destroy;
begin
  inherited;
end;

end.
