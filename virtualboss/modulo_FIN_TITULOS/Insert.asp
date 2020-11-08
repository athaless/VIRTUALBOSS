<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim objConn, objRS, strSQL
Dim strCODIGO, strTIPO
Dim strTIPO_CONTA, strTITLE 
Dim strLABEL_ENT, strLABEL_COR
Dim strCOD_CONTA, strLABEL_PARCELA
Dim strCOD_CENTRO_CUSTO, strCOD_PLANO_CONTA, strCOD_NF, strNUM_NF, strVLR_CONTA, strDOCUMENTO, strNUM_DOCUMENTO

AbreDBConn objConn, CFG_DB 

strCOD_CENTRO_CUSTO	= ""
strCOD_PLANO_CONTA	= ""

strCOD_CONTA 		= GetParam("var_chavereg")		
strCOD_PLANO_CONTA 	= GetParam("var_plano_conta")
strCOD_CENTRO_CUSTO = GetParam("var_centro_custo")
strCOD_NF			= GetParam("var_cod_nf")
strNUM_NF			= GetParam("var_num_nf")
strCODIGO			= GetParam("var_codigo")
strTIPO				= GetParam("var_tipo_entidade")
strVLR_CONTA		= GetParam("var_vlr_conta")
strDOCUMENTO		= GetParam("var_documento")
strNUM_DOCUMENTO	= GetParam("var_num_documento")
strTIPO_CONTA 		= GetParam("var_tipo")

if strTIPO_CONTA<>"" then
	strTITLE 			= "Conta a Receber"
	strLABEL_PARCELA	= "contas a receber"
	strLABEL_ENT 		= "Receber de:"
	strLABEL_COR 		= "color:#00C000;" 'verde		

	if strTIPO_CONTA="PG" then
		strTITLE 			= "Conta a Pagar"
		strLABEL_PARCELA 	= "contas a pagar"
		strLABEL_ENT 		= "Pagar para:"		
		strLABEL_COR 		= "color:#FF0000;" 'vermelho
	end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input=var_codigo&var_input_tipo=var_tipo&var_tipo=' + 
					document.form_insert.var_tipo.value,'640','390');
}

//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_cod_conta.value == '')  		var_msg += '\nConta';
	if (document.form_insert.var_codigo.value == '')  			var_msg += '\nCódigo da Entidade';
	if (document.form_insert.var_tipo.value == '')  			var_msg += '\nTipo da Entidade';
	if (document.form_insert.var_cod_centro_custo.value == '')	var_msg += '\nCentro de Custo';
	if (document.form_insert.var_cod_plano_conta.value == '')	var_msg += '\nPlano de Contas';
	if (document.form_insert.var_vlr_conta.value == '') 		var_msg += '\nValor';
	if (document.form_insert.var_documento.value == '')			var_msg += '\nDocumento';
	if (document.form_insert.var_num_documento.value == '')		var_msg += '\nNum Documento';
	if (document.form_insert.var_dt_emissao.value == '')		var_msg += '\nData de Emissão';
	if (document.form_insert.var_dt_vcto.value == '')			var_msg += '\nData de Vencimento';
	if (document.form_insert.var_historico.value == '')			var_msg += '\nHistórico';
	if (((document.form_insert.var_frequencia.value == '') && (document.form_insert.var_parcelas.value != '')) || ((document.form_insert.var_frequencia.value != '') && (document.form_insert.var_parcelas.value == ''))) var_msg += '\nPeriodicidade';
	
	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, strTITLE & " - Inser&ccedil;&atilde;o")%>
