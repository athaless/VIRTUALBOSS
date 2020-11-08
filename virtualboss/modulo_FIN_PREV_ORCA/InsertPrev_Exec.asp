<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL, objRS, objRSa, objConn
Dim strCOD_PREV_ORCA
Dim strCOD_CONTA_PAI
Dim strVALOR, strZERO
strCOD_PREV_ORCA = GetParam("var_cod_plano_prev")
strCOD_CONTA_PAI = GetParam("var_cod_plano_pai")
strVALOR = GetParam("var_vlr_conta")
'Response.Write(strVALOR)
'Response.End()
strVALOR = MoedaToFloat(strVALOR)

AbreDBConn objConn, CFG_DB 

'if strVALOR<>"" and InStr(strZERO,strVALOR)=0 then
if strVALOR<>"" then
	strSQL = "UPDATE"	&_
				"	FIN_PLANO_PREV_ORCA " &_
				"SET"		&_
				"	VALOR=" & strVALOR & "," &_
				"	SYS_DTT_ALT='" & PrepDataBrToUni(Now, True) & "'," &_
				"	SYS_ID_USUARIO_ALT='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " &_		
				"WHERE COD_PLANO_PREV_ORCA=" & strCOD_PREV_ORCA
'Response.Write(strSQL)				
'Response.End()
	objConn.execute(strSQL)
end if
if strCOD_CONTA_PAI<>"" then 	
	strSQL = "SELECT COD_PREV_ORCA FROM FIN_PLANO_PREV_ORCA WHERE COD_PLANO_PREV_ORCA=" & strCOD_PREV_ORCA
	AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

	strSQL = "SELECT SUM(ORCA.VALOR) AS TOTAL FROM FIN_PLANO_PREV_ORCA ORCA " &_
				"LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA=ORCA.COD_PLANO_CONTA) " &_
				"WHERE PLAN.COD_PLANO_CONTA_PAI=" & strCOD_CONTA_PAI & " AND ORCA.COD_PREV_ORCA=" & GetValue(objRSa,"COD_PREV_ORCA")
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

	if not objRS.eof then
		strVALOR = Replace(Replace(GetValue(objRS,"TOTAL"),".",""),",",".")
		if strVALOR="" then strVALOR=0
		strSQL = "UPDATE"	&_
					"	FIN_PLANO_PREV_ORCA " &_
					"SET"		&_
					"	VALOR=" & strVALOR & "," &_
					"	SYS_DTT_ALT=#" & PrepData(Now(), False, True) & "#," &_
					"	SYS_ID_USUARIO_ALT='" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " &_		
					"WHERE COD_PLANO_CONTA=" & strCOD_CONTA_PAI & " AND COD_PREV_ORCA=" & GetValue(objRSa,"COD_PREV_ORCA")
'Response.Write(strSQL)				
'Response.End()				
		objConn.execute(strSQL)
	end if
	FechaRecordSet objRS
	FechaRecordSet objRSa
end if
FechaDBConn objConn
%>
<html>
<head></head>
<script>window.parent.SomaIGrava();</script>
<body leftmargin="0" topmargin="0" marginheight="0" marginwidth="0">
	<img src="../img/IconStatus_OK.gif" border="0">
</body>
</html>