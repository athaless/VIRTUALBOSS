<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<% 
  Response.CacheControl = "no-cache"
  Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
  VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PONTO_FERIADO", Request.Cookies("VBOSS")("ID_USUARIO")), true 

  Dim objConn, objRS, strSQL
  Dim strANO, strCOLOR

  AbreDBConn objConn, CFG_DB 

  strANO = GetParam("var_ano")

  strSQL =          " SELECT COD_FERIADO, DATA_DIA, DATA_MES, DATA_ANO, UF, DESCRICAO "
  strSQL = strSQL & "   FROM PT_FERIADO "
  strSQL = strSQL & "  WHERE COD_FERIADO = COD_FERIADO " 
  
  if strANO <> "" then strSQL = strSQL & " AND (DATA_ANO = " & strANO & " OR DATA_ANO IS NULL OR DATA_ANO = 0)"
  
  strSQL = strSQL & " ORDER BY DATA_DIA, DATA_MES, DATA_ANO "

  Set objRS = objConn.Execute(strSQL) 
  
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
    <th width="1%"></th>
	<th width="5%" class="sortable">COD</th>
    <th width="1%" class="sortable">SDIA</th>
    <th width="5%" class="sortable">DIA</th>
	<th width="5%" class="sortable">MÊS</th>
    <th width="5%" class="sortable">ANO</th>
    <th width="5%" class="sortable">UF</th>
    <th width="71%" class="sortable">DESCRIÇÃO</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
     While Not objRS.Eof
       strCOLOR = swapString(strCOLOR, "#F5FAFA", "#FFFFFF")
  %>
  <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_FERIADO","Delete.asp",GetValue(objRS,"COD_FERIADO"),"IconAction_DEL.gif","REMOVER")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_FERIADO","Update.asp",GetValue(objRS,"COD_FERIADO"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_FERIADO","Detail.asp",GetValue(objRS,"COD_FERIADO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
    <td align="left" valign="top"><%=GetValue(objRS,"COD_FERIADO")%></td>
    <td align="left" valign="top"><%=DiaDaSemana(GetValue(objRS,"DATA_DIA"),GetValue(objRS,"DATA_MES"),strANO)%></td>
    <td align="left" valign="top"><%=GetValue(objRS,"DATA_DIA")%></td>
    <td align="left" valign="top"><%=GetValue(objRS,"DATA_MES")%></td>
    <td align="left" valign="top"><%if (GetValue(objRS,"DATA_ANO")<>"0") And (GetValue(objRS,"DATA_ANO")<>"") then response.write(GetValue(objRS,"DATA_ANO")) end if%></td>
    <td align="left" valign="top"><%=GetValue(objRS,"UF")%></td>
    <td align="left" valign="top"><%=GetValue(objRS,"DESCRICAO")%></td>
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