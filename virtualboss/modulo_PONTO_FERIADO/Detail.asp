<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
	Dim strSQL, objRS, ObjConn
	Dim strCODIGO
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSql =          "SELECT COD_FERIADO, DATA_DIA, DATA_MES, DATA_ANO, DESCRICAO "
		strSql = strSql & "  FROM PT_FERIADO"
		strSql = strSql & " WHERE COD_FERIADO = " & strCODIGO
		
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
 <thead>
   <tr> 
      <th width="150"></th>
      <th>Dados</th>
    </tr>
  </thead>
 <tbody style="text-align:left;">
<tr><td align="right" width="170">Código:&nbsp;</td>	<td><%=GetValue(objRS,"COD_FERIADO")%></td></tr>
  <tr><td align="right">Dia:&nbsp;</td>	<td><%=GetValue(objRS,"DATA_DIA")%></td></tr> 
  <tr><td align="right">Mês:&nbsp;</td>	<td><%=GetValue(objRS,"DATA_MES")%></td></tr>
  <tr><td align="right">Ano:&nbsp;</td>	<td><% If (GetValue(objRS,"DATA_ANO") <> "0") And (GetValue(objRS,"DATA_ANO") <> "") Then Response.Write(GetValue(objRS,"DATA_ANO")) %></td></tr>
  <tr id="tableheader_last_row"><td align="right">Descrição:&nbsp;</td> <td><%=GetValue(objRS,"DESCRICAO")%></td></tr>
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