{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Servidor relacionado � tabela [NFE_NUMERO] 
                                                                                
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
unit NfeNumeroController;

interface

uses
  Classes, SQLExpr, SysUtils, Generics.Collections, Controller, DBXJSON, DBXCommon;

type
  TNfeNumeroController = class(TController)
  protected
  public
    //consultar
    function NfeNumero(pSessao: String; pFiltro: String; pPagina: Integer): TJSONArray;
    //inserir
    function AcceptNfeNumero(pSessao: String; pObjeto: TJSONValue): TJSONArray;
    //alterar
    function UpdateNfeNumero(pSessao: String; pObjeto: TJSONValue): TJSONArray;
    //excluir
    function CancelNfeNumero(pSessao: String; pId: Integer): TJSONArray;
  end;

implementation

uses
  NfeNumeroVO, T2TiORM, SA;

{ TNfeNumeroController }

var
  objNfeNumero: TNfeNumeroVO;
  Resultado: Boolean;

function TNfeNumeroController.NfeNumero(pSessao, pFiltro: String; pPagina: Integer): TJSONArray;
var
  SQL: string;
  UltimoID: Integer;
begin
  (*
    Para o treinamento usaremos apenas a s�rie 001. O participante deve fazer
    as devidas adapta��es para trabalhar com mais de uma s�rie em seu sistema.
  *)

  //Verifica se a tabela est� vazia
  if TT2TiORM.SelectMax('NFE_NUMERO', '1=1') = -1 then
  begin
    objNfeNumero := TNfeNumeroVO.Create;
    objNfeNumero.Serie := '001';
    objNfeNumero.Numero := 1;
    objNfeNumero.IdEmpresa := 1;
    UltimoID := TT2TiORM.Inserir(objNfeNumero);
    Result := TT2TiORM.Consultar<TNfeNumeroVO>(pFiltro, pPagina);
  end
  else
  begin
    SQL := 'update NFE_NUMERO set NUMERO = NUMERO + 1';
    TT2TiORM.ComandoSQL(SQL);  
    Result := TT2TiORM.Consultar<TNfeNumeroVO>(pFiltro, pPagina);
  end;
end;

function TNfeNumeroController.AcceptNfeNumero(pSessao: String; pObjeto: TJSONValue): TJSONArray;
var
  UltimoID: Integer;
begin
  objNfeNumero := TNfeNumeroVO.Create(pObjeto);
  Result := TJSONArray.Create;
  try
    try
      UltimoID := TT2TiORM.Inserir(objNfeNumero);
      Result := NfeNumero(pSessao, 'ID = ' + IntToStr(UltimoID), 0);
    except
      on E: Exception do
      begin
        Result.AddElement(TJSOnString.Create('ERRO'));
        Result.AddElement(TJSOnString.Create(E.Message));
      end;
    end;
  finally
    objNfeNumero.Free;
  end;
end;

function TNfeNumeroController.UpdateNfeNumero(pSessao: String; pObjeto: TJSONValue): TJSONArray;
var
  objNfeNumeroOld: TNfeNumeroVO;
begin
 //Objeto Novo
  objNfeNumero := TNfeNumeroVO.Create((pObjeto as TJSONArray).Get(0));
  //Objeto Antigo
  objNfeNumeroOld := TNfeNumeroVO.Create((pObjeto as TJSONArray).Get(1));
  Result := TJSONArray.Create;
  try
    try
      Resultado := TT2TiORM.Alterar(objNfeNumero, objNfeNumeroOld);
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
    objNfeNumero.Free;
  end;
end;

function TNfeNumeroController.CancelNfeNumero(pSessao: String; pId: Integer): TJSONArray;
begin
  objNfeNumero := TNfeNumeroVO.Create;
  Result := TJSONArray.Create;
  try
    objNfeNumero.Id := pId;
    try
      Resultado := TT2TiORM.Excluir(objNfeNumero);
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
    objNfeNumero.Free;
  end;
end;

end.
