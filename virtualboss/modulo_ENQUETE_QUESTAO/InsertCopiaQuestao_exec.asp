<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/md5.asp"-->
<%
 Dim objConn, objRS, objRSAux, strSQL, objRSTs
 Dim strCodigo, strTitulo, intCodEnquete
 Dim intOrdem, strQuestao, intCodQuestaoNew

 strCodigo      = GetParam("var_cod_questao")
 strQuestao     = GetParam("var_nova_questao")
 intCodEnquete  = GetParam("var_cod_nova_enquete")
 intOrdem       = GetParam("var_nova_ordem")


 AbreDBConn objConn, CFG_DB 
 
 'AQUI: NEW TRANSACTION
 set objRSTs  = objConn.Execute("start transaction")
 set objRSTs  = objConn.Execute("set autocommit = 0") 


    '-------------------------------------------------
    '1.Insere a duplicação da enquete
    '-------------------------------------------------
	strSQL = "INSERT INTO en_questao( COD_ENQUETE, ORDEM, QUESTAO) VALUES ("&intCodEnquete&", " & intOrdem & ", '" & strQuestao & "')"

    'response.Write("<strong>QUESTAO:</strong> <BR>"&strSQL &"<BR><BR><BR>")
	objConn.Execute(strSQL)
 
	'-----------------------------------------------
	'2.Busca o código da enquete recém criado
	'-----------------------------------------------
 	strSQL = "select max(cod_questao) AS ULT_COD from en_questao"	
	set objRS = objConn.Execute(strSQL)                                            
	intCodQuestaoNew = GetValue(objRS,"ULT_COD") 
	'insere as alternativas
	strSQL = "INSERT INTO en_alternativa(COD_QUESTAO, ALTERNATIVA, TIPO, NUM_VOTOS, RESPOSTAS) (SELECT " & intCodQuestaoNew & ", ALTERNATIVA, TIPO, 0, '' FROM en_alternativa WHERE cod_questao = "&strCodigo&")"
	'response.Write("<strong>ALTERNATIVA</strong> <BR>"&strSQL &"<BR><BR><BR>")
	objConn.Execute(strSQL)
 
 set objRSTs = objConn.Execute("commit")
 'athSaveLog "COPY", Request.Cookies("VBOSS")("ID_USUARIO"), strID & " para " & strNOVO_ID, strAuxSQL
'response.end()
 response.write "<script>"  & vbCrlf 
 if (GetParam("JSCRIPT_ACTION") <> "")   then response.write  GetParam("JSCRIPT_ACTION") & vbCrlf end if
 if (GetParam("DEFAULT_LOCATION") <> "") then response.write "location.href='" & GetParam("DEFAULT_LOCATION") & "'" & vbCrlf
 response.write "</script>"
%>