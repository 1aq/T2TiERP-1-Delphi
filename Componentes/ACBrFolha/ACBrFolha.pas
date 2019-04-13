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


{$I ACBr.inc}
unit ACBrFolha;

interface

uses
  SysUtils, Classes, DateUtils,
{$IFDEF FPC}
  LResources,
{$ENDIF}
{$IFDEF CLX} QForms, {$ELSE} Forms, {$ENDIF}
  ACBrTXTClass, ACBrUtil, ACBrFolha_Sefip,
  ACBrFolha_Sefip_Class, ACBrFolha_Caged, ACBrFolha_Caged_Class;

const
  CACBrFolha_Versao = '0.01';

type

  // DECLARANDO O COMPONENTE:

  { TACBrFolha }

  TACBrFolha = class(TComponent)
  private
    FOnError: TErrorEvent;

    FPath: String; // Path do arquivo a ser gerado
    FDelimitador: String; // Caracter delimitador de campos
    FTrimString: boolean; // Retorna a string sem espa�os em branco iniciais e finais
    FCurMascara: String; // Mascara para valores tipo currency

    FFolha_Sefip: TFolha_Sefip;
    FFolha_Caged: TFolha_Caged;

    function GetAbout: String;
    function GetDelimitador: String;
    function GetTrimString: boolean;
    function GetCurMascara: String;
    procedure SetDelimitador(const Value: String);
    procedure SetTrimString(const Value: boolean);
    procedure SetCurMascara(const Value: String);

    function GetOnError: TErrorEvent; // M�todo do evento OnError
    procedure SetOnError(const Value: TErrorEvent); // M�todo SetError

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override; // Create
    destructor Destroy; override; // Destroy

    function SaveFileTXT_Sefip(Arquivo: String): boolean; // M�todo que escreve o arquivo texto no caminho passado como par�metro
    function SaveFileTXT_Caged(Arquivo: String): boolean;

    property Folha_Sefip: TFolha_Sefip read FFolha_Sefip write FFolha_Sefip;
    property Folha_Caged: TFolha_Caged read FFolha_Caged write FFolha_Caged;

  published
    property About: String read GetAbout stored False;
    property Path: String read FPath write FPath;

    property Delimitador: String read GetDelimitador write SetDelimitador;
    property TrimString: boolean read GetTrimString write SetTrimString default True;
    property CurMascara: String read GetCurMascara write SetCurMascara;

    property OnError: TErrorEvent read GetOnError write SetOnError;
  end;

procedure Register;

implementation

Uses
{$IFDEF COMPILER6_UP} StrUtils {$ELSE} ACBrD5 {$ENDIF};
{$IFNDEF FPC}
{$R ACBrFolha.dcr}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBr', [TACBrFolha]);
end;

constructor TACBrFolha.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FFolha_Sefip := TFolha_Sefip.Create;
  FFolha_Caged := TFolha_Caged.Create;

  // Define o delimitador
  SetDelimitador('');

  // Define a mascara dos campos num�ricos
  SetCurMascara('');

  FPath := ExtractFilePath(ParamStr(0));
  FDelimitador := '';
  FCurMascara := '';
  FTrimString := True;
end;

destructor TACBrFolha.Destroy;
begin
  FFolha_Sefip.Free;
  FFolha_Caged.Free;

  inherited;
end;

function TACBrFolha.GetAbout: String;
begin
  Result := 'ACBrFolha Ver: ' + CACBrFolha_Versao;
end;

function TACBrFolha.GetDelimitador: String;
begin
  Result := FDelimitador;
end;

procedure TACBrFolha.SetDelimitador(const Value: String);
begin
  FDelimitador := Value;

  FFolha_Sefip.Delimitador := Value;
  FFolha_Caged.Delimitador := Value;
end;

function TACBrFolha.GetCurMascara: String;
begin
  Result := FCurMascara;
end;

procedure TACBrFolha.SetCurMascara(const Value: String);
begin
  FCurMascara := Value;

  FFolha_Sefip.CurMascara := Value;
  FFolha_Caged.CurMascara := Value;
end;

function TACBrFolha.GetTrimString: boolean;
begin
  Result := FTrimString;
end;

procedure TACBrFolha.SetTrimString(const Value: boolean);
begin
  FTrimString := Value;

  FFolha_Sefip.TrimString := Value;
  FFolha_Caged.TrimString := Value;
end;

function TACBrFolha.GetOnError: TErrorEvent;
begin
  Result := FOnError;
end;

procedure TACBrFolha.SetOnError(const Value: TErrorEvent);
begin
  FOnError := Value;

  FFolha_Sefip.OnError := Value;
end;

function TACBrFolha.SaveFileTXT_Sefip(Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      Write(txtFile, FFolha_Sefip.WriteRegistroTipo00);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo10);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo12);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo13);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo14);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo20);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo21);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo30);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo32);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo50);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo51);
      Write(txtFile, FFolha_Sefip.WriteRegistroTipo90);

    finally
      CloseFile(txtFile);
    end;

    // Limpa todos os registros.
    FFolha_Sefip.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrFolha.SaveFileTXT_Caged(Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      Write(txtFile, FFolha_Caged.WriteRegistroTipoA);
      Write(txtFile, FFolha_Caged.WriteRegistroTipoB);
      Write(txtFile, FFolha_Caged.WriteRegistroTipoC);
      Write(txtFile, FFolha_Caged.WriteRegistroTipoX);

    finally
      CloseFile(txtFile);
    end;

    // Limpa todos os registros.
    FFolha_Caged.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

procedure TACBrFolha.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

{$IFDEF FPC}

initialization

{$I ACBrFolha.lrs}
{$ENDIF}

end.

