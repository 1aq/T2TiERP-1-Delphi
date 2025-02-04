{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela de Cadastro do Frete da Venda

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
unit UFreteVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, LabeledCtrls, Atributos, Constantes,
  Mask, JvExMask, JvToolEdit, JvBaseEdits, StrUtils;

type
  [TFormDescription(TConstantes.MODULO_VENDAS, 'Frete')]

  TFFreteVenda = class(TFTelaCadastro)
    EditPlaca: TLabeledEdit;
    EditMarcaVolume: TLabeledEdit;
    BevelEdits: TBevel;
    EditUfPlaca: TLabeledEdit;
    EditConhecimento: TLabeledCalcEdit;
    ComboBoxResponsavel: TLabeledComboBox;
    EditSeloFiscal: TLabeledCalcEdit;
    EditQuantidadeVolumes: TLabeledCalcEdit;
    EditEspecieVolume: TLabeledEdit;
    EditPesoBruto: TLabeledCalcEdit;
    EditPesoLiquido: TLabeledCalcEdit;
    EditIdVendaCabecalho: TLabeledCalcEdit;
    EditIdTransportadora: TLabeledCalcEdit;
    EditTransportadora: TLabeledEdit;
    EditVendaCabecalho: TLabeledCalcEdit;
    procedure FormCreate(Sender: TObject);
    procedure EditIdVendaCabecalhoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdVendaCabecalhoExit(Sender: TObject);
    procedure EditIdTransportadoraExit(Sender: TObject);
    procedure EditIdTransportadoraKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdVendaCabecalhoKeyPress(Sender: TObject; var Key: Char);
    procedure EditIdTransportadoraKeyPress(Sender: TObject; var Key: Char);

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
  FFreteVenda: TFFreteVenda;

implementation

uses VendaFreteController, VendaFreteVO, NotificationService, ULookup,
  VendaCabecalhoVO, VendaCabecalhoController, TransportadoraVO, TransportadoraController;
{$R *.dfm}

{$REGION 'Infra'}
procedure TFFreteVenda.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TVendaFreteVO;
  ObjetoController := TVendaFreteController.Create;

  inherited;
end;

procedure TFFreteVenda.ControlaBotoes;
begin
  inherited;

  BotaoImprimir.Visible := False;
end;

procedure TFFreteVenda.ControlaPopupMenu;
begin
  inherited;

  MenuImprimir.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFFreteVenda.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditIdVendaCabecalho.SetFocus;
  end;
end;

function TFFreteVenda.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditIdVendaCabecalho.SetFocus;
  end;
end;

function TFFreteVenda.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TVendaFreteController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TVendaFreteController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFFreteVenda.DoSalvar: Boolean;
begin
  DecimalSeparator := '.';
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TVendaFreteVO.Create;

      TVendaFreteVO(ObjetoVO).IdVendaCabecalho := EditIdVendaCabecalho.AsInteger;
      TVendaFreteVO(ObjetoVO).IdTransportadora := EditIdTransportadora.AsInteger;
      TVendaFreteVO(ObjetoVO).Conhecimento := EditConhecimento.AsInteger;
      TVendaFreteVO(ObjetoVO).Responsavel := IntToStr(ComboBoxResponsavel.ItemIndex + 1);
      TVendaFreteVO(ObjetoVO).Placa := EditPlaca.Text;
      TVendaFreteVO(ObjetoVO).UfPlaca := EditUfPlaca.Text;
      TVendaFreteVO(ObjetoVO).SeloFiscal := EditSeloFiscal.AsInteger;
      TVendaFreteVO(ObjetoVO).QuantidadeVolume := EditQuantidadeVolumes.Value;
      TVendaFreteVO(ObjetoVO).MarcaVolume := EditMarcaVolume.Text;
      TVendaFreteVO(ObjetoVO).EspecieVolume := EditEspecieVolume.Text;
      TVendaFreteVO(ObjetoVO).PesoBruto := EditPesoBruto.Value;
      TVendaFreteVO(ObjetoVO).PesoLiquido := EditPesoLiquido.Value;

      // ObjetoVO - libera objetos vinculados (TAssociation) - n�o tem necessidade de subir
      TVendaFreteVO(ObjetoVO).VendaCabecalhoVO := Nil;
      TVendaFreteVO(ObjetoVO).TransportadoraVO := Nil;

      // ObjetoOldVO - libera objetos vinculados (TAssociation) - n�o tem necessidade de subir
      if Assigned(ObjetoOldVO) then
      begin
        TVendaFreteVO(ObjetoOldVO).VendaCabecalhoVO := Nil;
        TVendaFreteVO(ObjetoOldVO).TransportadoraVO := Nil;
      end;

      if StatusTela = stInserindo then
        Result := TVendaFreteController(ObjetoController).Insere(TVendaFreteVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TVendaFreteVO(ObjetoVO).ToJSONString <> TVendaFreteVO(ObjetoOldVO).ToJSONString then
        begin
          TVendaFreteVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TVendaFreteController(ObjetoController).Altera(TVendaFreteVO(ObjetoVO), TVendaFreteVO(ObjetoOldVO));
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
procedure TFFreteVenda.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TVendaFreteVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TVendaFreteVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditIdVendaCabecalho.AsInteger := TVendaFreteVO(ObjetoVO).IdVendaCabecalho;
    EditVendaCabecalho.AsInteger := TVendaFreteVO(ObjetoVO).VendaCabecalhoNumeroFatura;
    EditIdTransportadora.AsInteger := TVendaFreteVO(ObjetoVO).IdTransportadora;
    EditTransportadora.Text := TVendaFreteVO(ObjetoVO).TransportadoraNome;
    EditConhecimento.AsInteger := TVendaFreteVO(ObjetoVO).Conhecimento;
    ComboBoxResponsavel.ItemIndex := StrToInt(TVendaFreteVO(ObjetoVO).Responsavel) + 1;
    EditPlaca.Text := TVendaFreteVO(ObjetoVO).Placa;
    EditUfPlaca.Text := TVendaFreteVO(ObjetoVO).UfPlaca;
    EditSeloFiscal.AsInteger := TVendaFreteVO(ObjetoVO).SeloFiscal;
    EditQuantidadeVolumes.Value := TVendaFreteVO(ObjetoVO).QuantidadeVolume;
    EditMarcaVolume.Text := TVendaFreteVO(ObjetoVO).MarcaVolume;
    EditEspecieVolume.Text := TVendaFreteVO(ObjetoVO).EspecieVolume;
    EditPesoBruto.Value := TVendaFreteVO(ObjetoVO).PesoBruto;
    EditPesoLiquido.Value := TVendaFreteVO(ObjetoVO).PesoLiquido;
  end;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
// Venda
procedure TFFreteVenda.EditIdVendaCabecalhoExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdVendaCabecalho.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdVendaCabecalho.Text;
      EditIdVendaCabecalho.Clear;
      EditVendaCabecalho.Clear;
      if not PopulaCamposTransientes(Filtro, TVendaCabecalhoVO, TVendaCabecalhoController) then
        PopulaCamposTransientesLookup(TVendaCabecalhoVO, TVendaCabecalhoController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdVendaCabecalho.Text := CDSTransiente.FieldByName('ID').AsString;
        EditVendaCabecalho.Text := CDSTransiente.FieldByName('NUMERO_FATURA').AsString;
        // Transportadora
        EditIdTransportadora.Text := CDSTransiente.FieldByName('ID_TRANSPORTADORA').AsString;
        EditTransportadora.Text := CDSTransiente.FieldByName('TRANSPORTADORA.NOME').AsString;
      end
      else
      begin
        Exit;
        EditIdVendaCabecalho.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditVendaCabecalho.Clear;
  end;
end;

procedure TFFreteVenda.EditIdVendaCabecalhoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdVendaCabecalho.Value := -1;
    EditIdTransportadora.SetFocus;
  end;
end;

procedure TFFreteVenda.EditIdVendaCabecalhoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditIdTransportadora.SetFocus;
  end;
end;

// Transportadora
procedure TFFreteVenda.EditIdTransportadoraExit(Sender: TObject);
var
  Filtro: String;
begin
  if EditIdTransportadora.Value <> 0 then
  begin
    try
      Filtro := 'ID = ' + EditIdTransportadora.Text;
      EditIdTransportadora.Clear;
      EditTransportadora.Clear;
      if not PopulaCamposTransientes(Filtro, TTransportadoraVO, TTransportadoraController) then
        PopulaCamposTransientesLookup(TTransportadoraVO, TTransportadoraController);
      if CDSTransiente.RecordCount > 0 then
      begin
        EditIdTransportadora.Text := CDSTransiente.FieldByName('ID').AsString;
        EditTransportadora.Text := CDSTransiente.FieldByName('PESSOA.NOME').AsString;
      end
      else
      begin
        Exit;
        EditIdTransportadora.SetFocus;
      end;
    finally
      CDSTransiente.Close;
    end;
  end
  else
  begin
    EditTransportadora.Clear;
  end;
end;

procedure TFFreteVenda.EditIdTransportadoraKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F1 then
  begin
    EditIdTransportadora.Value := -1;
    EditConhecimento.SetFocus;
  end;
end;

procedure TFFreteVenda.EditIdTransportadoraKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditConhecimento.SetFocus;
  end;
end;

{$ENDREGION}

end.
