<!--#include file="../_database/athdbConn.asp"--><!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn -->
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim strSQL, objRS, ObjConn
 Dim strCODIGO, strData, strRESP, arrESTADOS, arrNOMES, i
 Dim boolAuxChamado
 
 AbreDBConn objConn, CFG_DB
 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_nome.value == '')        var_msg += '\nNome';
	if (document.form_insert.var_id_usuario.value == '')  var_msg += '\nUsuário';
	if (document.form_insert.var_senha.value == '')       var_msg += '\nSenha';
	if (document.form_insert.var_email.value == '')       var_msg += '\nEmail';
	if (document.form_insert.var_codigo.value == '')      var_msg += '\nCódigo';
	if (document.form_insert.var_tipo.value == '')        var_msg += '\nTipo';
	if (document.form_insert.var_grp_user.value == '')    var_msg += '\nGrupo de Usuário';
	
	if (var_msg == ''){
		document.form_insert.submit();
    }
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
function UploadImage(formname,fieldname, dir_upload)
{
 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Usuário - Inserção") %>
<form name="form_insert" action="Insert_exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='insert.asp'>
	<div class='form_label'>*Nome:</div><input name="var_nome" type="text" style="width:300px" value="">
  	<br><div class='form_label'>*ID Usuário:</div><input name="var_id_usuario" type="text" style="width:150px;" value="">
	<br><div class='form_label'>Apelido:</div><input name="var_apelido" type="text" style="width:150px;" value="">
    <br><div class='form_label'>*Senha:</div><input name="var_senha" type="password" style="width:100px;" value="">
    <br><div class='form_label'>*Email:</div><input name="var_email" type="text" style="width:300px;" value="">
    <br><div class='form_label'>Login Facebook:</div><input name="var_login_fb" type="text" style="width:150px;" value=""><span class="texto_ajuda">ID ou e-mail do Facebook</span>	
    <br><div class='form_label'>*Entidade:</div><select name="var_tipo">
		<option value="ENT_COLABORADOR">Colaborador</option>
		<option value="ENT_CLIENTE">Cliente</option>
	</select>
	    <div class='form_label_nowidth'>*Cod.</div><input name="var_codigo" type="text" style="width:40px;" value="">
            <a style="cursor:pointer;" onClick="AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_insert','500','300');"><img src="../img/BtBuscar.gif" alt="Buscar entidade..." border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
    <br><div class='form_label'>*Grupo Usuário:</div><select name="var_grp_user" size="1" style="width:120px;">
		<option value="NORMAL">Normal</option>
		<option value="CLIENTE">Cliente</option>
		<option value="MANAGER">Manager</option>
		<option value="SU">SU</option>
	</select>
    <br><div class='form_label'>Entrada:</div><select name="var_dir_default" style="width:120px;">
		<option value="" selected="selected">Painel Padrão</option>
		<option value="CLIENTE">Painel de Cliente</option>
	</select>
    <br><div class="form_label">Foto:</div><input name="var_foto" type="text" maxlength="250" value="" style="width:200px;"><a href="javascript:UploadArquivo('form_insert','var_foto', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
    <br><div class='form_label'>Observação:</div><textarea name="var_obs" rows="4"></textarea>
    <br><div class="form_label">DIREITOS de:</div><select name="var_id_usuario_modelo" style="width:80px;">
					<option value=""></option>
					<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY TIPO DESC, ID_USUARIO", "ID_USUARIO", "ID_USUARIO", "")%>
				</select><span class="texto_ajuda">&nbsp;(permite utiliar os direitos de um outro usuário)</span>	
    <br><div class='form_label'></div><input name="var_cod_cli_chamado_filtro" type="hidden" value="">
    <br><div class='form_label'>Status:</div><input style='vertical-align:middle'; type='radio' class='inputclean' name='var_dt_inativo' id='var_dt_inativo' value='NULL' checked>&nbsp;Ativo&nbsp;
	                                         <input style='vertical-align:middle'; type='radio' class='inputclean' name='var_dt_inativo' id='var_dt_inativo' value='"<%=Date()%>"'>&nbsp;Inativo
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
  'FechaRecordset objRS
  FechaDBConn objConn
%>