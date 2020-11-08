<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn
	Dim strMSG, strDT_AGORA, strCOD_DADO, strSITUACAO, strMOTIVO, strACAO_TIT_ABERTO
	
	strCOD_DADO        = GetParam("var_chavereg"       )
	strSITUACAO        = GetParam("var_situacao"       )
	strACAO_TIT_ABERTO = GetParam("var_acao_tit_aberto")
	strMOTIVO          = GetParam("var_motivo"         )
	
	If Not IsNumeric(strCOD_DADO) Then strCOD_DADO = ""
	
	strMSG = ""
	If strCOD_DADO = "" Then strMSG = strMSG & "Parâmetro inválido para contrato<br>"
	If strSITUACAO = "" Then strMSG = strMSG & "Parâmetro inválido para situação<br>"
	
	If strMSG <> "" Then 
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	End If
	
	AbreDBConn objConn, CFG_DB 
	
	strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
	
	If strSITUACAO = "ABERTO" Then
		'-------------------------------------------------------------
		'Se está aberto então não tem títulos; logo, deleta direto ou apenas INATIVA (conforme a marcação na janela anterior)
		'-------------------------------------------------------------
		If (strACAO_TIT_ABERTO = "CANCELAR") Then ' neste caso o CANCEAR é sinônimo de DELETAR/INATIVAR 
			'------------------------------------------------------------------
			'Se está aberto não tem títulos, então pode marcar como inativo
			'------------------------------------------------------------------
			strSQL =          " UPDATE CONTRATO "
			strSQL = strSQL & " SET DT_INATIVO = " & strDT_AGORA
			strSQL = strSQL & "   , SYS_DT_ALTERACAO = " & strDT_AGORA
			strSQL = strSQL & "   , SYS_ALT_ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
			strSQL = strSQL & "   , MOTIVO_CANC_DEL =  '" & strMOTIVO & "' "
			strSQL = strSQL & " WHERE COD_CONTRATO = " & strCOD_DADO
			'AQUI: NEW TRANSACTION
			set objRS = objConn.Execute("start transaction" )
			set objRS = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRS = objConn.Execute("rollback")
				Mensagem "modulo_CONTRATO.delete_exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRS = objConn.Execute("commit")
			End If		
		Else
			strSQL = " DELETE FROM CONTRATO WHERE COD_CONTRATO = " & strCOD_DADO
			'AQUI: NEW TRANSACTION
			set objRS = objConn.Execute("start transaction" )
			set objRS = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRS = objConn.Execute("rollback")
				Mensagem "modulo_CONTRATO.delete_exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRS = objConn.Execute("commit")
			End If		

			'Deleta as parcelas
			strSQL = " DELETE FROM CONTRATO_PARCELA WHERE COD_CONTRATO = " & strCOD_DADO
			'AQUI: NEW TRANSACTION
			set objRS = objConn.Execute("start transaction" )
			set objRS = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRS = objConn.Execute("rollback")
				Mensagem "modulo_CONTRATO.delete_exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRS = objConn.Execute("commit")
			End If		

			'Deleta os anexos
			strSQL = " DELETE FROM CONTRATO_ANEXO WHERE COD_CONTRATO = " & strCOD_DADO
			'AQUI: NEW TRANSACTION
			set objRS = objConn.Execute("start transaction" )
			set objRS = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRS = objConn.Execute("rollback")
				Mensagem "modulo_CONTRATO.delete_exec D: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRS = objConn.Execute("commit")
			End If		
		End If			
	End If	
	
	If strSITUACAO = "FATURADO" Then
		'------------------------------------------------------------------------
		'Se está FATURADO os títulos em aberto podem ser cancelados 
		'------------------------------------------------------------------------	
		strSQL =          " UPDATE FIN_CONTA_PAGAR_RECEBER "
		strSQL = strSQL & " SET SYS_DT_CANCEL = " & strDT_AGORA
		strSQL = strSQL & "   , SYS_COD_USER_CANCEL = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
		strSQL = strSQL & "   , SITUACAO = 'CANCELADA' "		
		strSQL = strSQL & " WHERE SITUACAO = 'ABERTA' "
		strSQL = strSQL & " AND COD_CONTRATO = " & strCOD_DADO

		'AQUI: NEW TRANSACTION
		set objRS = objConn.Execute("start transaction")
		set objRS = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRS = objConn.Execute("rollback")
			Mensagem "modulo_CONTRATO.delete_exec E: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRS = objConn.Execute("commit")
		End If
		
		'------------------------------
		'Marca contrato como cancelado
		'------------------------------
		strSQL =          " UPDATE CONTRATO "
		strSQL = strSQL & " SET SYS_DT_CANCEL = " & strDT_AGORA
		strSQL = strSQL & "   , SYS_DEL_ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
		strSQL = strSQL & "   , SITUACAO = 'CANCELADO' "
		strSQL = strSQL & "   , MOTIVO_CANC_DEL =  '" & strMOTIVO & "' "		
		strSQL = strSQL & " WHERE COD_CONTRATO = " & strCOD_DADO
		
		'AQUI: NEW TRANSACTION
		set objRS = objConn.Execute("start transaction")
		set objRS = objConn.Execute("set autocommit = 0")
		objConn.Execute(strSQL)
		If Err.Number <> 0 Then
			set objRS = objConn.Execute("rollback")
			Mensagem "modulo_CONTRATO.delete_exec F: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRS = objConn.Execute("commit")
		End If
	End If
	
	FechaDBConn ObjConn
%>
<script>
	parent.frames["vbTopFrame"].document.form_principal.submit();
</script>