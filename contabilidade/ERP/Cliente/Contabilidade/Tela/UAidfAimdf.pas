{*******************************************************************************
Title: T2Ti ERP
Description: Janela Cadastro de AIDF e AIMDF

The MIT License

Copyright: Copyright (C) 2010 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

The author may be contacted at:
t2ti.com@gmail.com</p>

@author Albert Eije (alberteije@gmail.com)
@version 1.0
*******************************************************************************}
unit UAidfAimdf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, AidfAimdfVO,
  AidfAimdfController, Tipos, Atributos, Constantes, LabeledCtrls, Mask, JvExMask,
  JvToolEdit, JvMaskEdit, JvExStdCtrls, JvEdit, JvValidateEdit, JvBaseEdits, Math, StrUtils;

type
  [TFormDescription(TConstantes.MODULO_CONTABILIDADE, 'Aidf Aimdf')]

  TFAidfAimdf = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditNumeroAutorizacao: TLabeledEdit;
    EditDataAutorizacao: TLabeledDateEdit;
    EditDataValidade: TLabeledDateEdit;
    ComboBoxFormularioDisponivel: TLabeledComboBox;
    EditNumero: TLabeledCalcEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure ControlaBotoes; override;
    procedure ControlaPopupMenu; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FAidfAimdf: TFAidfAimdf;

implementation

uses ULookup, Biblioteca, UDataModule;
{$R *.dfm}

{$REGION 'Controles Infra'}
procedure TFAidfAimdf.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TAidfAimdfVO;
  ObjetoController := TAidfAimdfController.Create;
  inherited;
end;

procedure TFAidfAimdf.ControlaBotoes;
begin
  inherited;

  BotaoImprimir.Visible := False;
end;

procedure TFAidfAimdf.ControlaPopupMenu;
begin
  inherited;

  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFAidfAimdf.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditNumero.SetFocus;
  end;
end;

function TFAidfAimdf.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditNumero.SetFocus;
  end;
end;

function TFAidfAimdf.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TAidfAimdfController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TAidfAimdfController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFAidfAimdf.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      ObjetoVO := TAidfAimdfVO.Create;

      TAidfAimdfVO(ObjetoVO).IdEmpresa := Sessao.IdEmpresa;
      TAidfAimdfVO(ObjetoVO).Numero := EditNumero.AsInteger;
      TAidfAimdfVO(ObjetoVO).DataAutorizacao := EditDataAutorizacao.Date;
      TAidfAimdfVO(ObjetoVO).DataValidade := EditDataValidade.Date;
      TAidfAimdfVO(ObjetoVO).NumeroAutorizacao := EditNumeroAutorizacao.Text;
      TAidfAimdfVO(ObjetoVO).FormularioDisponivel := IfThen(ComboBoxFormularioDisponivel.ItemIndex = 0, 'S', 'N');

      if StatusTela = stInserindo then
        Result := TAidfAimdfController(ObjetoController).Insere(TAidfAimdfVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TAidfAimdfVO(ObjetoVO).ToJSONString <> TAidfAimdfVO(ObjetoOldVO).ToJSONString then
        begin
          TAidfAimdfVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TAidfAimdfController(ObjetoController).Altera(TAidfAimdfVO(ObjetoVO), TAidfAimdfVO(ObjetoOldVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFAidfAimdf.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TAidfAimdfVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TAidfAimdfVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditNumero.Text := IntToStr(TAidfAimdfVO(ObjetoVO).Numero);
    EditDataAutorizacao.Date := TAidfAimdfVO(ObjetoVO).DataAutorizacao;
    EditDataValidade.Date := TAidfAimdfVO(ObjetoVO).DataValidade;
    EditNumeroAutorizacao.Text := TAidfAimdfVO(ObjetoVO).NumeroAutorizacao;
    ComboBoxFormularioDisponivel.ItemIndex := AnsiIndexStr(TAidfAimdfVO(ObjetoVO).FormularioDisponivel, ['S', 'N']);
  end;
end;
{$ENDREGION}

end.