<form name="form_insert" action="../modulo_FIN_TITULOS/Insert_exec.asp" method="post">
	<input name="var_tipo_conta" id="var_tipo_conta" type="hidden" value="<%=strTIPO_CONTA%>">
	<input name="var_cod_nf" id="var_cod_nf" type="hidden" value="<%=strCOD_NF%>">
	<input name="var_num_nf" id="var_num_nf" type="hidden" value="<%=strNUM_NF%>">
	<input name="JSCRIPT_ACTION" type="hidden" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input name="DEFAULT_LOCATION" type="hidden" value='../modulo_FIN_TITULOS/insert.asp?var_tipo=<%=strTIPO_CONTA%>'>
	<div class="form_label">*Conta:</div><select name="var_cod_conta" style="width:234px;">
				<%
				strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
				strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
				strSQL = strSQL & " ORDER BY NOME "
				
				Set objRS = objConn.Execute(strSQL)
				
				Do While Not objRS.Eof
					Response.Write("<option value='" & GetValue(objRS, "COD_CONTA") & "'")
					If CStr(strCOD_CONTA) = CStr(GetValue(objRS, "COD_CONTA")) Then Response.Write(" selected")
					Response.Write(">" & GetValue(objRS, "NOME") & "</option>")
					
					objRS.MoveNext
				Loop
				
				FechaRecordSet objRS
				%>
			</select>
	<br><div class="form_label"><font style="<%=strLABEL_COR%>">*<%=strLABEL_ENT%></font></div><input name="var_codigo" type="text" maxlength="10" value="<%=strCODIGO%>" onKeyPress="validateNumKey();" style="vertical-align:bottom; width:40px;"><select name="var_tipo" size="1" style="width:185px;">
							<% MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", strTIPO %>
						</select><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Plano de Conta:</div><select name="var_cod_plano_conta" style="width:307px;">
							<%
							strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 
							strSQL = strSQL & " FROM FIN_PLANO_CONTA T1 " 
							strSQL = strSQL & " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_PLANO_CONTA=T2.COD_PLANO_CONTA) " 
							'strSQL = strSQL & " WHERE T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY) " 
							strSQL = strSQL & " ORDER BY 2 "
							Set objRS = objConn.Execute(stRSQL)
							
							Do While Not objRS.Eof
								Response.Write("<option value='" & GetValue(objRS, "COD_PLANO_CONTA") & "'")
								If CStr(strCOD_PLANO_CONTA) = CStr(GetValue(objRS, "COD_PLANO_CONTA")) Then Response.Write(" selected")
								Response.Write(">")
								If GetValue(objRS, "COD_REDUZIDO") <> "" Then Response.Write(GetValue(objRS, "COD_REDUZIDO") & " ")
								Response.Write(GetValue(objRS, "NOME") & "</option>")
								
								objRS.MoveNext
							Loop
							FechaRecordSet objRS
							%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_insert&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Centro de Custo:</div><%
							strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME " 
							strSQL = strSQL & " FROM FIN_CENTRO_CUSTO T1 " 
							strSQL = strSQL & " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) " 
							'strSQL = strSQL & " WHERE T1.DT_INATIVO IS NULL AND T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY) " 
							strSQL = strSQL & " ORDER BY 2 "
						%><select name="var_cod_centro_custo" style="width:234px;">
							<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME",strCOD_CENTRO_CUSTO)%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_insert&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Valor:</div><input name="var_vlr_conta" type="text" style="width:114px;" maxlength="15" onKeyPress="validateFloatKey();" value="<%=strVLR_CONTA%>">
	<br><div class="form_label">*Tipo Documento:</div><select name="var_documento" style="width:120px;">
							<option value="BOLETO"           <% If strDOCUMENTO = "BOLETO"           Then Response.Write("selected") %>>Boleto</option>
							<option value="CHEQUE"           <% If strDOCUMENTO = "CHEQUE"           Then Response.Write("selected") %>>Cheque</option>
							<option value="DOC"              <% If strDOCUMENTO = "DOC"              Then Response.Write("selected") %>>Doc</option>
							<option value="DUPLICATA"        <% If strDOCUMENTO = "DUPLICATA"        Then Response.Write("selected") %>>Duplicata</option>
							<option value="FATURA"           <% If strDOCUMENTO = "FATURA"           Then Response.Write("selected") %>>Fatura</option>
							<option value="NOTA_FISCAL"      <% If strDOCUMENTO = "NOTA_FISCAL"      Then Response.Write("selected") %>>Nota Fiscal</option>
							<option value="NOTA_PROMISSORIA" <% If strDOCUMENTO = "NOTA_PROMISSORIA" Then Response.Write("selected") %>>Nota Promissória</option>
							<option value="TED"              <% If strDOCUMENTO = "TED"              Then Response.Write("selected") %>>TED</option>
							<option value="OUTROS"           <% If strDOCUMENTO = "OUTROS"           Then Response.Write("selected") %>>Outros</option>
						</select>
	<br><div class="form_label">*Número:</div><input name="var_num_documento" type="text" style="width:114px;" value="<%=strNUM_DOCUMENTO%>">
	<br><div class="form_label">*Data Emissão:</div><%=InputDate("var_dt_emissao","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_emissao", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">*Data Vcto:</div><%=InputDate("var_dt_vcto","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_vcto", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
	<br><div class="form_label">*Histórico:</div><input name="var_historico" type="text" maxlength="250" style="width:307px;">
	<br><div class="form_label">Observação:</div><textarea name="var_obs" rows="6" style="width:307px;"></textarea>
	<br><div class="form_label">Arquivo Anexo:</div><input name="var_arquivo_anexo" type="text" maxlength="250" value="" style="width:180px;"><a href="javascript:UploadArquivo('form_insert','var_arquivo_anexo', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//FIN_Titulos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:middle;" vspace="0" hspace="0"></a>
	<div style="padding-left:110px;"><span class="texto_ajuda"><i>Arquivos de imagens JPEG com altura maior do que 1000 pixels serão redimensionados automaticamente.</i></span></div>
	
	<!-- GRUPO PERIODICIDADE -->
	<div class="form_grupo_collapse" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Periodicidade</b>
		<br><br><div class="form_label"></div><div class="form_bypass">O sistema deve gerar no total</div><input name="var_parcelas" value="" type="text" maxlength="3" style="width:25px; text-align:center;" onFocus="this.value='';" onKeyPress="validateNumKey();"><%=strLABEL_PARCELA%>
		<br><div class="form_label"></div><div class="form_bypass">com freqüência</div><select name="var_frequencia" size="1" style="width:120px;">
					<option value="" selected>[selecione]</option>
					<option value="DIARIA">Diária</option>
					<option value="SEMANAL">Semanal</option>
					<option value="QUINZENAL">Quinzenal</option>
					<option value="MENSAL">Mensal</option>
					<option value="BIMESTRAL">Bimestral</option>
					<option value="TRIMESTRAL">Trimestral</option>
					<option value="SEMESTRAL">Semestral</option>
					<option value="ANUAL">Anual</option>
				</select>
	</div>
	<!-- GRUPO PERIODICIDADE - FIM -->
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
end if
FechaDBConn objConn
%>