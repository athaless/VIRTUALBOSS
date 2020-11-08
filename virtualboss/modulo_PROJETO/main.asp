<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PROJETO", Request.Cookies("VBOSS")("ID_USUARIO")), true 
 
 Dim objConn, objRS, strSQL, strSQLClause
 Dim strCODPROJETO, strTITULO, strDESCRICAO, strROI, strSTATUS
 Dim intCountParam, strCOLOR

 Function AddParamSQL(prParam)
  Dim aux
   if intCountParam <= 0 then 
     aux = " WHERE " & prParam
   else
     aux = " AND " & prParam
   end if
   intCountParam = intCountParam + 1
   AddParamSQL = aux
 End Function
 
 intCountParam = CInt(0)
 
 AbreDBConn objConn, CFG_DB 

 strCODPROJETO = GetParam("var_cod_projeto")
 strTITULO     = GetParam("var_titulo")
 strDESCRICAO  = GetParam("var_descricao")
 strSTATUS     = GetParam("var_status")

 strSQL =          "SELECT "
 strSQL = strSQL & "   COD_PROJETO "
 strSQL = strSQL & "  ,ID_RESPONSAVEL "
 strSQL = strSQL & "  ,TITULO ,DESCRICAO "
 strSQL = strSQL & "  ,FASE_ATUAL "
 strSQL = strSQL & "  ,DT_INICIO ,DT_DEADLINE "
 strSQL = strSQL & "FROM prj_projeto "

 strSQLClause = ""
 if strCODPROJETO <> "" then strSQLClause = strSQLClause & AddParamSQL("COD_PROJETO = "		& strCODPROJETO)
 if strTITULO     <> "" then strSQLClause = strSQLClause & AddParamSQL("TITULO LIKE '"		& strTITULO & "%'")
 if strDESCRICAO  <> "" then strSQLClause = strSQLClause & AddParamSQL("DESCRICAO LIKE '"	& strDESCRICAO & "%'")
 if strSTATUS     <> "" then strSQLClause = strSQLClause & AddParamSQL("FASE_ATUAL = '"		& strSTATUS & "'")
 
 if (strSQLClause <> "") then strSQL = strSQL & strSQLClause
 
 strSQL = strSQL & " ORDER BY TITULO "
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 
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
    <th width="10%" class="sortable" nowrap>Cód.</th>
    <th width="34%" class="sortable" nowrap>Titulo</th>
	<th width="50%" class="sortable">Descrição</th>
	<th width="1%"  class="sortable" nowrap>Fase</th>
    <th width="1%"  class="sortable" nowrap>Resp.</th>
    <th width="1%"  class="sortable" nowrap>DEADLINE</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
 	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")	
%>
      <tr bgcolor=<%=strCOLOR%>> 
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO","Delete.asp",GetValue(objRS,"COD_PROJETO"),"IconAction_DEL.gif","REMOVER")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO","Update.asp",GetValue(objRS,"COD_PROJETO"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO","DetailHistorico.asp",GetValue(objRS,"COD_PROJETO"),"IconAction_DETAILadd.gif","VISUALIZAR")%></td>
        <td nowrap><%=getValue(objRS,"COD_PROJETO")%></td>
        <td><%=getValue(objRS,"TITULO")%></td>
        <td><%=getValue(objRS,"DESCRICAO")%></td>
        <td nowrap><%=getValue(objRS,"FASE_ATUAL")%></td>
        <td nowrap><%=getValue(objRS,"ID_RESPONSAVEL")%></td>				
        <td nowrap><%=getValue(objRS,"DT_DEADLINE")%></td>
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