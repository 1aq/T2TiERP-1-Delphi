{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela de Cadastro dos Grupos Tribut�rios

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
unit UTributGrupoTributario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, LabeledCtrls, Atributos, Constantes,
  Mask, JvExMask, JvToolEdit, JvBaseEdits, StrUtils;

type
  [TFormDescription(TConstantes.MODULO_ADMINISTRATIVO, 'Grupo Tribut�rio')]

  TFTributGrupoTributario = class(TFTelaCadastro)
    EditDescricao: TLabeledEdit;
    BevelEdits: TBevel;
    MemoObservacao: TLabeledMemo;
    ComboboxOrigemMercadoria: TLabeledComboBox;
    procedure FormCreate(Sender: TObject);

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
  FTributGrupoTributario: TFTributGrupoTributario;

implementation

uses ULookup, TributGrupoTributarioVO, TributGrupoTributarioController;

{$R *.dfm}

{$REGION 'Infra'}
procedure TFTributGrupoTributario.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TTributGrupoTributarioVO;
  ObjetoController := TTributGrupoTributarioController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFTributGrupoTributario.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditDescricao.SetFocus;
  end;
end;

function TFTributGrupoTributario.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditDescricao.SetFocus;
  end;
end;

function TFTributGrupoTributario.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TTributGrupoTributarioController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TTributGrupoTributarioController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFTributGrupoTributario.DoSalvar: Boolean;
begin
  DecimalSeparator := '.';
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TTributGrupoTributarioVO.Create;

      TTributGrupoTributarioVO(ObjetoVO).IdEmpresa := Sessao.IdEmpresa;
      TTributGrupoTributarioVO(ObjetoVO).Descricao := EditDescricao.Text;
      TTributGrupoTributarioVO(ObjetoVO).Observacao := MemoObservacao.Text;
      TTributGrupoTributarioVO(ObjetoVO).OrigemMercadoria := Copy(ComboboxOrigemMercadoria.Text, 1, 1);

      if StatusTela = stInserindo then
        Result := TTributGrupoTributarioController(ObjetoController).Insere(TTributGrupoTributarioVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TTributGrupoTributarioVO(ObjetoVO).ToJSONString <> TTributGrupoTributarioVO(ObjetoOldVO).ToJSONString then
        begin
          TTributGrupoTributarioVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TTributGrupoTributarioController(ObjetoController).Altera(TTributGrupoTributarioVO(ObjetoVO), TTributGrupoTributarioVO(ObjetoOldVO));
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
procedure TFTributGrupoTributario.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TTributGrupoTributarioVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoController.VO<TTributGrupoTributarioVO>(IdRegistroSelecionado);
  end;

  if Assigned(ObjetoVO) then
  begin
      EditDescricao.Text := TTributGrupoTributarioVO(ObjetoVO).Descricao;
      MemoObservacao.Text := TTributGrupoTributarioVO(ObjetoVO).Observacao;
      ComboboxOrigemMercadoria.ItemIndex := StrToInt(TTributGrupoTributarioVO(ObjetoVO).OrigemMercadoria);
  end;
end;
{$ENDREGION}

end.
