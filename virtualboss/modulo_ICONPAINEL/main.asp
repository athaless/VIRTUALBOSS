<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ICONPAINEL", Request.Cookies("VBOSS")("ID_USUARIO")), true

 Dim objConn, objRS, strSQL, strSQLClause
 Dim strROTULO, strTIPO, strTITULO, strSITUACAO
 Dim strID_USUARIO, strALLOW
 Dim strCOLOR, strArquivo

 AbreDBConn objConn, CFG_DB 

 strROTULO   = GetParam("var_rotulo")
 strTIPO     = GetParam("var_tipo")
 strTITULO   = GetParam("var_titulo")
 strSITUACAO = GetParam("var_situacao")
 strID_USUARIO = LCase(GetParam("var_id_usuario"))

 strALLOW = UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))="MANAGER" or UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))="SU"

 strSQL =          " SELECT SYS_PAINEL.COD_PAINEL, SYS_PAINEL.ROTULO, SYS_PAINEL.DESCRICAO, SYS_PAINEL.ID_USUARIO " 
 strSQL = strSQL & "      , SYS_PAINEL.IMG, SYS_PAINEL.LINK, SYS_PAINEL.TARGET, SYS_PAINEL.ORDEM "
 strSQL = strSQL & " FROM SYS_PAINEL "
 strSQL = strSQL & " WHERE TRUE " 

 strSQLClause = ""
 if strID_USUARIO="" and strALLOW then 
	strSQLClause = " "
 elseif strALLOW then 
	strSQLClause = " AND (ID_USUARIO = '" & strID_USUARIO & "')"
 end if

 if strID_USUARIO<>"" and not strALLOW then strSQLClause = " AND (ID_USUARIO = '" & strID_USUARIO & "' OR ID_USUARIO IS NULL)"

 if strROTULO <> ""         then strSQLClause = strSQLClause & " AND SYS_PAINEL.ROTULO LIKE '" & strROTULO & "%'"
 if strSITUACAO = "INATIVO" then strSQLClause = strSQLClause & " AND SYS_PAINEL.DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"   then strSQLClause = strSQLClause & " AND SYS_PAINEL.DT_INATIVO IS NULL "
 if (strSQLClause <> "") then strSQL = strSQL & strSQLClause 

 strSQL = strSQL & " ORDER BY SYS_PAINEL.ORDEM, SYS_PAINEL.ROTULO "
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 if not objRS.Eof then
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
	<th width="1%"  class="sortable">Usuário</th>
    <th width="22%" class="sortable">Rótulo</th>
	<th width="22%" class="sortable">Descrição</th>
    <th width="15%" class="sortable" nowrap>Imagem</th>
    <th width="38%" class="sortable" nowrap>Link</th>
	<th width="1%"  class="sortable" nowrap>Target</th>
	<th width="1%"  class="sortable" nowrap>Ordem</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
		strCOLOR = swapString (strCOLOR,"#F5FAFA","#FFFFFF")
	%>
	<tr bgcolor=<%=strCOLOR%> valign="middle"> 
		<td align="center"> 
		<%
		 if (UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))<>"MANAGER" and GetValue(objRS,"ID_USUARIO")<>"") or strALLOW then
			response.write (MontaLinkGrade("modulo_ICONPAINEL","Delete.asp",GetValue(objRS,"COD_PAINEL"),"IconAction_DEL.gif","REMOVER"))
		 end if
		%>
		</td>
		<td align="center"> 
		<%
		 if (UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))<>"MANAGER" and getValue(objRS,"ID_USUARIO")<>"") or strALLOW then
			response.write (MontaLinkGrade("modulo_ICONPAINEL","Update.asp",GetValue(objRS,"COD_PAINEL"),"IconAction_EDIT.gif","ALTERAR"))
		 end if
        %>
		</td>	
		<td><a href="InsertCopia.asp?var_chavereg=<%=GetValue(objRS,"COD_PAINEL")%>" style='cursor:pointer; text-decoration:none; border:none; outline:none;'><img src="../img/IconAction_COPY.gif" alt="COPIAR"></a></td>		
		<td nowrap><%=LCase(GetValue(objRS,"ID_USUARIO"))%></td>	
		<td nowrap><%=GetValue(objRS,"ROTULO")%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>
		<td nowrap><%=GetValue(objRS,"IMG")%></td>
		<td><%=GetValue(objRS,"LINK")%></td>
		<td nowrap><%=GetValue(objRS,"TARGET")%></td>
		<td align="right" nowrap><%=GetValue(objRS,"ORDEM")%></td>
	</tr>
  <%
        objRs.MoveNext
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

FechaRecordSet objRS
FechaDBConn objConn
%>