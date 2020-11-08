<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ACCOUNT", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL
 Dim strGRUPO, strFORNEC, strTIPO, strTITULO, strSITUACAO, strCOLOR

 AbreDBConn objConn, CFG_DB 

 strGRUPO    = GetParam("var_grupo")
 strFORNEC   = GetParam("var_fornec")
 strTIPO     = GetParam("var_tipo")
 strTITULO   = GetParam("var_titulo")
 strSITUACAO = GetParam("var_situacao")

 strSQL =          " SELECT COD_ACCOUNT_SERVICE, GRUPO, TIPO, FORNECEDOR, CONTA_USR, ENDER_URL " 
 strSQL = strSQL & "      , CONTA_SENHA, SYS_DT_UPD, SYS_USR_UPD, SYS_DT_INS, SYS_USR_INS "
 strSQL = strSQL & " FROM ACCOUNT_SERVICE "
 strSQL = strSQL & " WHERE TRUE " 

 if strGRUPO <> ""          then strSQL = strSQL & " AND GRUPO LIKE '" & strGRUPO & "%'"
 if strFORNEC <> ""         then strSQL = strSQL & " AND FORNECEDOR LIKE '" & strFORNEC & "%'"
 if strTIPO <> ""           then strSQL = strSQL & " AND TIPO = '" & strTIPO & "'" 
 if strTITULO <> ""         then strSQL = strSQL & " AND CONTA_USR LIKE '" & strTITULO & "%'" 
 if strSITUACAO = "INATIVO" then strSQL = strSQL & " AND DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"   then strSQL = strSQL & " AND DT_INATIVO IS NULL "
 
 strSQL = strSQL & " ORDER BY GRUPO, CONTA_USR"
 
 Set objRS = objConn.Execute(strSQL) 
 
 If Not objRS.EOF Then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body><br>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr> 
    <th width="1%" title="<%=GetParam("rndrequest")%>"></th>
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%"  class="sortable">Tipo</th>
	<th width="11%" class="sortable">Grupo</th>
    <th width="11%" class="sortable" nowrap>Fornec</th>
    <th width="38%" class="sortable">Account</th>
	<th width="34%" class="sortable" nowrap>Ender/URL</th>
    <th width="1%"  class="sortable-date-dmy">Ult.Oper</th>
	<th width="1%"  class="sortable" nowrap>Usr</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRS.Eof
  	  	strCOLOR = swapString(strCOLOR, "#F5FAFA", "#FFFFFF")
	%>
  <tr bgcolor="<%=strCOLOR%>"> 
	<td width="1%"><%=MontaLinkGrade("modulo_ACCOUNT","Delete.asp",GetValue(objRS,"COD_ACCOUNT_SERVICE"),"IconAction_DEL.gif","REMOVER")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_ACCOUNT","Update.asp",GetValue(objRS,"COD_ACCOUNT_SERVICE"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_ACCOUNT","Detail.asp",GetValue(objRS,"COD_ACCOUNT_SERVICE"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
	<td nowrap><%=GetValue(objRS,"TIPO")%></td>
    <td nowrap><%=GetValue(objRS,"GRUPO")%></td>
    <td><%=GetValue(objRS,"FORNECEDOR")%></td>
    <td><%=GetValue(objRS,"CONTA_USR")%></td>
    <td><%=GetValue(objRS,"ENDER_URL")%></td>
	<% If GetValue(objRS,"SYS_USR_UPD") <> "" Then %>
	    <td nowrap><%=PrepData(GetValue(objRS,"SYS_DT_UPD"), True, False)%></td>
    	<td nowrap><%=GetValue(objRS,"SYS_USR_UPD")%></td>
	<% Else %>
	    <td nowrap><%=PrepData(GetValue(objRS,"SYS_DT_INS"), True, False)%></td>
    	<td nowrap><%=GetValue(objRS,"SYS_USR_INS")%></td>
	<% End If %>
  </tr>
  <%
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
      Wend
%>
  </tbody>
</table>
</body>
</html>
<%
 else
   Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 FechaRecordSet ObjRS
 FechaDBConn objConn
%>