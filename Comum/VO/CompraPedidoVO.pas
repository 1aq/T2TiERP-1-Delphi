{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [COMPRA_PEDIDO] 
                                                                                
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
                                                                                
@author Albert Eije (t2ti.com@gmail.com)                    
@version 1.0                                                                    
*******************************************************************************}
unit CompraPedidoVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect,
  SysUtils, FornecedorVO, CompraTipoPedidoVO, CompraPedidoDetalheVO, CompraCotacaoPedidoDetalheVO;

type
  [TEntity]
  [TTable('COMPRA_PEDIDO')]
  TCompraPedidoVO = class(TJsonVO)
  private
    FID: Integer;
    FID_COMPRA_TIPO_PEDIDO: Integer;
    FID_FORNECEDOR: Integer;
    FDATA_PEDIDO: TDateTime;
    FDATA_PREVISTA_ENTREGA: TDateTime;
    FDATA_PREVISAO_PAGAMENTO: TDateTime;
    FLOCAL_ENTREGA: String;
    FLOCAL_COBRANCA: String;
    FCONTATO: String;
    FVALOR_SUBTOTAL: Extended;
    FTAXA_DESCONTO: Extended;
    FVALOR_DESCONTO: Extended;
    FVALOR_TOTAL_PEDIDO: Extended;
    FTIPO_FRETE: String;
    FFORMA_PAGAMENTO: String;
    FBASE_CALCULO_ICMS: Extended;
    FVALOR_ICMS: Extended;
    FBASE_CALCULO_ICMS_ST: Extended;
    FVALOR_ICMS_ST: Extended;
    FVALOR_TOTAL_PRODUTOS: Extended;
    FVALOR_FRETE: Extended;
    FVALOR_SEGURO: Extended;
    FVALOR_OUTRAS_DESPESAS: Extended;
    FVALOR_IPI: Extended;
    FVALOR_TOTAL_NF: Extended;
    FQUANTIDADE_PARCELAS: Integer;
    FDIAS_PRIMEIRO_VENCIMENTO: Integer;
    FDIAS_INTERVALO: Integer;

    FFornecedorPessoaNome: String;
    FCompraTipoPedidoNome: String;

    FFornecedorVO: TFornecedorVO;
    FCompraTipoPedidoVO: TCompraTipoPedidoVO;

    FListaCompraPedidoDetalheVO: TObjectList<TCompraPedidoDetalheVO>;
    FListaCompraCotacaoPedidoDetalheVO: TObjectList<TCompraCotacaoPedidoDetalheVO>;

  public 
    constructor Create; overload; override;
    constructor Create(pJsonValue: TJSONValue); overload; override;
    destructor Destroy; override;
    function ToJSON: TJSONValue; override;

    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property Id: Integer  read FID write FID;

    [TColumn('ID_COMPRA_TIPO_PEDIDO','Id Compra Tipo Pedido',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdCompraTipoPedido: Integer  read FID_COMPRA_TIPO_PEDIDO write FID_COMPRA_TIPO_PEDIDO;
    [TColumn('COMPRA_TIPO_PEDIDO.NOME', 'Tipo Pedido', 250, [ldGrid, ldLookup, ldComboBox], True, 'COMPRA_TIPO_PEDIDO', 'ID_COMPRA_TIPO_PEDIDO', 'ID')]
    property CompraTipoPedidoNome: String read FCompraTipoPedidoNome write FCompraTipoPedidoNome;

    [TColumn('ID_FORNECEDOR','Id Fornecedor',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property IdFornecedor: Integer  read FID_FORNECEDOR write FID_FORNECEDOR;
    [TColumn('FORNECEDOR.PESSOA.NOME', 'Requisitante', 250, [ldGrid, ldLookup, ldComboBox], True, 'FORNECEDOR', 'ID_FORNECEDOR', 'ID')]
    property FornecedorPessoaNome: String read FFornecedorPessoaNome write FFornecedorPessoaNome;

    [TColumn('DATA_PEDIDO','Data Pedido',80,[ldGrid, ldLookup, ldCombobox], False)]
    property DataPedido: TDateTime  read FDATA_PEDIDO write FDATA_PEDIDO;
    [TColumn('DATA_PREVISTA_ENTREGA','Data Prevista Entrega',80,[ldGrid, ldLookup, ldCombobox], False)]
    property DataPrevistaEntrega: TDateTime  read FDATA_PREVISTA_ENTREGA write FDATA_PREVISTA_ENTREGA;
    [TColumn('DATA_PREVISAO_PAGAMENTO','Data Previsao Pagamento',80,[ldGrid, ldLookup, ldCombobox], False)]
    property DataPrevisaoPagamento: TDateTime  read FDATA_PREVISAO_PAGAMENTO write FDATA_PREVISAO_PAGAMENTO;
    [TColumn('LOCAL_ENTREGA','Local Entrega',450,[ldGrid, ldLookup, ldCombobox], False)]
    property LocalEntrega: String  read FLOCAL_ENTREGA write FLOCAL_ENTREGA;
    [TColumn('LOCAL_COBRANCA','Local Cobranca',450,[ldGrid, ldLookup, ldCombobox], False)]
    property LocalCobranca: String  read FLOCAL_COBRANCA write FLOCAL_COBRANCA;
    [TColumn('CONTATO','Contato',240,[ldGrid, ldLookup, ldCombobox], False)]
    property Contato: String  read FCONTATO write FCONTATO;
    [TColumn('VALOR_SUBTOTAL','Valor Subtotal',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorSubtotal: Extended  read FVALOR_SUBTOTAL write FVALOR_SUBTOTAL;
    [TColumn('TAXA_DESCONTO','Taxa Desconto',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property TaxaDesconto: Extended  read FTAXA_DESCONTO write FTAXA_DESCONTO;
    [TColumn('VALOR_DESCONTO','Valor Desconto',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorDesconto: Extended  read FVALOR_DESCONTO write FVALOR_DESCONTO;
    [TColumn('VALOR_TOTAL_PEDIDO','Valor Total Pedido',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorTotalPedido: Extended  read FVALOR_TOTAL_PEDIDO write FVALOR_TOTAL_PEDIDO;
    [TColumn('TIPO_FRETE','Tipo Frete',8,[ldGrid, ldLookup, ldCombobox], False)]
    property TipoFrete: String  read FTIPO_FRETE write FTIPO_FRETE;
    [TColumn('FORMA_PAGAMENTO','Forma Pagamento',8,[ldGrid, ldLookup, ldCombobox], False)]
    property FormaPagamento: String  read FFORMA_PAGAMENTO write FFORMA_PAGAMENTO;
    [TColumn('BASE_CALCULO_ICMS','Base Calculo Icms',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property BaseCalculoIcms: Extended  read FBASE_CALCULO_ICMS write FBASE_CALCULO_ICMS;
    [TColumn('VALOR_ICMS','Valor Icms',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorIcms: Extended  read FVALOR_ICMS write FVALOR_ICMS;
    [TColumn('BASE_CALCULO_ICMS_ST','Base Calculo Icms St',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property BaseCalculoIcmsSt: Extended  read FBASE_CALCULO_ICMS_ST write FBASE_CALCULO_ICMS_ST;
    [TColumn('VALOR_ICMS_ST','Valor Icms St',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorIcmsSt: Extended  read FVALOR_ICMS_ST write FVALOR_ICMS_ST;
    [TColumn('VALOR_TOTAL_PRODUTOS','Valor Total Produtos',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorTotalProdutos: Extended  read FVALOR_TOTAL_PRODUTOS write FVALOR_TOTAL_PRODUTOS;
    [TColumn('VALOR_FRETE','Valor Frete',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorFrete: Extended  read FVALOR_FRETE write FVALOR_FRETE;
    [TColumn('VALOR_SEGURO','Valor Seguro',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorSeguro: Extended  read FVALOR_SEGURO write FVALOR_SEGURO;
    [TColumn('VALOR_OUTRAS_DESPESAS','Valor Outras Despesas',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorOutrasDespesas: Extended  read FVALOR_OUTRAS_DESPESAS write FVALOR_OUTRAS_DESPESAS;
    [TColumn('VALOR_IPI','Valor Ipi',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorIpi: Extended  read FVALOR_IPI write FVALOR_IPI;
    [TColumn('VALOR_TOTAL_NF','Valor Total Nf',168,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftFloatComSeparador, taRightJustify)]
    property ValorTotalNf: Extended  read FVALOR_TOTAL_NF write FVALOR_TOTAL_NF;
    [TColumn('QUANTIDADE_PARCELAS','Quantidade Parcelas',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property QuantidadeParcelas: Integer  read FQUANTIDADE_PARCELAS write FQUANTIDADE_PARCELAS;
    [TColumn('DIAS_PRIMEIRO_VENCIMENTO','Dias Primeiro Vencimento',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property DiasPrimeiroVencimento: Integer  read FDIAS_PRIMEIRO_VENCIMENTO write FDIAS_PRIMEIRO_VENCIMENTO;
    [TColumn('DIAS_INTERVALO','Dias Intervalo',80,[ldGrid, ldLookup, ldCombobox], False)]
    [TFormatter(ftZerosAEsquerda, taCenter)]
    property DiasIntervalo: Integer  read FDIAS_INTERVALO write FDIAS_INTERVALO;

    [TAssociation(False, 'ID', 'ID_COMPRA_TIPO_PEDIDO', 'COMPRA_TIPO_PEDIDO')]
    property CompraTipoPedidoVO: TCompraTipoPedidoVO read FCompraTipoPedidoVO write FCompraTipoPedidoVO;

    [TAssociation(True, 'ID', 'ID_FORNECEDOR', 'FORNECEDOR')]
    property FornecedorVO: TFornecedorVO read FFornecedorVO write FFornecedorVO;

    [TManyValuedAssociation(True,'ID_COMPRA_PEDIDO','ID')]
    property ListaCompraPedidoDetalheVO: TObjectList<TCompraPedidoDetalheVO> read FListaCompraPedidoDetalheVO write FListaCompraPedidoDetalheVO;

    [TManyValuedAssociation(False,'ID_COMPRA_PEDIDO','ID')]
    property ListaCompraCotacaoPedidoDetalheVO: TObjectList<TCompraCotacaoPedidoDetalheVO> read FListaCompraCotacaoPedidoDetalheVO write FListaCompraCotacaoPedidoDetalheVO;
  end;

implementation

constructor TCompraPedidoVO.Create;
begin
  inherited;
  ListaCompraPedidoDetalheVO := TObjectList<TCompraPedidoDetalheVO>.Create;
  ListaCompraCotacaoPedidoDetalheVO := TObjectList<TCompraCotacaoPedidoDetalheVO>.Create;
end;

constructor TCompraPedidoVO.Create(pJsonValue: TJSONValue);
var
  Deserializa: TJSONUnMarshal;
begin
  if pJsonValue is TJSONNull then
    Exception.Create('Erro ao criar objeto com um valor nulo.');

  Deserializa := TJSONUnMarshal.Create;
  try
    Self.Free;

    //Lista Pedido Detalhe
    Deserializa.RegisterReverter(TCompraPedidoVO, 'FListaCompraPedidoDetalheVO', procedure(Data: TObject; Field: String; Args: TListOfObjects)
    var
      Obj: TObject;
    begin
      if not Assigned(TCompraPedidoVO(Data).FListaCompraPedidoDetalheVO) then
        TCompraPedidoVO(Data).FListaCompraPedidoDetalheVO := TObjectList<TCompraPedidoDetalheVO>.Create;

      for Obj in Args do
      begin
        TCompraPedidoVO(Data).FListaCompraPedidoDetalheVO.Add(TCompraPedidoDetalheVO(Obj));
      end
    end);

    //Lista de itens da cota��o que foram utilizados no pedido
    Deserializa.RegisterReverter(TCompraPedidoVO, 'FListaCompraCotacaoPedidoDetalheVO', procedure(Data: TObject; Field: String; Args: TListOfObjects)
    var
      Obj: TObject;
    begin
      if not Assigned(TCompraPedidoVO(Data).FListaCompraCotacaoPedidoDetalheVO) then
        TCompraPedidoVO(Data).FListaCompraCotacaoPedidoDetalheVO := TObjectList<TCompraCotacaoPedidoDetalheVO>.Create;

      for Obj in Args do
      begin
        TCompraPedidoVO(Data).FListaCompraCotacaoPedidoDetalheVO.Add(TCompraCotacaoPedidoDetalheVO(Obj));
      end
    end);

    Self := Deserializa.Unmarshal(pJsonValue) as TCompraPedidoVO;
  finally
    Deserializa.Free;
  end;
end;

destructor TCompraPedidoVO.Destroy;
begin
  ListaCompraPedidoDetalheVO.Free;
  ListaCompraCotacaoPedidoDetalheVO.Free;

  if Assigned(FCompraTipoPedidoVO) then
    FCompraTipoPedidoVO.Free;
  if Assigned(FFornecedorVO) then
    FFornecedorVO.Free;
  inherited;
end;

function TCompraPedidoVO.ToJSON: TJSONValue;
var
  Serializa: TJSONMarshal;
begin
  Serializa := TJSONMarshal.Create(TJSONConverter.Create);
  try
    //Lista Pedido Detalhe
    Serializa.RegisterConverter(TCompraPedidoVO, 'FListaCompraPedidoDetalheVO', function(Data: TObject; Field: string): TListOfObjects
      var
        I: Integer;
      begin
        if Assigned(TCompraPedidoVO(Data).FListaCompraPedidoDetalheVO) then
        begin
          SetLength(Result, TCompraPedidoVO(Data).FListaCompraPedidoDetalheVO.Count);
          for I := 0 to TCompraPedidoVO(Data).FListaCompraPedidoDetalheVO.Count - 1 do
          begin
            Result[I] := TCompraPedidoVO(Data).FListaCompraPedidoDetalheVO.Items[I];
          end;
        end;
      end);

    //Lista de itens da cota��o que foram utilizados no pedido
    Serializa.RegisterConverter(TCompraPedidoVO, 'FListaCompraCotacaoPedidoDetalheVO', function(Data: TObject; Field: string): TListOfObjects
      var
        I: Integer;
      begin
        if Assigned(TCompraPedidoVO(Data).FListaCompraCotacaoPedidoDetalheVO) then
        begin
          SetLength(Result, TCompraPedidoVO(Data).FListaCompraCotacaoPedidoDetalheVO.Count);
          for I := 0 to TCompraPedidoVO(Data).FListaCompraCotacaoPedidoDetalheVO.Count - 1 do
          begin
            Result[I] := TCompraPedidoVO(Data).FListaCompraCotacaoPedidoDetalheVO.Items[I];
          end;
        end;
      end);

    // Campos Transientes
     if Assigned(Self.CompraTipoPedidoVO) then
       Self.CompraTipoPedidoNome := Self.CompraTipoPedidoVO.Nome;
     if Assigned(Self.FornecedorVO) then
       Self.FornecedorPessoaNome := Self.FornecedorVO.PessoaVO.Nome;

  Exit(serializa.Marshal(Self));
  finally
    Serializa.Free;
  end;
end;

end.
