<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim objConn, objRS, objRSAux, strSQL
Dim strLABEL_ENT, strLABEL_COR
Dim strLABEL_PARCELA
Dim strCOD_CONTA_PAGAR_RECEBER, strMSG, strEDICAO_TOTAL

AbreDBConn objConn, CFG_DB 

 strCOD_CONTA_PAGAR_RECEBER = GetParam("var_chavereg")
 
 if strCOD_CONTA_PAGAR_RECEBER <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT "											&_
				"	T1.COD_CONTA_PAGAR_RECEBER "					&_
				",	T1.TIPO "										&_
				",	T1.CODIGO "										&_
				",	T1.DT_EMISSAO "									&_
				",	T1.HISTORICO "									&_
				",	T1.TIPO_DOCUMENTO "								&_
				",	T1.NUM_DOCUMENTO "								&_
				",	T1.PAGAR_RECEBER "								&_
				",	T1.DT_VCTO "									&_
				",	T1.VLR_CONTA "									&_
				",	T2.NOME AS CONTA "								&_
				",	T1.COD_CONTA "									&_
				",	T1.SITUACAO "									&_
				",	T1.OBS "										&_
				",	T3.NOME AS PLANO_CONTA "						&_
				",	T3.COD_PLANO_CONTA "							&_
				",	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO "	&_
				",	T4.NOME AS CENTRO_CUSTO "						&_
				",	T4.COD_CENTRO_CUSTO "							&_
				",	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO "	&_
				",	T1.COD_NF "										&_
				",	T1.NUM_NF "										&_
				",	T1.ARQUIVO_ANEXO "								&_
				",	T1.MARCA_NFE "									&_
				",	T1.COD_CONTRATO "								&_
				",	T1.MARCA_NFE "									&_
				",	T5.CODIFICACAO "								&_
				"FROM FIN_CONTA_PAGAR_RECEBER AS T1 " 				&_
				"LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) " 	&_
				"LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) " 	&_
				"LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	&_
				"LEFT OUTER JOIN CONTRATO AS T5 ON (T1.COD_CONTRATO=T5.COD_CONTRATO) " 	&_
				"WHERE T1.COD_CONTA_PAGAR_RECEBER=" & strCOD_CONTA_PAGAR_RECEBER
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
		if GetValue(objRS,"PAGAR_RECEBER") <> "0" then
			strLABEL_PARCELA = "Conta a Pagar"
			strLABEL_ENT     = "Pagar para:"		
			strLABEL_COR     = "color:#FF0000;" 'vermelho
		else
			strLABEL_PARCELA = "Conta a Receber"
			strLABEL_ENT     = "Receber de:"
			strLABEL_COR     = "color:#00C000;" 'verde		
		end if
		
		strMSG = ""
		If GetValue(objRS, "SITUACAO") = "CANCELADA" Then strMSG = strMSG & "Conta está cancelada<br>"
		'If GetValue(objRS, "SITUACAO") <> "ABERTA" Then strMSG = strMSG & "Conta em situação diferente de aberta<br>"
		'If GetValue(objRS, "COD_NF") <> "" Then strMSG = strMSG & "Conta possui uma Nota Fiscal associada<br>"
		'If GetValue(objRS, "MARCA_NFE") = "COM_NFE" Then strMSG = strMSG & "Conta possui taxas calculadas e está marcada como tendo NFe<br>"
		
		strEDICAO_TOTAL = "F"
		If GetValue(objRS, "SITUACAO") = "ABERTA" And (GetValue(objRS, "MARCA_NFE") = "SEM_NFE" Or GetValue(objRS, "MARCA_NFE") = "") Then
			strEDICAO_TOTAL = "T"
		End If
		
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
<script language="JavaScript" type="text/javascript">
function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update&var_input=var_codigo&var_input_tipo=var_tipo&var_tipo=' + 
					document.form_update.var_tipo.value,'640','390');
}

