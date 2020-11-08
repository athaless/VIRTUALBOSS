<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strCOD_CONTA
Dim strDIA, strMES, strANO
Dim strINS_LCTO_NO_MES

Dim objConn, objRS, strSQL

AbreDBConn objConn, CFG_DB 

strCOD_CONTA = GetParam("var_chavereg") 

strDIA = DatePart("D", Date)
strMES = DatePart("M", Date)
strANO = DatePart("YYYY", Date)

strINS_LCTO_NO_MES = "F"
If VerificaDireito("|INS_NO_MES|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
	strINS_LCTO_NO_MES = "T"
End If
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
//****** Funções de ação dos botões - Fim ******

function submeterForm() {
	var var_msg = '';
	var var_vlr_lcto;
	var arrData, var_dt_lcto;
	var MesLcto, AnoHoje, AnoLcto;

    var prDiaHoje = '<%=strDIA%>';
	var prMesHoje = '<%=strMES%>';
	var prAnoHoje = '<%=strANO%>';
	var prInsLctoNoMes = '<%=strINS_LCTO_NO_MES%>';
	
	if (document.form_insert.var_cod_conta_orig.value == '') var_msg += '\nParâmetro inválido para conta de origem';
	if (document.form_insert.var_cod_conta_dest.value == '') var_msg += '\nParâmetro inválido para conta de destino';
	if ((document.form_insert.var_cod_conta_orig.value != '') && (document.form_insert.var_cod_conta_dest.value != '') && (document.form_insert.var_cod_conta_orig.value == document.form_insert.var_cod_conta_dest.value)) var_msg += '\nContas devem ser diferentes';
	if (document.form_insert.var_num_lcto.value == '') var_msg += '\nInformar número do lançamento';
	if (document.form_insert.var_historico.value == '') var_msg += '\nInformar histórico';
	if (document.form_insert.var_dt_lcto.value == '') var_msg += '\nInformar data do lançamento';
	if (document.form_insert.var_dt_lcto.value != '') {
		arrData = document.form_insert.var_dt_lcto.value;
		arrData = arrData.split("/");
		
		DiaLcto = arrData[0];
		MesLcto = arrData[1];
		AnoLcto = arrData[2];
		
		DiaLcto = Number(DiaLcto);
		AnoLcto = Number(AnoLcto);
		MesLcto = Number(MesLcto);
		
		prDiaHoje = Number(prDiaHoje);
		prMesHoje = Number(prMesHoje);
		prAnoHoje = Number(prAnoHoje);
		
		if ((AnoLcto > prAnoHoje) || ((MesLcto > prMesHoje) && (AnoLcto == prAnoHoje)) || ((DiaLcto > prDiaHoje) && (MesLcto == prMesHoje) && (AnoLcto == prAnoHoje))) 
			var_msg += '\nNão é permitido lançamento com data futura (' + document.form_insert.var_dt_lcto.value + ')';
		//Se tiver direito INS_NO_MES é porque só pode inserir no mês corrente
		if (prInsLctoNoMes == 'T') 
			if (((MesLcto != prMesHoje) && (AnoLcto == prAnoHoje)) || (AnoLcto != prAnoHoje)) 
				var_msg += '\nNão é permitido lançamento fora do mês corrente (' + document.form_insert.var_dt_lcto.value + ')';
	}
	if (document.form_insert.var_vlr_lcto.value != '') {
		var_vlr_lcto = eval("document.form_insert.var_vlr_lcto.value");
		var_vlr_lcto = var_vlr_lcto.toString();
		var_vlr_lcto = var_vlr_lcto.replace(',', '.');
		
		if (var_vlr_lcto <= 0) var_msg += '\nInformar valor válido para lançamento';
	}
	else {
		var_msg += '\nInformar valor válido para lançamento';
	}
	
	if (var_msg == '') {
		document.form_insert.submit();
	}
	else {
		alert('Verificar mensagem(ns) abaixo:\n' + var_msg);
		return false;
	}
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Transferência - Inserção")%>
<form name="form_insert" action="../modulo_FIN_LCTOCONTA/InsertTransf_Exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_FIN_LCTOCONTA/inserttransf.asp'>
	<div class="form_label">*Banco:&nbsp;</div><select name="var_cod_conta_orig" style="width:230px;">
				<%
				strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
				If strCOD_CONTA = "" Then strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
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
	<br><div class="form_label">*Destino:&nbsp;</div><select name="var_cod_conta_dest" style="width:230px;">
				<option value="" selected>[conta destino]</option>			
				<%
				strSQL =          " SELECT COD_CONTA, NOME FROM FIN_CONTA "
				strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
				strSQL = strSQL & " ORDER BY NOME "
				
				Set objRS = objConn.Execute(strSQL)
				
				Do While Not objRS.Eof
					Response.Write("<option value='" & GetValue(objRS, "COD_CONTA") & "'")
					If strCOD_CONTA = GetValue(objRS, "COD_CONTA") Then Response.Write(" selected")
					Response.Write(">" & GetValue(objRS, "NOME") & "</option>")
					
					objRS.MoveNext
				Loop
				
				FechaRecordSet objRS
				%>
			</select>
	<br><div class="form_label">*Número:&nbsp;</div><input name="var_num_lcto" type="text" maxlength="50" style="width:125px;">
	<br><div class="form_label">*Valor:&nbsp;</div><input name="var_vlr_lcto" type="text" maxlength="15" onKeyPress="validateFloatKey();" style="width:105px;">
	<br><div class="form_label">*Data:&nbsp;</div><%=InputDate("var_dt_lcto","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_lcto", "ver calendário")%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span>
	<br><div class="form_label">*Histórico:&nbsp;</div><input name="var_historico" type="text" maxlength="50" style="width:230px;">
	<br><div class="form_label">Observação:&nbsp;</div><textarea name="var_obs" rows="4" style="width:230px;"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
FechaDBConn objConn
%>