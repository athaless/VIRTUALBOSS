<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|FATURA|", BuscaDireitosFromDB("modulo_PEDIDO_OLD", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO! Você está prestes a gerar título para este pedido. Para confirmar clique no botão [ok], para desistir clique em [cancelar]." 'Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim objConn, objRS, objRSAux, strSQL
	Dim strCODIGO, strNOME, strMSG
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT T1.COD_CLI AS CODIGO, T1.TIPO, T1.OBS_NF, T1.TOT_SERVICO, T1.SITUACAO, T1.DT_EMISSAO "
		strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLI_NOME "
		'strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNEC_NOME "
		'strSQL = strSQL & "      , T4.NOME AS COLAB_NOME "
		strSQL = strSQL & " FROM NF_NOTA T1 "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T2 ON (T1.COD_CLI = T2.COD_CLIENTE) "
		'strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T3 ON (T1.CODIGO = T3.COD_FORNECEDOR) "
		'strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO = T4.COD_COLABORADOR) "
		strSQL = strSQL & " WHERE COD_NF = " & strCODIGO
		
		'athDebug strSQL, False
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
			'If GetValue(objRS, "TIPO") = "ENT_CLIENTE" Then 
			strNOME = GetValue(objRS, "CLI_NOME")
			'If GetValue(objRS, "TIPO") = "ENT_FORNECEDOR" Then strNOME = GetValue(objRS, "FORNEC_NOME")
			'If GetValue(objRS, "TIPO") = "ENT_COLABORADOR" Then strNOME = GetValue(objRS, "COLAB_NOME")
			
			strMSG = ""
			If GetValue(objRS, "SITUACAO") <> "ABERTO" Then strMSG = strMSG & "Pedido em situação diferente de aberto"
			If CDbl("0" & GetValue(objRS, "TOT_SERVICO")) <= 0 Then strMSG = strMSG & "Pedido com valor inválido para ser faturado"
			
			If strMSG <> "" Then
				Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
				Response.End()
			End If
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  {  }
function submeterForm() { 
	var var_msg = '';
	
	if (document.form_fatura.var_cod_conta.value == '')         var_msg += '\nConta';
	if (document.form_fatura.var_cod_centro_custo.value == '')  var_msg += '\nCentro de Custos';
	if (document.form_fatura.var_cod_plano_conta.value == '')   var_msg += '\nPlano de Contas';
	if (document.form_fatura.var_num_documento.value == '')     var_msg += '\nNum Documento';
	if (document.form_fatura.var_historico.value == '')         var_msg += '\nHistórico';
	
	if (var_msg == '') 
		document.form_fatura.submit(); 
	else {
		alert('Verificar mensagens:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Pedido - Faturamento") %>
<form name="form_fatura" action="Fatura_exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<input type="hidden" name="var_codigo" value="<%=GetValue(objRS, "CODIGO")%>">
	<input type="hidden" name="var_tipo" value="<%=GetValue(objRS, "TIPO")%>">
	<input type="hidden" name="var_dt_emissao" value="<%=GetValue(objRS, "DT_EMISSAO")%>">
	<input type="hidden" name="var_obs" value="<%=GetValue(objRS, "OBS_NF")%>">
	<input type="hidden" name="var_total" value="<%=GetValue(objRS,"TOT_SERVICO")%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass"><%=strNOME%></div>
	<br><div class="form_label">Data Emissão:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_EMISSAO"), True, False)%></div>
	<br><div class="form_label">Observação:</div><div class="form_bypass"><%=GetValue(objRS, "OBS_NF")%></div>
	<br><div class="form_label">Total:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"TOT_SERVICO"),2)%></div>
	<br><div class="form_label">*Conta:</div><select name="var_cod_conta" style="width:230px;"><%
				strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
				strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
				strSQL = strSQL & " ORDER BY NOME "
				
				Set objRSAux = objConn.Execute(strSQL)
				
				Do While Not objRSAux.Eof
					Response.Write("<option value='" & GetValue(objRSAux, "COD_CONTA") & "'>")
					Response.Write(GetValue(objRSAux, "NOME") & "</option>")
					
					objRSAux.MoveNext
				Loop
				
				FechaRecordSet objRSAux
				%>
			</select>
	<br><div class="form_label">*Plano de Conta:</div><select name="var_cod_plano_conta" style="width:307px;"><%
							strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 							&_
									 " FROM FIN_PLANO_CONTA T1 "																&_
									 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_PLANO_CONTA=T2.COD_PLANO_CONTA) " 	&_
									 " WHERE T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY) " 	&_
									 " ORDER BY 2 "
							Set objRSAux = objConn.Execute(stRSQL)
							
							Do While Not objRSAux.Eof
								Response.Write("<option value='" & GetValue(objRSAux, "COD_PLANO_CONTA") & "'>")
								If GetValue(objRSAux, "COD_REDUZIDO") <> "" Then Response.Write(GetValue(objRSAux, "COD_REDUZIDO") & " ")
								Response.Write(GetValue(objRSAux, "NOME") & "</option>")
								
								objRSAux.MoveNext
							Loop
							FechaRecordSet objRSAux
							%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_fatura&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Centro de Custo:</div><%
		strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "	&_
				 " FROM FIN_CENTRO_CUSTO T1 "						&_
				 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) " &_
				 " WHERE T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY) " &_
				 " ORDER BY 2 "
		%><select name="var_cod_centro_custo" style="width:230px;">
			<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME","")%>
		</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_fatura&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Histórico:</div><input name="var_historico" type="text" maxlength="250" style="width:300px;" value="">
	<br><div class="form_label">*Número:</div><input name="var_num_documento" type="text" style="width:115;" value="">
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>
