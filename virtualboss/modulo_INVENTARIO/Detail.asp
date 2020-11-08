<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL, strCODIGO, strARQUIVOANEXO
 
 AbreDBConn objConn, CFG_DB
 
 strCODIGO = GetParam("var_chavereg")
 
 strSQL =          " SELECT COD_INVENTARIO, ID_ITEM, NOME_ITEM, DESC_ITEM, PROPRIEDADE "
 strSQL = strSQL & "      , DT_COMPRA, LOCAL_COMPRA, PRC_COMPRA, DT_GARANTIA "  
 strSQL = strSQL & "      , TIPO, MARCA, DIVISAO, OBS, ARQUIVO_ANEXO, DT_INATIVO "
 strSQL = strSQL & "      , SYS_DT_INS, SYS_USR_INS, SYS_DT_ALT, SYS_USR_ALT "
 strSQL = strSQL & " FROM INVENTARIO "
 strSQL = strSQL & " WHERE COD_INVENTARIO = " & strCODIGO 
 
 Set objRS = objConn.execute(strSQL)
 
 If Not objRS.EOF then 
%>
<html>
<head>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
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
      <td align="right">ID:&nbsp;</td>
      <td><%=GetValue(objRS,"ID_ITEM")&""%></td>
    </tr>
    <tr> 
      <td align="right">Nome item:&nbsp;</td>
      <td><%=GetValue(objRS,"NOME_ITEM")%></td>
    </tr>
    <tr>  
      <td align="right">Descriçao:&nbsp;</td>
      <td><%=GetValue(objRS,"DESC_ITEM")%></td>
    </tr>
	<tr> 
      <td align="right">Owner:&nbsp;</td>
      <td><%=GetValue(objRS,"PROPRIEDADE")%></td>
    </tr>
	<tr> 
      <td align="right">Divisão/Área:&nbsp;</td>
      <td><%=GetValue(objRS,"DIVISAO")%></td>
    </tr>
    <tr> 
      <td align="right">Tipo:&nbsp;</td>
      <td><%=GetValue(objRS,"TIPO")%></td>
    </tr>
	<tr> 
      <td align="right">Marca:&nbsp;</td>
      <td><%=GetValue(objRS,"MARCA")%></td>
    </tr>
    <tr> 
      <td align="right">Local da Compra:&nbsp;</td>
      <td><%=GetValue(objRS,"LOCAL_COMPRA")%></td>
    </tr>
    <tr> 
      <td align="right">Preço da Compra ou Avaliação:&nbsp;</td>
      <td> <%=FormataDecimal(GetValue(objRS,"PRC_COMPRA"), 2)%></td>
    </tr>
    <tr>
      <td align="right">Data Compra ou Avaliação:&nbsp;</td>
      <td><%=PrepData(GetValue(objRS,"DT_COMPRA"), True, False)%></td>
    </tr>
    <tr>
      <td align="right">Data de Garantia:&nbsp;</td>
      <td><%=PrepData(GetValue(objRS,"DT_GARANTIA"), True, False)%></td>
    </tr>
    <tr>
      <td align="right">Obs.:&nbsp;</td>
      <td><%=GetValue(objRS,"OBS")%></td>
    </tr>
	<tr> 
      <td align="right">Status:&nbsp;</td>
      <td><% if GetValue(objRs,"DT_INATIVO") = "" then Response.Write("Ativo") else Response.Write("Inativo (desde " & PrepData(GetValue(objRS,"DT_INATIVO"), True, False) & ")") end if %></td>
    </tr>    
    <% 
	  strARQUIVOANEXO = GetValue(objRS,"ARQUIVO_ANEXO")
	  if strARQUIVOANEXO <> "" then
	%>
	<tr>
		<td>Documento:&nbsp;</td>
		<td><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=INVENTARIO_Anexos&var_arquivo=<%=strARQUIVOANEXO%>" style="cursor:hand;text-decoration:none;" target="_blank"><img src="../img/ico_clip.gif" border="0" title="Documento" alt="Documento">&nbsp;DOWNLOAD&nbsp;</a><small>&nbsp;&nbsp;<%=ucase(Replace(strARQUIVOANEXO,"}_","}_<b>")&"</b>")%></small></td>
	</tr>
	<% End If %>
    
    
    
 </tbody>
</table>
</body>
</html>
<%
 End if 
 
 FechaRecordset(objRS)
 FechaDBConn(objConn)
%>