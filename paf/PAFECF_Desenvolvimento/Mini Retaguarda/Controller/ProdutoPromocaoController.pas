{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Cliente relacionado � tabela [ProdutoPromocao]
                                                                                
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

@author  Marcos Leite
@version 1.0
*******************************************************************************}
unit ProdutoPromocaoController;

interface

uses
   Classes, Dialogs, SysUtils, DBClient, DB, Windows, Forms, DBXCommon, ProdutoPromocaoVO;


type
  TProdutoPromocaoController = class
  private
  protected
  public
    class Procedure Consulta(pFiltro: String; pPagina: Integer; pLookup: Boolean);
    class Procedure Insere(pProdutoPromocao: TProdutoPromocaoVO);
    class Procedure Altera(pProdutoPromocao: TProdutoPromocaoVO; pFiltro: String; pPagina: Integer);
    class Procedure Exclui(pId: Integer);
  end;

implementation


uses UDataModule, T2TiORM, Biblioteca;

var
  ProdutoPromocao: TProdutoPromocaoVO;

class procedure TProdutoPromocaoController.Consulta(pFiltro: String; pPagina: Integer; pLookup: Boolean);
var
  ResultSet: TDBXReader;
  ConsultaSQL: String;
  I: integer;
begin
  try
    try
      pFiltro := StringReplace(pFiltro,'*','%',[rfReplaceAll]);
      ResultSet := TT2TiORM.Consultar(TProdutoPromocaoVO.Create, pFiltro, pPagina);

      if pLookup then
      begin
        FDataModule.CDSLookup.DisableControls;
        FDataModule.CDSLookup.EmptyDataSet;
        while ResultSet.Next do
        begin
          FDataModule.CDSLookup.Append;
          FDataModule.CDSLookup.FieldByName('ID').AsInteger := ResultSet.Value['ID'].AsInt32;
          FDataModule.CDSLookup.FieldByName('ID_PRODUTO').AsInteger := ResultSet.Value['ID_PRODUTO'].AsInt32;
          FDataModule.CDSLookup.FieldByName('DATA_INICIO').AsString := ResultSet.Value['DATA_INICIO'].AsString;
          FDataModule.CDSLookup.FieldByName('DATA_FIM').AsString := ResultSet.Value['DATA_FIM'].AsString;
          FDataModule.CDSLookup.FieldByName('QUANTIDADE_EM_PROMOCAO').AsString := ResultSet.Value['QUANTIDADE_EM_PROMOCAO'].AsString;
          FDataModule.CDSLookup.FieldByName('QUANTIDADE_MAXIMA_CLIENTE').AsString := ResultSet.Value['QUANTIDADE_MAXIMA_CLIENTE'].AsString;
          FDataModule.CDSLookup.FieldByName('VALOR').AsString := ResultSet.Value['VALOR'].AsString;
          FDataModule.CDSLookup.Post;
        end;
        FDataModule.CDSLookup.Open;
        FDataModule.CDSLookup.EnableControls;
      end
      else
      begin
        FDataModule.CDSPromocao.DisableControls;
        FDataModule.CDSPromocao.EmptyDataSet;
        while ResultSet.Next do
        begin
          FDataModule.CDSPromocao.Append;
          for I := 0 to FDataModule.CDSPromocao.FieldCount -1 do
          begin
            if  ResultSet.Value[FDataModule.CDSPromocao.FieldDefList[i].Name].ValueType.DataType = 2 then
            begin
             if ResultSet.Value[FDataModule.CDSPromocao.FieldDefList[i].Name].GetDate > 0 then
                FDataModule.CDSPromocao.Fields[i].AsString := DataParaTexto(ResultSet.Value[FDataModule.CDSPromocao.FieldDefList[i].Name].AsDateTime);
            end
            else
            if  ResultSet.Value[FDataModule.CDSPromocao.FieldDefList[i].Name].ValueType.DataType = 8 then
            begin
              if not ResultSet.Value[FDataModule.CDSPromocao.FieldDefList[i].Name].IsNull  then
              begin
                FDataModule.CDSPromocao.Fields[i].AsFloat :=  ResultSet.Value[FDataModule.CDSPromocao.FieldDefList[i].Name].AsDouble;
              end
              else FDataModule.CDSPromocao.Fields[i].AsFloat := 0;
            end
            else
            if ResultSet.Value[FDataModule.CDSPromocao.FieldDefList[i].Name].AsString <> '' then
              FDataModule.CDSPromocao.Fields[i].AsString := ResultSet.Value[FDataModule.CDSPromocao.FieldDefList[i].Name].AsString;
          end;
          FDataModule.CDSPromocao.Post;
          {
          FDataModule.CDSPromocao.Append;
          FDataModule.CDSPromocao.FieldByName('ID').AsInteger := ResultSet.Value['ID'].AsInt32;
          FDataModule.CDSPromocao.FieldByName('ID_PRODUTO').AsInteger := ResultSet.Value['ID_PRODUTO'].AsInt32;
          FDataModule.CDSPromocao.FieldByName('DATA_INICIO').AsDateTime := ResultSet.Value['DATA_INICIO'].AsDateTime;
          FDataModule.CDSPromocao.FieldByName('DATA_FIM').AsDateTime := ResultSet.Value['DATA_FIM'].AsDateTime;
          FDataModule.CDSPromocao.FieldByName('QUANTIDADE_EM_PROMOCAO').AsString := ResultSet.Value['QUANTIDADE_EM_PROMOCAO'].AsString;
          FDataModule.CDSPromocao.FieldByName('QUANTIDADE_MAXIMA_CLIENTE').AsString := ResultSet.Value['QUANTIDADE_MAXIMA_CLIENTE'].AsString;
          FDataModule.CDSPromocao.FieldByName('VALOR').AsString := ResultSet.Value['VALOR'].AsString;
          FDataModule.CDSPromocao.Post;
          }
        end;
        //FDataModule.CDSPromocao.Open;
        FDataModule.CDSPromocao.EnableControls;
      end;
    except
    end;
  finally
    ResultSet.Free;
  end;
end;

class Procedure TProdutoPromocaoController.Insere(pProdutoPromocao: TProdutoPromocaoVO);
var
  UltimoID:Integer;
begin
  try
    try
      UltimoID := TT2TiORM.Inserir(pProdutoPromocao);
      Consulta('ID='+IntToStr(UltimoID),0,False);
    except
      Application.MessageBox('Ocorreu um erro. Inclus�o n�o realizada.', 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  finally
  end;
end;

class Procedure TProdutoPromocaoController.Altera(pProdutoPromocao: TProdutoPromocaoVO; pFiltro: String; pPagina: Integer);
begin
  try
    try
      TT2TiORM.Alterar(pProdutoPromocao);
      Consulta(pFiltro, pPagina,False);
    except
      Application.MessageBox('Ocorreu um erro. Altera��o n�o realizada.', 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  finally
  end;
end;

class Procedure TProdutoPromocaoController.Exclui(pId: Integer);
begin
  try
    try
      ProdutoPromocao := TProdutoPromocaoVO.Create;
      ProdutoPromocao.Id := pId;
      TT2TiORM.Excluir(ProdutoPromocao);
    except
      Application.MessageBox('Ocorreu um erro na exclus�o do cliente.', 'Erro do sistema', MB_OK + MB_ICONERROR);
    end;
  finally
  end;
end;

end.
