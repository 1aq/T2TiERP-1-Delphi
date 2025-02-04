{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela Cadastro de Par�metros para o m�dulo Contabilidade

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
  ******************************************************************************* }
unit UContabilParametros;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, ContabilParametrosVO,
  ContabilParametrosController, Tipos, Atributos, Constantes, LabeledCtrls, Mask,
  JvExMask, JvToolEdit, JvBaseEdits, StrUtils;

type
  [TFormDescription(TConstantes.MODULO_CONTABILIDADE, 'Par�metros')]

  TFContabilParametros = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditNiveis: TLabeledCalcEdit;
    ComboBoxCompartilhaPlanoConta: TLabeledComboBox;
    ComboBoxInformarContaPor: TLabeledComboBox;
    EditMascara: TLabeledEdit;
    ComboBoxCompartilhaHistoricos: TLabeledComboBox;
    ComboBoxAlteraLancamentoOutro: TLabeledComboBox;
    ComboBoxHistoricoObrigatorio: TLabeledComboBox;
    ComboBoxPermiteLancamentoZerado: TLabeledComboBox;
    ComboBoxGeraInformativoSped: TLabeledComboBox;
    ComboBoxSpedFormaEscrituracaoContabil: TLabeledComboBox;
    EditSpedNomeLivroDiario: TLabeledEdit;
    PageControlItens: TPageControl;
    tsComplemento: TTabSheet;
    PanelComplemento: TPanel;
    tsContas: TTabSheet;
    PanelContas: TPanel;
    GroupBox1: TGroupBox;
    MemoAssinaturaEsquerda: TLabeledMemo;
    MemoAssinaturaDireita: TLabeledMemo;
    EditHistoricoPadraoResultado: TLabeledEdit;
    EditHistoricoPadraoLucro: TLabeledEdit;
    EditHistoricoPadraoPrejuizo: TLabeledEdit;
    GridContas: TJvDBUltimGrid;
    CDSContas: TClientDataSet;
    DSContas: TDataSource;
    CDSContasCONTA: TStringField;
    CDSContasCLASSIFICACAO: TStringField;
    EditIdHistoricoPadraoResultado: TLabeledCalcEdit;
    EditIdHistoricoPadraoLucro: TLabeledCalcEdit;
    EditIdHistoricoPadraoPrejuizo: TLabeledCalcEdit;
    procedure FormCreate(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure CDSContasAfterPost(DataSet: TDataSet);
    procedure GridContasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdHistoricoPadraoResultadoExit(Sender: TObject);
    procedure EditIdHistoricoPadraoResultadoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdHistoricoPadraoResultadoKeyPress(Sender: TObject; var Key: Char);
    procedure EditIdHistoricoPadraoLucroExit(Sender: TObject);
    procedure EditIdHistoricoPadraoLucroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdHistoricoPadraoLucroKeyPress(Sender: TObject; var Key: Char);
    procedure EditIdHistoricoPadraoPrejuizoExit(Sender: TObject);
    procedure EditIdHistoricoPadraoPrejuizoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdHistoricoPadraoPrejuizoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure PopularGridContas;
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure LimparCampos; override;
    procedure ControlaBotoes; override;
    procedure ControlaPopupMenu; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;

    procedure ConfigurarLayoutTela;
  end;

var
  FContabilParametros: TFContabilParametros;

implementation

uses ContabilContaController, ContabilContaVO, ContabilHistoricoVO, ContabilHistoricoController;

{$R *.dfm}

{$REGION 'Controles Infra'}
procedure TFContabilParametros.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TContabilParametrosVO;
  ObjetoController := TContabilParametrosController.Create;

  inherited;
end;

procedure TFContabilParametros.LimparCampos;
begin
  inherited;
  CDSContas.EmptyDataSet;
end;

procedure TFContabilParametros.ConfigurarLayoutTela;
begin
  PanelEdits.Enabled := True;

  if StatusTela = stNavegandoEdits then
  begin
    PanelComplemento.Enabled := False;
    PanelContas.Enabled := False;
  end
  else
  begin
    PanelComplemento.Enabled := True;
    PanelContas.Enabled := True;
  end;
end;

procedure TFContabilParametros.ControlaBotoes;
begin
  inherited;

  BotaoImprimir.Visible := False;
end;

procedure TFContabilParametros.ControlaPopupMenu;
begin
  inherited;

  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFContabilParametros.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    ConfigurarLayoutTela;
    PopularGridContas;
    EditMascara.SetFocus;
  end;
end;

function TFContabilParametros.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    ConfigurarLayoutTela;
    PopularGridContas;
    EditMascara.SetFocus;
  end;
end;

function TFContabilParametros.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TContabilParametrosController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TContabilParametrosController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFContabilParametros.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TContabilParametrosVO.Create;

      TContabilParametrosVO(ObjetoVO).IdEmpresa := Sessao.IdEmpresa;
      TContabilParametrosVO(ObjetoVO).Mascara := EditMascara.Text;
      TContabilParametrosVO(ObjetoVO).Niveis := EditNiveis.AsInteger;
      TContabilParametrosVO(ObjetoVO).InformarContaPor := IfThen(ComboBoxInformarContaPor.ItemIndex = 0, 'C', 'M');
      TContabilParametrosVO(ObjetoVO).CompartilhaPlanoConta := IfThen(ComboBoxCompartilhaPlanoConta.ItemIndex = 0, 'S', 'N');
      TContabilParametrosVO(ObjetoVO).CompartilhaHistoricos := IfThen(ComboBoxCompartilhaHistoricos.ItemIndex = 0, 'S', 'N');
      TContabilParametrosVO(ObjetoVO).AlteraLancamentoOutro := IfThen(ComboBoxAlteraLancamentoOutro.ItemIndex = 0, 'S', 'N');
      TContabilParametrosVO(ObjetoVO).HistoricoObrigatorio := IfThen(ComboBoxHistoricoObrigatorio.ItemIndex = 0, 'S', 'N');
      TContabilParametrosVO(ObjetoVO).PermiteLancamentoZerado := IfThen(ComboBoxPermiteLancamentoZerado.ItemIndex = 0, 'S', 'N');
      TContabilParametrosVO(ObjetoVO).GeraInformativoSped := IfThen(ComboBoxGeraInformativoSped.ItemIndex = 0, 'S', 'N');
      TContabilParametrosVO(ObjetoVO).SpedFormaEscritDiario := Copy(ComboBoxSpedFormaEscrituracaoContabil.Text, 1, 3);
      TContabilParametrosVO(ObjetoVO).SpedNomeLivroDiario := EditSpedNomeLivroDiario.Text;
      TContabilParametrosVO(ObjetoVO).AssinaturaDireita := MemoAssinaturaDireita.Text;
      TContabilParametrosVO(ObjetoVO).AssinaturaEsquerda := MemoAssinaturaEsquerda.Text;
      TContabilParametrosVO(ObjetoVO).IdHistPadraoResultado := EditIdHistoricoPadraoResultado.AsInteger;
      TContabilParametrosVO(ObjetoVO).IdHistPadraoLucro := EditIdHistoricoPadraoLucro.AsInteger;
      TContabilParametrosVO(ObjetoVO).IdHistPadraoPrejuizo := EditIdHistoricoPadraoPrejuizo.AsInteger;

      // Contas
      CDSContas.DisableControls;
      CDSContas.First;
      while not CDSContas.Eof do
      begin
        TContabilParametrosVO(ObjetoVO).ContaAtivo := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaPassivo := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaPatrimonioLiquido := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaDepreciacaoAcumulada := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaCapitalSocial := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaResultadoExercicio := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaPrejuizoAcumulado := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaLucroAcumulado := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaTituloPagar := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaTituloReceber := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaJurosPassivo := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaJurosAtivo := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaDescontoObtido := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaDescontoConcedido := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaCmv := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaVenda := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaVendaServico := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaEstoque := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaApuraResultado := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
        TContabilParametrosVO(ObjetoVO).ContaJurosApropriar := CDSContasCLASSIFICACAO.AsString;
        CDSContas.Next;
      end;
      CDSContas.First;
      CDSContas.EnableControls;

      if StatusTela = stInserindo then
        Result := TContabilParametrosController(ObjetoController).Insere(TContabilParametrosVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TContabilParametrosVO(ObjetoVO).ToJSONString <> TContabilParametrosVO(ObjetoOldVO).ToJSONString then
        begin
          TContabilParametrosVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TContabilParametrosController(ObjetoController).Altera(TContabilParametrosVO(ObjetoVO), TContabilParametrosVO(ObjetoOldVO));
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

{$REGION 'Campos Transientes'}
procedure TFContabilParametros.EditIdHistoricoPadraoLucroExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdHistoricoPadraoLucro.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdHistoricoPadraoLucro.Text;
      EditIdHistoricoPadraoLucro.Clear;
      EditHistoricoPadraoLucro.Clear;
      if not PopulaCamposTransientes(Filtro, TContabilHistoricoVO, TContabilHistoricoController) then
        PopulaCamposTransientesLookup(TContabilHistoricoVO, TContabilHistoricoController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdHistoricoPadraoLucro.Text := CDSTransiente.FieldByName('ID').AsString;
        EditHistoricoPadraoLucro.Text := CDSTransiente.FieldByName('DESCRICAO').AsString;
      end
      else
      begin
        Exit;
        EditIdHistoricoPadraoLucro.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditHistoricoPadraoLucro.Clear;
  end;
end;

procedure TFContabilParametros.EditIdHistoricoPadraoLucroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdHistoricoPadraoLucro.Value := -1;
    EditIdHistoricoPadraoPrejuizo.SetFocus;
  end;
end;

procedure TFContabilParametros.EditIdHistoricoPadraoLucroKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditIdHistoricoPadraoPrejuizo.SetFocus;
  end;
end;

procedure TFContabilParametros.EditIdHistoricoPadraoPrejuizoExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdHistoricoPadraoPrejuizo.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdHistoricoPadraoPrejuizo.Text;
      EditIdHistoricoPadraoPrejuizo.Clear;
      EditHistoricoPadraoPrejuizo.Clear;
      if not PopulaCamposTransientes(Filtro, TContabilHistoricoVO, TContabilHistoricoController) then
        PopulaCamposTransientesLookup(TContabilHistoricoVO, TContabilHistoricoController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdHistoricoPadraoPrejuizo.Text := CDSTransiente.FieldByName('ID').AsString;
        EditHistoricoPadraoPrejuizo.Text := CDSTransiente.FieldByName('NOME').AsString;
      end
      else
      begin
        Exit;
        EditIdHistoricoPadraoPrejuizo.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditHistoricoPadraoPrejuizo.Clear;
  end;
end;

procedure TFContabilParametros.EditIdHistoricoPadraoPrejuizoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdHistoricoPadraoPrejuizo.Value := -1;
    EditMascara.SetFocus;
  end;
end;

procedure TFContabilParametros.EditIdHistoricoPadraoPrejuizoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditMascara.SetFocus;
  end;
end;

procedure TFContabilParametros.EditIdHistoricoPadraoResultadoExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdHistoricoPadraoResultado.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdHistoricoPadraoResultado.Text;
      EditIdHistoricoPadraoResultado.Clear;
      EditHistoricoPadraoResultado.Clear;
      if not PopulaCamposTransientes(Filtro, TContabilHistoricoVO, TContabilHistoricoController) then
        PopulaCamposTransientesLookup(TContabilHistoricoVO, TContabilHistoricoController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdHistoricoPadraoResultado.Text := CDSTransiente.FieldByName('ID').AsString;
        EditHistoricoPadraoResultado.Text := CDSTransiente.FieldByName('DESCRICAO').AsString;
      end
      else
      begin
        Exit;
        EditIdHistoricoPadraoResultado.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditHistoricoPadraoResultado.Clear;
  end;
end;

procedure TFContabilParametros.EditIdHistoricoPadraoResultadoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdHistoricoPadraoResultado.Value := -1;
    EditIdHistoricoPadraoLucro.SetFocus;
  end;
end;

procedure TFContabilParametros.EditIdHistoricoPadraoResultadoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditIdHistoricoPadraoLucro.SetFocus;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFContabilParametros.GridDblClick(Sender: TObject);
begin
  inherited;
  ConfigurarLayoutTela;
  PopularGridContas;
end;

procedure TFContabilParametros.GridParaEdits;
var
  HistoricoVO: TContabilHistoricoVO;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TContabilParametrosVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TContabilParametrosVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin

    EditMascara.Text := TContabilParametrosVO(ObjetoVO).Mascara;
    EditNiveis.AsInteger := TContabilParametrosVO(ObjetoVO).Niveis;
    ComboBoxInformarContaPor.ItemIndex := AnsiIndexStr(TContabilParametrosVO(ObjetoVO).InformarContaPor, ['C', 'M']);
    ComboBoxCompartilhaPlanoConta.ItemIndex := AnsiIndexStr(TContabilParametrosVO(ObjetoVO).CompartilhaPlanoConta, ['S', 'N']);
    ComboBoxCompartilhaHistoricos.ItemIndex := AnsiIndexStr(TContabilParametrosVO(ObjetoVO).CompartilhaHistoricos, ['S', 'N']);
    ComboBoxAlteraLancamentoOutro.ItemIndex := AnsiIndexStr(TContabilParametrosVO(ObjetoVO).AlteraLancamentoOutro, ['S', 'N']);
    ComboBoxHistoricoObrigatorio.ItemIndex := AnsiIndexStr(TContabilParametrosVO(ObjetoVO).HistoricoObrigatorio, ['S', 'N']);
    ComboBoxPermiteLancamentoZerado.ItemIndex := AnsiIndexStr(TContabilParametrosVO(ObjetoVO).PermiteLancamentoZerado, ['S', 'N']);
    ComboBoxGeraInformativoSped.ItemIndex := AnsiIndexStr(TContabilParametrosVO(ObjetoVO).GeraInformativoSped, ['S', 'N']);
    ComboBoxSpedFormaEscrituracaoContabil.ItemIndex := AnsiIndexStr(TContabilParametrosVO(ObjetoVO).SpedFormaEscritDiario, ['LDC', 'LDE', 'LBD']);

    EditSpedNomeLivroDiario.Text := TContabilParametrosVO(ObjetoVO).SpedNomeLivroDiario;
    MemoAssinaturaDireita.Text := TContabilParametrosVO(ObjetoVO).AssinaturaDireita;
    MemoAssinaturaEsquerda.Text := TContabilParametrosVO(ObjetoVO).AssinaturaEsquerda;

    EditIdHistoricoPadraoResultado.AsInteger := TContabilParametrosVO(ObjetoVO).IdHistPadraoResultado;
    if EditIdHistoricoPadraoResultado.AsInteger > 0 then
    begin
      HistoricoVO := TContabilHistoricoController.VO<TContabilHistoricoVO>('ID', EditIdHistoricoPadraoResultado.Text);
      if Assigned(HistoricoVO) then
        EditHistoricoPadraoResultado.Text := HistoricoVO.Descricao;
    end;

    EditIdHistoricoPadraoLucro.AsInteger := TContabilParametrosVO(ObjetoVO).IdHistPadraoLucro;
    if EditIdHistoricoPadraoLucro.AsInteger > 0 then
    begin
      HistoricoVO := TContabilHistoricoController.VO<TContabilHistoricoVO>('ID', EditIdHistoricoPadraoLucro.Text);
      if Assigned(HistoricoVO) then
        EditHistoricoPadraoLucro.Text := HistoricoVO.Descricao;
    end;

    EditIdHistoricoPadraoPrejuizo.AsInteger := TContabilParametrosVO(ObjetoVO).IdHistPadraoPrejuizo;
    if EditIdHistoricoPadraoPrejuizo.AsInteger > 0 then
    begin
      HistoricoVO := TContabilHistoricoController.VO<TContabilHistoricoVO>('ID', EditIdHistoricoPadraoPrejuizo.Text);
      if Assigned(HistoricoVO) then
        EditHistoricoPadraoPrejuizo.Text := HistoricoVO.Descricao;
    end;
  end;
end;

procedure TFContabilParametros.GridContasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    try
      PopulaCamposTransientesLookup(TContabilContaVO, TContabilContaController);
      if CDSTransiente.RecordCount > 0 then
      begin
        CDSContas.Edit;
        CDSContasCLASSIFICACAO.AsString := CDSTransiente.FieldByName('CLASSIFICACAO').AsString;
        CDSContas.Post;
      end;
    finally
      CDSTransiente.Close;
    end;
  end;
  If Key = VK_RETURN then
    EditMascara.SetFocus;
end;

procedure TFContabilParametros.PopularGridContas;
var
  i: Integer;
begin
  for i := 1 to 20 do
  begin
    CDSContas.Append;
    case i of
      1:
        begin
          CDSContasCONTA.AsString := 'Conta Ativo';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaAtivo;
          end;
        end;
      2:
        begin
          CDSContasCONTA.AsString := 'Conta Passivo';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaPassivo;
          end;
        end;
      3:
        begin
          CDSContasCONTA.AsString := 'Conta Patrim�nio L�quido';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaPatrimonioLiquido;
          end;
        end;
      4:
        begin
          CDSContasCONTA.AsString := 'Conta Deprecia��o Acumulada';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaDepreciacaoAcumulada;
          end;
        end;
      5:
        begin
          CDSContasCONTA.AsString := 'Conta Capital Social';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaCapitalSocial;
          end;
        end;
      6:
        begin
          CDSContasCONTA.AsString := 'Conta Resultado Exerc�cio';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaResultadoExercicio;
          end;
        end;
      7:
        begin
          CDSContasCONTA.AsString := 'Conta Preju�zo Acumulado';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaPrejuizoAcumulado;
          end;
        end;
      8:
        begin
          CDSContasCONTA.AsString := 'Conta Lucro Acumulado';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaLucroAcumulado;
          end;
        end;
      9:
        begin
          CDSContasCONTA.AsString := 'Conta T�tulo a Pagar';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaTituloPagar;
          end;
        end;
      10:
        begin
          CDSContasCONTA.AsString := 'Conta T�tulo a Receber';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaTituloReceber;
          end;
        end;
      11:
        begin
          CDSContasCONTA.AsString := 'Conta Juros Passivo';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaJurosPassivo;
          end;
        end;
      12:
        begin
          CDSContasCONTA.AsString := 'Conta Juros Ativo';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaJurosAtivo;
          end;
        end;
      13:
        begin
          CDSContasCONTA.AsString := 'Conta Desconto Obtido';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaDescontoObtido;
          end;
        end;
      14:
        begin
          CDSContasCONTA.AsString := 'Conta Desconto Concedido';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaDescontoConcedido;
          end;
        end;
      15:
        begin
          CDSContasCONTA.AsString := 'Conta CMV';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaCmv;
          end;
        end;
      16:
        begin
          CDSContasCONTA.AsString := 'Conta Venda';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaVenda;
          end;
        end;
      17:
        begin
          CDSContasCONTA.AsString := 'Conta Venda Servi�o';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaVendaServico;
          end;
        end;
      18:
        begin
          CDSContasCONTA.AsString := 'Conta Estoque';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaEstoque;
          end;
        end;
      19:
        begin
          CDSContasCONTA.AsString := 'Conta Apura Resultado';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaApuraResultado;
          end;
        end;
      20:
        begin
          CDSContasCONTA.AsString := 'Conta Juros Apropriar';
          if (StatusTela = stEditando) or (StatusTela = stNavegandoEdits) then
          begin
            CDSContasCLASSIFICACAO.AsString := TContabilParametrosVO(ObjetoVO).ContaJurosApropriar;
          end;
        end;
    end;
    CDSContas.Post;
  end;
  CDSContas.First;
end;

procedure TFContabilParametros.CDSContasAfterPost(DataSet: TDataSet);
begin
  if CDSContasCONTA.AsString = '' then
    CDSContas.Delete;
end;
{$ENDREGION}


end.
