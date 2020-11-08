<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

Dim objConn, objRS1, objRS2, strSQL
Dim intCOD_NF, i, strMSG

AbreDBConn objConn, CFG_DB 

intCOD_NF = GetParam("var_chavereg")

if intCOD_NF<>"" then
	strSQL =          " SELECT T1.NUM_NF "
	strSQL = strSQL & "	     , T1.SERIE "
	strSQL = strSQL & "	     , T1.COD_CLI "
	strSQL = strSQL & "	     , T1.CLI_NOME "
	strSQL = strSQL & "	     , T1.TOT_NF "
	strSQL = strSQL & "	     , T1.SITUACAO "
	strSQL = strSQL & "	     , T1.DT_EMISSAO "
	strSQL = strSQL & "	     , COUNT(T2.COD_NF) AS TOTAL "
	strSQL = strSQL & " FROM NF_NOTA T1 "
	strSQL = strSQL & " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_NF = T2.COD_NF) "
	strSQL = strSQL & " WHERE T1.SYS_DTT_INATIVO IS NULL "
	strSQL = strSQL & " AND T1.COD_NF = " & intCOD_NF
	strSQL = strSQL & " GROUP BY T1.NUM_NF "
	strSQL = strSQL & "	       , T1.SERIE "
	strSQL = strSQL & "	       , T1.COD_CLI "
	strSQL = strSQL & "	       , T1.CLI_NOME "
	strSQL = strSQL & "	       , T1.TOT_NF "
	strSQL = strSQL & "	       , T1.SITUACAO "
	strSQL = strSQL & "	       , T1.DT_EMISSAO "
	
	AbreRecordSet objRS1, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if objRS1.eof then
		strMSG = "Nota Fiscal n�o encontrada"
		
		Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
		Response.End()
	else
		strMSG = ""
		if GetValue(objRS1, "TOTAL") <> "0"          then strMSG = strMSG & "J� existe uma conta a receber associada � Nota Fiscal"
		if GetValue(objRS1, "SITUACAO") <> "EMITIDA" then strMSG = strMSG & "Situa��o da Nota Fiscal � diferente de <b>emitida</b>"
		
		if strMSG <> "" then
			Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
			Response.End()
		end if
		
		strSQL =          " SELECT COD_CONTA_PAGAR_RECEBER, DT_EMISSAO, DT_VCTO, VLR_CONTA, HISTORICO, SITUACAO "
		strSQL = strSQL & " FROM FIN_CONTA_PAGAR_RECEBER "
		strSQL = strSQL & " WHERE PAGAR_RECEBER = 0 "
		strSQL = strSQL & " AND COD_NF IS NULL "
		strSQL = strSQL & " AND SYS_DT_CANCEL IS NULL "
		strSQL = strSQL & " AND TIPO = 'ENT_CLIENTE' "
		strSQL = strSQL & " AND CODIGO = '" & GetValue(objRS1, "COD_CLI") & "'"
		strSQL = strSQL & " AND VLR_CONTA = " & FormataDouble(GetValue(objRS1, "TOT_NF"))
		
		AbreRecordSet objRS2, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		
		if objRS2.Eof then
			strMSG = "N�o existe nenhuma conta a receber deste CLIENTE e com o MESMO VALOR que possa ser associada � Nota Fiscal"
			
			Mensagem strMSG, "Javascript:history.back();", "Voltar", 1
			Response.End()
		else
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
	//****** Fun��es de a��o dos bot�es - In�cio ******
	function ok() 		{ document.formassociar.var_location.value = ""; submeterForm(); }
	function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
	function aplicar()  { }
	function submeterForm() {
		var var_msg = '';
		
		if (var_msg == ''){
			document.formassociar.submit();
		} else{
			alert('Favor verificar campos obrigat�rios:\n' + var_msg);
		}
	}
	//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Nota Fiscal - Associa��o a uma Conta a Receber")%>
<form name="formassociar" action="AssociarTitulo_Exec.asp" method="post">
	<input name="var_cod_nf" type="hidden" value="<%=intCOD_NF%>">
	<input name="var_num_nf" type="hidden" value="<%=GetValue(objRS1, "NUM_NF")%>">
	<input type="hidden" name="var_jscript_action"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="var_location" value="">
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Dados da Nota Fiscal</b><br>
		<br><div class="form_label">Cliente:</div><div class="form_bypass"><%=GetValue(objRS1, "CLI_NOME")%></div>
		<br><div class="form_label">Num NF:</div><div class="form_bypass"><%=GetValue(objRS1, "NUM_NF")%></div>
		<br><div class="form_label">Vlr Total:</div><div class="form_bypass"><%=FormatNumber(GetValue(objRS1, "TOT_NF"), 2)%></div>
		<br><div class="form_label">Dt Emiss�o:</div><div class="form_bypass"><%=PrepData(GetValue(objRS1, "DT_EMISSAO"), True, False)%></div>
		<br><div class="form_label">Situa��o:</div><div class="form_bypass"><%=GetValue(objRS1, "SITUACAO")%></div>
	</div>
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>T�tulos</b><br>
		<br>
		<div style="padding-left:110px;">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="1%" nowrap></td>
			<td width="12%" nowrap><u>Dt Emiss�o</u>&nbsp;</td>
			<td width="12%" nowrap><u>Dt Vcto&nbsp;</u></td>
			<td width="15%" align="right" nowrap><u>Valor</u></td>
			<td width="22%" nowrap><u>Situa��o</u>&nbsp;</td>
			<td width="38%"><u>Hist�rico</u>&nbsp;</td>
		</tr>
		<%
			i = 1
			do while not objRS2.eof
				%>
				<tr>
					<td width="1%"><input class="inputclean" name="var_cod_conta_receber" id="var_cod_conta_<%=i%>" type="radio" value="<%=GetValue(objRS2,"COD_CONTA_PAGAR_RECEBER")%>">&nbsp;</td>
					<td width="1%" style="text-align:left" nowrap><%=PrepData(GetValue(objRS2, "DT_EMISSAO"), True, False)%>&nbsp;</td>
					<td width="1%" style="text-align:left" nowrap><%=PrepData(GetValue(objRS2, "DT_VCTO"), True, False)%>&nbsp;</td>
					<td width="1%" style="text-align:right" nowrap><%=FormatNumber(GetValue(objRS2, "VLR_CONTA"))%>&nbsp;</td>
					<td width="1%" style="text-align:left" nowrap>
					<%
					If GetValue(objRS2, "SITUACAO") = "ABERTA"       Then Response.Write("Em Aberto")
					If GetValue(objRS2, "SITUACAO") = "CANCELADA"    Then Response.Write("Cancelada")
					If GetValue(objRS2, "SITUACAO") = "LCTO_TOTAL"   Then Response.Write("Quitada")
					If GetValue(objRS2, "SITUACAO") = "LCTO_PARCIAL" Then Response.Write("Parcialmente quitada")
					%>&nbsp;</td>
					<td width="95%" style="text-align:left"><%=GetValue(objRS2, "HISTORICO")%>&nbsp;</td>
				</tr>
				<%
				objRS2.MoveNext
				i = i + 1
			loop
		%>
		</table>
		</div>
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "") %>
</body>
</html>
<%
		end if
		FechaRecordSet objRS2
	end if
	FechaRecordSet objRS1
end if
FechaDBConn objConn
%>