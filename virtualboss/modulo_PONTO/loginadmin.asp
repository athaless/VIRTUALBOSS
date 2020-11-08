<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/md5.asp"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 ' -------------------------------------------------------------------------------

 Dim strSENHA, strLOCATION, strCHAVE
 Dim strSQL, objRS, objConn, strCod_Ponto
 Dim auxAVISO
 
 auxAVISO = "dlg_info.gif:Utilize a senha de um usuário do grupo SU."

 strSENHA 	 = GetParam("var_senhaadmin")
 strLOCATION = GetParam("var_location")
 strCHAVE 	 = GetParam("var_chavereg")

 if strSENHA <> "" then strSENHA = md5(strSENHA)
 if UCase(Request.Cookies("VBOSS")("GRUPO_USUARIO"))="SU" then 
  strSENHA    = Request.Cookies("VBOSS")("SENHA")
  strLOCATION = Replace(strLOCATION,"_exec","")
 end if

 if (strSENHA <> "") then
	 AbreDBConn ObjConn, CFG_DB
	 
	 strSQL = " SELECT SENHA FROM USUARIO WHERE GRP_USER = 'SU' AND SENHA = '" & strSENHA & "'"
	 set objRS = ObjConn.Execute(strSQL)
	 if Not objRS.EOF then
	  response.redirect(strLOCATION & "?var_chavereg=" & strCHAVE)
	 else
	  auxAVISO = "dlg_error.gif:Senha Incorreta! Utilize a senha de qualquer usuário do grupo SU."
	 end if
  end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html;">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.FrmInsertPonto.DEFAULT_LOCATION.value=""; submeterForm(); }
function aplicar()  { document.FrmInsertPonto.DEFAULT_LOCATION.value=""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function submeterForm() {
   document.FrmInsertPonto.submit(); 
}
//****** Funções de ação dos botões - Fim ******


</script>
</head>
<body onLoad="document.FrmInsertPonto.var_senhaadmin.focus();">
<%=athBeginDialog(WMD_WIDTH, "Reg. Horas - Acesso restrito")%> 
<form name="FrmInsertPonto" method="get">
 <input type="hidden" name="var_chavereg" value="<%=strCHAVE%>">
 <input type="hidden" name="var_location" value="<%=Replace(strLOCATION,"_exec","")%>">
 <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
 <input type="hidden" name="DEFAULT_LOCATION" value='update.asp?var_chavereg=<%=strCOD_PONTO%>'>
 <div class="form_label">Senha:</div><input type="password" name="var_senhaadmin" id="var_senhaadmin" maxlength="250" style="width:200px;">
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>