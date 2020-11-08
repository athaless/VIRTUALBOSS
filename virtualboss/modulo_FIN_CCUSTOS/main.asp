<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_CCUSTOS", Request.Cookies("VBOSS")("ID_USUARIO")), true 

 Dim objConn, objRS, objRSa, strSQL
 Dim strSITUACAO
 Dim strCOLOR

 AbreDBConn objConn, CFG_DB 

 strCOLOR = "#DAEEFA"

 strSITUACAO = GetParam("var_situacao")

  strSQL =	"SELECT" 					&_
			"	COD_CENTRO_CUSTO," 		&_
			"	COD_REDUZIDO,"     	    &_
			"	NOME," 					&_
			"	DESCRICAO," 			&_
			"	NIVEL," 				&_
			"	ORDEM," 				&_
			"	DT_INATIVO," 			&_
			"	COD_REDUZIDO " 			&_
			"FROM" 						&_
			"	FIN_CENTRO_CUSTO " 		&_
			"WHERE 1=1"
  
  if strSITUACAO="ATIVO" then strSQL = strSQL & " AND DT_INATIVO IS NULL "
  if strSITUACAO="INATIVO" then strSQL = strSQL & " AND DT_INATIVO IS NOT NULL "
  
  strSQL = strSQL & " ORDER BY COD_REDUZIDO, ORDEM, NOME "
  
  AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1

if not objRS.eof then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <thead>
  <tr> 
    <th width="01%"></th>
    <th width="01%" ></th>		
    <th width="01%" class="sortable-numeric">Código</th>
    <th width="01%" class="sortable" nowrap>Cod Reduzido</th>
    <th width="50%">Nome</th>								
    <th width="44%" class="sortable">Descrição</th>
    <th width="01%" class="sortable-numeric">Ordem</th>						
    <th width="01%" class="sortable-date-dmy" nowrap>Dt Inativo</th>
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      While Not objRs.Eof
 	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
  %>
  <tr bgcolor=<%=strCOLOR%>> 
		<td><%=MontaLinkGrade("modulo_FIN_CCUSTOS","Delete.asp",GetValue(objRS,"COD_CENTRO_CUSTO"),"IconAction_DEL.gif","REMOVER")%></td>							
		<td><%=MontaLinkGrade("modulo_FIN_CCUSTOS","Update.asp",GetValue(objRS,"COD_CENTRO_CUSTO"),"IconAction_EDIT.gif","ALTERAR")%></td>							
		<td><%=GetValue(objRS,"COD_CENTRO_CUSTO")%></td>
		<td nowrap><%=GetValue(objRS,"COD_REDUZIDO")%></td>
		<td nowrap><img src="../img/Custos_Nivel<%=GetValue(objRS,"NIVEL")%>.gif" border="0"><%=GetValue(objRS,"NOME")%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>
		<td align="right"><%=GetValue(objRS,"ORDEM")%></td>				
		<td align="right" nowrap><%=GetValue(objRS,"DT_INATIVO")%></td>
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
	Mensagem "Não há dados para a consulta solicitada.<br>Verifique os parâmetros de filtragem e tente novamente.", "", "", True
end if
FechaRecordSet objRS
FechaDBConn objConn
%>