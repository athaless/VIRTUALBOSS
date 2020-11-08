<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objConn, objRS1, objRS2, objRSCT
Dim intCod_NF, strDT_AGORA, strUSUARIO, strMsg

intCod_NF = GetParam("var_chavereg")

AbreDBConn objConn, CFG_DB 

if intCOD_NF<>"" then 
	strMsg=""
	
	if IsEmpty(intCod_NF) or intCod_NF="" then strMsg = strMsg & "Informar c�digo da nota<br>"
	
	if strMSG<>"" then 
		Mensagem strMsg, "Javascript:history.back();", "Voltar", 1
		Response.End()
	end if

	strSQL = " SELECT COD_NF, SITUACAO " &_
			 " FROM NF_NOTA " 			&_
			 " WHERE COD_NF=" & intCOD_NF &_
			 " AND SYS_DTT_INATIVO IS NULL " &_
			 " AND SITUACAO <> 'CANCELADA' "
	AbreRecordSet objRS1, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS1.eof then
		strDT_AGORA = "'" & PrepDataBrToUni(Now, True) & "'"
		strUSUARIO = "'" & LCase(Request.Cookies("VBOSS")("ID_USUARIO")) & "'"
		
		If GetValue(objRS1, "SITUACAO") = "EMITIDA" Then 
			strSQL = " SELECT COD_CONTA_PAGAR_RECEBER, SITUACAO FROM FIN_CONTA_PAGAR_RECEBER WHERE COD_NF=" & intCOD_NF
			AbreRecordSet objRS2, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
			
			Do While Not objRS2.Eof
				If (GetValue(objRS2, "COD_CONTA_PAGAR_RECEBER") <> "") And (GetValue(objRS2, "SITUACAO") <> "ABERTA") Then
					Mensagem "A Nota Fiscal est� relacionada a uma Conta a Receber que possui lan�amentos. A Nota n�o poder� ser cancelada.", "Javascript:history.back();", "Voltar", 1
					Response.End()
				End If
				
				objRS2.MoveNext
			Loop
			FechaRecordSet objRS2
			
			'----------------------------------------------------------------------------
			'Marca nota como cancelada e registra quando e quem executou tal opera��o
			'----------------------------------------------------------------------------
			strSQL =          " UPDATE NF_NOTA "
			strSQL = strSQL & " SET SITUACAO = 'CANCELADA' " 
			strSQL = strSQL & "   , SYS_DTT_CANCEL = " & strDT_AGORA
			strSQL = strSQL & "   , SYS_ID_USUARIO_CANCEL = " & strUSUARIO
			strSQL = strSQL & " WHERE COD_NF = " & intCOD_NF
			
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "modulo_FIN_NF.Delete_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
			
			'---------------------------------------------------
			'Deleta as contas que tiverem rela��o com a nota
			'---------------------------------------------------
			strSQL = " DELETE FROM FIN_CONTA_PAGAR_RECEBER WHERE COD_NF = " & intCOD_NF
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "modulo_FIN_NF.Delete_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
		Else
			'---------------------------------------------------
			'Deleta os itens e depois a nota
			'---------------------------------------------------
			'strSQL = " DELETE FROM NF_ITEM WHERE COD_NF = " & intCOD_NF
			'AQUI: NEW TRANSACTION
			'set objRSCT  = objConn.Execute("start transaction")
			'set objRSCT  = objConn.Execute("set autocommit = 0")
			'objConn.Execute(strSQL)
			'If Err.Number <> 0 Then
			'	set objRSCT = objConn.Execute("rollback")
			'	Mensagem "modulo_FIN_NF.Delete_Exec c: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			'	Response.End()
			'else
			'	set objRSCT = objConn.Execute("commit")
			'End If
			
			'strSQL = " DELETE FROM NF_NOTA WHERE COD_NF = " & intCOD_NF
			'AQUI: NEW TRANSACTION
			'set objRSCT  = objConn.Execute("start transaction")
			'set objRSCT  = objConn.Execute("set autocommit = 0")
			'objConn.Execute(strSQL)
			'If Err.Number <> 0 Then
			'	set objRSCT = objConn.Execute("rollback")
			'	Mensagem "modulo_FIN_NF.Delete_Exec d: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			'	Response.End()
			'else
			'	set objRSCT = objConn.Execute("commit")
			'End If
			
			'--------------------------------------------------------------------------------------
			'N�o deletamos mais para ter certeza de que as notas que "somem" n�o foram deletadas
			'                                                             08/11/2011 - Clv/Aless
			'--------------------------------------------------------------------------------------
			strSQL =          " UPDATE NF_NOTA "
			strSQL = strSQL & " SET SYS_DTT_INATIVO = " & strDT_AGORA
			strSQL = strSQL & "   , SYS_ID_USUARIO_INATIVO = " & strUSUARIO
			strSQL = strSQL & " WHERE COD_NF = " & intCOD_NF
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "modulo_FIN_NF.Delete_Exec E: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
		End If
	end if
	FechaRecordSet objRS1
end if

FechaDBConn objConn
'Response.Redirect("Default.htm")
%>
<script>
   //ASSIM S� FUNCIONA NO IE (s� no IE): parent.vbTopFrame.form_principal.submit();
 
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>