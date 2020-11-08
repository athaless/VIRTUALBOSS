<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<%
Session.LCID = 1046 

Dim strSQL, objRS, ObjConn, strBodyMsg, strDestMail   
Dim strHORAS, strMINUTOS, strHORASeMINUTOS
Dim strTITULO, strCODCLIENTE, strSITUACAO
Dim strCODCATEGORIA, strDESCCATEGORIA, strPRIORIDADE
Dim strRESPONSAVEL, strEQUIPE, strFECHA
Dim strDT_REALIZADO, strDESCRICAO, strTIPO
Dim strDT_AGORA, strUSUARIO
Dim strJSCRIPT_ACTION, strLOCATION

strTITULO         = GetParam("var_titulo")
strCODCLIENTE  	  = GetParam("var_cod_cliente")
strSITUACAO       = GetParam("var_SITUACAO")
strCODCATEGORIA   = GetParam("var_cod_e_desc_categoria")
strPRIORIDADE     = GetParam("var_prioridade")
strRESPONSAVEL    = LCase(GetParam("var_ID_RESPONSAVEL"))
strEQUIPE 		  = LCase(GetParam("var_equipe"))
strDESCRICAO      = Replace(GetParam("var_DESCRICAO"),"'","<ASLW_APOSTROFE>")
strTIPO           = GetParam("var_tipo")
strJSCRIPT_ACTION = GetParam("JSCRIPT_ACTION")
strLOCATION       = GetParam("DEFAULT_LOCATION")

strCODCATEGORIA = Mid(strCODCATEGORIA,1,InStr(strCODCATEGORIA," ")-1) 'Extrai apenas o Código da cateroria da String

AbreDBConn objConn, CFG_DB 

strDT_AGORA = "'" & PrepDataBrToUni(Now, true) & "'"
strUSUARIO = LCase(Request.Cookies("VBOSS")("ID_USUARIO"))

strSQL = "INSERT INTO"  				&_
			"	BS_BOLETIM (" 			&_ 
			"  	COD_CLIENTE,"	 		&_
			"  	COD_CATEGORIA, " 		&_
			"  	ID_RESPONSAVEL," 		&_
			" 	TITULO,"        		&_
			" 	DESCRICAO," 			&_
			" 	SITUACAO," 				&_
			" 	PRIORIDADE," 			&_
			" 	TIPO," 					&_
			"	SYS_DTT_INS,"			&_
			"	SYS_ID_USUARIO_INS) "	&_
			"VALUES ( " 					&_
				"'" & strCODCLIENTE	 & "', " &_
				"'" & strCODCATEGORIA & "', " &_
				"'" & strRESPONSAVEL  & "', " &_
				"'" & strTITULO       & "', " &_
				"'" & strDESCRICAO    & "', " &_
				"'" & strSITUACAO     & "', " &_ 
				"'" & strPRIORIDADE   & "', " &_ 
				"'" & strTIPO	      & "', " &_ 
				strDT_AGORA & ", " &_ 
				"'" & strUSUARIO & "') "

'AQUI: NEW TRANSACTION
set objRS  = objConn.Execute("start transaction")
set objRS  = objConn.Execute("set autocommit = 0")
objConn.Execute(strSQL)
If Err.Number <> 0 Then
  set objRS = objConn.Execute("rollback")
  Mensagem "modulo_BS.Insert_exec A: "& Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
else
  set objRS = objConn.Execute("commit")
End If


Dim Cont, strID_USUARIO, strCOD

strSQL =          " SELECT COD_BOLETIM "
strSQL = strSQL & " FROM BS_BOLETIM WHERE SYS_DTT_INS = " & strDT_AGORA
strSQL = strSQL & " AND SYS_ID_USUARIO_INS = '" & strUSUARIO & "' "

AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

strCOD = GetValue(objRS,"COD_BOLETIM")
strEQUIPE = Split(strEQUIPE,";")

FechaRecordSet objRS

'AQUI: NEW TRANSACTION
set objRS  = objConn.Execute("start transaction")
set objRS  = objConn.Execute("set autocommit = 0")
	for Cont = 0 to UBound(strEQUIPE)
		strID_USUARIO = LCase(Trim(CStr(strEQUIPE(Cont))))
		if strID_USUARIO <> "" then		
			strSQL = "INSERT INTO BS_EQUIPE (COD_BOLETIM, ID_USUARIO, SYS_DTT_INS, SYS_ID_USUARIO_INS) VALUES ('" & strCOD & "','" & strID_USUARIO & "'," & strDT_AGORA &  ",'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "')"
			objConn.Execute(strSQL)
		end if
	next
If Err.Number <> 0 Then
  set objRS = objConn.Execute("rollback")
  Mensagem "modulo_BS.Insert_exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
  response.End()
else
  set objRS = objConn.Execute("commit")
End If

FechaDBConn objConn
'Response.Redirect("Update.asp?var_chavereg=" & strCOD & "&var_todolist=true")

response.write "<script>"
If strJSCRIPT_ACTION <> "" Then response.write replace(strJSCRIPT_ACTION,"''","'") & ";"
If strLOCATION <> "" Then response.write " location.href='" & strLOCATION & "';"
response.write "</script>"
%>