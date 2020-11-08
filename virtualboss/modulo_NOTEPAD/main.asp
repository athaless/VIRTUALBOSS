<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 'Este módulo será LIVRE de direitos - todo mundo pode inserir, atualizar e deletar suas anotações
 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_NOTEPAD", Request.Cookies("VBOSS")("ID_USUARIO")), true 
%>
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL
 Dim strTEXTO, strTITULO, strID_FROM, strID_TO
 Dim strMES, strANO, strDT_INI, strDT_FIM, strSIGILOSO
 Dim strCOLOR
 
 AbreDBConn objConn, CFG_DB 

 strTITULO  = GetParam("var_titulo")
 strTEXTO   = GetParam("var_texto")
 
 strSQL =           " SELECT COD_NOTEPAD, ID_USUARIO, TITULO, TEXTO, TIPO, SYS_DTT_INS, SYS_DTT_UPD "
 strSQL = strSQL  & "   FROM NOTEPAD "
 strSQL = strSQL  & "  WHERE ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' " 
	
 if strTITULO  <> "" then strSQL = strSQL & " AND TITULO LIKE '%" & strTITULO & "%' "
 if strTEXTO   <> "" then strSQL = strSQL & " AND (TEXTO LIKE '%" & strTEXTO & "%' OR TEXTO LIKE '%" & strTEXTO & "%') " 
	
 strSQL = strSQL & "ORDER BY SYS_DTT_UPD DESC, SYS_DTT_INS DESC "
	
 Set objRs = objConn.Execute(strSql) 
 If Not objRS.EOF Then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr> 
    <th width="1%"></th>
    <th width="1%"></th>
	<th width="1%"  class="sortable-numeric" nowrap>Cod</th>
    <th width="30%" class="sortable">Titulo</th>
	<th width="55%" class="sortable">Texto</th>
	<th width="10%" class="sortable">Tipo</th>
    <th width="1%" class="sortable" nowrap>Inserido</th>
	<th width="1%" class="sortable" nowrap>Alterado</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
 <%
      While Not objRs.Eof
	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
 %>
 <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%"><%=MontaLinkGrade("modulo_NOTEPAD","Delete.asp",GetValue(objRS,"COD_NOTEPAD"),"IconAction_DEL.gif","REMOVER")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_NOTEPAD","Update.asp",GetValue(objRS,"COD_NOTEPAD"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td style="text-align:right" nowrap><%=GetValue(objRS,"COD_NOTEPAD")%></td>
    <td><%=GetValue(objRS,"TITULO")%></td>
	<td><%=Replace(GetValue(objRS,"TEXTO"), CHR(13),"<br>")%></td>
	<td style="text-align:left"><%=GetValue(objRS,"TIPO")%></td>
    <td style="text-align:left" nowrap><%=PrepData(GetValue(objRS,"SYS_DTT_INS"), True, False)%></td>
    <td style="text-align:left" nowrap><%=PrepData(GetValue(objRS,"SYS_DTT_UPD"), True, False)%></td>
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
	FechaRecordSet ObjRS
 else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 FechaDBConn objConn
%>