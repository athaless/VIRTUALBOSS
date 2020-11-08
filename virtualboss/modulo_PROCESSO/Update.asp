<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_PROCESSO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO, strData, strRESP 
	
	strCODIGO = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSql =          "SELECT T1.COD_PROCESSO, T1.ID_PROCESSO, T1.COD_CATEGORIA, T1.NOME, T1.DESCRICAO, T1.AUTORES "
		strSql = strSql & "     , T1.DATA, T1.SYS_DT_ALTERACAO, T1.SYS_ALT_ID_USUARIO, T1.DT_HOMOLOGACAO " 
		strSql = strSql & "  FROM PROCESSO T1 "
		strSql = strSql & " WHERE T1.COD_PROCESSO = " & strCODIGO 
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_update.var_id_processo.value == '')    var_msg += '\nID Processo';
	if (document.form_update.var_cod_categoria.value == '')  var_msg += '\nCategoria';
	if (document.form_update.var_nome.value == '')           var_msg += '\nNome';
	if (document.form_update.var_autores.value == '')        var_msg += '\nAutores';
	if (document.form_update.var_descricao.value == '')      var_msg += '\nDescrição';
	
	if (var_msg == '')
		document.form_update.submit();
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
<%=athBeginDialog(WMD_WIDTH, "Processos - Alteração")%>
<form name="form_update" action="update_exec.asp" method="post">
  <input type="hidden" name="var_chavereg"  value="<%=strCODIGO%>">
  <input type="hidden" name="JSCRIPT_ACTION" value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
  <input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PROCESSO/Update.asp?var_chavereg=<%=strCODIGO%>'>
  <div class="form_label">Cod.:</div><div class="form_bypass"><b><%=GetValue(objRS, "COD_PROCESSO")%></b></div>
  <br><div class="form_label">*ID do Processo:</div><input name="var_id_processo" type="text" style="width:150px" value="<%=GetValue(objRS, "ID_PROCESSO")%>">
  <br><div class="form_label">*Categoria:</div><select name="var_cod_categoria">
												<option value="">Selecione</option>
		<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM PROCESSO_CATEGORIA WHERE DT_INATIVO IS NULL ORDER BY NOME ", "COD_CATEGORIA", "NOME", GetValue(objRS, "COD_CATEGORIA") )%> 
											   </select>
  <br><div class="form_label">*Nome:</div><textarea name="var_nome" rows="4" cols="30"><%=GetValue(objRS, "NOME")%></textarea>
  <br><div class="form_label">*Autores:</div><textarea name="var_autores" rows="4" cols="30"><%=GetValue(objRS, "AUTORES")%></textarea>
  <br><div class="form_label">*Descrição:</div><textarea name="var_descricao" rows="6" cols="40"><%=GetValue(objRS, "DESCRICAO")%></textarea>
  <br><div class="form_label">Data:</div><%=InputDate("var_data","",PrepData(GetValue(objRS, "DATA"),True,False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "var_data", "ver calendário")%>
  <%if Request.Cookies("VBOSS")("GRUPO_USUARIO") = "MANAGER" OR Request.Cookies("VBOSS")("GRUPO_USUARIO") = "SU" then%>
  <br><div class="form_label">Homologado:</div><%=InputDate("var_dt_homologacao","",PrepData(GetValue(objRS, "DT_HOMOLOGACAO"),True,False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "var_dt_homologacao", "ver calendário")%>
  <%end if%>
  <br><div class="form_label">Data Altera&ccedil;&atilde;o:</div><div class="form_bypass"><%=PrepData(GetValue(objRS, "SYS_DT_ALTERACAO"), True, True)%></div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If 
	    FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>
