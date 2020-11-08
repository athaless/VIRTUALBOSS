<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
	VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_MB_REVISTA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<%
 	Dim objConn, objRS, strSQL, strSQLClause
 	Dim strSITUACAO, intCODIGO, strNOME, strCAPA, strEXTRA
 	Dim strAviso, strCOLOR

 	strAviso 	= "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
	
	strSITUACAO = GetParam("var_situacao")
	intCODIGO   = GetParam("var_codigo")
	strNOME     = GetParam("var_nome")
	strCAPA     = GetParam("var_capa")
	strEXTRA	= GetParam("var_extra")
	
 	AbreDBConn objConn, CFG_DB 
 
 	strSQL =          " SELECT COD_REVISTA, NOME, CAPA, EDITORA, EDICAO, ANO, ASSUNTO, ISSN, IMG "
	strSQL = strSQL & " FROM mb_revista "
	strSQL = strSQL & " WHERE TRUE " 
 
 	strSQLClause = ""
 	if (strSITUACAO = "INATIVO")  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NOT NULL " 
 	if (strSITUACAO = "ATIVO"  )  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NULL " 
  	if (intCODIGO   <> ""	   )  then strSQLClause = strSQLClause & " AND COD_REVISTA = " & intCODIGO 
	if (strNOME     <> ""	   )  then strSQLClause = strSQLClause & " AND NOME LIKE  '%" & strNOME  & "%'" 
	if (strCAPA     <> ""	   )  then strSQLClause = strSQLClause & " AND CAPA LIKE  '%" & strCAPA  & "%'" 
	if (strEXTRA    <> ""	   )  then strSQLClause = strSQLClause & " AND EXTRA LIKE '%" & strEXTRA & "%'" 
	
	if (strSQLClause <> ""     )  then strSql       = strSql       & strSQLClause 
 
 	strSql = strSql & " ORDER BY NOME, EDITORA "
 
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
    		<th width="20%" class="sortable">Nome</th>
    		<th width="20%" class="sortable">Capa</th>
			<th width="15%" class="sortable">Editora</th>
			<th width="05%" class="sortable-numeric">Edição</th>
			<th width="05%" class="sortable-numeric">Ano</th>
			<th width="15%" class="sortable">Assunto</th>
			<th width="12%" class="sortable-numeric">ISSN</th>
			<th width="01%"></th><!-- IMG -->
  		</tr>
  	</thead>
 	<tbody style="text-align:left;">
		<% 
		While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		%>
		<tr bgcolor="<%=strColor%>">
			<td><%=MontaLinkGrade("modulo_MB_REVISTA","Delete.asp",GetValue(objRS,"COD_REVISTA"),"IconAction_DEL.gif","REMOVER")%></td>
			<td><%=MontaLinkGrade("modulo_MB_REVISTA","Update.asp",GetValue(objRS,"COD_REVISTA"),"IconAction_EDIT.gif","ALTERAR")%></td>
			<td><%=MontaLinkGrade("modulo_MB_REVISTA","Detail.asp",GetValue(objRS,"COD_REVISTA"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"COD_REVISTA")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"NOME")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"CAPA")%></td>
			<td	style="text-align:left"><%=GetValue(objRS,"EDITORA")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"EDICAO")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"ANO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"ASSUNTO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"ISSN")%></td>
			<td style="text-align:center">
				<% if(GetValue(objRS,"IMG") <> "")then %>						
				<img src="../upload/<%=Response.Write(Request.Cookies("VBOSS")("CLINAME"))%>/MB_REVISTA/<%=GetValue(objRS,"IMG")%>" style="cursor:pointer;height:14px;border:none;" ondblclick="this.style.height='14px';" onclick="this.style.height='75px';" alt="Clique: AMPLIA - Duplo Clique: REDUZ" title="Clique: AMPLIA - Duplo Clique: REDUZ" />
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
