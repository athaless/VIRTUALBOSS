<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_CONTAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 

	Dim objConn, objRS, objRSAux, strSQL
	Dim strCODIGO, auxAVISO, strTOTAL, strNOME
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	auxAVISO  = "dlg_info.gif:Será gerado um ou mais títulos para o contrato. " &_ 
				"Para confirmar clique no botão [ok], para desistir clique em [cancelar]."
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT T1.CODIGO, T1.TIPO "
		strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLIENTE "
		strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNECEDOR "
		strSQL = strSQL & "      , T4.NOME AS COLABORADOR "
		strSQL = strSQL & "      , T1.COD_CONTRATO, T1.CODIFICACAO, T1.TITULO, T1.DT_INI, T1.DT_FIM "
		strSQL = strSQL & "      , T1.DT_ASSINATURA, T1.TP_RENOVACAO, T1.TP_COBRANCA, T1.SITUACAO, T1.DOC_CONTRATO "
		strSQL = strSQL & "      , T1.OBS, T1.FREQUENCIA, T1.NUM_PARC, T1.VLR_PARC, T1.NUM_PARC * T1.VLR_PARC AS VLR_TOTAL "
		strSQL = strSQL & "      , T1.DT_BASE_VCTO, T1.COD_SERVICO, T5.TITULO AS SERVICO "
		strSQL = strSQL & " FROM CONTRATO T1 "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T2 ON (T1.CODIGO = T2.COD_CLIENTE) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T3 ON (T1.CODIGO = T3.COD_FORNECEDOR) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO = T4.COD_COLABORADOR) "
		strSQL = strSQL & " LEFT OUTER JOIN SV_SERVICO T5 ON (T1.COD_SERVICO = T5.COD_SERVICO) "
		strSQL = strSQL & " WHERE COD_CONTRATO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
			If GetValue(objRS, "VLR_TOTAL") <> "" Then strTOTAL = "(Total: " & FormatNumber(GetValue(objRS, "VLR_TOTAL"), 2) & ")"
			
			If GetValue(objRS, "TIPO") = "ENT_CLIENTE" Then strNOME = GetValue(objRS, "CLIENTE")
			If GetValue(objRS, "TIPO") = "ENT_FORNECEDOR" Then strNOME = GetValue(objRS, "FORNECEDOR")
			If GetValue(objRS, "TIPO") = "ENT_COLABORADOR" Then strNOME = GetValue(objRS, "COLABORADOR")
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
function aplicar()  { }
function submeterForm() { 
	var var_msg = '';
	
	/*
	if (document.form_insert.var_chavereg.value == '') var_msg += '\nParâmetro inválido para contrato';
	if (document.form_insert.var_frequencia.value == '') var_msg += '\nInformar freqüência';
	if (document.form_insert.var_num_parc.value == '') var_msg += '\nInformar número de parcelas';
	if (document.form_insert.var_vlr_parc.value == '') var_msg += '\nInformar valor da parcela';
	if (document.form_insert.var_dt_base_vcto.value == '') var_msg += '\nInformar data base de vencimento';
	if (document.form_insert.var_cod_conta.value == '') var_msg += '\nInformar conta bancária';
	if (document.form_insert.var_cod_plano_conta.value == '') var_msg += '\nInformar plano de conta';
	if (document.form_insert.var_cod_centro_custo.value == '') var_msg += '\nInformar centro de custo';
	if (document.form_insert.var_historico.value == '') var_msg += '\nInformar histórico';
	if (document.form_insert.var_num_documento.value == '') var_msg += '\nInformar número do documento';
	
	if (((document.form_insert.var_num_parc.value == '1') && (document.form_insert.var_frequencia.value != 'UMA_VEZ')) || ((document.form_insert.var_num_parc.value != '1') && (document.form_insert.var_frequencia.value == 'UMA_VEZ'))) var_msg += '\nNúmero de parcelas e freqüência não conferem';
	
	if ((document.form_insert.var_tp_cobranca.value != 'PAGAR') && (document.form_insert.var_tp_cobranca.value != 'RECEBER')) var_msg += '\nTipo de cobrança a ser gerado é indefinido';
	*/
	
	if (var_msg == '') 
		document.form_insert.submit(); 
	else {
		alert('Verificar mensagens:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Contrato - Geração de Título") %>
<form name="form_insert" action="GerarTitulo_Exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<input type="hidden" name="var_frequencia" value="<%=GetValue(objRS, "FREQUENCIA")%>">
	<input type="hidden" name="var_num_parc" value="<%=GetValue(objRS, "NUM_PARC")%>">
	<input type="hidden" name="var_vlr_parc" value="<%=GetValue(objRS, "VLR_PARC")%>">
	<input type="hidden" name="var_dt_base_vcto" value="<%=GetValue(objRS, "DT_BASE_VCTO")%>">
	<input type="hidden" name="var_codigo" value="<%=GetValue(objRS, "CODIGO")%>">
	<input type="hidden" name="var_tipo" value="<%=GetValue(objRS, "TIPO")%>">
	<input type="hidden" name="var_tp_cobranca" value="<%=GetValue(objRS, "TP_COBRANCA")%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Título:</div><div class="form_bypass"><%=GetValue(objRS, "TITULO")%></div>
	<br><div class="form_label">Codificação:</div><div class="form_bypass"><%=GetValue(objRS, "CODIFICACAO")%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass"><%=GetValue(objRS, "CODIGO")%> - <%=strNOME%></div>
	<br><div class="form_label">Serviço:</div><div class="form_bypass"><%=GetValue(objRS, "COD_SERVICO")%> - <%=GetValue(objRS, "SERVICO")%></div>
	<br><div class="form_label">Documento:</div><div class="form_bypass"><%=GetValue(objRS, "DOC_CONTRATO")%></div>
	<br><div class="form_label">Obs:</div><div class="form_bypass"><%=GetValue(objRS, "OBS")%></div>
	<br><div class="form_label">Dt Início:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_INI"), True, False)%></div>
	<br><div class="form_label">Dt Fim:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_FIM"), True, False)%></div>
	<br><div class="form_label">Dt Assinatura:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_ASSINATURA"), True, False)%></div>
	<br><div class="form_label">Num de Parcelas:</div><div class="form_bypass"><strong><%=GetValue(objRS, "NUM_PARC")%></strong></div>
	<br><div class="form_label">Vlr Parcela:</div><div class="form_bypass"><strong><% If GetValue(objRS, "VLR_PARC") <> "" Then Response.Write(FormatNumber(GetValue(objRS, "VLR_PARC"), 2)) %></strong></div>&nbsp;&nbsp;<div class="form_bypass"><%=strTOTAL%></div>
	<br><div class="form_label">Freqüência:</div><div class="form_bypass"><% 
	If GetValue(objRS, "FREQUENCIA") = "UMA_VEZ"    Then Response.Write("Uma vez apenas")
	If GetValue(objRS, "FREQUENCIA") = "DIARIA"     Then Response.Write("Diária")
	If GetValue(objRS, "FREQUENCIA") = "SEMANAL"    Then Response.Write("Semanal")
	If GetValue(objRS, "FREQUENCIA") = "QUINZENAL"  Then Response.Write("Quinzenal")
	If GetValue(objRS, "FREQUENCIA") = "MENSAL"     Then Response.Write("Mensal")
	If GetValue(objRS, "FREQUENCIA") = "BIMESTRAL"  Then Response.Write("Bimestral")
	If GetValue(objRS, "FREQUENCIA") = "TRIMESTRAL" Then Response.Write("Trimestral")
	If GetValue(objRS, "FREQUENCIA") = "SEMESTRAL"  Then Response.Write("Semestral")
	If GetValue(objRS, "FREQUENCIA") = "ANUAL"      Then Response.Write("Anual")
	%></div>
	<br><div class="form_label">Dt Base de Vcto:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_BASE_VCTO"), True, False)%></div>
	<br><div class="form_label">Cobrança:</div><div class="form_bypass"><% 
	If GetValue(objRS, "TP_COBRANCA") = "PAGAR"   Then Response.Write("a Pagar")
	If GetValue(objRS, "TP_COBRANCA") = "RECEBER" Then Response.Write("a Receber")
	%></div>
	<br><div class="form_label">*Conta:</div><select name="var_cod_conta" style="width:230px;"><%
				strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
				strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
				strSQL = strSQL & " ORDER BY  NOME "
				
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
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_insert&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Centro de Custo:</div><%
		strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "	&_
				 " FROM FIN_CENTRO_CUSTO T1 "						&_
				 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) " &_
				 " WHERE T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY) " &_
				 " ORDER BY 2 "
		%><select name="var_cod_centro_custo" style="width:230px;">
			<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME","")%>
		</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_insert&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Histórico:</div><input name="var_historico" type="text" maxlength="250" style="width:300px;" value="Contrato <%=GetValue(objRS, "CODIFICACAO")%>">
	<br><div class="form_label">*Número:</div><input name="var_num_documento" type="text" style="width:115;" value="<%=GetValue(objRS, "CODIFICACAO")%>">
	<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="6" style="width:305px;"></textarea>
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
