{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela Cadastro de Bancos

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

  @author S�rgio
  @version 1.0   |   Fernando  @version 1.0.0.10
  ******************************************************************************* }
unit UAlmoxarifado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, Atributos, Constantes,
  LabeledCtrls;

type
  [TFormDescription(TConstantes.MODULO_CADASTROS, 'Almoxarifado')]
  TFAlmoxarifado = class(TFTelaCadastro)
    EditNome: TLabeledEdit;
    BevelEdits: TBevel;
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
  FAlmoxarifado: TFAlmoxarifado;

implementation

uses AlmoxarifadoController, AlmoxarifadoVO, NotificationService;

{$R *.dfm}

{$REGION 'Infra'}
procedure TFAlmoxarifado.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TAlmoxarifadoVO;
  ObjetoController := TAlmoxarifadoController.Create;
  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFAlmoxarifado.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditNome.SetFocus;
  end;
end;

function TFAlmoxarifado.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditNome.SetFocus;
  end;
end;

function TFAlmoxarifado.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TAlmoxarifadoController(ObjetoController).Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    TAlmoxarifadoController(ObjetoController).Consulta(Filtro, Pagina);
end;

function TFAlmoxarifado.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TAlmoxarifadoVO.Create;

      TAlmoxarifadoVO(ObjetoVO).IdEmpresa := Sessao.IdEmpresa;
      TAlmoxarifadoVO(ObjetoVO).Nome := EditNome.Text;

      TAlmoxarifadoVO(ObjetoVO).EmpresaVO := Nil;
      if Assigned(ObjetoOldVO) then
      begin
        TAlmoxarifadoVO(ObjetoOldVO).EmpresaVO := Nil;
      end;

      if StatusTela = stInserindo then
        Result := TAlmoxarifadoController(ObjetoController).Insere(TAlmoxarifadoVO(ObjetoVO))
      else if StatusTela = stEditando then
      begin
        if TAlmoxarifadoVO(ObjetoVO).ToJSONString <> TAlmoxarifadoVO(ObjetoOldVO).ToJSONString then
        begin
          TAlmoxarifadoVO(ObjetoVO).Id := IdRegistroSelecionado;
          Result := TAlmoxarifadoController(ObjetoController).Altera(TAlmoxarifadoVO(ObjetoVO), TAlmoxarifadoVO(ObjetoOldVO));
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
procedure TFAlmoxarifado.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TAlmoxarifadoVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoVO.Clone;
  end;

  if Assigned(ObjetoVO) then
  begin
    EditNome.Text := TAlmoxarifadoVO(ObjetoVO).Nome;
  end;
end;
{$ENDREGION}

end.
