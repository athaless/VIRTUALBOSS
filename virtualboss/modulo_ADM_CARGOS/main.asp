<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_ADM_CARGOS", Request.Cookies("VBOSS")("ID_USUARIO")), true 

 Dim objConn, objRS, strSQL
 Dim strSITUACAO, strTIT, strDEPSET, strSUP
 Dim strAviso, strCOLOR

 strAviso 	= "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente."

 AbreDBConn objConn, CFG_DB 

 strTIT       = GetParam("var_titulo")
 strDEPSET    = GetParam("var_depset")
 strSUP       = GetParam("var_superior")
 strSITUACAO  = GetParam("var_situacao")

 strSQL =          " SELECT COD_CARGO"
 strSQL = strSQL & "  ,TITULO"
 strSQL = strSQL & "  ,UNIDADE"
 strSQL = strSQL & "  ,DEPARTAMENTO"
 strSQL = strSQL & "  ,SETOR"
 strSQL = strSQL & "  ,SUP_HIERARQUICO"
 strSQL = strSQL & "  ,DESCRICAO"
 strSQL = strSQL & "  ,ATIVIDADES"
 strSQL = strSQL & "  ,QUALIFICACOES"
 strSQL = strSQL & "  ,COMPETENCIAS"
 strSQL = strSQL & " FROM ADM_CARGO "
 strSQL = strSQL & " WHERE TRUE " 
 
 if strTIT <> ""             then strSQL = strSQL & " AND (TITULO LIKE '" & strTIT & "%')"
 if strDEPSET <> ""          then strSQL = strSQL & " AND (DEPARTAMENTO LIKE '" & strDEPSET & "%' OR SETOR LIKE '" & strDEPSET & "%')"
 if strSUP <> ""             then strSQL = strSQL & " AND SUP_HIERARQUICO LIKE '" & strSUP & "%'" 
 if strSITUACAO = "INATIVO"  then strSQL = strSQL & " AND DT_INATIVO IS NOT NULL " 
 if strSITUACAO = "ATIVO"    then strSQL = strSQL & " AND DT_INATIVO IS NULL "
 
 strSQL = strSQL & " ORDER BY DEPARTAMENTO, TITULO"
 
 'athDebug strSQL, false
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
	<th width="1%"   class="sortable-numeric" nowrap>Cod</th>
    <th width="20%"  class="sortable" nowrap>Dep.</th>
    <th width="20%"  class="sortable" nowrap>Título</th>
	<th width="5%"   class="sortable" nowrap>Un</th>
    <th width="20%"  class="sortable" nowrap>Setor</th>
	<th width="20%"  class="sortable" nowrap>Sup.</th>
	<th width="11%"  class="sortable" nowrap>Comp.</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
			strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
 %>
 <tr bgcolor=<%=strCOLOR%>> 
	<td><%=MontaLinkGrade("modulo_ADM_CARGOS","Delete.asp",GetValue(objRS,"COD_CARGO"),"IconAction_DEL.gif","REMOVER")%></td>
	<td><%=MontaLinkGrade("modulo_ADM_CARGOS","Update.asp",GetValue(objRS,"COD_CARGO"),"IconAction_EDIT.gif","ALTERAR")%></td>
	<td><%=MontaLinkGrade("modulo_ADM_CARGOS","Detail.asp",GetValue(objRS,"COD_CARGO"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
	<td style="text-align:right" nowrap><%=getValue(objRS,"COD_CARGO")%></td>
    <td style="text-align:left"><%=getValue(objRS,"DEPARTAMENTO")%></td>
    <td style="text-align:left"><%=getValue(objRS,"TITULO")%></td>
    <td style="text-align:left"><%=getValue(objRS,"UNIDADE")%></td>
    <td style="text-align:left"><%=getValue(objRS,"SETOR")%></td>
    <td style="text-align:left"><%=getValue(objRS,"SUP_HIERARQUICO")%></td>
    <td style="text-align:left"><%=getValue(objRS,"COMPETENCIAS")%></td>
 </tr>
	<%
			athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
		wend
	%>
 </tbody>
</table>
</body>
</html>
<%
	else
		Mensagem strAviso, "", "", true
	end if
	FechaRecordSet objRS
	FechaDBConn objConn
%>