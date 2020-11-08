<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
	VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_MB_LIVRO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<%
 	Dim objConn, objRS, strSQL, strSQLClause
 	Dim strSITUACAO, intCODIGO, strTITULO, strLOCAL, strEXTRA
 	Dim strAviso, strCOLOR

 	strAviso 	= "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."
	
	strSITUACAO = GetParam("var_situacao")
	intCODIGO   = GetParam("var_codigo")
	strTITULO   = GetParam("var_titulo")
	strLOCAL    = GetParam("var_local")
	strEXTRA	= GetParam("var_extra")
	
 	AbreDBConn objConn, CFG_DB 
 
 	strSQL =          " SELECT COD_LIVRO, TITULO, AUTORES, EDITORA, ANO, ASSUNTO, ISBN, IMG, LOCADO "
	strSQL = strSQL & " FROM mb_livro "
	strSQL = strSQL & " WHERE TRUE " 
 
 	strSQLClause = ""
 	if (strSITUACAO = "INATIVO")  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NOT NULL " 
 	if (strSITUACAO = "ATIVO"  )  then strSQLClause = strSQLClause & " AND DT_INATIVO IS NULL "
  	if (intCODIGO    <> "")       then strSQLClause = strSQLClause & " AND COD_LIVRO = " & intCODIGO 
	if (strTITULO    <> "")       then strSQLClause = strSQLClause & " AND TITULO LIKE      '%" & strTITULO & "%'"
	if (strLOCAL     <> "")       then strSQLClause = strSQLClause & " AND LOCALIZACAO LIKE '%" & strLOCAL  & "%'"
	if (strEXTRA     <> "")       then strSQLClause = strSQLClause & " AND TITULO LIKE      '%" & strEXTRA  & "%'"	
	
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
    		<th width="25%" class="sortable">Título</th>
    		<th width="20%" class="sortable">Autores</th>
			<th width="15%" class="sortable">Editora</th>
			<th width="14%" class="sortable">Assunto</th>
			<th width="12%" class="sortable-numeric">ISBN</th>
			<th width="05%" class="sortable-numeric">Ano</th>
			<th width="01%"></th><!-- IMG -->
			<th width="01%"></th><!-- BULLET LOCADO -->
  		</tr>
  	</thead>
 	<tbody style="text-align:left;">
		<% 
		While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		%>
		<tr bgcolor="<%=strColor%>">
			<td><%=MontaLinkGrade("modulo_MB_LIVRO","Delete.asp",GetValue(objRS,"COD_LIVRO"),"IconAction_DEL.gif","REMOVER")%></td>
			<td><%=MontaLinkGrade("modulo_MB_LIVRO","Update.asp",GetValue(objRS,"COD_LIVRO"),"IconAction_EDIT.gif","ALTERAR")%></td>
			<td><%=MontaLinkGrade("modulo_MB_LIVRO","Detail.asp",GetValue(objRS,"COD_LIVRO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"COD_LIVRO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"TITULO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"AUTORES")%></td>
			<td	style="text-align:left"><%=GetValue(objRS,"EDITORA")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"ASSUNTO")%></td>
			<td style="text-align:left"><%=GetValue(objRS,"ISBN")%></td>
			<td style="text-align:center"><%=GetValue(objRS,"ANO")%></td>
			<td style="text-align:center">
				<% if(GetValue(objRS,"IMG") <> "")then %>						
				<img src="../upload/<%=Response.Write(Request.Cookies("VBOSS")("CLINAME"))%>/MB_LIVRO/<%=GetValue(objRS,"IMG")%>" style="cursor:pointer;height:14px;border:none;" ondblclick="this.style.height='14px';" onclick="this.style.height='75px';" alt="Clique: AMPLIA - Duplo Clique: REDUZ" title="Clique: AMPLIA - Duplo Clique: REDUZ"/>
				<!--img src="../upload/<%=Response.Write(Request.Cookies("VBOSS")("CLINAME"))%>/MB_LIVRO/<%=GetValue(objRS,"IMG")%>" style="cursor:pointer;height:14px;border:none;" onclick="document.getElementById('<%=GetValue(objRS,"IMG")%>_ID').style.display = 'block';" alt="Clique: AMPLIA - Duplo Clique: REDUZ" title="Clique: AMPLIA - Duplo Clique: REDUZ" />
				<div id="<%=(GetValue(objRS,"IMG") & "_ID")%>" style="width:auto;height:auto;right:2%;background-color:#FFFFFF;display:none;position:absolute;padding:4px 10px 10px 10px;border:1px solid black;">
					<div style="height:18px;"><span style="float:right;position:relative;clear:both;margin-bottom:4px;width:auto;"><img src="../img/icon_close_window_modal.gif" style="cursor:pointer;" onclick="document.getElementById('<%=GetValue(objRS,"IMG")%>_ID').style.display = 'none';" /></span></div>
					<div><img src="../upload/<%=Response.Write(Request.Cookies("VBOSS")("CLINAME"))%>/MB_LIVRO/<%=GetValue(objRS,"IMG")%>" style="border:none;" width="180" alt="Clique: AMPLIA - Duplo Clique: REDUZ" title="Clique: AMPLIA - Duplo Clique: REDUZ" /></div>
				</div-->
				<% end if %>
			</td>
			<td style="text-align:center">
				<% if(GetValue(objRS,"LOCADO") <> "")then %>						
				<img src="../img/IconStatus_LOCADO.png" title="ESTE ITEM ESTÁ LOCADO" alt="ESTE ITEM ESTÁ LOCADO" width="14" />
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
