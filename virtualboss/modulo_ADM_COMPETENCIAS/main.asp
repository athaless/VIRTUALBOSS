<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ADM_COMPETENCIAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<%
 Dim objConn, objRS, strSQL
 Dim strSITUACAO, strSIGLA, strCOMPETENCIA
 Dim strAviso, strCOLOR

 strAviso 	= "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."

 AbreDBConn objConn, CFG_DB 
 
 strSIGLA       = GetParam("var_sigla")
 strCOMPETENCIA = GetParam("var_competencia")
 strSITUACAO    = GetParam("var_situacao")

 strSQL =          " SELECT COD_COMPETENCIA "
 strSQL = strSQL & " , SIGLA"
 strSQL = strSQL & " , COMPETENCIA"
 strSQL = strSQL & " , CONCEITO"
 strSQL = strSQL & " , PESO"
 strSQL = strSQL & " FROM ADM_COMPETENCIA "
 strSQL = strSQL & " WHERE TRUE " 
 
 if strSIGLA <> ""           then strSQL = strSQL & " AND SIGLA LIKE '" & strSIGLA & "%' "
 if strCOMPETENCIA <> ""     then strSQL = strSQL & " AND COMPETENCIA LIKE '" & strCOMPETENCIA & "%' "
 if strSITUACAO = "INATIVO"  then strSQL = strSQL & " AND DT_INATIVO IS NOT NULL "
 if strSITUACAO = "ATIVO"    then strSQL = strSQL & " AND DT_INATIVO IS NULL "
 
 strSQL = strSQL & " ORDER BY SIGLA "
 
 'athDebug strSQL, false
 Set objRs = objConn.Execute(strSql) 
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
    <th width="01%"></td>
    <th width="01%"></td>
	<th width="01%"></td>
    <th width="5%" class="sortable">Sigla</th>
    <th width="25%" class="sortable">Competência</th>
	<th width="62%" class="sortable">Conceito</th>
    <th width="5%" class="sortable">Peso</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<% 
      While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
	%>
	<tr bgcolor="<%=strColor%>">
		<td><%=MontaLinkGrade("modulo_ADM_COMPETENCIAS","Delete.asp",GetValue(objRS,"COD_COMPETENCIA"),"IconAction_DEL.gif","REMOVER")%></td>
		<td><%=MontaLinkGrade("modulo_ADM_COMPETENCIAS","Update.asp",GetValue(objRS,"COD_COMPETENCIA"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td><%=MontaLinkGrade("modulo_ADM_COMPETENCIAS","Detail.asp",GetValue(objRS,"COD_COMPETENCIA"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
		<td><%=GetValue(objRS,"SIGLA")%></td>
		<td><%=GetValue(objRS,"COMPETENCIA")%></td>
		<td><%=GetValue(objRS,"CONCEITO")%></td>
		<td style="text-align:right" class="sortable-numeric"><%=GetValue(objRS,"PESO")%></td>
	</tr>
	<%
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
      wend
	%>
 </tbody>
</table>
</body>
</html>
<%
 else
	Mensagem strAviso, "", "", true
 end if
 FechaRecordSet objRS
 FechaDBConn objConn
%>