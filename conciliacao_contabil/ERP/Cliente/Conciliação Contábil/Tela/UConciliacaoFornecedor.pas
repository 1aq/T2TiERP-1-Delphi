{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela de concilia��o dos fornecedores - M�dulo Concilia��o Cont�bil

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

  t2ti.com@gmail.com
  @author Albert Eije (T2Ti.COM)
  @version 1.0
  ******************************************************************************* }
unit UConciliacaoFornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, FornecedorVO,
  FornecedorController, Tipos, Atributos, Constantes, LabeledCtrls, JvToolEdit,
  Mask, JvExMask, JvBaseEdits, Math, StrUtils, CheckLst, ActnList, ToolWin,
  ActnMan, ActnCtrls, PlatformDefaultStyleActnCtrls, JvExExtCtrls,
  JvNetscapeSplitter;

type
  [TFormDescription(TConstantes.MODULO_CONCILIACAO_CONTABIL, 'Concilia��o Fornecedor')]

  TFConciliacaoFornecedor = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditIdContabilConta: TLabeledCalcEdit;
    EditContabilConta: TLabeledEdit;
    CDSParcelaPagamento: TClientDataSet;
    DSParcelaPagamento: TDataSource;
    CDSContabilLancamento: TClientDataSet;
    CDSContabilLancamentoID: TIntegerField;
    CDSContabilLancamentoID_CONTABIL_CONTA: TIntegerField;
    CDSContabilLancamentoID_CONTABIL_HISTORICO: TIntegerField;
    CDSContabilLancamentoID_CONTABIL_LANCAMENTO_CAB: TIntegerField;
    CDSContabilLancamentoHISTORICO: TStringField;
    CDSContabilLancamentoTIPO: TStringField;
    CDSContabilLancamentoVALOR: TFMTBCDField;
    DSContabilLancamento: TDataSource;
    GroupBox4: TGroupBox;
    JvDBUltimGrid2: TJvDBUltimGrid;
    CDSLancamentoConciliado: TClientDataSet;
    DSLancamentoConciliado: TDataSource;
    ActionManager1: TActionManager;
    ActionToolBar1: TActionToolBar;
    ActionListarLancamentos: TAction;
    ActionConciliacao: TAction;
    EditIdFornecedor: TLabeledCalcEdit;
    EditFornecedor: TLabeledEdit;
    CDSParcelaPagamentoID: TIntegerField;
    CDSParcelaPagamentoID_CONTA_CAIXA: TIntegerField;
    CDSParcelaPagamentoID_TIPO_PAGAMENTO: TIntegerField;
    CDSParcelaPagamentoID_CHEQUE_EMITIDO: TIntegerField;
    CDSParcelaPagamentoID_PARCELA: TIntegerField;
    CDSParcelaPagamentoDATA_PAGAMENTO: TDateField;
    CDSParcelaPagamentoTAXA_JURO: TFMTBCDField;
    CDSParcelaPagamentoTAXA_MULTA: TFMTBCDField;
    CDSParcelaPagamentoTAXA_DESCONTO: TFMTBCDField;
    CDSParcelaPagamentoVALOR_JURO: TFMTBCDField;
    CDSParcelaPagamentoVALOR_MULTA: TFMTBCDField;
    CDSParcelaPagamentoVALOR_DESCONTO: TFMTBCDField;
    CDSParcelaPagamentoVALOR_PAGO: TFMTBCDField;
    CDSParcelaPagamentoHISTORICO: TStringField;
    CDSLancamentoConciliadoDATA_PAGAMENTO: TDateField;
    CDSLancamentoConciliadoDATA_BALANCETE: TDateField;
    CDSLancamentoConciliadoHISTORICO_PAGAMENTO: TStringField;
    CDSLancamentoConciliadoVALOR_PAGAMENTO: TFMTBCDField;
    CDSLancamentoConciliadoCLASSIFICACAO: TStringField;
    CDSLancamentoConciliadoHISTORICO_CONTA: TStringField;
    CDSLancamentoConciliadoTIPO: TStringField;
    CDSLancamentoConciliadoVALOR_CONTA: TFMTBCDField;
    PanelLancamentos: TPanel;
    GroupBox2: TGroupBox;
    GridDetalhe: TJvDBUltimGrid;
    GroupBox3: TGroupBox;
    JvDBUltimGrid1: TJvDBUltimGrid;
    JvNetscapeSplitter1: TJvNetscapeSplitter;
    EditPeriodoInicial: TLabeledDateEdit;
    EditPeriodoFinal: TLabeledDateEdit;
    CDSContabilLancamentoCONTABIL_CONTACLASSIFICACAO: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure ActionListarLancamentosExecute(Sender: TObject);
    procedure ActionConciliacaoExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure ControlaBotoes; override;
    procedure LimparCampos; override;
  end;

var
  FConciliacaoFornecedor: TFConciliacaoFornecedor;

