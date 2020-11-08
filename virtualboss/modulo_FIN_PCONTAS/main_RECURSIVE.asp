<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_PCONTAS", Request.Cookies("VBOSS")("ID_USUARIO")), true 

 Dim objConn, objRS, objRSa, strSQL
 Dim strSITUACAO
 Dim strCOLOR

 AbreDBConn objConn, CFG_DB 

 strCOLOR = "#DAEEFA"
 strSITUACAO = GetParam("var_situacao")

 function RecursiveItens(prCodPai)
 Dim LocalstrSQL, LocalObjRS, LocalAuxCont
	LocalstrSQL =	"SELECT" 						&_
						"	COD_PLANO_CONTA," 		&_
						"	COD_PLANO_CONTA_PAI," 	&_
						"	NOME," 					&_
						"	DESCRICAO," 			&_
						"	NIVEL," 				&_
						"	ORDEM," 				&_
						"	DT_INATIVO," 			&_
						"	COD_REDUZIDO " 			&_
						"FROM" 						&_
						"	FIN_PLANO_CONTA " 		&_
						"WHERE COD_PLANO_CONTA_PAI=" & prCodPai
	if strSITUACAO="ATIVO" then LocalstrSQL = LocalstrSQL & " AND DT_INATIVO IS NULL "
	if strSITUACAO="INATIVO" then LocalstrSQL = LocalstrSQL & " AND DT_INATIVO IS NOT NULL "
	LocalstrSQL = LocalstrSQL & " ORDER BY ORDEM, NOME"						
   
   AbreRecordSet LocalObjRS, LocalstrSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
   while not LocalObjRS.eof
 	    strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")
		
		with Response
			.Write("<tr bgcolor='" & strCOLOR & "'>")
			.Write("	<td>" & MontaLinkGrade("modulo_FIN_PCONTAS","Delete.asp",GetValue(LocalObjRS,"COD_PLANO_CONTA"),"IconAction_DEL.gif","REMOVER") & "</td>"																																																	)							
			.Write("	<td>" & MontaLinkGrade("modulo_FIN_PCONTAS","Update.asp",GetValue(LocalObjRS,"COD_PLANO_CONTA"),"IconAction_EDIT.gif","ALTERAR") & "</td>"																																																	)							
			.Write("	<td>" & GetValue(LocalObjRS,"COD_PLANO_CONTA") & "</td>")
			.Write("	<td nowrap>" & GetValue(LocalObjRS,"COD_REDUZIDO") & "</td>")
			.Write("	<td nowrap><img src='../img/Custos_Nivel" & GetValue(LocalObjRS,"NIVEL") & ".gif' border='0'>" & GetValue(LocalObjRS,"NOME") & "</td>")
			.Write("	<td>" & GetValue(LocalObjRS,"DESCRICAO") & "</td>")
			.Write("	<td align='right'>" & GetValue(LocalObjRS,"ORDEM") & "</td>")				
			.Write("	<td align='right' nowrap>" & GetValue(LocalObjRS,"DT_INATIVO") & "</td>")
			.Write("</tr>")
		end with
	  'Ct = Ct + 1  
 	  RecursiveItens(GetValue(LocalObjRS,"COD_PLANO_CONTA"))		
	  athMoveNext LocalObjRS, ContFlush, CFG_FLUSH_LIMIT
   wend
   FechaRecordSet(LocalObjRS)
end function


	strSQL = " SELECT" 	&_
			"	COD_PLANO_CONTA," 		&_
			"	COD_PLANO_CONTA_PAI," 	&_
			"	NOME," 	&_
			"	DESCRICAO," &_
			"	NIVEL," 	&_
			"	ORDEM," 	&_
			"	DT_INATIVO," 	&_
			"	COD_REDUZIDO " &_
			"FROM" 	&_
			"	FIN_PLANO_CONTA " &_
			"WHERE 1=1"
	
	if strSITUACAO="ATIVO" then strSQL = strSQL & " AND DT_INATIVO IS NULL "
	if strSITUACAO="INATIVO" then strSQL = strSQL & " AND DT_INATIVO IS NOT NULL "
	
	strSQL = strSQL & " ORDER BY ORDEM, NOME"
	
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
if not objRS.eof then
%>
<html>
<script type="text/javascript" src="../_scripts/tablesort.js"></script>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<body>
<table align="center" cellpadding="0" cellspacing="1" style="width:100%">
 <!-- Possibilidades de tipo de sort...
  class="sortable-date-dmy"
  class="sortable-currency"
  class="sortable-numeric"
  class="sortable"
 -->
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
 <thead>
 <tbody style="text-align:left;">
	</tr>
  <%
     While Not objRs.Eof
  %>		
	<tr>	
		<td><%=MontaLinkGrade("modulo_FIN_PCONTAS","Delete.asp",GetValue(ObjRS,"COD_PLANO_CONTA"),"IconAction_DEL.gif","REMOVER")%></td>
		<td><%=MontaLinkGrade("modulo_FIN_PCONTAS","Update.asp",GetValue(ObjRS,"COD_PLANO_CONTA"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td><%=GetValue(objRS,"COD_PLANO_CONTA")%></td>
		<td nowrap><%=GetValue(objRS,"COD_REDUZIDO")%></td>
		<td nowrap><img src="../img/Custos_Nivel<%=GetValue(objRS,"NIVEL")%>.gif" border="0"><%=GetValue(objRS,"NOME")%></td>
		<td><%=GetValue(objRS,"DESCRICAO")%></td>
		<td align="right"><%=GetValue(objRS,"ORDEM")%></td>				
		<td align="right" nowrap><%=GetValue(objRS,"DT_INATIVO")%></td>
	</tr>
  <%
      RecursiveItens GetValue(ObjRS,"COD_PLANO_CONTA")
      athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	wend
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