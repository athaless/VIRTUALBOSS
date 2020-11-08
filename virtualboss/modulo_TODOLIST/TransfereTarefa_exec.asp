<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_database/athEnviaAlert.asp"-->
<%
Session.LCID = 1046

Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 415
WMD_WIDTHTTITLES = 100

Dim objConn, objRS, objRSResp, objRSAux, strSQLTransf, strSQLResp, auxSTR
Dim strDtInicio, strDtFim, strSituacao ,strRespAtual ,strRespNovo, strLOCATION, strJSCRIPT_ACTION
Dim arrCodigoTarefa,strCodigoTarefa, strMENSAGEM_RESPOSTA,intCodigo, i

abreDBConn objConn, CFG_DB

 strDtInicio = GetParam("var_dt_ini")
 strDtFim    = GetParam("var_dt_fim")
 strSituacao = GetParam("var_sit")
 strRespAtual = GetParam("var_responsavel_atual")
 strRespNovo  = GetParam("var_responsavel_novo")
 strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
 strLOCATION       = GetParam("DEFAULT_LOCATION")
 
if strRespAtual = "" or strRespNovo = "" or strDtInicio = "" or strDtFim = "" Then
	Mensagem "Preencha todos os campos obrigatórios","javascript:history.go(-1);", "Voltar", false
	Response.End()
else 
	 AbreDBConn objConn, CFG_DB 
end if

strSQLTransf = " UPDATE TL_TODOLIST" &_
		 " INNER JOIN TL_TODOLIST T1" &_
		 "     ON TL_TODOLIST.COD_TODOLIST = T1.COD_TODOLIST" &_
		 "     SET TL_TODOLIST.ID_RESPONSAVEL = '" & strRespNovo & "'" &_
		 " WHERE T1.ID_RESPONSAVEL = '" & strRespAtual & "'"
			
	if strSITUACAO <> "" then
		if InStr(strSITUACAO,"_") = 1 then 
			auxStr = Replace(strSITUACAO,"_", " <> '",1) & "' " 	 
		else 
			auxStr = " = '" & strSITUACAO & "' " 
		end if
		strSQLTransf = strSQLTransf & " AND T1.SITUACAO " & auxStr 
	end if
	if strDtInicio <> "" AND strDtFim <> "" then
		strSQLTransf = strSQLTransf & " AND (T1.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strDtInicio,false) & "' AND '" & PrepDataBrToUni(strDtFim,false) & "')"
	end if
	
	 strSQLResp = "SELECT "												&_
			"	T1.COD_TODOLIST" 									&_			
			",	T1.TITULO" 											&_			
			" FROM " 												&_
			"	TL_TODOLIST T1 " 									&_			
			" WHERE T1.ID_RESPONSAVEL = '"  & strRespAtual & "' "   &_
		    " AND T1.SITUACAO " & auxStr 	
	  if strDtInicio <> "" AND strDtFim <> "" then
		strSQLResp = strSQLResp & " AND (T1.PREV_DT_INI BETWEEN '" & PrepDataBrToUni(strDtInicio,false) & "' AND '" & PrepDataBrToUni(strDtFim,false) & "')"
	  end if		    		
'response.Write(strSQLResp)

	set objRSResp = objConn.Execute(strSQLResp)		
	
	'prepara arr para inserir as respostas das tarefas
	While not objRSResp.eof 
		arrCodigoTarefa = arrCodigoTarefa & getValue(objRSResp, "COD_TODOLIST") &";"
		objRSResp.movenext
	Wend
 'response.Write(arrCodigoTarefa)
' response.End()
	'AQUI: NEW TRANSACTION
	set objRS  = objConn.Execute("start transaction")
	set objRS  = objConn.Execute("set autocommit = 0")
	
	objConn.execute(strSQLTransf)
	If Err.Number <> 0 Then
		set objRS = objConn.Execute("rollback")
		Mensagem Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRS = objConn.Execute("commit")
		
		arrCodigoTarefa = Split(arrCodigoTarefa,";")
		'response.Write(ubound(arrCodigoTarefa))
		strMENSAGEM_RESPOSTA = "MENSAGEM DO SISTEMA - Transferencia realizada por "& uCase(Request.Cookies("VBOSS")("ID_USUARIO")) & " onde responsavel passa de "& ucase(strRespAtual) & " para " & ucase(strRespNovo) & " em tarefas ABERTAS no periodo de " & strDtInicio & " ate "& strDtFim & "."
		'for each intCodigo in arrCodigoTarefa
		for i=0 to (ubound(arrCodigoTarefa)-1) 	
			
			strSQLResp = " INSERT INTO TL_RESPOSTA (COD_TODOLIST, ID_FROM, ID_TO, RESPOSTA, DTT_RESPOSTA) "
			strSQLResp = strSQLResp & " VALUES (" & arrCodigoTarefa(i) & ", '" & LCase(strRespAtual) & "','" & LCase(strRespNovo) & "', '"
			strSQLResp = strSQLResp &           Server.HTMLEncode(strMENSAGEM_RESPOSTA) & "', '" & PrepDataBrToUni(Now, True) & "');"	
			'response.Write(strSQLResp & "<br>")
			objConn.Execute(strSQLResp)			
		next
		'response.End()
		
		
	End If
 
 athSaveLog "TL_TRANSRESP", Request.Cookies("VBOSS")("ID_USUARIO"), "TL_TODOLIST - transfresp", strSQLTransf

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'")
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "'"
response.write "</script>"
%>