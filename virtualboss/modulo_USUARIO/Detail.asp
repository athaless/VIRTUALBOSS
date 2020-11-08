<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
	Dim strSQL, objRS, objRSEntCli, ObjConn, objRS2
	Dim strCODIGO, strATIVO, strENTIDADE, strNomesENT_CLIENTE_REF, strAuxENT_CLIENTE_REF 
	Dim strCOLOR
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
	
		strSQL=          " SELECT COD_USUARIO, ID_USUARIO, GRP_USER, TIPO, CODIGO, OBS, DT_INATIVO, DIR_DEFAULT, APELIDO, ENT_CLIENTE_REF, ID_USUARIO_MODELO "
		strSQL = strSQL & " FROM USUARIO "
		strSQL = strSQL & " WHERE COD_USUARIO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then 
		 strENTIDADE = ""
		 If GetValue(objRS,"TIPO") = "ENT_COLABORADOR" then strENTIDADE = "Colaborador" 
		 If GetValue(objRS,"TIPO") = "ENT_CLIENTE" then strENTIDADE = "Cliente"
		 
		 If GetValue(objRS,"DT_INATIVO") = "" then
		   strATIVO = "Ativo" 
		 Else
		   strATIVO = "Inativo"
		 End If   
		 
		 strAuxENT_CLIENTE_REF = GetValue(objRS, "ENT_CLIENTE_REF")	 	 
		 strNomesENT_CLIENTE_REF  = ""
		 
		 if(strAuxENT_CLIENTE_REF <> "") then
		   strAuxENT_CLIENTE_REF = Replace(strAuxENT_CLIENTE_REF, ";", ",") 'substitui ; por ,
	       strSQL = " SELECT COD_CLIENTE, COALESCE(NOME_COMERCIAL, NOME_FANTASIA) AS ENT_CLIENTE FROM ENT_CLIENTE WHERE COD_CLIENTE IN (" & strAuxENT_CLIENTE_REF & ")" 	 

		   Set objRSEntCli = objConn.Execute(strSQL)
		   
           While(not objRSEntCli.Eof)
	         strNomesENT_CLIENTE_REF  = strNomesENT_CLIENTE_REF  & GetValue(ObjRSEntCli, "COD_CLIENTE") & " - " & GetValue(objRSEntCli, "ENT_CLIENTE") & "</br>"
		     objRSEntCli.movenext
		   Wend
		   FechaRecordSet objRSEntCli
		 end if
%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
</head>
<body>
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	'Descomente caso queira utilizar o outro estilo (menu + tableheader)
	'athBeginCssMenu()
	'	athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "USUÁRIO <strong>" & strCODIGO & "</strong> - " & getValue(objRS,"ID_USUARIO"), "", 0
	'athEndCssMenu("")
%>
<div id="table_header" style="width:100%">
	<table align="center" cellpadding="0" cellspacing="1" class="tablesort">
		<thead>
			<tr>
				<th></th>
				<th>Dados</th>
			</tr>
		</thead>
		<tbody style="text-align:left;">
			<tr>
				<td align="right">Cod. Usuário:</td>
				<td><%=strCODIGO%></td>
			</tr>
			<tr>
				<td align="right">ID Usuário:</td>
				<td><%=getValue(objRS,"ID_USUARIO")%></td>
			</tr>
			<tr>
				<td align="right">Apelido:</td>
				<td><%=getValue(objRS,"APELIDO")%></td>
			</tr>
			<tr> 
				<td align="right">Entidade / Cod. Entidade:&nbsp;</td>
				<td><%=strENTIDADE & " / " & GetValue(objRS,"CODIGO")%></td>
			</tr>
			<tr> 
				<td align="right">Grupo de Usuário:&nbsp;</td>
				<td><%=GetValue(objRS,"GRP_USER")%></td>
			</tr>
			<tr> 
				<td align="right">Entrada:&nbsp;</td>
				<td>
					<%
						If GetValue(objRS,"DIR_DEFAULT") = "" Then Response.Write("Painel Padrão")
						If GetValue(objRS,"DIR_DEFAULT") = "CLIENTE" Then Response.Write("Painel de Cliente")
					%>
				</td>
			</tr>
			<tr> 
				<td align="right">Observação:&nbsp;</td>
				<td><%=GetValue(objRS,"OBS")%></td>
			</tr>
			<tr id="tableheader_last_row"> 
				<td align="right">Status:&nbsp;</td>
				<td><%=strATIVO%></td>
			</tr>
			<tr id="tableheader_last_row"> 
				<td align="right">Direitos de:&nbsp;</td>
				<td><%=GetValue(objRS,"ID_USUARIO_MODELO")%></td>
			</tr>
			<tr id="tableheader_last_row"> 
				<td align="right">Visualiza chamados de:&nbsp;</td>
				<td><%=strNomesENT_CLIENTE_REF %></td>
			</tr>						
		</tbody> 
	</table>
</div>
<br />
<%
	strSQL = " SELECT COD_USUARIO_LOG, NUM_SESSAO, DT_LOGIN, DT_LOGOUT, EXTRA, DT_OCORRENCIA " &_
    	     " FROM USUARIO_LOG WHERE ID_USUARIO = '" & GetValue(objRS,"ID_USUARIO") & "'" &_
			 " ORDER BY DT_OCORRENCIA DESC, DT_LOGIN DESC "  
	Set objRS2 = objConn.execute(strSQL)

	If Not objRS2.Eof Then 
%>

<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
 <!-- 
 	Possibilidades de tipo de sort...
  	class="sortable-date-dmy"
  	class="sortable-currency"
  	class="sortable-numeric"
  	class="sortable"
   -->
	<thead>
   		<tr> 
	  		<th width="1%"  nowrap></td>
			<th width="1%"  class="sortable" nowrap>N° de Sessão</th>
			<th width="1%"  class="sortable-date-dmy" nowrap>Data login</th>
			<th width="1%"  class="sortable-date-dmy" nowrap>Data logout</th>
			<th width="95%" class="sortable" nowrap>Extra</th>
			<th width="1%"  class="sortable-date-dmy" nowrap>Data Ocorrência</th>
		</tr>
	</thead>
 	<tbody style="text-align:left;">
	<%
		While Not objRS2.Eof
	%>
		<tr>
		  <td width="1%" nowrap><%=MontaLinkGrade("modulo_USUARIO","delete_log.asp",GetValue(objRS2,"COD_USUARIO_LOG"),"IconAction_DEL.gif","REMOVER")%></td>
		  <td width="1%" nowrap><%=GetValue(objRS2, "NUM_SESSAO")%></td>
		  <td width="1%"nowrap><%=GetValue(objRS2, "DT_LOGIN")%></td>
		  <td width="1%" nowrap><%=GetValue(objRS2, "DT_LOGOUT")%></td>
		  <td width="95%" nowrap><%=GetValue(objRS2, "EXTRA")%></td>
		  <td width="1%" nowrap><%=PrepData(GetValue(objRS2, "DT_OCORRENCIA"), True, True)%></td>
		</tr>
	<%
		athMoveNext objRS2, ContFlush, CFG_FLUSH_LIMIT
		Wend
		FechaRecordSet objRS2 
	%>
	</tbody>
</table>
<% End If %>
</body>
</html>
<%
	End If
	FechaRecordSet objRS
	FechaDBConn objConn
End If 
%>