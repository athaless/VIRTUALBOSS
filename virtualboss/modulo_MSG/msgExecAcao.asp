<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<!--#include file="ConfigMSG.asp"--> 
<%
	Dim strSQL, objConn, objRS, objRSCT
	
	Dim strPARAMS, strACTION 
	Dim strPASTA_ATUAL, strPASTA_NOVA
	Dim strDT_AGORA 
	
	strPARAMS = GetParam("var_params") 
	strACTION = GetParam("var_action") 
	strPASTA_ATUAL = GetParam("var_pasta_atual")
	
	'athDebug "<br>strPARAMS:" & strPARAMS, False
	'athDebug "<br>strACTION:" & strACTION, False
	'athDebug "<br>strPASTA_ATUAL:" & strPASTA_ATUAL, True
	
	If (strPARAMS <> "") And (strACTION <> "") Then
		AbreDBConn objConn, CFG_DB 
		
		strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'" 
		strSQL = "" 
		
		If strACTION = "MARCAR_LIDO" Then 
			strSQL =          " UPDATE MSG_PASTA " 
			strSQL = strSQL & " SET DT_LIDO = " & strDT_AGORA 
			strSQL = strSQL & "   , LIDO = 1 " 
			strSQL = strSQL & " WHERE COD_MENSAGEM IN (" & strPARAMS & ") " 
			strSQL = strSQL & " AND PASTA LIKE '" & strPASTA_ATUAL & "' "
			strSQL = strSQL & " AND COD_USER = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
		End If
		
		If strACTION = "MARCAR_NAOLIDO" Then 
			strSQL =          " UPDATE MSG_PASTA " 
			strSQL = strSQL & " SET DT_LIDO = Null " 
			strSQL = strSQL & "   , LIDO = 0 " 
			strSQL = strSQL & " WHERE COD_MENSAGEM IN (" & strPARAMS & ") " 
			strSQL = strSQL & " AND PASTA LIKE '" & strPASTA_ATUAL & "' "
			strSQL = strSQL & " AND COD_USER='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
		End If
		
		If strACTION = "DELETAR" Then 
			strSQL =          " DELETE FROM MSG_PASTA " 
			strSQL = strSQL & " WHERE COD_MENSAGEM IN (" & strPARAMS & ") " 
			strSQL = strSQL & " AND PASTA LIKE '" & strPASTA_ATUAL & "' "
			strSQL = strSQL & " AND COD_USER='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
		End If
		
		If InStr(1, strACTION, "MOVER_", VBTextCompare) > 0 Then 
			strPASTA_NOVA = Mid(strACTION, 7) 
			
			If strPASTA_NOVA <> "" Then 
				strSQL =          " UPDATE MSG_PASTA " 
				strSQL = strSQL & " SET PASTA = '" & strPASTA_NOVA & "' " 
				strSQL = strSQL & " WHERE COD_MENSAGEM IN (" & strPARAMS & ") " 
				strSQL = strSQL & " AND PASTA LIKE '" & strPASTA_ATUAL & "' " 
				strSQL = strSQL & " AND COD_USER='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' "
			End If
		End If
		
		If strSQL <> "" Then 
			athDebug strSQL, False

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
			
		end if
		
		FechaDBConn objConn
	End If 
	
	Response.Redirect("msgShowMensagens.asp?var_pasta=" & strPASTA_ATUAL)
%>