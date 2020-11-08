<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
	VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_MB_DADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<%
 	Dim objConn, objRS, strSQL, strSQLClause
 	Dim strSITUACAO, intCODIGO, strTITULO, strLOCAL, strPRODUTOR
 	Dim strAviso, strCOLOR

 	strAviso 	= "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
	
	strSITUACAO = GetParam("var_situacao")
	intCODIGO   = GetParam("var_codigo")
	strTITULO   = GetParam("var_titulo")
	strPRODUTOR	= GetParam("var_produtor")
	strLOCAL    = GetParam("var_local")
	
 	AbreDBConn objConn, CFG_DB 
 
 	strSQL =          " SELECT COD_DADO, TITULO, PRODUTOR, ANO, TAMANHO, IMG "
	strSQL = strSQL & " FROM mb_dado "
	strSQL = strSQL & " WHERE TRUE " 
 
 	strSQLClause = ""
 	if (strSITUACAO = "INATIVO")  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NOT NULL " 
 	if (strSITUACAO = "ATIVO"  )  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NULL "
  	if (intCODIGO    <> "")       then strSQLClause = strSQLClause & " AND COD_DADO = " & intCODIGO 
	if (strTITULO    <> "")       then strSQLClause = strSQLClause & " AND TITULO LIKE      '%" & strTITULO   & "%'"
	if (strLOCAL     <> "")       then strSQLClause = strSQLClause & " AND LOCALIZACAO LIKE '%" & strLOCAL    & "%'"
	if (strPRODUTOR  <> "")       then strSQLClause = strSQLClause & " AND PRODUTOR    LIKE '%" & strPRODUTOR & "%'"	
	
	if (strSQLClause <> ""     )  then strSql       = strSql       & strSQLClause 
 
 	strSql = strSql & " ORDER BY TITULO, PRODUTOR "
 
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
    		<th width="40%" class="sortable">Título</th>
    		<th width="30%" class="sortable">Produtor</th>
			<th width="10%" class="sortable">Ano</th>
			<th width="10%" class="sortable-numeric">Tamanho</th>
			<th width="01%"></th><!-- IMG -->
  		</tr>
  	</thead>
 	<tbody style="text-align:left;">
		<% 
		While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		%>
		<tr bgcolor="<%=strColor%>">
			<td><%=MontaLinkGrade("modulo_MB_DADO","Delete.asp",GetValue(objRS,"COD_DADO"),"IconAction_DEL.gif","REMOVER")%></td>
			<td><%=MontaLinkGrade("modulo_MB_DADO","Update.asp",GetValue(objRS,"COD_DADO"),"IconAction_EDIT.gif","ALTERAR")%></td>
			<td><%=MontaLinkGrade("modulo_MB_DADO","DetailHistorico.asp",GetValue(objRS,"COD_DADO"),"IconAction_DETAILADD.gif","VISUALIZAR")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"COD_DADO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"TITULO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"PRODUTOR")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"ANO")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"TAMANHO")%></td>
			<td style="text-align:center">
				<% if(GetValue(objRS,"IMG") <> "")then %>						
				<img src="../upload/<%=Response.Write(Request.Cookies("VBOSS")("CLINAME"))%>/MB_DADO/<%=GetValue(objRS,"IMG")%>" style="cursor:pointer;height:14px;border:none;" ondblclick="this.style.height='14px';" onclick="this.style.height='75px';" alt="Clique: AMPLIA - Duplo Clique: REDUZ" title="Clique: AMPLIA - Duplo Clique: REDUZ" />
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
