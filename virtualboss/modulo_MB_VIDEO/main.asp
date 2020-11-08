<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
	VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_MB_VIDEO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<%
 	Dim objConn, objRS, strSQL, strSQLClause
 	Dim strSITUACAO, intCODIGO, strTITULOORIG, strLOCAL, strATORESPRINC
 	Dim strAviso, strCOLOR

 	strAviso 	    = "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
	
	strSITUACAO     = GetParam("var_situacao")
	intCODIGO       = GetParam("var_codigo")
	strTITULOORIG   = GetParam("var_titulo_orig")
	strATORESPRINC  = GetParam("var_atores_princ")
	strLOCAL	    = GetParam("var_local")
	
 	AbreDBConn objConn, CFG_DB 
 
 	strSQL =          " SELECT COD_VIDEO, TITULO_ORIG, ATORES, ANO, TEMPO, IMG, TEMATICA "
	strSQL = strSQL & " FROM mb_video "
	strSQL = strSQL & " WHERE TRUE " 
 
 	strSQLClause = ""
 	if (strSITUACAO = "INATIVO")  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NOT NULL " 
 	if (strSITUACAO = "ATIVO"  )  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NULL "
  	if (intCODIGO      <> "")     then strSQLClause = strSQLClause & " AND COD_VIDEO = " & intCODIGO 
	if (strTITULOORIG  <> "")     then strSQLClause = strSQLClause & " AND TITULO_ORIG LIKE  '%" & strTITULOORIG & "%'"
	if (strATORESPRINC <> "")     then strSQLClause = strSQLClause & " AND ATORES      LIKE  '%" & strATORESPRINC  & "%'"
	if (strLOCAL       <> "")     then strSQLClause = strSQLClause & " AND LOCAL       LIKE  '%" & strLOCAL  & "%'"	
	
	if (strSQLClause <> ""     )  then strSql       = strSql       & strSQLClause 
 
 	strSql = strSql & " ORDER BY TITULO_ORIG, ATORES "
 
 	'athDebug strSQL, false
 	Set objRs = objConn.Execute(strSql) 
 	If Not objRS.EOF Then
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
</head>
<body>
<table align="center" cellpadding="0" cellspacing="1" class="tablesort">
	<!-- 
		Possibilidades de tipo de sort...
		class="sortable-date-dmy"
		class="sortable-currency"
		class="sortable-numeric"
		class="sortable"
	-->
	<thead>
  		<tr> 
    		<th width="01%"></td><!-- DEL -->
    		<th width="01%"></td><!-- UPD -->
    		<th width="01%"></td><!-- VIE -->
    		<th width="04%" class="sortable-numeric">Cod</th>
    		<th width="35%" class="sortable">Título</th>
    		<th width="25%" class="sortable">Atores</th>
			<th width="10%" class="sortable-numeric">Tempo</th>
			<th width="10%" class="sortable-numeric">Ano</th>
			<th width="12%" class="sortable">Temática</th>
			<th width="01%"></th><!-- IMG -->
  		</tr>
  	</thead>
 	<tbody style="text-align:left;">
		<% 
		While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		%>
		<tr bgcolor="<%=strColor%>">
			<td><%=MontaLinkGrade("modulo_MB_VIDEO","Delete.asp",GetValue(objRS,"COD_VIDEO"),"IconAction_DEL.gif","REMOVER")%></td>
			<td><%=MontaLinkGrade("modulo_MB_VIDEO","Update.asp",GetValue(objRS,"COD_VIDEO"),"IconAction_EDIT.gif","ALTERAR")%></td>
			<td><%=MontaLinkGrade("modulo_MB_VIDEO","Detail.asp",GetValue(objRS,"COD_VIDEO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"COD_VIDEO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"TITULO_ORIG")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"ATORES")%></td>
			<td	style="text-align:center"><%=GetValue(objRS,"TEMPO")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"ANO")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"TEMATICA")%></td>
			<td style="text-align:center">
				<% if(GetValue(objRS,"IMG") <> "")then %>						
				<img src="../upload/<%=Response.Write(Request.Cookies("VBOSS")("CLINAME"))%>/MB_VIDEO/<%=GetValue(objRS,"IMG")%>" style="cursor:pointer;height:14px;border:none;" ondblclick="this.style.height='14px';" onclick="this.style.height='75px';" alt="Clique: AMPLIA - Duplo Clique: REDUZ" title="Clique: AMPLIA - Duplo Clique: REDUZ" />
				<% end if %>
			</td>
		</tr>
		<%
		athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		WEnd
		%>
 	</tbody>
</table>
</body>
</html>
<%
 	else Mensagem strAviso, "", "", true
 	end if
	FechaRecordSet objRS
 	FechaDBConn objConn
%>
