<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PONTO_FOLGA", Request.Cookies("VBOSS")("ID_USUARIO")), true 

  Dim objConn, objRS, strSQL, strSQLClause
  Dim strID_USUARIO, strCOD_CATEGORIA, strSITUACAO, strMES, strANO
  Dim strDT_INI, strDT_FIM
  Dim strCOLOR, strArquivo

  AbreDBConn objConn, CFG_DB 

  strCOD_CATEGORIA	= GetParam("var_cod_categoria")
  strID_USUARIO = GetParam("var_id_usuario")
  strMES = GetParam("var_mes")
  strANO = GetParam("var_ano")

  If strMES <> "Todos" And strANO <> "" Then
	strDT_INI = DateSerial(strANO, strMES, 1)
	strDT_FIM = DateAdd("D", -1, DateAdd("M", 1, strDT_INI))
  End If
  If strMES = "Todos" And strANO <> "" Then
	strDT_INI = DateSerial(strANO, 1, 1)
	strDT_FIM = DateSerial(strANO, 12, 31)
  End If

  strSQL =          " SELECT T1.COD_FOLGA, T1.ID_USUARIO, T1.DT_INI, T1.DT_FIM, T1.OBS, T2.NOME AS CATEGORIA "
  strSQL = strSQL & " FROM PT_FOLGA T1, PT_FOLGA_CATEGORIA T2 "
  strSQL = strSQL & " WHERE T1.COD_CATEGORIA = T2.COD_CATEGORIA " 

  if strID_USUARIO <> "" then strSQL = strSQL & " AND T1.ID_USUARIO LIKE '" & strID_USUARIO & "' "
  if strCOD_CATEGORIA <> "" then strSQL = strSQL & " AND T1.COD_CATEGORIA = " & strCOD_CATEGORIA
  if IsDate(strDT_INI) And IsDate(strDT_FIM) then 
	strSQL = strSQL & " AND ((T1.DT_INI BETWEEN '" & PrepDataBrToUni(strDT_INI, False) & "' AND '" & PrepDataBrToUni(strDT_FIM, False) & "') OR "
	strSQL = strSQL & "      (T1.DT_FIM BETWEEN '" & PrepDataBrToUni(strDT_INI, False) & "' AND '" & PrepDataBrToUni(strDT_FIM,  False) & "') OR "
	strSQL = strSQL & "      (T1.DT_INI < '" & PrepDataBrToUni(strDT_INI, False) & "' AND T1.DT_FIM > '" & PrepDataBrToUni(strDT_FIM, False) & "')) "
  end if
  strSQL = strSQL & " ORDER BY T1.ID_USUARIO, T1.DT_INI "

  Set objRS = objConn.Execute(strSQL) 
  
  If Not objRS.EOF Then
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
    <th width="1%"></th>
    <th width="1%"></th>
    <th width="1%"></th>
	<th width="10%" class="sortable">Usuário</th>
    <th width="10%" class="sortable" nowrap>Dt Início</th>
	<th width="10%" class="sortable" nowrap>Dt Fim</th>
    <th width="20%" class="sortable" nowrap>Categoria</th>
    <th width="47%" class="sortable">Obs</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRS.Eof
	  	strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
	%>
  <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_FOLGA","Delete.asp",GetValue(objRS,"COD_FOLGA"),"IconAction_DEL.gif","REMOVER")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_FOLGA","Update.asp",GetValue(objRS,"COD_FOLGA"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_PONTO_FOLGA","Detail.asp",GetValue(objRS,"COD_FOLGA"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
    <td align="left" valign="top"><div><%=GetValue(objRS,"ID_USUARIO")%></td>
    <td align="left" valign="top" nowrap><%=PrepData(GetValue(objRS,"DT_INI"), True, False)%></td>
    <td align="left" valign="top" nowrap><%=PrepData(GetValue(objRS,"DT_FIM"), True, False)%></td>
    <td align="left" valign="top" nowrap><%=GetValue(objRS,"CATEGORIA")%></td>
    <td align="left" valign="top"><%=GetValue(objRS,"OBS")%></td>
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