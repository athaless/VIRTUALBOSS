<!--#include file="../_database/athdbConn.asp"--><%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_TITULOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"

Dim strCODIGO, strENTIDADE
Dim objConn, objRS, objRSAux, objRSa, strSQL

AbreDBConn objConn, CFG_DB 

strCODIGO = GetParam("var_chavereg")
 
if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	"SELECT" 		&_	
				"	ORD.COD_LCTO_ORDINARIO," 	&_
				"	ORD.COD_CONTA_PAGAR_RECEBER," &_
				"	ORD.TIPO,"	&_
				"	ORD.CODIGO,"	&_
				"	ORD.COD_CONTA,"		&_
				"	CTA.NOME AS CONTA,"	&_
				"	ORD.COD_PLANO_CONTA,"&_
				"	PLN.NOME AS PLANO_CONTA,"	&_
				"	ORD.COD_CENTRO_CUSTO,"		&_
				"	CTO.NOME AS CENTRO_CUSTO,"	&_
				"	ORD.HISTORICO,"		&_
				"	ORD.NUM_LCTO,"			&_
				"	ORD.DT_LCTO,"			&_
				"	ORD.VLR_ORIG,"			&_
				"	ORD.VLR_MULTA,"		&_
				"	ORD.VLR_JUROS,"		&_
				"	ORD.VLR_DESC,"			&_
				"	ORD.VLR_LCTO,"			&_
				"	ORD.OBS "	&_
				"FROM "		&_
				"	FIN_LCTO_ORDINARIO ORD "	&_
				"INNER JOIN"	&_
				"	FIN_CONTA CTA ON (ORD.COD_CONTA=CTA.COD_CONTA) "	&_
				"INNER JOIN"	&_
				"	FIN_PLANO_CONTA PLN ON (ORD.COD_PLANO_CONTA=PLN.COD_PLANO_CONTA) "	&_
				"INNER JOIN"	&_
				"	FIN_CENTRO_CUSTO CTO ON (ORD.COD_CENTRO_CUSTO=CTO.COD_CENTRO_CUSTO) "	&_
				"WHERE"			&_
				"	ORD.COD_LCTO_ORDINARIO=" & strCODIGO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then
		strSQL=""					 
		if GetValue(objRS,"TIPO")="ENT_CLIENTE"	    then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE	 WHERE COD_CLIENTE     =" & GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO")="ENT_FORNECEDOR"  then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR	 WHERE COD_FORNECEDOR  =" & GetValue(objRS,"CODIGO")
		if GetValue(objRS,"TIPO")="ENT_COLABORADOR" then strSQL = "SELECT NOME                  FROM ENT_COLABORADOR WHERE COD_COLABORADOR =" & GetValue(objRS,"CODIGO")
		
		strENTIDADE=""
		if strSQL<>"" then
			AbreRecordSet objRSa, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
			if not objRSa.Eof then strENTIDADE = GetValue(objRSa, "NOME")
			FechaRecordSet objRSa
		end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.var_cod_centro_custo.value == '') var_msg += '\nCentro de Custos';
	if (document.form_update.var_cod_plano_conta.value == '')  var_msg += '\nPlano de Contas';
	
	if (var_msg == '')
		document.form_update.submit();
	else
		alert('Favor verificar campos obrigat�rios:\n' + var_msg);
}
//****** Fun��es de a��o dos bot�es - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Lan�amento Ordin�rio - Altera&ccedil;&atilde;o")%>
<form name="form_update" action="UpdateLcto_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="UpdateLcto.asp?var_chavereg=<%=strCODIGO%>">
	<input type="hidden" name="var_cod_chavereg" value="<%=strCODIGO%>">
	<div class="form_label">C�digo:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Conta a Pagar e Receber:</div><div class="form_bypass"><%=GetValue(objRS,"COD_CONTA_PAGAR_RECEBER")%></div>
	<br><div class="form_label">Conta:</div><div class="form_bypass"><%=GetValue(objRS,"CONTA")%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass"><%=strENTIDADE%></div>
	<br><div class="form_label">Plano de Conta:</div><select name="var_cod_plano_conta" style="width:307px;">
							<%
							strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 							&_
									 " FROM FIN_PLANO_CONTA T1 "																&_
									 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_PLANO_CONTA=T2.COD_PLANO_CONTA) " 	&_
									 " WHERE T1.DT_INATIVO IS NULL " 															&_ 
									 " AND ((T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_PLANO_CONTA = " & GetValue(objRS, "COD_PLANO_CONTA") & ")) " &_
									 " ORDER BY 2 "
							
							Set objRSAux = objConn.Execute(strSQL)
							
							Do While Not objRSAux.Eof
								Response.Write("<option value='" & GetValue(objRSAux, "COD_PLANO_CONTA") & "'")
								If CStr(GetValue(objRS, "COD_PLANO_CONTA")) = CStr(GetValue(objRSAux, "COD_PLANO_CONTA")) Then Response.Write(" selected")
								Response.Write(">")
								If GetValue(objRSAux, "COD_REDUZIDO") <> "" Then Response.Write(GetValue(objRSAux, "COD_REDUZIDO") & " ")
								Response.Write(GetValue(objRSAux, "NOME") & "</option>")
								
								objRSAux.MoveNext
							Loop
							FechaRecordSet objRSAux
							%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaPlanoConta.asp?var_form=form_update&var_retorno1=var_cod_plano_conta', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
	<br><div class="form_label">Centro de Custo:</div><%
							strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "												&_
									 " FROM FIN_CENTRO_CUSTO T1 "																	&_
									 " LEFT OUTER JOIN FIN_CONTA_PAGAR_RECEBER T2 ON (T1.COD_CENTRO_CUSTO=T2.COD_CENTRO_CUSTO) "	&_
									 " WHERE T1.DT_INATIVO IS NULL " 																&_ 
									 " AND ((T2.DT_EMISSAO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_CENTRO_CUSTO = " & GetValue(objRS, "COD_CENTRO_CUSTO") & ")) " 	&_
									 " ORDER BY 2"
						%><select name="var_cod_centro_custo" style="width:230px;">
							<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME",GetValue(objRS, "COD_CENTRO_CUSTO"))%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_update&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
	<br><div class="form_label">Hist�rico:</div><div class="form_bypass"><%=GetValue(objRS,"HISTORICO")%></div>
	<br><div class="form_label">N�mero:</div><div class="form_bypass"><%=GetValue(objRS,"NUM_LCTO")%></div>
	<br><div class="form_label">Data:</div><div class="form_bypass"><%=PrepData(GetValue(objRS,"DT_LCTO"), True, False)%></div>
	<br><div class="form_label">Observa��o:</div><div class="form_bypass_inline"><%=GetValue(objRS, "OBS")%></div>
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_bullet_grupo_1" border="0" onClick="ShowArea('form_grupo_1','form_bullet_grupo_1');" 
  		style="cursor:pointer;">
		<b>Valores</b>
		<br>
		<br><div class="form_label">Valor Original:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_ORIG"),2)%></div>
		<br><div class="form_label">Valor Multa:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_MULTA"),2)%></div>
		<br><div class="form_label">Valor Juros:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_JUROS"),2)%></div>
		<br><div class="form_label">Valor Desconto:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_DESC"),2)%></div>
		<br><div class="form_label">Valor Lan�amento:</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)%></div>
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
	end if 
	FechaRecordSet objRS
end if
FechaDBConn objConn
%>