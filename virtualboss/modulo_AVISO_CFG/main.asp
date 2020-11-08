<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_AVISO_CFG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL
 Dim strAviso, strCOLOR
 
 strAviso = "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."

	AbreDBConn objConn, CFG_DB

	strSQL = " SELECT COD_CFG_AVISO, AVISAR_MANAGER_BS_TODO FROM CFG_AVISO "
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr> 
    <th width="01%"></td>
    <th width="99%" class="sortable">Emitir Aviso</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<% 
		While Not objRs.Eof
			strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
	%>
	<tr bgcolor=<%=strCOLOR%>>
		<td><%=MontaLinkGrade("modulo_AVISO_CFG","Update.asp",GetValue(objRS,"COD_CFG_AVISO"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td><%=GetValue(objRS,"AVISAR_MANAGER_BS_TODO")%></td>
	</tr>
	<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		WEnd
	%>
 </tbody>
</table>
</body>
</html>
<%
	else
		Mensagem strAviso, "", "", true
	end if
	
	FechaRecordSet objRS
	FechaDBConn objConn
%>