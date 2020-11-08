<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_LCTOCONTA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strCODIGO, strENTIDADE
Dim objConn, objRS, objRSAux, objRSa, strSQL

AbreDBConn objConn, CFG_DB 

strCODIGO = GetParam("var_chavereg")
 
if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =	" SELECT LCTO.COD_LCTO_EM_CONTA "&_	
				"		,LCTO.OPERACAO "&_	
				"		,LCTO.CODIGO "&_	
				"		,LCTO.TIPO "&_	
				"		,LCTO.COD_CONTA " &_
				"		,PLAN.COD_REDUZIDO "&_
				"		,CTA.NOME AS CONTA "&_
				"		,LCTO.COD_PLANO_CONTA " &_
				"		,PLAN.NOME AS PLANO_CONTA "	&_	
				"		,LCTO.COD_CENTRO_CUSTO " &_
				"		,CUST.NOME AS CENTRO_CUSTO "&_	
				"		,LCTO.HISTORICO "&_
				"		,LCTO.OBS "	&_					
				"		,LCTO.NUM_LCTO "&_	
				"		,LCTO.VLR_LCTO "&_		
				"		,LCTO.DT_LCTO "	&_	
				" FROM FIN_LCTO_EM_CONTA LCTO "	&_	
				" LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA = LCTO.COD_PLANO_CONTA) "	&_	
				" LEFT OUTER JOIN FIN_CENTRO_CUSTO CUST ON (CUST.COD_CENTRO_CUSTO = LCTO.COD_CENTRO_CUSTO) "	&_	
				" LEFT OUTER JOIN FIN_CONTA CTA ON (LCTO.COD_CONTA=CTA.COD_CONTA) "	&_	
				" WHERE LCTO.COD_LCTO_EM_CONTA=" & strCODIGO	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.Eof then				 
		strSQL=""					 
		if GetValue(objRS, "TIPO")="ENT_CLIENTE"     and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_CLIENTE     WHERE COD_CLIENTE     = " & GetValue(objRS,"CODIGO")
		if GetValue(objRS, "TIPO")="ENT_FORNECEDOR"  and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME_FANTASIA AS NOME FROM ENT_FORNECEDOR  WHERE COD_FORNECEDOR  = " & GetValue(objRS,"CODIGO")
		if GetValue(objRS, "TIPO")="ENT_COLABORADOR" and IsNumeric(GetValue(objRS,"CODIGO")) then strSQL = "SELECT NOME                  FROM ENT_COLABORADOR WHERE COD_COLABORADOR = " & GetValue(objRS,"CODIGO")
		
		strENTIDADE=""
		if strSQL<>"" then 
			Set objRSa = objConn.Execute(strSQL)
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
//****** Funções de ação dos botões - Início ******
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
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Lançamento em Conta - Altera&ccedil;&atilde;o")%>
<form name="form_update" action="Update_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="Update.asp?var_chavereg=<%=strCODIGO%>">
	<input type="hidden" name="var_cod_chavereg" value="<%=strCODIGO%>">
	<div class="form_label">Código:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Operação</div><div class="form_bypass"><%=GetValue(objRS,"OPERACAO")%></div>
	<br><div class="form_label">Entidade:</div><div class="form_bypass"><%=strENTIDADE%></div>
	<br><div class="form_label">Conta:</div><div class="form_bypass"><%=GetValue(objRS,"CONTA")%></div>
	<br><div class="form_label">Plano de Conta:</div><select name="var_cod_plano_conta" style="width:307px;">
							<%
							strSQL = " SELECT DISTINCT T1.COD_PLANO_CONTA, T1.COD_REDUZIDO, T1.NOME " 	&_
									 " FROM FIN_PLANO_CONTA T1, FIN_LCTO_EM_CONTA T2 "	&_
									 " WHERE T1.DT_INATIVO IS NULL " 					&_
									 " AND T1.COD_PLANO_CONTA = T2.COD_PLANO_CONTA " 	&_
									 " AND ((T2.DT_LCTO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_PLANO_CONTA = " & GetValue(objRS, "COD_PLANO_CONTA") & ")) " &_
									 " ORDER BY T1.NOME "
							Set objRSAux = objConn.Execute(stRSQL)
							
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
							strSQL = " SELECT DISTINCT T1.COD_CENTRO_CUSTO, T1.NOME "	&_
									 " FROM FIN_CENTRO_CUSTO T1, FIN_LCTO_EM_CONTA T2 "	&_
									 " WHERE T1.DT_INATIVO IS NULL " 					&_ 
									 " AND T1.COD_CENTRO_CUSTO = T2.COD_CENTRO_CUSTO "	&_
									 " AND ((T2.DT_LCTO>DATE_SUB(CURDATE(), INTERVAL 60 DAY)) OR (T1.COD_CENTRO_CUSTO = " & GetValue(objRS, "COD_CENTRO_CUSTO") & ")) " &_
									 " ORDER BY T1.NOME "
						%><select name="var_cod_centro_custo" style="width:230px;">
							<%=montaCombo("STR",strSQL,"COD_CENTRO_CUSTO","NOME",GetValue(objRS, "COD_CENTRO_CUSTO"))%>
						</select><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_update&var_retorno1=var_cod_centro_custo', '640', '365');"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
	<br><div class="form_label">Histórico:</div><div class="form_bypass"><%=GetValue(objRS,"HISTORICO")%></div>
	<br><div class="form_label">Número:</div><div class="form_bypass"><%=GetValue(objRS,"NUM_LCTO")%></div>
	<br><div class="form_label">Valor</div><div class="form_bypass"><%=FormataDecimal(GetValue(objRS,"VLR_LCTO"),2)%></div>
	<br><div class="form_label">Data:</div><div class="form_bypass"><%=PrepData(GetValue(objRS,"DT_LCTO"), True, False)%></div>
	<br><div class="form_label">Observação:</div><div class="form_bypass_inline"><%=GetValue(objRS, "OBS")%></div>
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