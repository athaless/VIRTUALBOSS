<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_CCUSTOS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, objConn
Dim strCODIGO

strCODIGO = GetParam("var_chavereg")

If strCODIGO <> "" Then
	AbreDBConn objConn, CFG_DB 
	
	strSQL = "SELECT"			&_
				"	T1.COD_CENTRO_CUSTO," 		&_
				"	T1.COD_CENTRO_CUSTO_PAI," 	&_
				"	T1.COD_REDUZIDO,"		 		&_			
				"	T1.NOME,"	&_
				"	T2.NOME AS NOME_PAI,"		&_			
				"	T1.ORDEM,"	&_
				"	T1.DESCRICAO,"		&_			
				"	T1.DT_INATIVO "	&_
				"FROM"		&_
				"	FIN_CENTRO_CUSTO T1 "		&_
				"LEFT OUTER JOIN"					&_
				"	FIN_CENTRO_CUSTO T2 ON (T1.COD_CENTRO_CUSTO_PAI=T2.COD_CENTRO_CUSTO) "		&_
				"WHERE"		&_
				"	T1.COD_CENTRO_CUSTO=" &	strCODIGO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.eof then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.var_nome.value == '') var_msg += '\nNome';
	
	if (var_msg == '')
		document.form_update.submit();
	else
		alert('Favor verificar campos:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Centro de Custo - Alteração")%>
<form name="form_update" action="InsUpd_Exec.asp" method="post">
	<input type="hidden" name="var_oper" value="UPD">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="Update.asp?var_chavereg=<%=strCODIGO%>">
	<div class="form_label"></div><div class="form_bypass"><b>Centro de Custos a que estará associado</b></div>
	<br><div class="form_label">Centro de Custo:</div><input name="var_cod_centro_custo_pai" value="<%=GetValue(objRS,"COD_CENTRO_CUSTO_PAI")%>" type="text" size="5" maxlength="10"><a href="Javascript://;" onClick="Javascript:AbreJanelaPAGE('BuscaCentroCusto.asp?var_form=form_update&var_retorno1=var_cod_centro_custo_pai&var_retorno2=var_hierarquia', '640', '390');"><img src="../img/BtBuscar.gif" border="0" style='vertical-align:top; padding-top:2px;' vspace='0' hspace='0'></a>
	<br><div class="form_label">Hierarquia:</div><input name="var_hierarquia" value="../<%=GetValue(objRS,"NOME_PAI")%>" type="text" size="60" maxlength="50" readonly="readonly" style="color:#000000; background-color:#FFFFFF; border:0px;">
	<br><div class="form_label"></div><div class="form_bypass"><b>Dados do Centro de Custo</b></div>
	<br><div class="form_label">Código Reduzido:</div><input name="var_cod_reduzido" value="<%=GetValue(objRS,"COD_REDUZIDO")%>" type="text" size="25" maxlength="50">
	<br><div class="form_label">*Nome:</div><input name="var_nome" value="<%=GetValue(objRS,"NOME")%>" type="text" size="40" maxlength="50">
	<br><div class="form_label">Descrição:</div><input name="var_descricao" value="<%=GetValue(objRS,"DESCRICAO")%>" type="text"size="60" maxlength="250">
	<br><div class="form_label">Ordem:</div><input name="var_ordem" value="<%=GetValue(objRS,"ORDEM")%>" type="text" size="10" maxlength="10" onKeyPress="validateNumKey();">
	<br><div class="form_label">Status:</div><%
			If GetValue(objRS,"DT_INATIVO") = "" Then
				Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='' checked>Ativo")
				Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='" & Date() & "'>Inativo")
			Else
				Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value=''>Ativo")
				Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='" & Date() & "' checked>Inativo")
			End If
		%>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
		End If 
	    FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>