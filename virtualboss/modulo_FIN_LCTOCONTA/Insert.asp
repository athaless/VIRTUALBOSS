<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

Dim strVAR_CODIGO
Dim strTIPO_LCTO 
Dim strLABEL, strLABEL_ENT
Dim strLABEL_COR, strCOD_CONTA
Dim strDIA, strMES, strANO
Dim strINS_LCTO_NO_MES

Dim objConn, objRS, strSQL

AbreDBConn objConn, CFG_DB 

strCOD_CONTA = GetParam("var_chavereg")	
strTIPO_LCTO = GetParam("var_tipo")

if strTIPO_LCTO<>"" then
	if strTIPO_LCTO="DESP" then
		strLABEL = "Despesa"
		strLABEL_ENT = "Pagar para"
		strLABEL_COR = "#FF0000" 'vermelho
	else
		strLABEL = "Receita"
		strLABEL_ENT = "Receber de"
		strLABEL_COR = "#00C000" 'verde		
	end if 
	
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
<script language="JavaScript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
//****** Fun��es de a��o dos bot�es - Fim ******

function submeterForm() {
	var var_msg = '';
	var var_vlr_lcto;
	var arrData, var_dt_lcto;
	var MesLcto, AnoHoje, AnoLcto;

    var prDiaHoje = '<%=strDIA%>';
	var prMesHoje = '<%=strMES%>';
	var prAnoHoje = '<%=strANO%>';
	var prInsLctoNoMes = '<%=strINS_LCTO_NO_MES%>';
	
	if (document.form_insert.var_cod_conta.value == '') 		var_msg += '\nPar�metro inv�lido para conta';
	if (document.form_insert.var_operacao.value == '') 			var_msg += '\nPar�metro inv�lido para opera��o';
	if ((document.form_insert.var_codigo.value == '') || (document.form_insert.var_tipo.value == '')) var_msg += '\nInformar entidade';
	if (document.form_insert.var_cod_centro_custo.value == '') 	var_msg += '\nInformar centro de custo';
	if (document.form_insert.var_cod_plano_conta.value == '') 	var_msg += '\nInformar plano de conta';
	if (document.form_insert.var_dt_lcto.value == '') 			var_msg += '\nInformar data do lan�amento';
	if (document.form_insert.var_num_lcto.value == '') 			var_msg += '\nInformar n�mero do lan�amento';
	//if (document.form_insert.var_historico.value == '') 		var_msg += '\nInformar hist�rico';
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
			var_msg += '\nN�o � permitido lan�amento com data futura (' + document.form_insert.var_dt_lcto.value + ')';
		//Se tiver direito INS_NO_MES � porque s� pode inserir no m�s corrente
		if (prInsLctoNoMes == 'T') 
			if (((MesLcto != prMesHoje) && (AnoLcto == prAnoHoje)) || (AnoLcto != prAnoHoje)) 
				var_msg += '\nN�o � permitido lan�amento fora do m�s corrente (' + document.form_insert.var_dt_lcto.value + ')';
	}
	
	if (document.form_insert.var_vlr_lcto.value != '') {
		var_vlr_lcto = eval("document.form_insert.var_vlr_lcto.value");
		var_vlr_lcto = var_vlr_lcto.toString();
		var_vlr_lcto = var_vlr_lcto.replace(',', '.');
		
		if (var_vlr_lcto <= 0) var_msg += '\nInformar valor v�lido para lan�amento';
	}
	else {
		var_msg += '\nInformar valor v�lido para lan�amento';
	}
	
	if (var_msg == '') {
		document.form_insert.submit();
	}
	else {
		alert('Verificar mensagem(ns) abaixo:\n' + var_msg);
		return false;
	}
}

function BuscaEntidade() {	
	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert&var_input=var_codigo&var_input_tipo=var_tipo&var_tipo=' + 
					document.form_insert.var_tipo.value,'640','390');
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Lan�amento em Conta - Inser��o")%>
<form name="form_insert" action="../modulo_FIN_LCTOCONTA/Insert_Exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_FIN_LCTOCONTA/insert.asp?var_tipo=<%=strTIPO_LCTO%>'>
	<input name="var_operacao" id="var_operacao" type="hidden" value="<%=UCase(strLABEL)%>">
	<div class="form_label">*Opera��o:</div><div class="form_bypass" style="color:<%=strLABEL_COR%>;"><%=strLABEL%></div>
	<br><div class="form_label">*Conta:</div><select name="var_cod_conta" style="width:230px;">
				<%
				strSQL = " SELECT COD_CONTA, NOME FROM FIN_CONTA "
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
	<br><div class="form_label">*<%=strLABEL_ENT%>:</div><input name='var_codigo' type='text' maxlength='10' value="<%=strVAR_CODIGO%>" onKeyPress="validateNumKey();" style="width:40px;"><select name="var_tipo" size="1" style="width:160x;">
							<% MontaCombo "STR", "SELECT TIPO, DESCRICAO FROM SYS_ENTIDADE ORDER BY DESCRICAO ", "TIPO", "DESCRICAO", "" %>
						</select><a href="Javascript://;" onClick="Javascript:BuscaEntidade();"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Plano de Conta:</div><%
							strSQL = "SELECT DISTINCT T1.COD_PLANO_CONTA, T1.NOME " 	&_
									" FROM FIN_PLANO_CONTA T1, FIN_LCTO_EM_CONTA T2 " 	&_
									" WHERE T1.COD_PLANO_CONTA = T2.COD_PLANO_CONTA " 	&_
									" AND T1.DT_INATIVO IS NULL "						&_
									" AND T2.DT_LCTO > DATE_SUB(CURDATE(), INTERVAL 60 DAY) " &_
									" ORDER BY T1.NOME "
						%><select name="var_cod_plano_conta" style="width:307px;">
							<%=montaCombo("STR",strSQL,"COD_PLANO_CONTA","NOME","")%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_insert&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*Centro de Custo:</div><%
							strSQL = "SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "						&_
									" FROM FIN_CENTRO_CUSTO T1, FIN_LCTO_EM_CONTA T2 "			&_
									" WHERE T1.COD_CENTRO_CUSTO = T2.COD_CENTRO_CUSTO "			&_
									" AND T1.DT_INATIVO IS NULL "								&_
									" AND T2.DT_LCTO > DATE_SUB(CURDATE(), INTERVAL 60 DAY) " 	&_
									" ORDER BY T1.NOME "
						%><select name="var_cod_centro_custo" style="width:230px;">
							<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME","")%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_insert&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">*N�mero:</div><input name="var_num_lcto" type="text" style="width:125px;" maxlength="50">
	<br><div class="form_label">*Valor:</div><input name="var_vlr_lcto" type="text" style="width:105px;" maxlength="15" onKeyPress="validateFloatKey();">
	<br><div class="form_label">*Data:</div><%=InputDate("var_dt_lcto","","",false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_dt_lcto", "ver calend�rio")%>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa</i></span>
	<br><div class="form_label">Hist�rico:</div><input name="var_historico" type="text" maxlength="50" style="width:340px;">
	<br><div class="form_label">Observa��o:</div><textarea name="var_obs" rows="7" style="width:340px;"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
end if
FechaDBConn objConn
%>