implementation

uses ULookup, Biblioteca, UDataModule, ContabilContaVO, ContabilLancamentoDetalheController,
ViewConciliaFornecedorController;
{$R *.dfm}

{$REGION 'Controles Infra'}
procedure TFConciliacaoFornecedor.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TFornecedorVO;
  ObjetoController := TFornecedorController.Create;

  inherited;
end;

procedure TFConciliacaoFornecedor.ControlaBotoes;
begin
  inherited;

  BotaoInserir.Visible := False;
  BotaoAlterar.Visible := False;
  BotaoExcluir.Visible := False;
  BotaoSalvar.Visible := False;
end;

procedure TFConciliacaoFornecedor.LimparCampos;
begin
  inherited;
  CDSParcelaPagamento.EmptyDataSet;
  CDSContabilLancamento.EmptyDataSet;
  CDSLancamentoConciliado.EmptyDataSet;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFConciliacaoFornecedor.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TFornecedorVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdContabilConta.AsInteger := TFornecedorVO(ObjetoVO).IdContabilConta;
    EditContabilConta.Text := TFornecedorVO(ObjetoVO).ContabilContaClassificacao;
    EditIdFornecedor.AsInteger := TFornecedorVO(ObjetoVO).Id;
    EditFornecedor.Text := TFornecedorVO(ObjetoVO).PessoaNome;
  end;
end;

procedure TFConciliacaoFornecedor.GridDblClick(Sender: TObject);
begin
  inherited;
  PanelEdits.Enabled := True;
  EditPeriodoInicial.SetFocus;
  if TFornecedorVO(ObjetoVO).IdContabilConta = 0 then
  begin
    Application.MessageBox('Fornecedor sem conta cont�bil vinculada.', 'Informa��o do Sistema', MB_OK + MB_IconInformation);
    BotaoCancelar.Click;
  end
end;
{$ENDREGION}

{$REGION 'Actions'}
procedure TFConciliacaoFornecedor.ActionListarLancamentosExecute(Sender: TObject);
begin
  // Contas Pagas
  TViewConciliaFornecedorController.SetDataSet(CDSParcelaPagamento);
  TViewConciliaFornecedorController.Consulta('ID_FORNECEDOR=' + IntToStr(TFornecedorVO(ObjetoVO).Id) + ' and (DATA_PAGAMENTO BETWEEN ' + QuotedStr(DataParaTexto(EditPeriodoInicial.Date)) + ' and ' + QuotedStr(DataParaTexto(EditPeriodoFinal.Date)) + ')', 0);

  // Lan�amentos Cont�beis
  TContabilLancamentoDetalheController.SetDataSet(CDSContabilLancamento);
  TContabilLancamentoDetalheController.Consulta('ID_CONTABIL_CONTA=' + IntToStr(TFornecedorVO(ObjetoVO).IdContabilConta), 0);
end;

procedure TFConciliacaoFornecedor.ActionConciliacaoExecute(Sender: TObject);
begin
  CDSParcelaPagamento.DisableControls;
  CDSContabilLancamento.DisableControls;

  CDSParcelaPagamento.First;
  while not CDSParcelaPagamento.Eof do
  begin

    CDSContabilLancamento.First;
    while not CDSContabilLancamento.Eof do
    begin

      if CDSParcelaPagamentoVALOR_PAGO.AsExtended = CDSContabilLancamentoVALOR.AsExtended then
      begin
        CDSLancamentoConciliado.Append;
        CDSLancamentoConciliadoDATA_PAGAMENTO.AsDateTime := CDSParcelaPagamentoDATA_PAGAMENTO.AsDateTime;
        CDSLancamentoConciliadoDATA_BALANCETE.AsDateTime := CDSParcelaPagamentoDATA_PAGAMENTO.AsDateTime;
        CDSLancamentoConciliadoHISTORICO_PAGAMENTO.AsString := CDSParcelaPagamentoHISTORICO.AsString;
        CDSLancamentoConciliadoVALOR_PAGAMENTO.AsExtended := CDSParcelaPagamentoVALOR_PAGO.AsExtended;
        CDSLancamentoConciliadoCLASSIFICACAO.AsString := CDSContabilLancamentoCONTABIL_CONTACLASSIFICACAO.AsString;
        CDSLancamentoConciliadoHISTORICO_CONTA.AsString := CDSContabilLancamentoHISTORICO.AsString;
        CDSLancamentoConciliadoTIPO.AsString := CDSContabilLancamentoTIPO.AsString;
        CDSLancamentoConciliadoVALOR_CONTA.AsExtended := CDSContabilLancamentoVALOR.AsExtended;
        CDSLancamentoConciliado.Post;
      end;

      CDSContabilLancamento.Next;
    end;
    CDSParcelaPagamento.Next;
  end;

  CDSParcelaPagamento.EnableControls;
  CDSContabilLancamento.EnableControls;
end;
{$ENDREGION}

end.
