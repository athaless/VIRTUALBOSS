<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_DRE", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
  Dim objConn, objRS, objRSa, strSQL
 Dim strCOLOR
 Dim strSITUACAO

 AbreDBConn objConn, CFG_DB 

 strSITUACAO = GetParam("var_situacao")
 strCOLOR  = "#DAEEFA"

 ' Previsões do mês atual até o fim do ano corrente
 strSQL = "SELECT COD_PREV_ORCA, DESCRICAO, DT_PREV_INI, DT_PREV_FIM FROM FIN_PREV_ORCA WHERE 1=1"

 if strSITUACAO="VIGENTES" then
	strSQL = strSQL & " AND DT_PREV_FIM>= '" & PrepDataBrToUni(Date,false) & "'"
 elseif InStr(strSITUACAO,"_")>0 then
	strSQL = strSQL & " AND DT_PREV_FIM<= '" & PrepDataBrToUni(Date,false) & "'"
 end if

 strSQL = strSQL &	" ORDER BY DT_PREV_INI, DT_PREV_FIM"
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

 if not objRS.eof then
%>
<html>
<link rel="stylesheet" href="../_css/virtualboss.css" type="text/css">
<body bgcolor="#FFFFFF" topmargin="0px" leftmargin="3px" rightmargin="0px" bottommargin="0px">
<table align="center" cellpadding="0px" cellspacing="1px" width="100%">
	<tr><td height="2px" colspan="8"></td></tr>
	<tr bgcolor="#CCCCCC" bordercolordark="#CCCCCC" bordercolorlight="#CCCCCC" class="arial11Bold">
		<td height="16px"></td>		
		<td></td>		
		<td></td>		
		<td width="05%" nowrap>Cod Prev</div></td>		
		<td width="05%" nowrap>Data Início</div></td>
		<td width="05%" nowrap>Data Fim</div></td>								
		<td width="72%">Descrição</div></td>
		<td width="10%">Total</div></td>
	</tr>
	<% 
			while not objRS.eof 
				strSQL = "SELECT SUM(ORCA.VALOR) AS TOTAL FROM FIN_PLANO_PREV_ORCA ORCA " &_
						 " LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA=ORCA.COD_PLANO_CONTA) " &_
						 " WHERE PLAN.COD_PLANO_CONTA_PAI IS NULL AND ORCA.COD_PREV_ORCA=" & GetValue(objRS,"COD_PREV_ORCA")
				AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	%>	
	<tr bgcolor=<%=strCOLOR%> valign="middle">
		<td align="center" style="cursor:hand;"><%=MontaLinkGrade("modulo_FIN_PREV_ORCA","Delete.asp",GetValue(objRS,"COD_PREV_ORCA"),"IconAction_DEL.gif","REMOVER")%></div></td>
		<td align="center" style="cursor:hand;"><%=MontaLinkGrade("modulo_FIN_PREV_ORCA","Update.asp",GetValue(objRS,"COD_PREV_ORCA"),"IconAction_EDIT.gif","ALTERAR")%></div></td>
		<td align="center" style="cursor:hand;"><%=MontaLinkGrade("modulo_FIN_PREV_ORCA","InsertPrev.asp",GetValue(objRS,"COD_PREV_ORCA"),"IconAction_DETAILADD.gif","")%></div></td>						
		<td nowrap><%=GetValue(objRS,"COD_PREV_ORCA")%></div></td>
		<td align="right" nowrap><%=PrepData(GetValue(objRS,"DT_PREV_INI"),true,false)%></div></td>
		<td align="right" nowrap><%=PrepData(GetValue(objRS,"DT_PREV_FIM"),true,false)%></div></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></div></td>
		<td align="right" nowrap><%=FormataDecimal(GetValue(objRSa,"TOTAL"),2)%></div></td>
	</tr>
	<%
				athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
			wend
	%>
	<tr><td align="center" bgcolor="#CCCCCC" colspan="8" height="1px"></td></tr>	
</table>
</body>
</html>
<%
	FechaRecordSet objRS
else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
	FechaDBConn objConn
end if
%>