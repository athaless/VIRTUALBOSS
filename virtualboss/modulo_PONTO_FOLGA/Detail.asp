<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn
	Dim strCODIGO
		
	strCODIGO   = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
	
		strSQL =          "SELECT T1.COD_FOLGA, T1.ID_USUARIO, T1.DT_INI, T1.DT_FIM, T1.OBS, T2.NOME AS CATEGORIA "
		strSQL = strSQL & "  FROM PT_FOLGA T1, PT_FOLGA_CATEGORIA T2 "
		strSQL = strSQL & " WHERE T1.COD_FOLGA = " & strCODIGO
		strSQL = strSQL & " AND T1.COD_CATEGORIA = T2.COD_CATEGORIA "
		
		Set objRS = objConn.Execute(strSQL)

		If Not objRS.Eof Then 
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
<table align="center" cellpadding="0" cellspacing="1" class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
   <tr> 
      <th width="150"></th>
      <th>Dados</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
<tr><td align="right" width="170">Usuário:&nbsp;</td>	<td><%=GetValue(objRS,"ID_USUARIO")%></td></tr>
  <tr><td align="right">Categoria:&nbsp;</td>			<td><%=GetValue(objRS,"CATEGORIA")%></td></tr> 
  <tr><td align="right">Dt Início:&nbsp;</td>			<td><%=PrepData(GetValue(objRS,"DT_INI"), True, False)%></td></tr>
  <tr><td align="right">Dt Fim:&nbsp;</td>				<td><%=PrepData(GetValue(objRS,"DT_FIM"), True, False)%></td></tr>
  <tr id="tableheader_last_row"><td align="right">Obs:&nbsp;</td>					<td><%=GetValue(objRS,"OBS")%></td></tr>
 </tbody>
</table>
</body>
</html>
<%
		End If 
		FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>