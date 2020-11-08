<!--#include file="athDbConn.asp"-->
<!--#include file="athUtils.asp"--> 
<!--#include file="athSendMail.asp"-->
<%
  '*************************************
  '      VERSÃO 1.9 (MSQL-transaction) *
  '      01/02/2009                    *
  '*************************************

  '********************************* Nome de Campos de Formulários ***************************************
  '*******************************************************************************************************
  ' 1° - Crie um prefixo - ex: DBVAR_
  ' 2° - Escolha o tipo de dados que a tabela recebe para este campo:
  ' STR - Texto e Memo
  ' NUM - Número
  ' AUTODATE - Data/Hora (obs: o valor para este campo deve ser vazio)
  ' BOOL - Sim/Não
  ' DATE - Data
  ' 3° - Escreva o nome do campo na tabela
  ' 4° - Se o campo for requerido adicione "ô" ao final de seu nome
  '
  'Obs: Sempre adicione _ após o Prefixo e o Tipo_campo_tabela
  '
  ' Ex:  Prefixo   Tipo_campo_Tabela    Nome_campo_Tabela   Nome_campo_formulário  É Requerido
  '       DBVAR_          STR_               TEXTO             DBVAR_STR_TEXTO         Não
  '       VAR_            NUM_               CODIGO            VAR_NUM_CODIGOô         Sim
  '
  ' Exemplo prático:
  ' 
  '*******************************************************************************************************
  '*******************************************************************************************************
  ' Esta página precisa receber os seguintes valores do formulário que a chama:
  ' DEFAULT_TABLE = Tabela a ser feita a deleção
  ' DEFAULT_DB = Variável do banco de dados incluso no arquivo ConfigINC.asp (CFG_DB_SITE ou CFG_DB_CSM)  
  ' RECORD_KEY_NAME = Nome do campo que servirá de condição para a deleção
  ' RECORD_KEY_VALUE = Valor do campo que servirá de condição para a deleção (pode ser mais de um valor)
  ' DEFAULT_LOCATION = Página e parâmetros para o redirecionamento
  ' JSCRIPT_ACTION = Script a ser rodado antes de redirecionar a página
  '*******************************************************************************************************
   
  Response.Expires = 0

  Dim ObjConn_DeleteToDB, StrSql_DeleteToDB, StrSQL_DeleteImagesToDB, ObjRS
  Dim AuxStr
  'Variáveis passadas pelo formulário
  Dim DEFAULT_TABLE, RECORD_KEY_NAME, RECORD_KEY_VALUE, RECORD_KEY_NAME_EXTRA, RECORD_KEY_VALUE_EXTRA, DEFAULT_LOCATION, JSCRIPT_ACTION, DEFAULT_DB, MSG

  DEFAULT_TABLE          = GetParam("DEFAULT_TABLE")
  DEFAULT_DB	         = GetParam("DEFAULT_DB")
  RECORD_KEY_NAME        = GetParam("RECORD_KEY_NAME")
  RECORD_KEY_VALUE       = GetParam("RECORD_KEY_VALUE")
  DEFAULT_LOCATION       = GetParam("DEFAULT_LOCATION")
  JSCRIPT_ACTION         = GetParam("JSCRIPT_ACTION")
  RECORD_KEY_NAME_EXTRA  = GetParam("RECORD_KEY_NAME_EXTRA")
  RECORD_KEY_VALUE_EXTRA = GetParam("RECORD_KEY_VALUE_EXTRA")
  MSG = GetParam("EXIBE_MENSAGEM")

  AuxStr = Request.QueryString
  If AuxStr = "" Then AuxStr = Request.Form End If

 'Debug dos "fields" e seus respectivos "values" e "types" recebidos 
 'Response.Write "<BR>DEFAULT_TABLE: "    &  DEFAULT_TABLE
 'Response.Write "<BR>RECORD_KEY_NAME: "  &  RECORD_KEY_NAME
 'Response.Write "<BR>RECORD_KEY_VALUE: " &  RECORD_KEY_VALUE
 'Response.Write "<BR>DEFAULT_LOCATION: " &  DEFAULT_LOCATION
 'Response.Write "<BR>JSCRIPT_ACTION: "   & JSCRIPT_ACTION
 'Response.Write "<BR><BR>AUXSTR: " &  Auxstr & "<BR><BR>"
 'Response.End
  
  AbreDBConn ObjConn_DeleteToDB, DEFAULT_DB

  StrSql_DeleteToDB = "DELETE FROM "& DEFAULT_TABLE & " WHERE " &  RECORD_KEY_NAME & " IN (" &  RECORD_KEY_VALUE & ")"
   
  If RECORD_KEY_NAME_EXTRA <> "" THEN
   	If NOT isNumeric(RECORD_KEY_VALUE_EXTRA) Then
   	   StrSql_DeleteToDB = StrSql_DeleteToDB &  " AND " & RECORD_KEY_NAME_EXTRA & " = '" &  RECORD_KEY_VALUE_EXTRA & "'"
	Else
	   StrSql_DeleteToDB = StrSql_DeleteToDB &  " AND " & RECORD_KEY_NAME_EXTRA & " = " &  RECORD_KEY_VALUE_EXTRA
	End If
  End IF
  objRS = ObjConn_DeleteToDB.Execute("start transaction")
  objRS = ObjConn_DeleteToDB.Execute("set autocommit = 0")
  ObjConn_DeleteToDB.Execute(StrSql_DeleteToDB)
   
  If Err.Number <> 0 Then 
 	set objRS = ObjConn_DeleteToDB.Execute("rollback")
    athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "ROLLBACK " &  DEFAULT_TABLE, StrSql_DeleteToDB

    Mensagem ShowErrorDescription(Err.Number, Err.Description) , DEFAULT_LOCATION, "voltar", True
  Else	 
 	set objRS = ObjConn_DeleteToDB.Execute("commit")
    athSaveLog "DEL", Request.Cookies("VBOSS")("ID_USUARIO"), "COMMIT " & DEFAULT_TABLE, StrSql_DeleteToDB

	If MSG <> 0 Then
	   Mensagem "O(s) registro(s) foi(ram) apagado(s) com sucesso", DEFAULT_LOCATION, "voltar", True
    Else
       response.write "<script>"  & vbCrlf 
	   if (JSCRIPT_ACTION <> "")   then response.write  replace(JSCRIPT_ACTION,"''","'") & vbCrlf end if
       If (DEFAULT_LOCATION <> "") then response.write "location.href='" & DEFAULT_LOCATION & "'" & vbCrlf  End If
       response.write "</script>"
     End If
  End if
  FechaDBConn ObjConn_DeleteToDB
%>