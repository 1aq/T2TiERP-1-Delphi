{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Servidor relacionado � tabela [REGISTRO_CARTORIO] 
                                                                                
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
unit RegistroCartorioController;

interface

uses
  Classes, SQLExpr, SysUtils, Generics.Collections, Controller, DBXJSON, DBXCommon;

type
  TRegistroCartorioController = class(TController)
  protected
  public
    //consultar
    function RegistroCartorio(pSessao: String; pFiltro: String; pPagina: Integer): TJSONArray;
    //inserir
    function AcceptRegistroCartorio(pSessao: String; pObjeto: TJSONValue): TJSONArray;
    //alterar
    function UpdateRegistroCartorio(pSessao: String; pObjeto: TJSONValue): TJSONArray;
    //excluir
    function CancelRegistroCartorio(pSessao: String; pId: Integer): TJSONArray;
  end;

implementation

uses
  RegistroCartorioVO, T2TiORM, SA;

{ TRegistroCartorioController }

var
  objRegistroCartorio: TRegistroCartorioVO;
  Resultado: Boolean;

function TRegistroCartorioController.RegistroCartorio(pSessao, pFiltro: String; pPagina: Integer): TJSONArray;
begin
  pFiltro := pFiltro + ' AND ID_EMPRESA = ' + IntToStr(Sessao(pSessao).IdEmpresa);
  Result := TJSONArray.Create;
  try
    if Pos('ID=', pFiltro) > 0 then
      Result := TT2TiORM.Consultar<TRegistroCartorioVO>(pFiltro, pPagina, True)
    else
      Result := TT2TiORM.Consultar<TRegistroCartorioVO>(pFiltro, pPagina, False);
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

function TRegistroCartorioController.AcceptRegistroCartorio(pSessao: String; pObjeto: TJSONValue): TJSONArray;
var
  UltimoID:Integer;
begin
  objRegistroCartorio := TRegistroCartorioVO.Create(pObjeto);
  Result := TJSONArray.Create;
  try
    try
      UltimoID := TT2TiORM.Inserir(objRegistroCartorio);
      Result := RegistroCartorio(pSessao, 'ID = ' + IntToStr(UltimoID), 0);
    except
      on E: Exception do
      begin
        Result.AddElement(TJSOnString.Create('ERRO'));
        Result.AddElement(TJSOnString.Create(E.Message));
      end;
    end;
  finally
    objRegistroCartorio.Free;
  end;
end;

function TRegistroCartorioController.UpdateRegistroCartorio(pSessao: String; pObjeto: TJSONValue): TJSONArray;
var
  objRegistroCartorioOld: TRegistroCartorioVO;
begin
 //Objeto Novo
  objRegistroCartorio := TRegistroCartorioVO.Create((pObjeto as TJSONArray).Get(0));
  //Objeto Antigo
  objRegistroCartorioOld := TRegistroCartorioVO.Create((pObjeto as TJSONArray).Get(1));
  Result := TJSONArray.Create;
  try
    try
      Resultado := TT2TiORM.Alterar(objRegistroCartorio, objRegistroCartorioOld);
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
    objRegistroCartorio.Free;
  end;
end;

function TRegistroCartorioController.CancelRegistroCartorio(pSessao: String; pId: Integer): TJSONArray;
begin
  objRegistroCartorio := TRegistroCartorioVO.Create;
  Result := TJSONArray.Create;
  try
    objRegistroCartorio.Id := pId;
    try
      Resultado := TT2TiORM.Excluir(objRegistroCartorio);
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
    objRegistroCartorio.Free;
  end;
end;

end.
