{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [NIVEL_FORMACAO] 
                                                                                
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
                                                                                
@author Fernando L�cio Oliveira (fsystem.br@gmail.com)                    
@version 1.0                                                                    
*******************************************************************************}
unit NivelFormacaoVO;

interface

uses
  JsonVO, Atributos, Classes, Constantes, Generics.Collections, DBXJSON, DBXJSONReflect, SysUtils;

type
  [TEntity]
  [TTable('NIVEL_FORMACAO')]
  TNivelFormacaoVO = class(TJsonVO)
  private
    FID: Integer;
    FNOME: String;
    FDESCRICAO: String;
    FGRAU_INSTRUCAO_CAGED: Integer;
    FGRAU_INSTRUCAO_SEFIP: Integer;
    FGRAU_INSTRUCAO_RAIS: Integer;

  public 
    [TId('ID')]
    [TGeneratedValue(sAuto)]
    [TFormatter('0000',taCenter)]
    property Id: Integer  read FID write FID;
    [TColumn('NOME','Nome',160,[ldGrid, ldLookup, ldComboBox], False)]
    property Nome: String  read FNOME write FNOME;
    [TColumn('DESCRICAO','Descri��o',650,[ldGrid, ldLookup], False)]
    property Descricao: String  read FDESCRICAO write FDESCRICAO;
    [TColumn('GRAU_INSTRUCAO_CAGED','Grau Instru��o Caged',80,[ldGrid, ldLookup], False)]
    property GrauInstrucaoCaged: Integer  read FGRAU_INSTRUCAO_CAGED write FGRAU_INSTRUCAO_CAGED;
    [TColumn('GRAU_INSTRUCAO_SEFIP','Grau Instru��o Sefip',80,[ldGrid, ldLookup], False)]
    property GrauInstrucaoSefip: Integer  read FGRAU_INSTRUCAO_SEFIP write FGRAU_INSTRUCAO_SEFIP;
    [TColumn('GRAU_INSTRUCAO_RAIS','Grau Instru��o Rais',80,[ldGrid, ldLookup], False)]
    property GrauInstrucaoRais: Integer  read FGRAU_INSTRUCAO_RAIS write FGRAU_INSTRUCAO_RAIS;

  end;

implementation



end.
