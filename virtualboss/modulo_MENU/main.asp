<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_MENU", Request.Cookies("VBOSS")("ID_USUARIO")), true 
 
 Dim objConn, objRS, strSQL
 Dim strROTULO, strCOD_MENU_PAI, strSITUACAO
 Dim strCOLOR

 AbreDBConn objConn, CFG_DB 

 strROTULO        = GetParam("var_rotulo")
 strCOD_MENU_PAI  = GetParam("var_cod_menu_pai")
 strSITUACAO      = GetParam("var_situacao")

 strSQL =          " SELECT COD_MENU, ROTULO, LINK, ID_APP " 
 strSQL = strSQL & "      , GRP_USER, COD_MENU_PAI, ORDEM "
 strSQL = strSQL & " FROM SYS_MENU "
 strSQL = strSQL & " WHERE TRUE " 

 if strROTULO <> ""         then strSQL = strSQL & " AND ROTULO LIKE '" & strROTULO & "%'"
 if strCOD_MENU_PAI <> ""   then strSQL = strSQL & " AND COD_MENU_PAI = " & strCOD_MENU_PAI
 if strSITUACAO = "INATIVO" then strSQL = strSQL & " AND DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"   then strSQL = strSQL & " AND DT_INATIVO IS NULL "
 
 strSQL = strSQL & " ORDER BY GRP_USER, ORDEM "
 
 Set objRs = objConn.Execute(strSQL) 
 If Not objRS.EOF Then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%;" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr> 
    <th width="1%"></th>
    <th width="1%"></th>
	<th width="1%"  class="sortable" nowrap>Rótulo</th>
    <th width="94%" class="sortable" nowrap>Link</th>
	<th width="1%"  class="sortable" nowrap>Grupo</th>
    <th width="1%"  class="sortable-numeric" nowrap>Código Pai</th>
    <th width="1%"  class="sortable-numeric" nowrap>Ordem</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
 While Not objRs.Eof
	strCOLOR = SwapString(strCOLOR,"#FFFFFF","#F5FAFA")
 %>
	<tr bgcolor=<%=strCOLOR%>> 
		<td width="1%"><%=MontaLinkGrade("modulo_MENU","Delete.asp",GetValue(objRS,"COD_MENU"),"IconAction_DEL.gif","REMOVER")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_MENU","Update.asp",GetValue(objRS,"COD_MENU"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td nowrap><%=getValue(objRS,"ROTULO")%></td>
		<td><%=getValue(objRS,"LINK")%></td>
		<td nowrap><%=getValue(objRS,"GRP_USER")%></td>
		<td nowrap><%=getValue(objRS,"COD_MENU_PAI")%></td>
		<td nowrap><%=getValue(objRS,"ORDEM")%></td>
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