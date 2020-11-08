<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_RELAT_ASLW", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim objConn, objRS, strSQL
	Dim strCODIGO
	
	AbreDBConn objConn, CFG_DB 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		strSQL = " SELECT T1.COD_RELATORIO, T1.COD_CATEGORIA, T1.NOME, T1.DESCRICAO, T1.EXECUTOR, T1.PARAMETRO " & _ 
		  		 "       ,T1.SYS_CRIA, T1.SYS_ALTERA, T1.DT_CRIACAO, T1.DT_INATIVO, T1.DT_ALTERACAO, T2.NOME AS CATEGORIA " &_
  				 " FROM ASLW_RELATORIO T1 " &_
				 " LEFT OUTER JOIN ASLW_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) " & _
				 " WHERE T1.COD_RELATORIO = " & strCODIGO
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.radExecDefault.checked) {
		document.form_update.var_executor.value = 'ExecASLW.asp';
	}
	else {
		document.form_update.var_executor.value = document.form_update.var_executor_outro.value;
	}
	
	if (document.form_update.var_nome.value == '') var_msg += '\nNome';
	
	if (var_msg == ''){
		document.form_update.submit();
	} else{
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
}
//****** Funções de ação dos botões - Fim ******
function ExecRelASLW(prPagina, prCodigo) {
	var var_msg = '';
	
	if (prPagina == '') var_msg += 'Favor informar executor do relatório\n';
	if (prCodigo == '') var_msg += 'Favor informar código do relatório\n';
	
	if (var_msg == '') 
		AbreJanelaPAGE(prPagina + '?var_chavereg=' + prCodigo, '680', '460');
	else 
		alert(var_msg);
}

function ExecRelOutro() {
	if (document.form_update.var_executor_outro.value != '<Digite seu executor de relatório>')
		AbreJanelaPAGE(document.form_update.var_executor_outro.value+'?var_strParam='+document.form_update.var_parametro.value, '680', '460');
	else
		alert('Favor informar executor do relatório');
}

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Relatório - Alteração") %>
<form name="form_update" action="Update_exec.asp" method="post">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="Update.asp?var_chavereg=<%=strCODIGO%>">
	<input type="hidden" name="var_executor" value="">
	<div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Categoria:</div><select name="var_cod_categoria">
													<option value="">Selecione...</option>
													<% montaCombo "STR", " SELECT COD_CATEGORIA, NOME FROM ASLW_CATEGORIA ORDER BY NOME ", "COD_CATEGORIA", "NOME", GetValue(ObjRS,"COD_CATEGORIA") %>
												</select>
	<br><div class="form_label">*Nome:</div><input name="var_nome" type="text" value="<%=GetValue(objRS, "NOME")%>" style="width:240px;">
	<br><div class="form_label">Descrição:</div><textarea name="var_descricao" cols="50" rows="5"><%=GetValue(objRS, "DESCRICAO")%></textarea>
	<br><div class="form_label">*Executor:</div><input type="radio" name="radExec" id="radExecDefault" value="" <% If UCase(GetValue(ObjRS,"EXECUTOR")) = "EXECASLW.ASP" Then Response.Write(" checked") %> class="inputclean">Default<input name="var_executor_aslw" type="text" style="width:90px;" readonly="readonly" value="ExecASLW.asp"><a href="Javascript:ExecRelASLW(document.form_update.var_executor_aslw.value, '<%=GetValue(ObjRS,"COD_RELATORIO")%>');"><img src="../img/bt_execSQL.gif" width="13" height="17" alt="Testar SQL" title="Testar SQL" style="vertical-align:bottom; padding-bottom:2px;" vspace="0" hspace="0" border="0"></a>
	<br><div class="form_label">&nbsp;</div><input type="radio" name="radExec" id="radExecOutro" value="" class="inputclean" <% If UCase(GetValue(ObjRS,"EXECUTOR")) <> "EXECASLW.ASP" Then Response.Write(" checked") %>>Outro<input name="var_executor_outro" type="text" value="<% If UCase(GetValue(ObjRS,"EXECUTOR")) = "EXECASLW.ASP" Then Response.Write("<Digite seu relatório>") Else Response.Write(GetValue(ObjRS,"EXECUTOR")) End If %>" style="width:180px;" <% If UCase(GetValue(ObjRS,"EXECUTOR")) <> "EXECASLW.ASP" Then Response.Write(" checked") %>><a href="Javascript:ExecRelOutro();"><img src="../img/bt_execSQL.gif" alt="Testar" title="Testar" width="13" height="17" border="0" hspace="0" style="vertical-align:bottom; padding-bottom:2px;"></a>
	<br><div class="form_label">Parâmetro:</div><textarea name="var_parametro" cols="50" rows="20"><%=RemoveTagSQL(GetValue(ObjRS, "PARAMETRO"))%></textarea>
    <br><div class="texto_ajuda" style="padding-left:110px; padding-right:20px;">
    	<div>Consulta SQL que permite a colocação de variáveis ambiente em Session ou Cookies (com o uso de chaves { }) e parâmetros de filtragem (com o uso de colchetes [ ])<br> 
	        <b>Ex.:</b> SELECT * FROM usuario WHERE id_usuario like '{ID_USUARIO}%'  AND cod_usuario > [mincoduser] 
        </div> 
	<br><div class="form_label">Criação:</div><%=PrepData(GetValue(ObjRS,"DT_CRIACAO"), True, False)%>&nbsp;&nbsp;(&nbsp;<%=GetValue(ObjRS,"SYS_CRIA")%>&nbsp;)
	<br><div class="form_label">Alteração:</div><%
	If GetValue(ObjRS,"DT_ALTERACAO") <> "" Then
		Response.Write(PrepData(GetValue(ObjRS,"DT_ALTERACAO"), True, False) & "&nbsp;&nbsp;(&nbsp;" & GetValue(ObjRS,"SYS_ALTERA") & "&nbsp;)")
	End If
	%>
	<br><div class="form_label">Status:</div>
	  <%
		If GetValue(objRS,"DT_INATIVO") = "" Then
		  Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='NULL' checked>Ativo")
		  Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='" & Date() & "'>Inativo")
		Else
		  Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='NULL'>Ativo")
		  Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='" & Date() & "' checked>Inativo")
		End If
	  %>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
		End If
		FechaRecordSet objRS
	End If
	FechaDBConn objConn
%>