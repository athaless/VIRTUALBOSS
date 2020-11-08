<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
    Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO, strData, strRESP, arrESTADOS, arrNOMES, i, boolCOD_COOKIE
	Dim boolAuxChamado
	
	strCODIGO = GetParam("var_chavereg")

	' Indica se a Dialog foi chamada sem user (no caso do menu MEUS DADOS)
	' neste caso pega o user do cooki e marca que venho de lá
	boolCOD_COOKIE = false
	if strCODIGO="" then 
		strCODIGO = Request.Cookies("VBOSS")("COD_USUARIO")
		boolCOD_COOKIE = true
	end if
	
	if strCODIGO<>"" then
		AbreDBConn objConn, CFG_DB 
		
		strSql =          " SELECT COD_USUARIO, NOME, ID_USUARIO, EMAIL, GRP_USER, TIPO, CODIGO "
		strSql = strSql & "      , FOTO, OBS, DT_INATIVO, SENHA, GRP_USER, DIR_DEFAULT, APELIDO, ENT_CLIENTE_REF, LOGIN_FACEBOOK, ID_USUARIO_MODELO "
		strSql = strSql & " FROM USUARIO "
		strSql = strSql & " WHERE COD_USUARIO = " & strCODIGO
		
		'athDebug strSQL, true
		
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
function ok()       { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.var_nome.value == '') var_msg += '\nNome';
	if (document.form_update.var_email.value == '') var_msg += '\nEmail';
	if ((document.form_update.var_codigo.value == '') && (document.form_update.var_codigo.disabled == false)) var_msg += '\nCódigo';
	if ((document.form_update.var_tipo.value == '') && (document.form_update.var_tipo.disabled == false)) var_msg += '\nTipo';
	if ((document.form_update.var_grp_user.value == '') && (document.form_update.var_grp_user.disabled == false)) var_msg += '\nGrupo de Usuário';
	
	if (var_msg == ''){
		document.form_update.submit();
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
<%=athBeginDialog(WMD_WIDTH, "Usuário - Alteração") %>
  <form name="form_update" action="Update_exec.asp" method="post">
  <input type="hidden" name="var_chavereg"       value="<%=strCODIGO%>">
  <input type="hidden" name="JSCRIPT_ACTION"     value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
  <input type="hidden" name="var_apelido2"       value="<%=GetValue(objRS,"ID_USUARIO")%>">
  <% if not boolCOD_COOKIE then%>
    <input type="hidden" name="DEFAULT_LOCATION" value='Update.asp?var_chavereg=<%=strCODIGO%>'>
    <input type="hidden" name="var_retorno"      value="update.asp?var_chavereg=<%=strCODIGO%>">
  <% else %>
    <input type="hidden" name="DEFAULT_LOCATION" value='Update.asp'>
    <input type="hidden" name="var_retorno"      value="update.asp">
  <% end if%>     
		<div class='form_label'>Cod:</div><div class="form_bypass"><%=GetValue(objRS,"COD_USUARIO")%></div>
	<br><div class='form_label'>*Nome:</div><input name="var_nome" type="text" style="width:300px" value="<%=GetValue(objRS,"NOME")%>">
  	<br><div class='form_label'>ID Usuário:</div><div class="form_bypass"><%=GetValue(objRS,"ID_USUARIO")%></div>
	<br><div class='form_label'>Apelido:</div><input name="var_apelido1" type="text" style="width:150px;" value="<%=GetValue(objRS,"APELIDO")%>">
    <br><div class='form_label'>Nova Senha:</div><input name="var_senha" type="password" style="width:100px;" value=""><span class="texto_ajuda">&nbsp;"em branco" mantém a senha atual</span>
    <br><div class='form_label'>*Email:</div><input name="var_email" type="text" style="width:300px;" value="<%=GetValue(objRS,"EMAIL")%>">
    <br><div class='form_label'>Login Facebook:</div><input name="var_login_fb" type="text" style="width:150px;" value="<%=GetValue(objRS,"LOGIN_FACEBOOK")%>"><span class="texto_ajuda">ID ou e-mail do Facebook</span>		
    <br>
		<div class='form_label'>*Entidade:</div><select name="var_tipo" <% if boolCOD_COOKIE then Response.Write(" disabled")%> style="width:150px;">
			<option value="ENT_COLABORADOR" <% if GetValue(objRS,"TIPO")="ENT_COLABORADOR" then Response.Write(" selected")%>>Colaborador</option>
			<option value="ENT_CLIENTE" <% if GetValue(objRS,"TIPO")="ENT_CLIENTE" then Response.Write(" selected")%>>Cliente</option>
			</select>
		<div class='form_label_nowidth'>*Cod.</div><input name="var_codigo" type="text" style="width:40px;" value="<%=GetValue(objRS,"CODIGO")%>" <% if boolCOD_COOKIE then Response.Write(" disabled") %> onKeyPress="validateNumKey();">
 			<% if not boolCOD_COOKIE then %>
				<a style="cursor:pointer;" onClick="AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update','500','300');"> 
				<img src="../img/BtBuscar.gif" alt="Buscar entidade..." border="0" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
			<% end if %>
    
    <br>
		<div class='form_label'>*Grupo Usuário:</div><select name="var_grp_user" <% if boolCOD_COOKIE then Response.Write("disabled")%> style="width:120px;">
			<option value="NORMAL"  <%if GetValue(objRS,"GRP_USER")="NORMAL"  then Response.Write(" selected")%>>NORMAL</option>
			<option value="CLIENTE" <%if GetValue(objRS,"GRP_USER")="CLIENTE" then Response.Write(" selected")%>>CLIENTE</option>
			<option value="MANAGER" <%if GetValue(objRS,"GRP_USER")="MANAGER" then Response.Write(" selected")%>>MANAGER</option>
			<option value="SU" <%if GetValue(objRS,"GRP_USER")="SU" then Response.Write(" selected")%>>SU</option>
			</select> 
    
    <br>
		<div class='form_label'>Entrada:</div><select name="var_dir_default" style="width:120px;">
			<option value="" <% If GetValue(objRS,"DIR_DEFAULT") = "" Then Response.Write("selected='selected'") %>>Painel Padrão</option>
		 	<option value="CLIENTE" <% If GetValue(objRS,"DIR_DEFAULT") = "CLIENTE" Then Response.Write("selected='selected'") %>>Painel de Cliente</option>
       		</select>
    <br><div class="form_label">DIREITOS de:</div><select name="var_id_usuario_modelo" style="width:80px;">
					<option value=""></option>
					<%=montaCombo("STR","SELECT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL ORDER BY TIPO DESC, ID_USUARIO", "ID_USUARIO", "ID_USUARIO", GetValue(objRS,"ID_USUARIO_MODELO"))%>
				</select><span class="texto_ajuda">&nbsp;(permite utiliar os direitos de um outro usuário)</span>	
    
	<br><div class="form_label">Foto:</div><input name="var_foto" type="text" maxlength="250" value="<%=GetValue(objRS,"FOTO")%>" style="width:200px;"><a href="javascript:UploadArquivo('form_update','var_foto', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
    <br><div class='form_label'>Observação:</div><textarea name="var_obs" rows="5"><%=GetValue(objRS,"OBS")%></textarea>
    <br><div class='form_label'>Status:</div><%
			If GetValue(objRS,"DT_INATIVO")="" Then
				if not boolCOD_COOKIE then
					Response.Write("<input style='vertical-align:middle'; type='radio' class='inputclean' name='var_dt_inativo' id='var_dt_inativo' value='NULL' checked>&nbsp;Ativo&nbsp;")
					Response.Write("<input style='vertical-align:middle'; type='radio' class='inputclean' name='var_dt_inativo' id='var_dt_inativo' value='" & Date() & "'>&nbsp;Inativo")
				else
					Response.Write("Ativo")
				end if
			Else
				Response.Write("<input style='vertical-align:middle'; type='radio' class='inputclean' name='var_dt_inativo' id='var_dt_inativo' value='NULL'>&nbsp;Ativo&nbsp;")
				Response.Write("<input style='vertical-align:middle'; type='radio' class='inputclean' name='var_dt_inativo' id='var_dt_inativo' value='" & Date() & "' checked>&nbsp;Inativo")
			End If
		%>
  </form>
<%
 if not boolCOD_COOKIE then 
   response.write athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")
 else 
   response.write athEndDialog(auxAVISO, "", "", "", "", "../img/butxp_aplicar.gif", "aplicar();")
 end if
%>
 <script language="javascript" type="text/javascript">MarcaCods();</script>
</body>
</html>
<%
		End If
		FechaRecordSet objRS 
		FechaDBConn objConn
	End If 
%>