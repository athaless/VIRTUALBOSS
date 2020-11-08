<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim objConn, objRS, objRSCT, objRSa, strSQL
Dim strCOD_LCTO_EM_CONTA, strCOD_CONTA
Dim strVLR_SALDO, strNOVO_SALDO, strDT_LCTO
Dim strVLR_LCTO, strOPERACAO
		
strCOD_LCTO_EM_CONTA = GetParam("var_chavereg")
strCOD_CONTA = GetParam("var_conta")
strOPERACAO = GetParam("var_op")
strVLR_LCTO = GetParam("var_vlr")

if strCOD_LCTO_EM_CONTA <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL = "SELECT COD_CONTA, VLR_SALDO FROM FIN_CONTA WHERE COD_CONTA=" & strCOD_CONTA
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if GetValue(objRS,"VLR_SALDO")<>"" then
		strVLR_SALDO = GetValue(objRS,"VLR_SALDO")
	else
		strVLR_SALDO = "0,00"
	end if
	
	if strOPERACAO="DESPESA" then	
		strNOVO_SALDO = strVLR_SALDO + strVLR_LCTO
	else
		strNOVO_SALDO = strVLR_SALDO - strVLR_LCTO
	end if


	strSQL = "UPDATE FIN_CONTA SET VLR_SALDO=" & Replace(strNOVO_SALDO,",",".") & " WHERE COD_CONTA=" & GetValue(objRS,"COD_CONTA")
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_LCTOCONTA.Delete_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
	
	strSQL = "SELECT DT_LCTO FROM FIN_LCTO_EM_CONTA WHERE COD_LCTO_EM_CONTA=" & strCOD_LCTO_EM_CONTA
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	strDT_LCTO = GetValue(objRS,"DT_LCTO")
	FechaRecordSet objRS
	
	strSQL = "DELETE FROM FIN_LCTO_EM_CONTA WHERE COD_LCTO_EM_CONTA=" & strCOD_LCTO_EM_CONTA
	'AQUI: NEW TRANSACTION
	set objRSCT = objConn.Execute("start transaction")
	set objRSCT = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	if Err.Number<>0 then 
	  set objRSCT= objConn.Execute("rollback")
	  Mensagem "modulo_FIN_LCTOCONTA.Delete_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
 	  Response.End()
	else	  
	  set objRSCT= objConn.Execute("commit")
	End If
	
	if strOPERACAO="DESPESA" then	 
		AcumulaSaldoNovo objConn, strCOD_CONTA, strDT_LCTO, strVLR_LCTO 
	else
		AcumulaSaldoNovo objConn, strCOD_CONTA, strDT_LCTO, -strVLR_LCTO 
	end if
	
	FechaDBConn objConn
end if
%>
<script>
   //ASSIM SÓ FUNCIONA NO IE (só no IE): parent.vbTopFrame.form_principal.submit();
   //ASSIM FUNCIONA NO IE e no FIREFOX
   parent.frames["vbTopFrame"].document.form_principal.submit();
</script>