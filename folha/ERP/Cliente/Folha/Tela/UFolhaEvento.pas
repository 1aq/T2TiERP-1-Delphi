{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela Eventos para a Folha de Pagamento

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
unit UFolhaEvento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, FolhaEventoVO,
  FolhaEventoController, Tipos, Atributos, Constantes, LabeledCtrls, Mask,
  JvExMask, JvToolEdit, JvBaseEdits, StrUtils;

type
  [TFormDescription(TConstantes.MODULO_FOLHA_PAGAMENTO, 'Eventos')]

  TFFolhaEvento = class(TFTelaCadastro)
    BevelEdits: TBevel;
    ComboBoxBaseCalculo: TLabeledComboBox;
    EditTaxa: TLabeledCalcEdit;
    EditCodigo: TLabeledEdit;
    EditNome: TLabeledEdit;
    MemoDescricao: TLabeledMemo;
    ComboBoxTipo: TLabeledComboBox;
    ComboBoxUnidade: TLabeledComboBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FFolhaEvento: TFFolhaEvento;

implementation

{$R *.dfm}

{$REGION 'Controles Infra'}
procedure TFFolhaEvento.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TFolhaEventoVO;
  ObjetoController := TFolhaEventoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFFolhaEvento.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditCodigo.SetFocus;
  end;
end;

function TFFolhaEvento.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditCodigo.SetFocus;
  end;
end;

function TFFolhaEvento.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TFolhaEventoController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TFolhaEventoController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFFolhaEvento.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      DecimalSeparator := '.';
      if not Assigned(ObjetoVO) then
        ObjetoVO := TFolhaEventoVO.Create;

      TFolhaEventoVO(ObjetoVO).IdEmpresa := Sessao.IdEmpresa;
      TFolhaEventoVO(ObjetoVO).Codigo := EditCodigo.Text;
      TFolhaEventoVO(ObjetoVO).Nome := EditNome.Text;
      TFolhaEventoVO(ObjetoVO).Descricao := MemoDescricao.Text;
      TFolhaEventoVO(ObjetoVO).BaseCalculo := Copy(ComboBoxBaseCalculo.Text, 1, 2);
      TFolhaEventoVO(ObjetoVO).Tipo := IfThen(ComboBoxTipo.ItemIndex = 0, 'P', 'D');
      TFolhaEventoVO(ObjetoVO).Unidade := IfThen(ComboBoxUnidade.ItemIndex = 0, 'V', 'P');
      TFolhaEventoVO(ObjetoVO).Taxa := EditTaxa.Value;

      if StatusTela = stInserindo then
        Result := TFolhaEventoController(ObjetoController).Insere(TFolhaEventoVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TFolhaEventoVO(ObjetoVO).ToJSONString <> TFolhaEventoVO(ObjetoOldVO).ToJSONString then
        begin
          TFolhaEventoVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TFolhaEventoController(ObjetoController).Altera(TFolhaEventoVO(ObjetoVO), TFolhaEventoVO(ObjetoOldVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
      DecimalSeparator := ',';
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFFolhaEvento.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TFolhaEventoVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TFolhaEventoVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditCodigo.Text := TFolhaEventoVO(ObjetoVO).Codigo;
    EditNome.Text := TFolhaEventoVO(ObjetoVO).Nome;
    MemoDescricao.Text := TFolhaEventoVO(ObjetoVO).Descricao;
    ComboBoxBaseCalculo.ItemIndex := StrToInt(TFolhaEventoVO(ObjetoVO).BaseCalculo) - 1;
    ComboBoxTipo.ItemIndex := AnsiIndexStr(TFolhaEventoVO(ObjetoVO).Tipo, ['P', 'D']);
    ComboBoxUnidade.ItemIndex := AnsiIndexStr(TFolhaEventoVO(ObjetoVO).Unidade, ['V', 'P']);
    EditTaxa.Value := TFolhaEventoVO(ObjetoVO).Taxa;
  end;
end;
{$ENDREGION}

end.
