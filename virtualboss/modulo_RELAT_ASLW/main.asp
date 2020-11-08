<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_RELAT_ASLW", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
 <!--#include file="../_database/athUtils.asp"--> 
<%
 Dim objConn, objRS, strSQL
 Dim strNOME, strSITUACAO, strCODCATEG, strUSER_ID, strCOLOR
 
 AbreDBConn objConn, CFG_DB 

 strNOME     = GetParam("var_nome")
 strSITUACAO = GetParam("var_situacao")
 strCODCATEG = GetParam("var_cod_categoria")

 strSQL =          " SELECT AR.COD_RELATORIO, AR.NOME as NOME_RELAT, AR.DESCRICAO, AR.EXECUTOR, AR.PARAMETRO, AR.SYS_CRIA, AR.SYS_ALTERA "
 strSQL = strSQL & "      , AR.DT_CRIACAO, AR.DT_INATIVO, AR.DT_ALTERACAO, AC.COD_CATEGORIA, AC.NOME AS NOME_CATEG "
 strSQL = strSQL & " FROM ASLW_RELATORIO AR "
 strSQL = strSQL & " LEFT OUTER JOIN ASLW_CATEGORIA AC ON (AR.COD_CATEGORIA = AC.COD_CATEGORIA) "
 strSQL = strSQL & " WHERE AR.COD_RELATORIO > 0 " 

 if strNOME <> ""           then strSQL = strSQL & " AND (AR.NOME LIKE '" & strNOME & "%')"
 if strCODCATEG <> ""       then strSQL = strSQL & " AND AC.COD_CATEGORIA = " & strCODCATEG
 if strSITUACAO = "INATIVO" then strSQL = strSQL & " AND AR.DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"   then strSQL = strSQL & " AND AR.DT_INATIVO IS NULL "

 strSQL = strSQL & " ORDER BY AC.NOME, AR.NOME  "
 
 Set objRs = objConn.Execute(strSQL) 
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
	<th width="1%"></th>
    <th width="2%" class="sortable-numeric" nowrap>Cod</th>
    <th width="8%" class="sortable" nowrap>Categoria</th>
	<th width="23%" class="sortable" nowrap>Nome</th>
    <th width="55%" class="sortable" nowrap>Descrição</th>
    <th width="4%" class="sortable" nowrap>Ult Alter</th>
	<th width="4%" class="sortable" nowrap>Em</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
	<%
      While Not objRS.Eof
	  	strCOLOR = swapString(strCOLOR,"#FFFFFF","#F5FAFA")
	%>
		  <tr bgcolor=<%=strCOLOR%>> 
			<td width="1%"><%=MontaLinkGrade("modulo_RELAT_ASLW","Delete.asp",GetValue(objRS,"COD_RELATORIO"),"IconAction_DEL.gif","REMOVER")%></td>
			<td width="1%"><%=MontaLinkGrade("modulo_RELAT_ASLW","Update.asp",GetValue(objRS,"COD_RELATORIO"),"IconAction_EDIT.gif","ALTERAR")%></td>
			<td width="1%"><%=MontaLinkGrade("modulo_RELAT_ASLW","Detail.asp",GetValue(objRS,"COD_RELATORIO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
			<td width="2%" align="left" valign="top"><%
			if GetValue(objRS,"DT_INATIVO") = "" then
				Response.Write(MontaLinkPopup("modulo_RELAT_ASLW",GetValue(objRS,"EXECUTOR"),GetValue(objRS,"COD_RELATORIO"),"IconAction_PLAY.gif","EXECUTAR","680","460","yes"))
			end if
			%></td>
			<td align="right" nowrap><%=GetValue(objRS,"COD_RELATORIO")%></td>
			<td align="left" nowrap><%=GetValue(objRS,"NOME_CATEG")%></td>
			<td nowrap><%=GetValue(objRS,"NOME_RELAT")%></td>
			<td><%=GetValue(objRS,"DESCRICAO")%></td>
			<td nowrap><%=GetValue(objRS,"SYS_ALTERA")%></td>
			<td nowrap><%=PrepData(GetValue(objRS,"DT_ALTERACAO"), True, False)%></td>
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
   FechaRecordSet ObjRS
 else
   Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
 end if
 FechaDBConn objConn
%>