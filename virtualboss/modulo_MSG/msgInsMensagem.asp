<!--#include file="../_database/athdbConn.asp"	--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%> 
<!--#include file="../_database/athUtils.asp"	--> 
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="ConfigMSG.asp"--> 

<%
	Dim objRS, objConn, strSQL, objRSCT 
	Dim objRSMail, strSQLMail, strDestMail
	Dim strFROM, strTO, strSUBJECT, strBODY
	
  	Sub ExibeMsg(StrAviso, StrDesc)
		Response.Write ("<p align='center'><font face='Arial' size='2'><b>.:: AVISO ::.</b></font></p>")
		Response.Write ("<p align='center'><font face='Arial' size='2'>" & StrAviso & "<br><br></font></p><hr>")
		Response.Write ("<p align='center'><table width='600' border='0'><tr><td><font face='Arial' size='2'>" & StrDesc & "</font></td></tr></table></p><hr>")	
		Response.End()
  	End Sub

	'--------------------------------------------------------------------------------
	' Variáveis 
	'--------------------------------------------------------------------------------
	Dim strRETORNO, strREMETENTE, strDESTINATARIOS, strDESTINO, arrDESTINOS, strASSUNTO, strMENSAGEM 
	Dim strMSG 
	Dim Cont, strCOD_MENSAGEM, strDT_ENVIO 
	Dim strMSG_AVISO, strCOD_SESSION 	
	
	strRETORNO 			= GetParam("var_retorno")
	strREMETENTE 		= GetParam("var_remetente")
	strDESTINATARIOS 	= GetParam("var_destinatarios")
	strASSUNTO 			= GetParam("var_assunto")
	strMENSAGEM 		= GetParam("var_mensagem") & GetParam("var_historico")
	
	strMSG = ""
	If strREMETENTE 		= "" Then strMSG = strMSG & "Remetente não informado<br>" 
	If strDESTINATARIOS 	= "" Then strMSG = strMSG & "Destinatário(s) não informado(s)<br>" 
	If strMENSAGEM 		    = "" Then strMSG = strMSG & "Mensagem não informada<br>" 
	If strASSUNTO 			= "" Then strMSG = strMSG & "Assunto não informado<br>" 
	
	If strMSG <> "" Then
		ExibeMsg "Parâmetros faltantes", strMSG 
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	strDT_ENVIO = "'" & PrepDataBrToUni(Now, True) & "'" 
	'If strRETORNO = "" Then strRETORNO = "msgNovaMensagem.asp" 
	
	'-----------------------------------
	'Insere Mensagem
	'-----------------------------------
	strSQL = 			" INSERT INTO MSG_MENSAGEM (ASSUNTO, MENSAGEM, DT_ENVIO) "
	strSQL =	strSQL & " VALUES ('" & strASSUNTO & "', '" & strMENSAGEM & "', " & strDT_ENVIO & ")"	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_MSG.msgExecAcao: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If


	'Busca código da Mensagem
	strSQL = 			" SELECT COD_MENSAGEM FROM MSG_MENSAGEM "
	strSQL =	strSQL &	" WHERE DT_ENVIO = " & strDT_ENVIO 
	Set objRS = objConn.Execute(strSQL)
	
	If Not objRS.Eof Then
		strCOD_MENSAGEM = objRS("COD_MENSAGEM")
							
		'Insere na tabela de REMETENTES
		strSQL = 			" INSERT INTO MSG_REMETENTE (COD_MENSAGEM, COD_USER_REMETENTE) "
		strSQL =	strSQL &	" VALUES (" & strCOD_MENSAGEM & ", '" & strREMETENTE & "')"
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_MSG.msgExecAcao: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If


		'Insere na Caixa de SAIDA
		strSQL = 			" INSERT INTO MSG_PASTA (COD_MENSAGEM, COD_USER, PASTA, DT_LIDO) "
		strSQL =	strSQL &	" VALUES (" & strCOD_MENSAGEM &", '" & strREMETENTE & "', '" & CX_SAIDA_Value & "', Null)" 
		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_MSG.msgExecAcao: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If
		
		'Insere os anexos
		strCOD_SESSION = Session.SessionID
		strSQL = " SELECT COD_MSG_TEMP_ANEXO FROM MSG_TEMP_ANEXO WHERE `SESSION` = '" & strCOD_SESSION & "'"
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.EOF Then
				'Copia da tabela temporária de anexos para a tabela principal
				strSQL = 			" INSERT INTO MSG_ANEXO (COD_MENSAGEM, ARQUIVO, DESCRICAO) " 
				strSQL =	strSQL &	" SELECT " & strCOD_MENSAGEM & " AS COD_MENSAGEM, ARQUIVO, DESCRICAO FROM MSG_TEMP_ANEXO WHERE `SESSION` = '" & strCOD_SESSION & "'" 				
				'AQUI: NEW TRANSACTION
				set objRSCT  = objConn.Execute("start transaction")
				set objRSCT  = objConn.Execute("set autocommit = 0")
				objConn.Execute(strSQL)
				If Err.Number <> 0 Then
					set objRSCT = objConn.Execute("rollback")
					Mensagem "modulo_MSG.msgExecAcao: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
					Response.End()
				else
					set objRSCT = objConn.Execute("commit")
				End If

				'Apaga os registros da tabela temporária
				strSQL = " DELETE FROM MSG_TEMP_ANEXO WHERE `SESSION` = '" & strCOD_SESSION & "'" 
				'AQUI: NEW TRANSACTION
				set objRSCT  = objConn.Execute("start transaction")
				set objRSCT  = objConn.Execute("set autocommit = 0")
				objConn.Execute(strSQL)
				If Err.Number <> 0 Then
					set objRSCT = objConn.Execute("rollback")
					Mensagem "modulo_MSG.msgExecAcao: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
					Response.End()
				else
					set objRSCT = objConn.Execute("commit")
				End If
		End If
		FechaRecordset(objRS)
		
		arrDESTINOS = Split(strDESTINATARIOS, ";")
		
		For Cont = 0 To UBound(arrDESTINOS)
			strDESTINO = Trim(CStr(arrDESTINOS(Cont)))
			'Insere na tabela de DESTINATARIOS
			If strDESTINO <> "" Then				
					strSQL =          " INSERT INTO MSG_DESTINATARIO (COD_MENSAGEM, COD_USER_DESTINATARIO) "
					strSQL = strSQL & " VALUES (" & strCOD_MENSAGEM & ", '" & strDESTINO & "')"
					'AQUI: NEW TRANSACTION
					set objRSCT  = objConn.Execute("start transaction")
					set objRSCT  = objConn.Execute("set autocommit = 0")
					objConn.Execute(strSQL)
					If Err.Number <> 0 Then
						set objRSCT = objConn.Execute("rollback")
						Mensagem "modulo_MSG.msgExecAcao: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
						Response.End()
					else
						set objRSCT = objConn.Execute("commit")
					End If
					
					'Insere na Caixa de ENTRADA
					strSQL =          " INSERT INTO MSG_PASTA (COD_MENSAGEM, COD_USER, PASTA) "
					strSQL = strSQL & " VALUES (" & strCOD_MENSAGEM &", '" & strDESTINO & "', '" & CX_ENTRADA_Value & "')" 
					'AQUI: NEW TRANSACTION
					set objRSCT  = objConn.Execute("start transaction")
					set objRSCT  = objConn.Execute("set autocommit = 0")
					objConn.Execute(strSQL)
					If Err.Number <> 0 Then
						set objRSCT = objConn.Execute("rollback")
						Mensagem "modulo_MSG.msgExecAcao: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
						Response.End()
					else
						set objRSCT = objConn.Execute("commit")
					End If

			End If
		Next
	End If

	strDestMail = Replace(strDESTINATARIOS," ","")
	strDestMail = "'" & Replace(strDestMail,";","','") & "'"
	
	strSQLMail =              " SELECT EMAIL "
	strSQLMail = strSQLMail & " FROM USUARIO "
	strSQLMail = strSQLMail & " WHERE ID_USUARIO IN (" & strDestMail & ")"
	Set objRSMail = objConn.Execute(strSQLMail)
	
	strDestMail = ""	
	while not objRSMail.Eof
		strDestMail = strDestMail & objRSMail("EMAIL") & ";"
		objRSMail.MoveNext
	wend
	
    '---------------------------------------------------------------------------------------------- 
	strFROM 	= mid(UCase(strREMETENTE),1,1) & mid(LCase(strREMETENTE),2,Len(strREMETENTE))
	strTO		= strDestMail
 	strSUBJECT	= Request.Cookies("VBOSS")("CLINAME") & " - VirtualBOSS: Aviso de Mensagem"
	strBODY		= strFROM & " enviou uma mensagem para você."

	Email_notify strBODY, strSUBJECT, strTO, strFROM, LCase(replace(CFG_DB,"vboss_",""))
    '---------------------------------------------------------------------------------------------- 
	FechaDBConn objConn
%>
<script>
if ('<%=strRETORNO%>' != '')
	window.location = "<%=strRETORNO%>";
else
	window.close();
</script>