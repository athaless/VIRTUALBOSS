<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PROJETO_BACKLOG", Request.Cookies("VBOSS")("ID_USUARIO")), true 
 
 Dim objConn, objRS, strSQL, strSQLClause
 Dim strCODPROJETO, strTITULO, strDESCRICAO, strROI, strSTATUS
 Dim strCOLOR

 
 AbreDBConn objConn, CFG_DB 

 strCODPROJETO = GetParam("var_cod_projeto")
 strTITULO     = GetParam("var_titulo")
 strDESCRICAO  = GetParam("var_descricao")
 strROI        = GetParam("var_roi")
 strSTATUS     = GetParam("var_status")

 strSQL = "SELECT t1.COD_PRJ_BACKLOG "
 strSQL = strSQL & "     , t2.TITULO as PROJETO "
 strSQL = strSQL & "     , t1.TITULO "
 strSQL = strSQL & "     , t1.DESCRICAO "
 strSQL = strSQL & "     , t1.TAMANHO "
 strSQL = strSQL & "     , t1.ROI "
 strSQL = strSQL & "     , t1.STATUS "
 strSQL = strSQL & "  FROM prj_backlog t1, prj_projeto t2 "
 strSQL = strSQL & " WHERE t1.COD_PROJETO = t2.COD_PROJETO "

 strSQLClause = ""
 if (strCODPROJETO <> "") and (strCODPROJETO <> Empty) 	then strSQLClause = strSQLClause & " AND t1.COD_PROJETO = " & strCODPROJETO
 if (strTITULO     <> "") and (strTITULO <> Empty)	 	then strSQLClause = strSQLClause & " AND t1.TITULO LIKE '" & strTITULO & "%'"
 if (strDESCRICAO  <> "") and (strDESCRICAO <> Empty)	then strSQLClause = strSQLClause & " AND t1.DESCRICAO LIKE '" & strDESCRICAO & "%'"
 if (strROI        <> "") and (strROI <> Empty)			then strSQLClause = strSQLClause & " AND t1.ROI = " & strROI
 if (strSTATUS     <> "") and (strSTATUS <> Empty)		then strSQLClause = strSQLClause & " AND t1.STATUS = '" & strSTATUS & "'"
 
 if (strSQLClause <> "") then strSQL = strSQL & strSQLClause
 
 strSQL = strSQL & " ORDER BY TITULO "
 
 'athDebug strSQL, true
 
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
    <th width="10%" class="sortable" nowrap>Projeto</th>	
    <th width="24%" class="sortable" nowrap>Titulo</th>
	<th width="50%" class="sortable">Descrição</th>
	<th width="1%"  class="sortable" nowrap>Tamanho</th>
    <th width="1%"  class="sortable" nowrap>ROI</th>
    <th width="1%"  class="sortable" nowrap>Status</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
 	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")	
%>
      <tr bgcolor=<%=strCOLOR%>> 
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO_BACKLOG","Delete.asp",GetValue(objRS,"COD_PRJ_BACKLOG"),"IconAction_DEL.gif","REMOVER")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO_BACKLOG","Update.asp",GetValue(objRS,"COD_PRJ_BACKLOG"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO_BACKLOG","Detail.asp",GetValue(objRS,"COD_PRJ_BACKLOG"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
        <td><%=getValue(objRS,"COD_PRJ_BACKLOG")%></td>
        <td><%=getValue(objRS,"PROJETO")%></td>		
        <td><%=getValue(objRS,"TITULO")%></td>
        <td><%=getValue(objRS,"DESCRICAO")%></td>
        <td><%=getValue(objRS,"TAMANHO")%></td>
        <td><%=getValue(objRS,"ROI")%></td>
        <td><%=getValue(objRS,"STATUS")%></td>				
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