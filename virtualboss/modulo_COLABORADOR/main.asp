<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), true

 Dim objConn, objRS, strSQL, strSQLClause, auxStr
 Dim strTEXTO, strCOD_CATEGORIA, strSITUACAO, strAno, strINICIAL, strNOME, strNUMDOC
 Dim strUSER_ID, strCOLOR, auxCONTADOR

 AbreDBConn objConn, CFG_DB 

 strNOME      = GetParam("var_nome")
 strNUMDOC    = GetParam("var_num_doc")
 strSITUACAO  = GetParam("var_situacao")
 strAno       = GetParam("selAno")
 strINICIAL   = GetParam("var_inicial")
 auxCONTADOR  = 0

 strSql =          " SELECT ENT_COLABORADOR.COD_COLABORADOR, ENT_COLABORADOR.NOME, ENT_COLABORADOR.FONE_1, ENT_COLABORADOR.CELULAR "
 strSql = strSql & "       ,ENT_COLABORADOR.DT_INATIVO, ENT_COLABORADOR.RG, ENT_COLABORADOR.CPF, ENT_COLABORADOR.EMAIL, ENT_COLABORADOR.FOTO, ENT_COLABORADOR.DT_NASC "
 strSql = strSql & " FROM ENT_COLABORADOR "
 strSql = strSql & " WHERE TRUE "

 strSQLClause = ""
 if strNOME <> ""            then strSQLClause = strSQLClause & " AND ENT_COLABORADOR.NOME LIKE '%" & strNOME & "%'"
 if strNUMDOC <> ""          then strSQLClause = strSQLClause & " AND (ENT_COLABORADOR.RG LIKE '%" & strNUMDOC & "%' or " & "ENT_COLABORADOR.CPF LIKE '%" & strNUMDOC & "%') "
 if strSITUACAO = "INATIVO"  then strSQLClause = strSQLClause & " AND ENT_COLABORADOR.DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"    then strSQLClause = strSQLClause & " AND ENT_COLABORADOR.DT_INATIVO IS NULL "
 
 if strINICIAL <> "" then
  if strINICIAL <> "0-9" then
  	strSQLClause = strSQLClause & " AND ENT_COLABORADOR.NOME LIKE '" & strINICIAL & "%'"
  else 
  	strSQLClause = strSQLClause & " AND ENT_COLABORADOR.NOME LIKE '0%' "
    strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '1%' "
	strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '2%' "
	strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '3%' "
	strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '4%' "
	strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '5%' "
	strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '6%' "
	strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '7%' "
	strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '8%' "
	strSQLClause = strSQLClause & " OR ENT_COLABORADOR.NOME LIKE '9%' "
  end if
 end if
 
 if (strSQLClause <> "") then strSql = strSql & strSQLClause 

 strSql = strSql & " ORDER BY ENT_COLABORADOR.NOME, ENT_COLABORADOR.DT_CADASTRO DESC, ENT_COLABORADOR.COD_COLABORADOR "
 
 Set objRS = objConn.Execute(strSql) 
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
	<th width="1%"  class="sortable-numeric" nowrap>Cod</th>
    <th width="89%" class="sortable">Nome</th>
	<th width="1%"  class="sortable">Email</th>
    <th width="1%"  class="sortable">Fone</th>
	<th width="1%"  class="sortable">Celular</th>
	<th width="1%"  class="sortable">RG</th>
	<th width="1%"  class="sortable">CPF</th>
	<th width="1%"></th>
	<th width="1%"></th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRS.Eof
	  	strCOLOR = swapString (strCOLOR, "#FFFFFF", "#F5FAFA")
	%>
  <tr bgcolor=<%=strCOLOR%>> 
	<td width="1%"><%=MontaLinkGrade("modulo_COLABORADOR","Delete.asp",GetValue(objRS,"COD_COLABORADOR"),"IconAction_DEL.gif","REMOVER")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_COLABORADOR","Update.asp",GetValue(objRS,"COD_COLABORADOR"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td width="1%"><%=MontaLinkGrade("modulo_COLABORADOR","DetailHistorico.asp",GetValue(objRS,"COD_COLABORADOR"),"IconAction_DETAILadd.gif","VISUALIZAR")%></td>
	<td style="text-align:right" nowrap><%=getValue(objRS,"COD_COLABORADOR")%></td>
	<td><%=GetValue(objRS,"NOME")%></td>
    <td nowrap><%=GetValue(objRS,"EMAIL")%></td>
    <td nowrap><%=GetValue(objRS,"FONE_1")%></td>
    <td nowrap><%=GetValue(objRS,"CELULAR")%></td>
    <td nowrap><%=GetValue(objRS,"RG")%></td>
    <td nowrap><%=GetValue(objRS,"CPF")%></td>
    <td nowrap>
    <% If GetValue(objRS,"FOTO") <> "" Then %>
  	  <!-- div style='height:16px; position:relative; overflow:visible' -->
	  <img style='height:14px; cursor:pointer;'  src='../upload/<%=Request.Cookies("VBOSS")("CLINAME")%>/<%=GetValue(objRS,"FOTO")%>' onDblClick="this.style.height='14px';" onClick="this.style.height='90px';">
	  <!-- /div -->
    <% End If %>
	</td>
    <td nowrap>
    <% 
		auxStr = GetValue(objRS,"DT_NASC")
	   	If auxStr <> "" Then
			auxCONTADOR = auxCONTADOR + 1
	%>
		<img src="../img/signo_<%=GetSigno(auxStr,false)%>.jpg" style="cursor:pointer;height:14px;border:none;" onClick="document.getElementById('<%=auxStr%>_ID_<%=auxCONTADOR%>').style.display = 'block';" alt="CLIQUE PARA AMPLIAR | <%=GetSigno(auxStr,true)%>" title="CLIQUE PARA AMPLIAR | <%=GetSigno(auxStr,true)%>" />
		<div id="<%=auxStr%>_ID_<%=auxCONTADOR%>" style="width:auto;height:auto;right:2%;background-color:#FFFFFF;display:none;position:absolute;padding:4px 10px 10px 10px;border:1px solid black;">
			<div style="height:18px;"><span style="float:right;position:relative;clear:both;margin-bottom:4px;width:auto;"><img src="../img/icon_close_window_modal.gif" style="cursor:pointer;" onClick="document.getElementById('<%=auxStr%>_ID_<%=auxCONTADOR%>').style.display = 'none';" /></span></div>
			<div><img src="../img/signo_<%=GetSigno(auxStr,false)%>.jpg" style="border:none;" width="120" alt="<%=GetSigno(auxStr,true)%>" title="<%=GetSigno(auxStr,true)%>" /></div>
		</div>
		<!--img style='height:14px; cursor:pointer;' src='../img/signo_<%=GetSigno(auxStr,false)%>.jpg' ondblclick="this.style.height='14px';" onclick="this.style.height='75px';" alt="<%=GetSigno(auxStr,true)%>" title="<%=GetSigno(auxStr,true)%>"-->
    <% End If %>
	</td>
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
   FechaRecordSet objRS
 else
   Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 FechaDBConn objConn
%>