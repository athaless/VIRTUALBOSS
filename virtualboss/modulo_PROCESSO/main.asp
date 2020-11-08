<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
 Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PROCESSO", Request.Cookies("VBOSS")("ID_USUARIO")), true 

 Dim objConn, objRS, strSQL, strSQLClause
 Dim strTEXTO, strCOD_CATEGORIA, strSITUACAO, strAUTOR
 Dim strUSER_ID, strCOLOR, strArquivo
 Dim strIMG_HOMOLOGACAO, strALT_HOMOLOGACAO
 Dim strCFG_TD_HEADER, strCFG_TD_DADOS
 strCFG_TD_HEADER = "class='arial11Bold' nowrap"
 strCFG_TD_DADOS = "align='left' valign='middle' class='arial11' nowrap"

 AbreDBConn objConn, CFG_DB 

 strTEXTO         = GetParam("var_texto")
 strCOD_CATEGORIA = GetParam("var_categoria")
 strSITUACAO      = GetParam("var_situacao")
 strAUTOR         = GetParam("var_autor")

 strSql =          " SELECT T1.COD_PROCESSO, T1.ID_PROCESSO, T1.NOME, T1.AUTORES, T1.DATA, T1.DT_HOMOLOGACAO, T1.SYS_INS_ID_USUARIO, T1.SYS_DT_ALTERACAO, T2.NOME AS CATEGORIA"
 strSql = strSql & " FROM PROCESSO T1, PROCESSO_CATEGORIA T2 "
 strSql = strSql & " WHERE T1.COD_CATEGORIA = T2.COD_CATEGORIA " 

 'Antigamente só via os processos que ele mesmo inseriu.
 'foi comentada essa parte  06.10.2014 --------- by Aless
 'If (Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "MANAGER") And (Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "ADMIN") Then
 ' strSql = strSql & " AND ((T1.SYS_INS_ID_USUARIO LIKE '" & Request.Cookies("VBOSS")("ID_USUARIO") & "') OR "
 ' strSql = strSql & "      (T1.SYS_INS_ID_USUARIO NOT LIKE '" & Request.Cookies("VBOSS")("ID_USUARIO") & "' AND T1.DT_HOMOLOGACAO IS NOT NULL)) " 
 'End If 

 strSQLClause = ""
 if (strTEXTO <> "")         then strSQLClause = strSQLClause & " AND (T1.NOME LIKE '%" & strTEXTO & "%' OR T1.DESCRICAO LIKE '%" & strTEXTO & "%') " 
 if (strAUTOR <> "")         then strSQLClause = strSQLClause & " AND T1.SYS_INS_ID_USUARIO = '" & strAUTOR & "'" 
 if (strCOD_CATEGORIA <> "") then strSQLClause = strSQLClause & " AND T1.COD_CATEGORIA = " & strCOD_CATEGORIA 

 if strSITUACAO = "HOMOLOGADO"     then strSQLClause = strSQLClause & " AND T1.DT_HOMOLOGACAO IS NOT NULL " 
 if strSITUACAO = "NAO_HOMOLOGADO" then strSQLClause = strSQLClause & " AND T1.DT_HOMOLOGACAO IS NULL " 

 if (strSQLClause <> "") then strSql = strSql & strSQLClause  

 strSQL = strSql & " ORDER BY T2.NOME, T1.ID_PROCESSO, T1.NOME "
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

 'athDebug strSQL, false
 
 if not objRS.eof then
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
    <!--th width="1%"></th-->
	<th width="15%" class="sortable">Categoria</th>
    <th width="15%" class="sortable" nowrap="nowrap">ID</th>
	<th width="30%" class="sortable">Nome</th>
    <th width="30%" class="sortable">Autores</th>
    <th width="6%" class="sortable">Últ Alteração</th>
    <th width="1%"></th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
  	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")

		If IsDate(GetValue(objRS, "DT_HOMOLOGACAO")) Then
			strIMG_HOMOLOGACAO = "ProcHomologado.gif"
			strALT_HOMOLOGACAO = "Homologado" 
		Else 
			strIMG_HOMOLOGACAO = "ProcNaoHomologado.gif"
			strALT_HOMOLOGACAO = "Não Homologado" 
		End If 
  %>
	<tr bgcolor="<%=strCOLOR%>">
		<td><%=MontaLinkGrade("modulo_PROCESSO","Delete.asp",GetValue(objRS,"COD_PROCESSO"),"IconAction_DEL.gif","REMOVER")%></td>
		<td><%=MontaLinkGrade("modulo_PROCESSO","Update.asp",GetValue(objRS,"COD_PROCESSO"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<!--td><%'=MontaLinkGrade("modulo_PROCESSO","Detail.asp",GetValue(objRS,"COD_PROCESSO"),"IconAction_DETAIL.gif","DETALHES")%></td-->
		<td><%=MontaLinkGrade("modulo_PROCESSO","DetailHistorico.asp",GetValue(objRS,"COD_PROCESSO") & "&var_instarefas=T","IconAction_DETAILadd.gif","VISUALIZAR")%></td>
		<td><%=UCase(GetValue(objRS, "CATEGORIA"))%></td>
		<td nowrap><%=GetValue(objRS, "ID_PROCESSO")%></td>
		<td><%=GetValue(objRS, "NOME")%></td>
		<td><%=GetValue(objRS, "AUTORES")%></td>
		<td nowrap><%=PrepData(GetValue(objRS, "SYS_DT_ALTERACAO"), True, True)%></td>
		<td nowrap><img src="../img/<%=strIMG_HOMOLOGACAO%>" alt="SITUAÇÃO: <%=strALT_HOMOLOGACAO%>"></td>
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