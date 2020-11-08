<!--#include file="../_database/athdbConn.asp"--><% ' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PROJETO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 150 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 

	Dim objConn, objRS, strSQL 
	Dim acROI, strCOLOR
	Dim strCODIGO, strTITULO, strDESC
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL = " SELECT COD_PROJETO, COD_CATEGORIA, TITULO, DESCRICAO, DT_DEADLINE FROM PRJ_PROJETO WHERE COD_PROJETO = " & strCODIGO
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		If Not objRS.Eof Then
			strTITULO   = GetValue(objRS,"TITULO")
			strDESC     = GetValue(objRS,"DESCRICAO")
			FechaRecordSet objRS
%>
<html>
<head>
	<title>vboss</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<!-- estilo abaixo precisa ficar nesse arquivo porque é específico da página -->
	<!-- será usado para abrir e fechar uma área, se tiver mais de uma, cada uma terá de ter um nome -->

	<script type="text/javascript">
		/****** Funções de ação dos botões - Início ******/
		function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
		function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
		function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
		function submeterForm() {
			var var_msg = '';

			if (document.form_insert.DBVAR_STR_TITULOô.value == '') var_msg += '\nTítulo';
			if (document.form_insert.DBVAR_NUM_COD_PROJETOô.value == '')  var_msg += '\nProjeto';	
			
			if (var_msg == ''){
				document.form_insert.submit();
			} else{
				alert('Favor verificar campos obrigatórios:\n' + var_msg);
			}
		}
		/****** Funções de ação dos botões - Fim ******/
	</script>
</head>
<body>
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "PROJETO <strong>" & strCODIGO & "</strong> - " & strTITULO, "", 0
	athEndCssMenu("")
%>
<!-- C6DBD6 -->
<div id="table_header" style="width:100%">
	<table border="0" cellpadding="0" cellspacing="1" class="tableheader">
		<tbody>
			<tr>
				<td>Código:&nbsp;</td>
				<td><%=strCODIGO%></td>
			</tr>
			<tr>
				<td>Título:&nbsp;</td>
				<td><%=strTITULO%></td>
			</tr>
			<tr id="tableheader_last_row">
				<td>Descrição:&nbsp;</td>
				<td style="background-color:#E7EFF1;border:#E7EFF1;"><%=Replace(Replace(strDESC,"<ASLW_APOSTROFE>","'"),CHR(13),"<br>")%><br></td>
			</tr>
		</tbody>
	</table>
</div>
<br>
<% 
	strSQL =          "SELECT COD_PRJ_BACKLOG, COD_PROJETO, TITULO, DESCRICAO, TAMANHO, ROI, STATUS "
	strSQL = strSQL & "  FROM PRJ_BACKLOG "
	strSQL = strSQL & " WHERE COD_PROJETO = " & strCODIGO  
	strSQL = strSQL & " ORDER By ROI DESC, STATUS "

	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1


	'Montagem do MENU DETAIL
	athBeginCssMenu()
		athCssMenuAddItem "", "", "_self", "BACKLOG", "", 1
		athBeginCssSubMenu()
			athCssMenuAddItem "../modulo_PROJETO_BACKLOG/Insert.asp?var_cod_projeto="& strCODIGO, "", "_self", "Inserir Backlog", "div_modal", 0
		athEndCssSubMenu()
	athEndCssMenu("div_modal")
	
	
	if not objRS.eof then 
%>
<table style="width:100%;" border="0" align="center" cellpadding="0" cellspacing="1" class="tablesort">
	<thead>
		<tr>
		  <tr> 
			<th width="1%"></th>
			<th width="1%"></th>
			<th width="1%"></th>
			<th width="1%" class="sortable" nowrap>Cód.</th>
			<th width="26%" class="sortable" nowrap>Titulo</th>
			<th width="60%" class="sortable">Descrição</th>
			<th width="5%"  class="sortable" nowrap>ROI</th>
			<th width="5%"  class="sortable" nowrap>Status</th>
		  </tr>
		</tr>
	</thead>
	<tbody style="text-align:left">
	<%
	acROI=0
    While Not objRs.Eof
	  strCOLOR = swapString (strCOLOR,"#FFFFFF","#F5FAFA")	
	  If IsNumeric(getValue(objRS,"ROI")) Then acROI = acROI + getValue(objRS,"ROI")
	%>
	<tr bgcolor=<%=strCOLOR%>> 
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO_BACKLOG","Delete.asp",GetValue(objRS,"COD_PRJ_BACKLOG"),"IconAction_DEL.gif","REMOVER")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO_BACKLOG","Update.asp",GetValue(objRS,"COD_PRJ_BACKLOG"),"IconAction_EDIT.gif","ALTERAR")%></td>
		<td width="1%"><%=MontaLinkGrade("modulo_PROJETO_BACKLOG","Detail.asp",GetValue(objRS,"COD_PRJ_BACKLOG"),"IconAction_DETAIL.gif","VISUALIZAR")%></td>
		<td nowrap="nowrap"><%=getValue(objRS,"COD_PRJ_BACKLOG")%></td>
		<td><%=getValue(objRS,"TITULO")%></td>
		<td><%=getValue(objRS,"DESCRICAO")%></td>
		<td nowrap="nowrap"><%=getValue(objRS,"ROI")%></td>
		<td nowrap="nowrap"><%=getValue(objRS,"STATUS")%></td>				
	</tr>
	<%
	  athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
	Wend
	%>
	<tr>
		<td style="text-align:right;" height="30px" colspan="8" valign="middle">Total (Roi): <%=acROI%></td>
	</tr>
	</tbody>
</table>
<br/>
<%		End If'If Not objRS.Eof(backlog) Then %>
</body>
</html>
<%
	End If'If Not objRS.Eof(projeto) Then
	FechaDBConn objConn
End If 'If strCODIGO <> ""
%>