//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if ('<%=strEDICAO_TOTAL%>' == 'T') {
		if (document.form_update.var_cod_conta.value == '')         var_msg += '\nConta';
		if (document.form_update.var_codigo.value == '')            var_msg += '\nCódigo da Entidade';
		if (document.form_update.var_tipo.value == '')              var_msg += '\nTipo da Entidade';
		if (document.form_update.var_cod_centro_custo.value == '')  var_msg += '\nCentro de Custos';
		if (document.form_update.var_cod_plano_conta.value == '')   var_msg += '\nPlano de Contas';
		if (document.form_update.var_vlr_conta.value == '')         var_msg += '\nValor';
		if (document.form_update.var_documento.value == '')         var_msg += '\nDocumento';
		if (document.form_update.var_num_documento.value == '')     var_msg += '\nNum Documento';
		if (document.form_update.var_dt_emissao.value == '')        var_msg += '\nData de Emissão';
		if (document.form_update.var_dt_vcto.value == '')           var_msg += '\nData de Vencimento';
		if (document.form_update.var_historico.value == '')         var_msg += '\nHistórico';
	}
	
	if (var_msg == '')
		document.form_update.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, strLABEL_PARCELA & " - Altera&ccedil;&atilde;o")%>
<form name="form_update" action="Update_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="Update.asp?var_chavereg=<%=strCOD_CONTA_PAGAR_RECEBER%>">
	<input type="hidden" name="var_cod_chavereg" value="<%=strCOD_CONTA_PAGAR_RECEBER%>">
	<input type="hidden" name="var_arquivo_anexo_orig" value="<%=GetValue(objRS, "ARQUIVO_ANEXO")%>">
	<input type="hidden" name="var_edicao_total" value="<%=strEDICAO_TOTAL%>">
	<% If strEDICAO_TOTAL = "T" Then %>
		<div class="form_label">Cod:</div><div class="form_bypass"><%=strCOD_CONTA_PAGAR_RECEBER%></div>
		<% If GetValue(objRS, "COD_CONTRATO") <> "" Then %>
			<br><div class="form_label">Contrato:</div><div class="form_bypass"><%=GetValue(objRS, "COD_CONTRATO")%> - <%=GetValue(objRS, "CODIFICACAO")%></div>
		<% End If %>
		<br><div class="form_label">*Conta:</div><select name="var_cod_conta" style="width:234px;"><%
			strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
			strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
			strSQL = strSQL & " ORDER BY ORDEM, NOME "
			
			Set objRSAux = objConn.Execute(strSQL)
			
			Do While Not objRSAux.Eof
				Response.Write("<option value='" & GetValue(objRSAux, "COD_CONTA") & "'")
				If CStr(GetValue(objRS, "COD_CONTA")) = CStr(GetValue(objRSAux, "COD_CONTA")) Then Response.Write(" selected")
				Response.Write(">" & GetValue(objRSAux, "NOME") & "</option>")
				
				objRSAux.MoveNext
			Loop
			
			FechaRecordSet objRSAux
			%>
		</select>
		<br><div class="form_label" style="<%=strLABEL_COR%>">*<%=strLABEL_ENT%></div><input name="var_codigo" type="text" maxlength="10" value="<%=GetValue(objRS, "CODIGO")%>" onKeyPress="validateNumKey();" style="vertical-align:bottom; width:40px;"><select name="var_tipo" size="1" style="width:185px;"><%
		 MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", GetValue(objRS, "TIPO") %></select><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
		<br><div class="form_label">*Plano de Conta:</div><select name="var_cod_plano_conta" style="width:307px;">
								<%
								Response.Write("<option value='" & GetValue(objRS, "COD_PLANO_CONTA") & "' selected='selected'>")
								If (GetValue(objRS, "PLANO_CONTA_COD_REDUZIDO") <> "") Then Response.Write(GetValue(objRS, "PLANO_CONTA_COD_REDUZIDO") & " ")
								Response.Write(GetValue(objRS, "PLANO_CONTA"))
								Response.Write("</option>")
								
								strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 							&_
										 " FROM FIN_PLANO_CONTA T1 "																&_
										 " INNER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_PLANO_CONTA = T2.COD_PLANO_CONTA) " 	&_
										 " WHERE T1.DT_INATIVO IS NULL " &_
										 " AND T2.DT_EMISSAO > DATE_SUB(CURDATE(), INTERVAL 60 DAY) " &_
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
							</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_update&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
		<br><div class="form_label">*Centro de Custo:</div><%
								strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "												&_
										 " FROM FIN_CENTRO_CUSTO T1 "																	&_
										 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) "	&_
										 " WHERE T1.DT_INATIVO IS NULL " &_
										 " AND ((T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_CENTRO_CUSTO = " & GetValue(objRS, "COD_CENTRO_CUSTO") & ")) " 		&_
										 " ORDER BY 2 "
							%><select name="var_cod_centro_custo" style="width:234px;">
								<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME",GetValue(objRS, "COD_CENTRO_CUSTO"))%>
							</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_update&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a> 
		<br><div class="form_label">*Valor:</div><input name="var_vlr_conta" type="text" style="width:114px;" maxlength="15" onKeyPress="validateFloatKey();" value="<% If GetValue(objRS, "VLR_CONTA") <> "" Then Response.Write(FormatNumber(GetValue(objRS, "VLR_CONTA"), 2)) %>">
		<br><div class="form_label">*Tipo Documento:</div><select name="var_documento" style="width:120px;">
								<option value="BOLETO"           <% If GetValue(objRS, "DOCUMENTO") = "BOLETO"           Then Response.Write("selected") %>>Boleto</option>
								<option value="CHEQUE"           <% If GetValue(objRS, "DOCUMENTO") = "CHEQUE"           Then Response.Write("selected") %>>Cheque</option>
								<option value="DOC"              <% If GetValue(objRS, "DOCUMENTO") = "DOC"              Then Response.Write("selected") %>>Doc</option>
								<option value="DUPLICATA"        <% If GetValue(objRS, "DOCUMENTO") = "DUPLICATA"        Then Response.Write("selected") %>>Duplicata</option>
								<option value="FATURA"           <% If GetValue(objRS, "DOCUMENTO") = "FATURA"           Then Response.Write("selected") %>>Fatura</option>
								<option value="NOTA_FISCAL"      <% If GetValue(objRS, "DOCUMENTO") = "NOTA_FISCAL"      Then Response.Write("selected") %>>Nota Fiscal</option>
								<option value="NOTA_PROMISSORIA" <% If GetValue(objRS, "DOCUMENTO") = "NOTA_PROMISSORIA" Then Response.Write("selected") %>>Nota Promissória</option>
								<option value="TED"              <% If GetValue(objRS, "DOCUMENTO") = "TED"              Then Response.Write("selected") %>>TED</option>
								<option value="OUTROS"           <% If GetValue(objRS, "DOCUMENTO") = "OUTROS"           Then Response.Write("selected") %>>Outros</option>
							</select>
		<br><div class="form_label">*Número:</div><input name="var_num_documento" type="text" style="width:114px;" value="<%=GetValue(objRS, "NUM_DOCUMENTO")%>">
		<br><div class="form_label">*Data Emissão:</div><%=InputDate("var_dt_emissao","",GetValue(objRS,"DT_EMISSAO"),false)%><%=ShowLinkCalendario("form_update", "var_dt_emissao", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
		<br><div class="form_label">Data Vcto:</div><%=InputDate("var_dt_vcto","",GetValue(objRS,"DT_VCTO"),false)%><%=ShowLinkCalendario("form_update", "var_dt_vcto", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
		<br><div class="form_label">*Histórico:</div><input name="var_historico" type="text" maxlength="250" style="width:307px;" value="<%=GetValue(objRS, "HISTORICO")%>">
		<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="6" style="width:307px;"><%=GetValue(objRS, "OBS")%></textarea>
		<br><div class="form_label">Arquivo Anexo:</div><input name="var_arquivo_anexo" type="text" maxlength="250" value="<%=GetValue(objRS, "ARQUIVO_ANEXO")%>" style="width:180px;"><a href="javascript:UploadArquivo('form_update','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//FIN_Titulos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:middle;" vspace="0" hspace="0"></a>
		<div style="padding-left:110px;"><span class="texto_ajuda"><i>Arquivos de imagens JPEG com altura maior do que 1000 pixels serão redimensionados automaticamente.</i></span></div>
	<% Else %>
		<div class="form_label">Cod:</div><div class="form_bypass"><%=strCOD_CONTA_PAGAR_RECEBER%></div>
		<% If GetValue(objRS, "COD_CONTRATO") <> "" Then %>
			<br><div class="form_label">Contrato:</div><div class="form_bypass"><%=GetValue(objRS, "COD_CONTRATO")%> - <%=GetValue(objRS, "CODIFICACAO")%></div>
		<% End If %>
		<br><div class="form_label">Conta:</div><div class="form_bypass"><%=GetValue(objRS, "CONTA")%></div>
		<br><div class="form_label" style="<%=strLABEL_COR%>">*<%=strLABEL_ENT%></div><div class="form_bypass"><%
		if GetValue(objRS,"TIPO")="ENT_CLIENTE"	    and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE WHERE COD_CLIENTE =" & GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR	WHERE COD_FORNECEDOR =" & GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & GetValue(objRS,"CODIGO")
		Dim strENTIDADE
		strENTIDADE=""
		if strSQL<>"" then
			AbreRecordSet objRSAux, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
			if not objRSAux.Eof then strENTIDADE = GetValue(objRSAux, "NOME")
			FechaRecordSet objRSAux
		end if
		Response.Write(strENTIDADE)
		%></div>
		<br><div class="form_label">Plano de Conta:</div><div class="form_bypass"><%=GetValue(objRS, "PLANO_CONTA_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS, "PLANO_CONTA")%></div>
		<br><div class="form_label">Centro de Custo:</div><div class="form_bypass"><%=GetValue(objRS, "CENTRO_CUSTO_COD_REDUZIDO")%>&nbsp;<%=GetValue(objRS, "CENTRO_CUSTO")%></div>
		<br><div class="form_label">Valor:</div><div class="form_bypass"><%=FormatNumber(GetValue(objRS, "VLR_CONTA"), 2)%></div>
		<br><div class="form_label">Tipo Documento:</div><div class="form_bypass"><%
		If GetValue(objRS, "TIPO_DOCUMENTO") = "BOLETO"           Then Response.Write("Boleto")
		If GetValue(objRS, "TIPO_DOCUMENTO") = "CHEQUE"           Then Response.Write("Cheque")
		If GetValue(objRS, "TIPO_DOCUMENTO") = "DOC"              Then Response.Write("Doc")
		If GetValue(objRS, "TIPO_DOCUMENTO") = "DUPLICATA"        Then Response.Write("Duplicata")
		If GetValue(objRS, "TIPO_DOCUMENTO") = "FATURA"           Then Response.Write("Fatura")
		If GetValue(objRS, "TIPO_DOCUMENTO") = "NOTA_FISCAL"      Then Response.Write("Nota Fiscal")
		If GetValue(objRS, "TIPO_DOCUMENTO") = "NOTA_PROMISSORIA" Then Response.Write("Nota Promissória")
		If GetValue(objRS, "TIPO_DOCUMENTO") = "TED"              Then Response.Write("TED")
		If GetValue(objRS, "TIPO_DOCUMENTO") = "OUTROS"           Then Response.Write("Outros")
		%></div>
		<br><div class="form_label">Número:</div><div class="form_bypass"><%=GetValue(objRS, "NUM_DOCUMENTO")%></div>
		<br><div class="form_label">Data Emissão:</div><div class="form_bypass"><%=PrepData(GetValue(objRS,"DT_EMISSAO"), True, False)%></div>
		<br><div class="form_label">Data Vcto:</div><div class="form_bypass"><%=PrepData(GetValue(objRS,"DT_VCTO"), True, False)%></div>
		<br><div class="form_label">*Histórico:</div><div class="form_bypass"><%=GetValue(objRS, "HISTORICO")%></div>
		<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="6" style="width:307px;"><%=GetValue(objRS, "OBS")%></textarea>
		<br><div class="form_label">Arquivo Anexo:</div><input name="var_arquivo_anexo" type="text" maxlength="250" value="<%=GetValue(objRS, "ARQUIVO_ANEXO")%>" style="width:180px;"><a href="javascript:UploadArquivo('form_update','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//FIN_Titulos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:middle;" vspace="0" hspace="0"></a>
		<div style="padding-left:110px;"><span class="texto_ajuda"><i>Arquivos de imagens JPEG com altura maior do que 1000 pixels serão redimensionados automaticamente.</i></span></div>
	<% End If %>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
	FechaDBConn objConn
end if
%>