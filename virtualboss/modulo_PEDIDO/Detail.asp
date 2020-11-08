<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%

Const WMD_WIDTHTTITLES = 150

Dim strSQL, objRS, ObjConn
Dim strOBS, strTOT_SERVICO, strMSG
Dim strCODIGO, strNOME, strDT_EMISSAO

strCODIGO = GetParam("var_chavereg")

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =          " SELECT T1.COD_CLI AS CODIGO, T1.TIPO, T1.OBS_NF, T1.TOT_SERVICO, T1.SITUACAO, T1.DT_EMISSAO "
	strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLI_NOME "
	'strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNEC_NOME "
	'strSQL = strSQL & "      , T4.NOME AS COLAB_NOME "
	strSQL = strSQL & " FROM NF_NOTA T1 "
	strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T2 ON (T1.COD_CLI = T2.COD_CLIENTE) "
	'strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T3 ON (T1.CODIGO = T3.COD_FORNECEDOR) "
	'strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO = T4.COD_COLABORADOR) "
	strSQL = strSQL & " WHERE COD_NF = " & strCODIGO
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.eof then 
		strMSG = ""
		If GetValue(objRS, "SITUACAO") <> "ABERTO" Then strMSG = strMSG & "Pedido em situação diferente de aberto"
		
		If strMSG <> "" Then
			Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
			Response.End()
		End If
		
		'If GetValue(objRS, "TIPO") = "ENT_CLIENTE" Then 
		strNOME = GetValue(objRS, "CLI_NOME")
		'If GetValue(objRS, "TIPO") = "ENT_FORNECEDOR" Then strNOME = GetValue(objRS, "FORNEC_NOME")
		'If GetValue(objRS, "TIPO") = "ENT_COLABORADOR" Then strNOME = GetValue(objRS, "COLAB_NOME")
		
		strOBS = GetValue(objRS,"OBS_NF")
		strTOT_SERVICO = FormataDecimal(GetValue(objRS,"TOT_SERVICO"),2)
		strDT_EMISSAO = PrepData(GetValue(objRS, "DT_EMISSAO"), True, False)
		
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
function aplicar()      { submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	//if (document.form_insert.var_to.value == '')        var_msg += '\nPara';
	//if (document.form_insert.var_resposta.value == '')  var_msg += '\nResposta';
	
	if (var_msg == ''){
		document.form_insert.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}

function BuscaServico1() {	
	AbreJanelaPAGE('BuscaServicoUm.asp?var_chavereg=' + document.form_insert.var_cod_servico.value + '&var_input1=var_cod_servico&var_input2=var_nome&var_input3=var_descricao&var_input4=var_valor&var_form=form_insert','70','40');
}

function BuscaServico2() {	
	AbreJanelaPAGE('BuscaServico.asp?var_input1=var_cod_servico&var_input2=var_nome&var_input3=var_descricao&var_input4=var_valor&var_form=form_insert','760','390');
}

function LimparCampo(prForm, prCampo) {
	eval("document." + prForm + "." + prCampo + ".value = '';");
}

/****** Funções de ação dos botões - Fim ******/
</script>
</head>
<body>
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "PEDIDO <strong>" & strCODIGO & "</strong>", "", 0
	athEndCssMenu("")
%>
<!-- C6DBD6 -->
<div id="table_header" style="width:100%">
	<table border="0" cellpadding="0" cellspacing="1" class="tableheader">
		<tbody>
			<tr>
				<td>Entidade:&nbsp;</td>
				<td><%=strNOME%></td>
			</tr>
			<tr>
				<td>Data Emissão:&nbsp;</td>
				<td><%=strDT_EMISSAO%></td>
			</tr>
			<tr>
				<td>Observação:&nbsp;</td>
				<td><%=strOBS%></td>
			</tr>
			<tr id="tableheader_last_row">
				<td>Total:&nbsp;</td>
				<td><%=strTOT_SERVICO%></td>
			</tr>
		</tbody>
	</table>
</div>
<br>
<% 
	end if 
	
	strSQL =          " SELECT COD_NF_ITEM, COD_SERVICO, TIT_SERVICO, DESC_SERVICO, VALOR " 
	strSQL = strSQL & " FROM NF_ITEM WHERE COD_NF = " & strCODIGO & " ORDER BY TIT_SERVICO " 
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	'Montagem do MENU DETAIL
	athBeginCssMenu()
		athCssMenuAddItem "", "", "_self", "SERVIÇOS", "", 1
		athBeginCssSubMenu()
			athCssMenuAddItem "InsertDetail.asp?var_chavereg="& strCODIGO, "", "_self", "Inserir Serviço", "div_modal", 0
		athEndCssSubMenu()
	athEndCssMenu("div_modal")
	
	if not objRS.eof then 
%>
	
<table style="width:100%;" border="0" align="center" cellpadding="0" cellspacing="1" class="tablesort">
	<thead>
		<tr>
			<th width="01%"></th>
			<th width="01%">Cod</th>
			<th class="sortable" width="28%">Título</th>
			<th class="sortable" width="60%">Descrição</th>
			<th class="sortable" width="10%">Valor</th>
		</tr>
	</thead>
	<tbody style="text-align:left">
		<% do while not objRS.Eof %>
		<tr>
			<td><%=MontaLinkGrade("modulo_PEDIDO","DeleteItem.asp",GetValue(objRS,"COD_NF_ITEM") & "&var_cod_pedido=" & strCODIGO,"IconAction_DEL.gif","REMOVER")%></td>
			<td style="text-align:center; vertical-align:middle;"><%=GetValue(objRS,"COD_NF_ITEM")%></td>
			<td style="text-align:left; vertical-align:middle;"><%=GetValue(objRS,"TIT_SERVICO")%></td>
			<td style="text-align:left; vertical-align:middle;"><%=GetValue(objRS,"DESC_SERVICO")%></td>
			<td style="text-align:right; vertical-align:middle;"><%=FormataDecimal(GetValue(objRS,"VALOR"),2)%></td>
		</tr>
		<% 
			objRS.MoveNext 
		loop 
		%>
	</tbody>
</table>
<br/>
<%	end if %>
</body>
</html>
<%
	FechaRecordSet objRS
	FechaDBConn objConn
	end if
%>