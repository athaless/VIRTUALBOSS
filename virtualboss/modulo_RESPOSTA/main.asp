<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_RESPOSTA", Request.Cookies("VBOSS")("ID_USUARIO")), true 
%>
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL
 Dim strTEXTO, strTAREFA, strID_FROM, strID_TO
 Dim strMES, strANO, strDT_INI, strDT_FIM, strSIGILOSO
 Dim strCOLOR
 
 AbreDBConn objConn, CFG_DB 

 strTEXTO = GetParam("var_texto")
 strTAREFA = GetParam("var_tarefa")
 strID_FROM = GetParam("var_id_from")
 strID_TO = GetParam("var_id_to")
 strMES = GetParam("var_mes")
 strANO = GetParam("var_ano")
 
 if (strMES = "") And (strANO <> "") then
	strDT_INI = DateSerial(strANO, 1, 1)
	strDT_FIM = DateSerial(strANO, 12, 31)
 end if
 
 if (strMES <> "") And (strANO = "") then
	strANO = DatePart("YYYY", Date)
	
	strDT_INI = DateSerial(strANO, strMES, 1)
	strDT_FIM = DateAdd("M", 1, strDT_INI)
	strDT_FIM = DateAdd("D", -1, strDT_FIM)
 end if
 
 if (strMES <> "") And (strANO <> "") then
	strDT_INI = DateSerial(strANO, strMES, 1)
	strDT_FIM = DateAdd("M", 1, strDT_INI)
	strDT_FIM = DateAdd("D", -1, strDT_FIM)
 end if
 
 if strTEXTO <> "" or strTAREFA <> "" or strID_FROM <> "" or strID_TO <> "" or (strDT_INI <> "" and strDT_FIM <> "") then
	strSQL =          " SELECT T1.COD_TODOLIST, T1.TITULO AS TAREFA, T2.COD_TL_RESPOSTA, T2.HORAS "
	strSQL = strSQL & "      , T2.ID_FROM, T2.ID_TO, T2.RESPOSTA, T2.DTT_RESPOSTA, T2.SIGILOSO "
	strSQL = strSQL & " FROM TL_TODOLIST T1, TL_RESPOSTA T2 "
	strSQL = strSQL & " WHERE T1.COD_TODOLIST = T2.COD_TODOLIST "
	
	if strTEXTO <> "" then strSQL = strSQL & " AND T2.RESPOSTA LIKE '%" & strNOME & "%' "
	if strTAREFA <> "" then strSQL = strSQL & " AND (T1.TITULO LIKE '%" & strTAREFA & "%' OR T1.DESCRICAO LIKE '%" & strTAREFA & "%') " 
	if strID_FROM <> "" then strSQL = strSQL & " AND T2.ID_FROM LIKE '" & strID_FROM & "%' "
	if strID_TO <> "" then strSQL = strSQL & " AND T2.ID_TO LIKE '" & strID_TO & "%' "
	if strDT_INI <> "" and strDT_FIM <> "" then strSQL = strSQL & " AND (T2.DTT_RESPOSTA >= '" & PrepDataBrToUni(strDT_INI,false) & "' AND T2.DTT_RESPOSTA < '" & PrepDataBrToUni(DateAdd("D", 1, strDT_FIM),false) & "') " 
	
	strSQL = strSQL & " ORDER BY T1.COD_TODOLIST DESC, T2.DTT_RESPOSTA DESC "
	
	Set objRs = objConn.Execute(strSql) 
	If Not objRS.EOF Then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1"  class="tablesort">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
 <thead>
  <tr> 
	<th width="1%"  class="sortable-numeric" nowrap>Cod</th>
    <th width="30%" class="sortable">Tarefa</th>
	<th width="40%" class="sortable">Resposta</th>
	<th width="25%" class="sortable">Sigiloso</th>
    <th width="1%" class="sortable" nowrap>De</th>
    <th width="1%" class="sortable" nowrap>Para</th>
	<th width="1%" class="sortable" nowrap>Data</th>
	<th width="1%" class="sortable" nowrap>Hr</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
 %>
 <tr bgcolor="<%=strCOLOR%>"> 
	<td style="text-align:right" nowrap><%=GetValue(objRS,"COD_TODOLIST")%></td>
    <td><%=GetValue(objRS,"TAREFA")%></td>
	<td><%=Replace(GetValue(objRS,"RESPOSTA"), CHR(13),"<br>")%></td>
	<td><%
	strSIGILOSO = GetValue(objRS,"SIGILOSO")
	If strSIGILOSO <> "" Then
		If (GetValue(objRS,"ID_FROM") = Request.Cookies("VBOSS")("ID_USUARIO")) Or (GetValue(objRS,"ID_TO") = Request.Cookies("VBOSS")("ID_USUARIO")) Then
			Response.Write(Replace(strSIGILOSO, CHR(13),"<br>"))
		Else
			Response.Write("*************")
		End If
	End If
	%></td>
    <td style="text-align:left" nowrap><%=GetValue(objRS,"ID_FROM")%></td>
    <td style="text-align:left" nowrap><%=GetValue(objRS,"ID_TO")%></td>
    <td style="text-align:right" nowrap><%=PrepData(GetValue(objRS,"DTT_RESPOSTA"), True, True)%></td>
	<td style="text-align:right" nowrap><%=FormataHoraNumToHHMM(GetValue(objRS,"HORAS"))%></td>
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
 else
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 FechaDBConn objConn
%>