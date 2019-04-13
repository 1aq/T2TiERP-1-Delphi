{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela de Cadastro das Opera��es Fiscais

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
  t2ti.com@gmail.com

  @author Albert Eije
  @version 1.0
  ******************************************************************************* }
unit UTributOperacaoFiscal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, LabeledCtrls, Atributos, Constantes,
  Mask, JvExMask, JvToolEdit, JvBaseEdits, StrUtils;

type
  [TFormDescription(TConstantes.MODULO_ADMINISTRATIVO, 'Opera��o Fiscal')]

  TFTributOperacaoFiscal = class(TFTelaCadastro)
    EditDescricao: TLabeledEdit;
    BevelEdits: TBevel;
    EditCfop: TLabeledCalcEdit;
    EditDescricaoNf: TLabeledEdit;
    MemoObservacao: TLabeledMemo;
    EditCfopDescricao: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditCfopKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditCfopExit(Sender: TObject);
    procedure EditCfopKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
  public
    { Public declarations }
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FTributOperacaoFiscal: TFTributOperacaoFiscal;

implementation

uses ULookup, TributOperacaoFiscalVO, TributOperacaoFiscalController,
CfopVO, CfopController;

{$R *.dfm}

{$REGION 'Infra'}
procedure TFTributOperacaoFiscal.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TTributOperacaoFiscalVO;
  ObjetoController := TTributOperacaoFiscalController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFTributOperacaoFiscal.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditCfop.SetFocus;
  end;
end;

function TFTributOperacaoFiscal.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditCfop.SetFocus;
  end;
end;

function TFTributOperacaoFiscal.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TTributOperacaoFiscalController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TTributOperacaoFiscalController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFTributOperacaoFiscal.DoSalvar: Boolean;
begin
  DecimalSeparator := '.';
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TTributOperacaoFiscalVO.Create;

      TTributOperacaoFiscalVO(ObjetoVO).IdEmpresa := Sessao.IdEmpresa;
      TTributOperacaoFiscalVO(ObjetoVO).Cfop := EditCfop.AsInteger;
      TTributOperacaoFiscalVO(ObjetoVO).CfopDescricao := EditCfopDescricao.Text;
      TTributOperacaoFiscalVO(ObjetoVO).Descricao := EditDescricao.Text;
      TTributOperacaoFiscalVO(ObjetoVO).DescricaoNaNf := EditDescricaoNf.Text;
      TTributOperacaoFiscalVO(ObjetoVO).Observacao := MemoObservacao.Text;

      // ObjetoVO - libera objetos vinculados (TAssociation) - n�o tem necessidade de subir
      TTributOperacaoFiscalVO(ObjetoVO).CfopVO := Nil;

      // ObjetoOldVO - libera objetos vinculados (TAssociation) - n�o tem necessidade de subir
      if Assigned(ObjetoOldVO) then
      begin
        TTributOperacaoFiscalVO(ObjetoOldVO).CfopVO := Nil;
      end;

      if StatusTela = stInserindo then
        Result := TTributOperacaoFiscalController(ObjetoController).Insere(TTributOperacaoFiscalVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TTributOperacaoFiscalVO(ObjetoVO).ToJSONString <> TTributOperacaoFiscalVO(ObjetoOldVO).ToJSONString then
        begin
          TTributOperacaoFiscalVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TTributOperacaoFiscalController(ObjetoController).Altera(TTributOperacaoFiscalVO(ObjetoVO), TTributOperacaoFiscalVO(ObjetoOldVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
  DecimalSeparator := ',';
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFTributOperacaoFiscal.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TTributOperacaoFiscalVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TTributOperacaoFiscalVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
      EditCfop.AsInteger := TTributOperacaoFiscalVO(ObjetoVO).Cfop;
      EditCfopDescricao.Text := TTributOperacaoFiscalVO(ObjetoVO).CfopDescricao;
      EditDescricao.Text := TTributOperacaoFiscalVO(ObjetoVO).Descricao;
      EditDescricaoNf.Text := TTributOperacaoFiscalVO(ObjetoVO).DescricaoNaNf;
      MemoObservacao.Text := TTributOperacaoFiscalVO(ObjetoVO).Observacao;
  end;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
procedure TFTributOperacaoFiscal.EditCfopExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditCfop.Value <> 0 then
  begin
    try
      Filtro := 'CFOP = ' + EditCfop.Text;
      EditCfop.Clear;
      EditCfopDescricao.Clear;
      if not PopulaCamposTransientes(Filtro, TCfopVO, TCfopController) then
        PopulaCamposTransientesLookup(TCfopVO, TCfopController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditCfop.AsInteger := CDSTransiente.FieldByName('CFOP').AsInteger;
        EditCfopDescricao.Text := CDSTransiente.FieldByName('DESCRICAO').AsString;
      end
      else
      begin
        Exit;
        EditCfop.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditCfopDescricao.Clear;
  end;
end;

procedure TFTributOperacaoFiscal.EditCfopKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditCfop.Value := -1;
    EditDescricao.SetFocus;
  end;
end;

procedure TFTributOperacaoFiscal.EditCfopKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditDescricao.SetFocus;
  end;
end;
{$ENDREGION}

end.
