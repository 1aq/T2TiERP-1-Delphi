{ *******************************************************************************
  Title: T2Ti ERP
  Description: Janela Cadastro de Municípios

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
unit UMunicipio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, ComCtrls, LabeledCtrls, Tipos, Atributos,
  Constantes, MunicipioVO, MunicipioController, Mask, JvExMask, JvToolEdit,
  JvBaseEdits;

type
  [TFormDescription(TConstantes.MODULO_CADASTROS, 'Município')]

  TFMunicipio = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditUfSigla: TLabeledEdit;
    EditNome: TLabeledEdit;
    EditCodigoIbge: TLabeledCalcEdit;
    EditCodigoEstadual: TLabeledCalcEdit;
    EditCodigoReceitaFederal: TLabeledCalcEdit;
    EditUfNome: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;
    procedure ControlaBotoes; override;
  end;

var
  FMunicipio: TFMunicipio;

implementation

uses ULookup, UfController, UfVO, Biblioteca, UDataModule;
{$R *.dfm}

{$REGION 'Infra'}
procedure TFMunicipio.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TMunicipioVO;
  ObjetoController := TMunicipioController.Create;
  inherited;

end;

procedure TFMunicipio.ControlaBotoes;
begin
  inherited;

  BotaoInserir.Visible := False;
  BotaoAlterar.Visible := False;
  BotaoExcluir.Visible := False;
  BotaoSalvar.Visible := False;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFMunicipio.GridParaEdits;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    ObjetoVO := ObjetoController.VO<TMunicipioVO>(IdRegistroSelecionado);
    if StatusTela = stEditando then
      ObjetoOldVO := ObjetoVO.Clone;
  end;

  if Assigned(ObjetoVO) then
  begin
    EditUfSigla.Text := TMunicipioVO(ObjetoVO).UfSigla;
    EditUfNome.Text := TMunicipioVO(ObjetoVO).UfNome;
    EditNome.Text := TMunicipioVO(ObjetoVO).Nome;
    EditCodigoIbge.AsInteger := TMunicipioVO(ObjetoVO).CodigoIBGE;
    EditCodigoReceitaFederal.AsInteger := TMunicipioVO(ObjetoVO).CodigoReceitaFederal;
    EditCodigoEstadual.AsInteger := TMunicipioVO(ObjetoVO).CodigoEstadual;
  end;
end;
{$ENDREGION}

end.
