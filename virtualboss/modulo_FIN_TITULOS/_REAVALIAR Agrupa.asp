<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_BOLETO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 
 Dim strSQL, objConn, objRS
 
 AbreDBConn objConn, CFG_DB
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
	function BuscaEntidade() {
		AbreJanelaPAGE('BuscaPorEntidade.asp?var_input1=var_cod_cli&var_input2=var_cli_nome&var_tipo=ENT_CLIENTE','640','390');
	}
	
	function LimparNome() {
		document.form_insert.var_cli_nome.value = '';
	}
	
	//****** Funções de ação dos botões - Início ******
	function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
	function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
	function aplicar()      { document.form_insert.JSCRIPT_ACTION.value   = ""; submeterForm(); }
	function submeterForm() {
		var var_msg = '';
		
		if (document.form_insert.var_mes.value == '') var_msg += '\nMês';
		if (document.form_insert.var_ano.value == '') var_msg += '\nAno';
		
		if (document.form_insert.var_cliente_um_apenas.checked) {
			if (document.form_insert.var_cod_cli.value == '') var_msg += '\nCliente';
		}
		else if (!document.form_insert.var_cliente_todos.checked) {
			var_msg += '\nCliente';
		}
		/*
		if (document.form_insert.DBVAR_STR_CEDENTE_CNPJô.value == '')       var_msg += '\nCNPJ Cedente';
		if (document.form_insert.DBVAR_NUM_CEDENTE_CODIGOô.value == '')     var_msg += '\nConta (código)';
		if (document.form_insert.DBVAR_STR_CEDENTE_CODIGO_DVô.value == '')  var_msg += '\nConta (dv)';
		if (document.form_insert.DBVAR_NUM_BANCO_CODIGOô.value == '')       var_msg += '\nBanco (código)';
		if (document.form_insert.DBVAR_STR_BANCO_DVô.value == '')           var_msg += '\nBanco (dv)';
		if (document.form_insert.DBVAR_STR_CEDENTE_AGENCIAô == '')          var_msg += '\nBanco (agência)';
		if (document.form_insert.DBVAR_STR_BOLETO_CARTEIRAô.value == '')    var_msg += '\nBoleto Carteira';
		if (document.form_insert.DBVAR_STR_BOLETO_ACEITEô.value == '')      var_msg += '\nBoleto Aceite';
		if (document.form_insert.DBVAR_STR_LOCAL_PGTOô.value == '')         var_msg += '\nLocal Pagamento';
		if (document.form_insert.DBVAR_STR_INSTRUCOESô.value == '')         var_msg += '\nInstruções';
		*/
		if (var_msg == '')
			document.form_insert.submit();
		else
			alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
	
	//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Boletos - Agrupamento") %>
<form name="form_insert" action="Agrupa_Confirm.asp" method="post">
	<div class="form_label">*Período:</div><select name="var_mes" style="width:50px;">
												<option value="[selecione]">
												<option value="1">Jan</option>
												<option value="2">Fev</option>
												<option value="3">Mar</option>
												<option value="4">Abr</option>
												<option value="5">Mai</option>
												<option value="6">Jun</option>
												<option value="7">Jul</option>
												<option value="8">Ago</option>
												<option value="9">Set</option>
												<option value="10">Out</option>
												<option value="11">Nov</option>
												<option value="12">Dez</option>
										  </select><input name="var_ano" type="text" style="width:80px;" value="">
	<br><div class="form_label">*Cliente:</div><input type="radio" class="inputclean" name="var_cliente" id="var_cliente_todos" value="todos" checked="checked">todos
	<input type="radio" class="inputclean" name="var_cliente" id="var_cliente_um_apenas" value="um_apenas"><br>
	<input name="var_cod_cli" type="text" style="width:30px;" value="" onChange="LimparNome();" onKeyPress="validateNumKey();" maxlength="5"><input name="var_cli_nome" type="text" style="width:140px;" value="" readonly><a href="Javascript:void(0);" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" hspace="0" align="absmiddle"></a>
	<br><div class="form_label">*Dia de Vcto:</div><input name="var_dia_vcto" style="width:40px;" value="" onKeyPress="validateNumKey();" maxlength="5">
	<br><div class="form_label">*Centro de Custo:</div><select name="var_cod_centro_custo" style="width:230px;">
					<%
					strSQL = "SELECT DISTINCT"																	&_
							"	T1.COD_CENTRO_CUSTO, T1.NOME "													&_
							"FROM"																				&_
							"	FIN_CENTRO_CUSTO T1 "															&_
							"LEFT OUTER JOIN"																	&_
							"	FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) "		&_
							"WHERE"																				&_
							"	T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY) " 	&_
							"ORDER BY 2"
					%>
						<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME","")%>
					</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_insert&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Plano de Conta:</div><select name="var_cod_plano_conta" style="width:307px;">
							<%
							strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 							&_
									 " FROM FIN_PLANO_CONTA T1 "																&_
									 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_PLANO_CONTA=T2.COD_PLANO_CONTA) " 	&_
									 " WHERE T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY) " 	&_
									 " ORDER BY 2 "
							Set objRS = objConn.Execute(stRSQL)
							
							Do While Not objRS.Eof
								Response.Write("<option value='" & GetValue(objRS, "COD_PLANO_CONTA") & "'")
								'If CStr(intCOD_PLANO_CONTA) = CStr(GetValue(objRS, "COD_PLANO_CONTA")) Then Response.Write(" selected")
								Response.Write(">")
								If GetValue(objRS, "COD_REDUZIDO") <> "" Then Response.Write(GetValue(objRS, "COD_REDUZIDO") & " ")
								Response.Write(GetValue(objRS, "NOME") & "</option>")
								
								objRS.MoveNext
							Loop
							FechaRecordSet objRS
							%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_insert&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>			
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
  FechaDBConn objConn
%>