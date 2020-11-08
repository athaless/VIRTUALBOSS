<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL, strCODIGO
 
 AbreDBConn objConn, CFG_DB
 
 strCODIGO = GetParam("var_chavereg")
 
 strSQL = " SELECT GRUPO, FORNECEDOR, TIPO, CONTA_USR, CONTA_SENHA, CONTA_EXTRA1, CONTA_EXTRA2, CONTA_EXTRA3, ENDER_URL, OBS, ORDEM, DT_INATIVO " &_
          "  FROM ACCOUNT_SERVICE " &_
		  "  WHERE COD_ACCOUNT_SERVICE = " & strCODIGO
 Set objRS = objConn.execute(strSQL)
 
 If Not objRS.EOF Then 
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
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
<tr> 
      <td align="right" width="170">Código:&nbsp;</td>
      <td><%=strCODIGO%></td>
    </tr>
	<tr> 
      <td align="right">Grupo:&nbsp;</td>
      <td><%=GetValue(objRS,"GRUPO")&""%></td>
    </tr>
    <tr> 
      <td align="right">Fornecedor:&nbsp;</td>
      <td><%=GetValue(objRS,"FORNECEDOR")%></td>
    </tr>
    <tr> 
      <td align="right">Tipo:&nbsp;</td>
      <td><%=GetValue(objRS,"TIPO")%></td>
    </tr>
    <tr> 
      <td align="right">Nome/Usr:&nbsp;</td>
      <td><%=GetValue(objRS,"CONTA_USR")%></td>
    </tr>
	<% if Request.Cookies("VBOSS")("GRUPO_USUARIO")="MANAGER" then %>
	<tr> 
      <td align="right">Senha:&nbsp;</td>
      <td><%=GetValue(objRS,"CONTA_SENHA")%></td>
    </tr>
    <% end if %>
    <tr> 
      <td align="right">Info Extra1:&nbsp;</td>
      <td><%=GetValue(objRS,"CONTA_EXTRA1")%></td>
    </tr>
    <tr> 
      <td align="right">Info Extra2:&nbsp;</td>
      <td><%=GetValue(objRS,"CONTA_EXTRA2")%></td>
    </tr>
    <tr> 
      <td align="right">Info Extra3:&nbsp;</td>
      <td> <%=GetValue(objRS,"CONTA_EXTRA3")%></td>
    </tr>
    <tr> 
      <td align="right">Ender/URL:&nbsp;</td>
      <td><%=GetValue(objRS,"ENDER_URL")%></td>
    </tr>
    <tr> 
      <td align="right">Obs.:&nbsp;</td>
      <td><%=GetValue(objRS,"OBS")%></td>
    </tr>
    <tr> 
      <td align="right">Ordem:&nbsp;</td>
      <td><%=GetValue(objRS,"ORDEM")%></td>
    </tr>
	<tr id="tableheader_last_row"> 
      <td align="right">Status:&nbsp;</td>
      <td><% if GetValue(objRs,"DT_INATIVO") = "" then Response.Write("Ativo") else Response.Write("Inativo") end if %></td>
    </tr>
  </table>
 </tbody>
</table>
</body>
</html>
<%
 End If 
 
 FechaRecordset(objRS)
 FechaDBConn(objConn)
%>