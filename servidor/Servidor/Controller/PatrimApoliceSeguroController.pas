{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Servidor relacionado � tabela [PATRIM_APOLICE_SEGURO] 
                                                                                
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
unit PatrimApoliceSeguroController;

interface

uses
  Classes, SQLExpr, SysUtils, Generics.Collections, Controller, DBXJSON, DBXCommon;

type
  TPatrimApoliceSeguroController = class(TController)
  protected
  public
    //consultar
    function PatrimApoliceSeguro(pSessao: String; pFiltro: String; pPagina: Integer): TJSONArray;
    //inserir
    function AcceptPatrimApoliceSeguro(pSessao: String; pObjeto: TJSONValue): TJSONArray;
    //alterar
    function UpdatePatrimApoliceSeguro(pSessao: String; pObjeto: TJSONValue): TJSONArray;
    //excluir
    function CancelPatrimApoliceSeguro(pSessao: String; pId: Integer): TJSONArray;
  end;

implementation

uses
  PatrimApoliceSeguroVO, T2TiORM, SA;

{ TPatrimApoliceSeguroController }

var
  objPatrimApoliceSeguro: TPatrimApoliceSeguroVO;
  Resultado: Boolean;

function TPatrimApoliceSeguroController.PatrimApoliceSeguro(pSessao, pFiltro: String; pPagina: Integer): TJSONArray;
begin
  Result := TJSONArray.Create;
  try
    if Pos('ID=', pFiltro) > 0 then
      Result := TT2TiORM.Consultar<TPatrimApoliceSeguroVO>(pFiltro, pPagina, True)
    else
      Result := TT2TiORM.Consultar<TPatrimApoliceSeguroVO>(pFiltro, pPagina, False);
  except
    on E: Exception do
    begin
      Result.AddElement(TJSOnString.Create('ERRO'));
      Result.AddElement(TJSOnString.Create(E.Message));
    end;
  end;

  FSA.MemoResposta.Lines.Clear;
  FSA.MemoResposta.Lines.Add(result.ToString);
end;

function TPatrimApoliceSeguroController.AcceptPatrimApoliceSeguro(pSessao: String; pObjeto: TJSONValue): TJSONArray;
var
  UltimoID:Integer;
begin
  objPatrimApoliceSeguro := TPatrimApoliceSeguroVO.Create(pObjeto);
  Result := TJSONArray.Create;
  try
    try
      UltimoID := TT2TiORM.Inserir(objPatrimApoliceSeguro);
      Result := PatrimApoliceSeguro(pSessao, 'ID = ' + IntToStr(UltimoID), 0);
    except
      on E: Exception do
      begin
        Result.AddElement(TJSOnString.Create('ERRO'));
        Result.AddElement(TJSOnString.Create(E.Message));
      end;
    end;
  finally
    objPatrimApoliceSeguro.Free;
  end;
end;

function TPatrimApoliceSeguroController.UpdatePatrimApoliceSeguro(pSessao: String; pObjeto: TJSONValue): TJSONArray;
var
  objPatrimApoliceSeguroOld: TPatrimApoliceSeguroVO;
begin
 //Objeto Novo
  objPatrimApoliceSeguro := TPatrimApoliceSeguroVO.Create((pObjeto as TJSONArray).Get(0));
  //Objeto Antigo
  objPatrimApoliceSeguroOld := TPatrimApoliceSeguroVO.Create((pObjeto as TJSONArray).Get(1));
  Result := TJSONArray.Create;
  try
    try
      Resultado := TT2TiORM.Alterar(objPatrimApoliceSeguro, objPatrimApoliceSeguroOld);
    except
      on E: Exception do
      begin
        Result.AddElement(TJSOnString.Create('ERRO'));
        Result.AddElement(TJSOnString.Create(E.Message));
      end;
    end;
  finally
    if Resultado then
    begin
      Result.AddElement(TJSONTrue.Create);
    end;
    objPatrimApoliceSeguro.Free;
  end;
end;

function TPatrimApoliceSeguroController.CancelPatrimApoliceSeguro(pSessao: String; pId: Integer): TJSONArray;
begin
  objPatrimApoliceSeguro := TPatrimApoliceSeguroVO.Create;
  Result := TJSONArray.Create;
  try
    objPatrimApoliceSeguro.Id := pId;
    try
      Resultado := TT2TiORM.Excluir(objPatrimApoliceSeguro);
    except
      on E: Exception do
      begin
        Result.AddElement(TJSOnString.Create('ERRO'));
        Result.AddElement(TJSOnString.Create(E.Message));
      end;
    end;
  finally
    if Resultado then
    begin
      Result.AddElement(TJSONTrue.Create);
    end;
    objPatrimApoliceSeguro.Free;
  end;
end;

end.
