<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "dlg_warning.gif:Para confirmar clique no bot�o [ok], para desistir clique em [cancelar]." '"<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

	Dim objConn, objRS, strSQL
	Dim strCODIGO, strNOME
	Dim strCOM_TITULOS, strQTDE_ABERTA, strQTDE_LCTO_PARCIAL, strQTDE_LCTO_TOTAL, strQTDE_CANCELADO, strACAO, strROTULO_ACAO
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL =          " SELECT T1.CODIGO, T1.TIPO, T1.CODIFICACAO "
		strSQL = strSQL & "      , T2.NOME_FANTASIA AS CLIENTE "
		strSQL = strSQL & "      , T3.NOME_FANTASIA AS FORNECEDOR "
		strSQL = strSQL & "      , T4.NOME AS COLABORADOR "
		strSQL = strSQL & "      , T1.COD_CONTRATO, T1.CODIFICACAO, T1.TITULO, T1.DT_INI, T1.DT_FIM "
		strSQL = strSQL & "      , T1.DT_ASSINATURA, T1.TP_RENOVACAO, T1.TP_COBRANCA, T1.SITUACAO, T1.DOC_CONTRATO "
		strSQL = strSQL & "      , T1.OBS, T1.FREQUENCIA, T1.NUM_PARC, T1.VLR_TOTAL "
		strSQL = strSQL & "      , T1.DT_BASE_VCTO, T1.ALIQ_ISSQN_SERVICO "
		strSQL = strSQL & "      , T1.SYS_DT_INSERCAO, T1.SYS_INS_ID_USUARIO "
		strSQL = strSQL & " FROM CONTRATO T1 "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_CLIENTE T2 ON (T1.CODIGO = T2.COD_CLIENTE) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_FORNECEDOR T3 ON (T1.CODIGO = T3.COD_FORNECEDOR) "
		strSQL = strSQL & " LEFT OUTER JOIN ENT_COLABORADOR T4 ON (T1.CODIGO = T4.COD_COLABORADOR) "
		strSQL = strSQL & " WHERE COD_CONTRATO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
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
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok() 		{ submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { }
function submeterForm() { 
	var var_msg = '';
	
	if (document.form_delete.var_chavereg.value == '') var_msg += '\nPar�metro inv�lido para contrato';
	
	if (var_msg == '') 
		document.form_delete.submit(); 
	else {
		alert('Verificar mensagens:\n' + var_msg);
	}
}
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
	<% 
	If(GetValue(objRS, "SITUACAO") = "ABERTO") Then
   		Response.Write athBeginDialog(WMD_WIDTH, "Contrato - Dele��o")
		strACAO        = "DELETA" 
		strROTULO_ACAO = "Dele��o"
	ElseIf(GetValue(objRS, "SITUACAO") = "FATURADO") Then
		Response.Write athBeginDialog(WMD_WIDTH, "Contrato - Cancelamento")
		strACAO        = "CANCELA" 
		strROTULO_ACAO = "Cancelamento"		
	End If	          
	%>
<form name="form_delete" action="Delete_Exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<input type="hidden" name="var_situacao" value="<%=GetValue(objRS,"SITUACAO")%>">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">T�tulo:</div><div class="form_bypass"><%=GetValue(objRS, "TITULO")%></div>
	<br><div class="form_label">Codifica��o:</div><div class="form_bypass"><%=GetValue(objRS, "CODIFICACAO")%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass"><%=GetValue(objRS, "CODIGO")%> - <%=strNOME%></div>
	<br><div class="form_label">Al�quota ISSQN:</div><div class="form_bypass"><% If GetValue(objRS, "ALIQ_ISSQN_SERVICO") <> "" Then Response.Write(FormatNumber(GetValue(objRS, "ALIQ_ISSQN_SERVICO"), 2)) %></div>
	<br><div class="form_label">Documento:</div><div class="form_bypass"><%
	If GetValue(objRS,"DOC_CONTRATO") <> "" Then
		Response.Write("<a href='../upload/" & Request.Cookies("VBOSS")("CLINAME") & "/CONTRATOS/" & GetValue(objRS,"DOC_CONTRATO") & "' target='_blank'>" & GetValue(objRS,"DOC_CONTRATO") & "</a>")
	End If
	%></div>
	<br><div class="form_label">Observa��o:</div><div class="form_bypass_multiline"><%=GetValue(objRS, "OBS")%></div>
	<br><div class="form_label">Vig�ncia:</div><div class="form_bypass">de <%=PrepData(GetValue(objRS, "DT_INI"), True, False)%> a <%=PrepData(GetValue(objRS, "DT_FIM"), True, False)%></div>
	<br><div class="form_label">Assinatura:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_ASSINATURA"), True, False)%></div>
	<br><div class="form_label">Vlr Total:</div><div class="form_bypass"><strong><% If GetValue(objRS, "VLR_TOTAL") <> "" Then Response.Write(FormatNumber(GetValue(objRS, "VLR_TOTAL"), 2)) %></strong></div>
	<br><div class="form_label">Parcelas:</div><div class="form_bypass"><strong><%=GetValue(objRS, "NUM_PARC")%></strong></div>
	<br><div class="form_label">Freq��ncia:</div><div class="form_bypass"><% 
	If GetValue(objRS, "FREQUENCIA") = ""           Then Response.Write("")
	If GetValue(objRS, "FREQUENCIA") = "DIARIA"     Then Response.Write("Di�ria")
	If GetValue(objRS, "FREQUENCIA") = "SEMANAL"    Then Response.Write("Semanal")
	If GetValue(objRS, "FREQUENCIA") = "QUINZENAL"  Then Response.Write("Quinzenal")
	If GetValue(objRS, "FREQUENCIA") = "MENSAL"     Then Response.Write("Mensal")
	If GetValue(objRS, "FREQUENCIA") = "BIMESTRAL"  Then Response.Write("Bimestral")
	If GetValue(objRS, "FREQUENCIA") = "TRIMESTRAL" Then Response.Write("Trimestral")
	If GetValue(objRS, "FREQUENCIA") = "SEMESTRAL"  Then Response.Write("Semestral")
	If GetValue(objRS, "FREQUENCIA") = "ANUAL"      Then Response.Write("Anual")
	%></div>
	<br><div class="form_label">Dt Base de Vcto:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "DT_BASE_VCTO"), True, False)%></div>
	<br><div class="form_label">Gerar Cobran�a:</div><div class="form_bypass"><% 
	If GetValue(objRS, "TP_COBRANCA") = "PAGAR"   Then Response.Write("A Pagar")
	If GetValue(objRS, "TP_COBRANCA") = "RECEBER" Then Response.Write("A Receber")
	%></div>
	<br><div class="form_label">Quem inseriu:</div><div class="form_bypass">Por <%=GetValue(objRS, "SYS_INS_ID_USUARIO")%>, em <%=PrepData(GetValue(objRS, "SYS_DT_INSERCAO"), True, True)%></div>    
	<br><div class="form_label">*A��o:</div><input type="radio" name="var_acao" id="var_acao" value="<%=strACAO%>" checked="checked" class="inputclean"><div class="form_bypass"><%=strROTULO_ACAO%></div>
   	<br><div class="form_label">Motivo:</div><textarea name="var_motivo" rows="6"></textarea>
    <%If(GetValue(objRS, "SITUACAO") = "FATURADO") Then%>    
	<br><div class="form_label">T�tulos em aberto:</div><select name="var_acao_tit_aberto" size="1" style="width:70px;">
													<option value="CANCELAR"        >Cancelar</option>
													<option value="DELETAR" selected>Deletar </option>
												</select><span class="texto_ajuda">T�tulos parciais e/ou quitados n�o ser�o alterados.</span>                                                       
	<%End If%>
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
