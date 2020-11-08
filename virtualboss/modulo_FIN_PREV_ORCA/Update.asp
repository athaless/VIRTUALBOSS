<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%' VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_FIN_PREV_ORCA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH = 400
WMD_WIDTHTTITLES = 100
' -------------------------------------------------------------------------------

Dim strSQL, objRS, ObjConn
Dim strCOD_PREV_ORCA 

strCOD_PREV_ORCA = GetParam("var_chavereg")
AbreDBConn objConn, CFG_DB 

strSQL = "SELECT DESCRICAO, DT_PREV_INI, DT_PREV_FIM FROM FIN_PREV_ORCA WHERE COD_PREV_ORCA=" & strCOD_PREV_ORCA 
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
if not objRS.eof then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="form_update.DBVAR_DATE_DT_PREV_INIô.focus();">
<% athBeginDialog WMD_WIDTH, "Previsão Orçamentária - Inserção" %>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
<input type="hidden" name="DEFAULT_TABLE"    value="FIN_PREV_ORCA">
<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
<input type="hidden" name="RECORD_KEY_NAME"  value="COD_PREV_ORCA">
<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_PREV_ORCA%>">
<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<tr><td colspan="2" height="10px"></td></tr>
	<tr> 
		<td align="right">*Data Início:&nbsp;</td>
      <td>
			<input name="DBVAR_DATE_DT_PREV_INIô" type="text" class="edtext" style="width:70px" maxlength="10" value="<%=GetValue(objRS,"DT_PREV_INI")%>"
			onkeyUp="JavaScript:FormataInputData(this.form.name, this.name); return autoTab(this, 10, event);" 
			onkeypress="validateNumKey();">
		</td>
	</tr>
	<tr><td colspan="2" height="2px"></td></tr>
	<tr> 
		<td align="right">*Data Fim:&nbsp;</td>
      <td>
			<input name="DBVAR_DATE_DT_PREV_FIMô" type="text" class="edtext" style="width:70px" maxlength="10" value="<%=GetValue(objRS,"DT_PREV_FIM")%>"
			onkeyUp="JavaScript:FormataInputData(this.form.name, this.name); return autoTab(this, 10, event);" 
			onkeypress="validateNumKey();">			
		</td>
	</tr>
	<tr><td colspan="2" height="2px"></td></tr>
    <tr> 
      <td align="right">Descriçao:&nbsp;</td>
      <td><textarea name="DBVAR_STR_DESCRICAO" rows="6" class="edtext" style="width:220px"><%=GetValue(objRS,"DESCRICAO")%></textarea></td>
    </tr>
	<tr><td align="right"></td><td class="texto_ajuda"><i>Campos com <span style="font-size:8px; vertical-align:middle; width:10px;">*</span>são obrigatórios</i></td></tr>
</table>
</form>
<% athEndDialog WMD_WIDTH, "../img/bt_save.gif", "document.form_update.submit();", "", "", "", "" %>
</body>
</html>
<%
end if
FechaRecordSet objRS
FechaDBConn objConn
%>
