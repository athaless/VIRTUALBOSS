<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
	VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_MB_MANUAL", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<%
 	Dim objConn, objRS, strSQL, strSQLClause
 	Dim strSITUACAO, intCODIGO, strTITULO, strAUTOR, strEXTRA
 	Dim strAviso, strCOLOR

 	strAviso 	= "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
	
	strSITUACAO = GetParam("var_situacao")
	intCODIGO   = GetParam("var_codigo")
	strTITULO   = GetParam("var_titulo")
	strAUTOR    = GetParam("var_autores")
	strEXTRA	= GetParam("var_extra")
	
 	AbreDBConn objConn, CFG_DB 
 
 	strSQL =          " SELECT COD_MANUAL, TITULO, AUTORES, EDITORA, EDICAO, ANO, ASSUNTO, ISBN, IMG "
	strSQL = strSQL & " FROM mb_manual "
	strSQL = strSQL & " WHERE TRUE " 
 
 	strSQLClause = ""
 	if (strSITUACAO = "INATIVO")  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NOT NULL " 
 	if (strSITUACAO = "ATIVO"  )  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NULL " 
  	if (intCODIGO   <> ""	   )  then strSQLClause = strSQLClause & " AND COD_MANUAL =   " & intCODIGO 
	if (strTITULO   <> ""	   )  then strSQLClause = strSQLClause & " AND TITULO LIKE  '%" & strTITULO & "%'" 
	if (strAUTOR    <> ""	   )  then strSQLClause = strSQLClause & " AND AUTORES LIKE '%" & strAUTOR  & "%'" 
	if (strEXTRA    <> ""	   )  then strSQLClause = strSQLClause & " AND EXTRA LIKE   '%" & strEXTRA  & "%'" 
	
	if (strSQLClause <> ""     )  then strSql       = strSql       & strSQLClause 
 
 	strSql = strSql & " ORDER BY TITULO, EDITORA "
 
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
    		<th width="20%" class="sortable">Titulo</th>
    		<th width="22%" class="sortable">Autores</th>
			<th width="15%" class="sortable">Editora</th>
			<th width="05%" class="sortable-numeric">Ano</th>
			<th width="15%" class="sortable">Assunto</th>
			<th width="15%" class="sortable-numeric">ISBN</th>
			<th width="01%"></th><!-- IMG -->
  		</tr>
  	</thead>
 	<tbody style="text-align:left;">
		<% 
		While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		%>
		<tr bgcolor="<%=strColor%>">
			<td><%=MontaLinkGrade("modulo_MB_MANUAL","Delete.asp",GetValue(objRS,"COD_MANUAL"),"IconAction_DEL.gif","REMOVER")%></td>
			<td><%=MontaLinkGrade("modulo_MB_MANUAL","Update.asp",GetValue(objRS,"COD_MANUAL"),"IconAction_EDIT.gif","ALTERAR")%></td>
			<td><%=MontaLinkGrade("modulo_MB_MANUAL","Detail.asp",GetValue(objRS,"COD_MANUAL"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"COD_MANUAL")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"TITULO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"AUTORES")%></td>
			<td	style="text-align:left"><%=GetValue(objRS,"EDITORA")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"ANO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"ASSUNTO")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"ISBN")%></td>
			<td style="text-align:center">
				<% if(GetValue(objRS,"IMG") <> "")then %>						
				<img src="../upload/<%=Response.Write(Request.Cookies("VBOSS")("CLINAME"))%>/MB_MANUAL/<%=GetValue(objRS,"IMG")%>" style="cursor:pointer;height:14px;border:none;" ondblclick="this.style.height='14px';" onclick="this.style.height='75px';" alt="Clique: AMPLIA - Duplo Clique: REDUZ" title="Clique: AMPLIA - Duplo Clique: REDUZ" />
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
