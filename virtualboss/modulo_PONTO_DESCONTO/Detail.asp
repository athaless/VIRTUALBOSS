<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn
	Dim strCODIGO
		
	strCODIGO   = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSQL =          " SELECT COD_DESCONTO, ID_USUARIO, MES, ANO, TOTAL_HR, TOTAL_MIN, OBS "
		strSQL = strSQL & " FROM PT_DESCONTO "
		strSQL = strSQL & " WHERE COD_DESCONTO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)

		If Not objRS.Eof Then 
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<!--link rel="stylesheet" type="text/css" href="../_css/virtualboss.css"-->
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
  <tr><td align="right">Período:&nbsp;</td>				<td><%=MesExtenso(GetValue(objRS, "MES"))%> / <%=GetValue(objRS, "ANO")%></td></tr> 
  <tr><td align="right">Horas de Desconto:&nbsp;</td>	<td><%=GetValue(objRS,"TOTAL_HR")%>:<%=GetValue(objRS,"TOTAL_MIN")%></td></tr>
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