<!--#include file="../_database/athdbConn.asp"--><!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn -->
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_MENU", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 
 Dim objConn, objRS, strSQL
 Dim strCODIGO
 
 strCODIGO = GetParam("var_chavereg")
 
 AbreDBConn objConn, CFG_DB
 
 strSQL =          " SELECT COD_MENU, COD_MENU_PAI, ROTULO, LINK "
 strSQL = strSQL & "      , ID_APP, DT_INATIVO, IMG, ORDEM "
 strSQL = strSQL & " FROM SYS_MENU WHERE COD_MENU = " & strCODIGO
 
 Set objRS = objConn.execute(strSQL)
 
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
function aplicar() 	{ document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { 	
	var var_msg = '';
	if (document.form_update.var_cod_menu_pai.value == '') { var_msg += '\nMenu Pai' };
	if (var_msg == ''){ document.form_update.submit(); }
	else { alert('Favor verificar campos obrigatórios:\n' + var_msg); }
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Menu Principal - Atualização")%>
<form name="form_update" action="Update_Exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_MENU/Update.asp?var_chavereg=<%=strCODIGO%>">
	<input type="hidden" name="var_chavereg" value="<%=strCODIGO%>">
	<div class='form_label'>Cod:</div><div class="form_bypass"><%=GetValue(objRS,"COD_MENU")%></div>
	<br><div class="form_label">*Menu Pai:</div><input name="var_cod_menu_pai" type="text"  style="width:50px" value="<%=GetValue(objRS,"COD_MENU_PAI")%>"><a style="cursor:hand;" onClick="AbreJanelaPAGE('buscapormenu.asp?var_form=form_update&var_campo=var_cod_menu_pai','540','360');"><img src="../img/btBuscar.gif" title="Pesquisar" style="vertical-align:top; padding-top:2px" vspace="0" hspace="0"></a>
	<br><div class="form_label">Rótulo:</div><input name="var_rotulo" type="text" style="width:300px" maxlength="80" value="<%=GetValue(objRS,"ROTULO")%>">
	<br><div class="form_label">Link:</div><textarea name="var_link" rows="4"><%=GetValue(objRS,"LINK")%></textarea>
	<!--
	<br><div class="form_label">Módulo:</div><select name="var_id_app" size="1">
    	<option value="">[selecione]</option>
        <% 'montacombo "STR", " SELECT DISTINCT ID_APP FROM SYS_APP_DIREITO ", "ID_APP", "ID_APP",  GetValue(objRS,"ID_APP") %>
       	</select> 
	-->
	<br><div class="form_label">Imagem:</div><input name="var_img" type="text"  style="width:150px" value="<%=GetValue(objRS,"IMG")%>">
	<br><div class="form_label">Ordem:</div><input name="var_ordem" type="text"  style="width:50px" value="<%=GetValue(objRS,"ORDEM")%>">
	<br><div class="form_label">Status:</div><%
	      If GetValue(objRS,"DT_INATIVO") = "" Then
          	Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='NULL' checked>Ativo")
            Response.Write("<input type='radio' class='inputclean'' name='var_dt_inativo' value='" & Date() & "'>Inativo")
          Else
            Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='NULL'>Ativo")
            Response.Write("<input type='radio' class='inputclean' name='var_dt_inativo' value='" & Date() & "' checked>Inativo")
          End If
		%>
</form>
<%=athEndDialog(auxAviso, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
 End If
 
 FechaRecordset(objRS)
 FechaDBConn(objConn)
%>