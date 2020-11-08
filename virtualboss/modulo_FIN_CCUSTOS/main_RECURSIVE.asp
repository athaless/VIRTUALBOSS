<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<% 
 Response.AddHeader "Content-Type","text/html; charset=iso-8859-1"
 VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FIN_CCUSTOS", Request.Cookies("VBOSS")("ID_USUARIO")), true 

 Dim objConn, objRS, objRSa, strSQL
 Dim strSITUACAO
 Dim Ct, strCOLOR

 AbreDBConn objConn, CFG_DB 

 strCOLOR = "#DAEEFA"
 
 strSITUACAO = GetParam("var_situacao")

 function RecursiveItens(prCodPai)
 Dim LocalstrSQL, LocalObjRS, LocalAuxCont
	 LocalstrSQL =	"SELECT" 						&_
						"	COD_CENTRO_CUSTO," 		&_
						"	COD_CENTRO_CUSTO_PAI," 	&_
						"	NOME," 					&_
						"	DESCRICAO," 			&_
						"	NIVEL," 				&_
						"	ORDEM," 				&_
						"	DT_INATIVO," 			&_
						"	COD_REDUZIDO " 			&_
						"FROM" 						&_
						"	FIN_CENTRO_CUSTO " 		&_
						"WHERE COD_CENTRO_CUSTO_PAI=" & prCodPai
	if strSITUACAO="ATIVO" then LocalstrSQL = LocalstrSQL & " AND DT_INATIVO IS NULL "
	if strSITUACAO="INATIVO" then LocalstrSQL = LocalstrSQL & " AND DT_INATIVO IS NOT NULL "
	LocalstrSQL = LocalstrSQL & " ORDER BY ORDEM, NOME"
   
   AbreRecordSet LocalObjRS, LocalstrSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
   while not LocalObjRS.eof
		with Response
			.Write("<tr bgcolor='" & strCOLOR & "' class='arial11' valign='middle'>")
			.Write("	<td align='center' style='cursor:hand;'>")
			.Write("		" & MontaLinkGrade("modulo_FIN_CCUSTOS","Delete.asp",GetValue(LocalObjRS,"COD_CENTRO_CUSTO"),"IconAction_DEL.gif","REMOVER") & "</div>")
			.Write("	</td>")
			.Write("	<td align='center' style='cursor:hand;'>")
			.Write("		" & MontaLinkGrade("modulo_FIN_CCUSTOS","Update.asp",GetValue(LocalObjRS,"COD_CENTRO_CUSTO"),"IconAction_EDIT.gif","ALTERAR") & "</div>")
			.Write("	</td>")
			.Write("	<td>" & GetValue(LocalObjRS,"COD_CENTRO_CUSTO") & "</div></td>")
			.Write("	<td nowrap>" & GetValue(LocalObjRS,"COD_REDUZIDO") & "</div></td>")
			.Write("	<td nowrap>")
			.Write("		<img src='../img/Custos_Nivel" & GetValue(LocalObjRS,"NIVEL") & ".gif' border='0'>" & GetValue(LocalObjRS,"NOME") & "</div>")
			.Write("	</td>")
			.Write("	<td>" & GetValue(LocalObjRS,"DESCRICAO") & "</div></td>")
			.Write("	<td align='right'>" & GetValue(LocalObjRS,"ORDEM") & "</div></td>")
			.Write("	<td align='right' nowrap>" & GetValue(LocalObjRS,"DT_INATIVO") & "</div></td>")
			.Write("</tr>")
		end with
		RecursiveItens(GetValue(LocalObjRS,"COD_CENTRO_CUSTO"))		
		athMoveNext LocalObjRS, ContFlush, CFG_FLUSH_LIMIT
   wend
   FechaRecordSet(LocalObjRS)
end function


  strSQL =	"SELECT" 					&_
			"	COD_CENTRO_CUSTO," 		&_
			"	COD_CENTRO_CUSTO_PAI," 	&_
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
  
  strSQL = strSQL & " ORDER BY ORDEM, NOME "
  
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
  </tr>
  </thead>
 <tbody style="text-align:left;">
<%
      Ct = 1  
      While Not objRs.Eof
        if (Ct mod 2) = 0 then
  	      strCOLOR = "#FFFFFF"
  	    else
  	       strCOLOR = "#F5FAFA"
	    end if
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
        Ct = Ct + 1
		if strSITUACAO<>"INATIVO" then RecursiveItens GetValue(ObjRS,"COD_CENTRO_CUSTO")
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