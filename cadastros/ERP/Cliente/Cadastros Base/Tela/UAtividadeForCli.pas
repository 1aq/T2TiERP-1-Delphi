{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela Cadastro de AtividadeForCli

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

  @author Fernando L Oliveira
  @version 1.0   |   Fernando  @version 1.0.0.10
  ******************************************************************************* }
unit UAtividadeForCli;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, DB, DBClient, Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, AtividadeForCliVO,
  AtividadeForCliController, Tipos, Atributos, Constantes, LabeledCtrls;

type
  [TFormDescription(TConstantes.MODULO_CADASTROS, 'Atividade Cliente/Fornecedor')]

  TFAtividadeForCli = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditNome: TLabeledEdit;
    EditDescricao: TLabeledEdit;
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
  FAtividadeForCli: TFAtividadeForCli;

implementation

{$R *.dfm}

{$REGION 'Infra'}
procedure TFAtividadeForCli.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TAtividadeForCliVO;
  ObjetoController := TAtividadeForCliController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFAtividadeForCli.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditNome.SetFocus;
  end;
end;

function TFAtividadeForCli.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditNome.SetFocus;
  end;
end;

function TFAtividadeForCli.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TAtividadeForCliController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TAtividadeForCliController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFAtividadeForCli.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TAtividadeForCliVO.Create;

      TAtividadeForCliVO(ObjetoVO).Nome := EditNome.Text;
      TAtividadeForCliVO(ObjetoVO).Descricao := EditDescricao.Text;

      if StatusTela = stInserindo then
        Result := TAtividadeForCliController(ObjetoController).Insere(TAtividadeForCliVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TAtividadeForCliVO(ObjetoVO).ToJSONString <> TAtividadeForCliVO(ObjetoOldVO).ToJSONString then
        begin
          TAtividadeForCliVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TAtividadeForCliController(ObjetoController).Altera(TAtividadeForCliVO(ObjetoVO), TAtividadeForCliVO(ObjetoOldVO));
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
procedure TFAtividadeForCli.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TAtividadeForCliVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoVO.Clone;
  end;

  if Assigned(ObjetoVO) then
  begin
    EditNome.Text := TAtividadeForCliVO(ObjetoVO).Nome;
    EditDescricao.Text := TAtividadeForCliVO(ObjetoVO).Descricao;
  end;
end;
{$ENDREGION}

end.
