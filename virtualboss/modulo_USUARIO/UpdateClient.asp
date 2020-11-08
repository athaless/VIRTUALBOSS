<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
    Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO, i, boolCOD_COOKIE
	
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
		
		strSql =          " SELECT COD_USUARIO,NOME,ID_USUARIO,EMAIL,GRP_USER,TIPO,CODIGO,FOTO"
		strSql = strSql & " 	  ,SYS_DT_ALT,SYS_USR_ALT"	
		strSql = strSql & " FROM USUARIO "
		strSql = strSql & " WHERE COD_USUARIO = " & strCODIGO
		
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

function abreBuscaEntidade(){
alert(document.getElementById("var_tipo").value);
//	AbreJanelaPAGE('BuscaPorEntidade.asp?var_form=form_update&var_table='+ document.getElementById("var_tipo").value,'500','300');
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Usuário Cliente - Alteração") %>
  <form name="form_update" action="UpdateClient_exec.asp" method="post">
  <input type="hidden" name="var_chavereg"       value="<%=strCODIGO%>">
  <input type="hidden" name="JSCRIPT_ACTION"     value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
  <input type="hidden" name="var_apelido2"       value="<%=GetValue(objRS,"ID_USUARIO")%>">
  <% if not boolCOD_COOKIE then%>
    <input type="hidden" name="DEFAULT_LOCATION" value='UpdateClient.asp?var_chavereg=<%=strCODIGO%>'>
    <input type="hidden" name="var_retorno"      value="updateClient.asp?var_chavereg=<%=strCODIGO%>">
  <% else %>
    <input type="hidden" name="DEFAULT_LOCATION" value='UpdateClient.asp'>
    <input type="hidden" name="var_retorno"      value="updateClient.asp">
  <% end if%>     
		<div class='form_label'>Cod:</div><div class="form_bypass"><%=GetValue(objRS,"COD_USUARIO")%></div>
  	<br><div class='form_label'>ID Usuário:</div><div class="form_bypass"><%=GetValue(objRS,"ID_USUARIO")%></div>
	<br><div class='form_label'>*Nome:</div><input name="var_nome" type="text" style="width:300px" value="<%=GetValue(objRS,"NOME")%>">
    <br><div class='form_label'>*eMail:</div><textarea name="var_email" type="text" style="width:300px;" value="" maxlength="255" rows="5"><%=GetValue(objRS,"EMAIL")%></textarea>
	<br><div class="texto_ajuda" style="padding-left:110px; padding-right:20px;">Ex. paulo@gmail.com; pedro@gmail.com (max 250 caracteres)</div> 
    <br><div class='form_label'>Entidade:</div><div class="form_bypass"><%=GetValue(objRS,"CODIGO") & " - " & GetValue(objRS,"TIPO")%></div>
    <br><div class='form_label'>Grupo:</div><div class="form_bypass"><%=GetValue(objRS,"GRP_USER")%></div>
	<br><div class="form_label">Foto:</div><input name="var_foto" type="text" maxlength="250" value="<%=GetValue(objRS,"FOTO")%>" style="width:200px;"><a href="javascript:UploadArquivo('form_update','var_foto', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	<br><div class="form_label">&nbsp;</div>
	<% If GetValue(objRS,"FOTO") <> "" Then %>
          <!-- img src='../upload/<%=Request.Cookies("VBOSS")("CLINAME")%>/<%=GetValue(objRS,"FOTO")%>' width='160' //-->
	<% End If %>
    <br><div class='form_label'>Alterado:</div><div class="form_bypass"><%=GetValue(objRS,"SYS_DT_ALT") & " por <b>" & GetValue(objRS,"SYS_USR_ALT") & "</b>"%></div>
	<br>
  </form>
<%
 if not boolCOD_COOKIE then 
   response.write athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")
 else 
   response.write athEndDialog(auxAVISO, "", "", "", "", "../img/butxp_aplicar.gif", "aplicar();")
 end if
%>
 <script language="javascript" type="text/javascript">//MarcaCods();</script>
</body>
</html>
<%
		End If
		FechaRecordSet objRS 
		FechaDBConn objConn
	End If 
%>