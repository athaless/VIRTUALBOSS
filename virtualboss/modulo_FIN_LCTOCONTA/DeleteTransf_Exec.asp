<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, objRSCT, objRSa, strSQL
Dim strCOD_LCTO_TRANSF 
Dim strVLR_SALDO, strNOVO_SALDO
Dim strVLR_LCTO, strCOD_CONTA_ORIG, strCOD_CONTA_DEST
		
strCOD_LCTO_TRANSF = GetParam("var_chavereg")
strCOD_CONTA_ORIG = GetParam("var_conta_orig")
strCOD_CONTA_DEST = GetParam("var_conta_dest")
strVLR_LCTO = GetParam("var_vlr")

if strCOD_LCTO_TRANSF <> "" then
	AbreDBConn objConn, CFG_DB 

	'Insere novo saldo na conta de ORIGEM
	strSQL = "SELECT VLR_SALDO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA_ORIG
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

	if GetValue(objRS,"VLR_SALDO")<>"" then
		strVLR_SALDO = GetValue(objRS,"VLR_SALDO")
	else
		strVLR_SALDO = "0,00"
	end if
	strNOVO_SALDO = strVLR_SALDO + strVLR_LCTO
	
	strSQL = "UPDATE FIN_CONTA SET VLR_SALDO=" & Replace(strNOVO_SALDO,",",".") & " WHERE COD_CONTA=" & strCOD_CONTA_ORIG
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_LCTOCONTA.DeleteTransf_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If

	FechaRecordSet objRS
	
	'Insere novo saldo na conta DESTINO
	strSQL = "SELECT VLR_SALDO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA_DEST
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	

	if GetValue(objRS,"VLR_SALDO")<>"" then
		strVLR_SALDO = GetValue(objRS,"VLR_SALDO")
	else
		strVLR_SALDO = "0,00"
	end if
	strNOVO_SALDO = strVLR_SALDO - strVLR_LCTO


	strSQL = "UPDATE FIN_CONTA SET VLR_SALDO=" & Replace(strNOVO_SALDO,",",".") & " WHERE COD_CONTA=" & strCOD_CONTA_DEST
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_LCTOCONTA.DeleteTransf_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
	
	FechaRecordSet objRS
	
	'Exclui o lançamento da transferência	
	strSQL = "DELETE FROM FIN_LCTO_TRANSF WHERE COD_LCTO_TRANSF=" & strCOD_LCTO_TRANSF
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_LCTOCONTA.DeleteTransf_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
	
	FechaDBConn ObjConn
end if
%>
<script>
   //ASSIM SÓ FUNCIONA NO IE (só no IE): parent.vbTopFrame.form_principal.submit();
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>