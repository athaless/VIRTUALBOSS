<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_FIN_PREV_ORCA", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
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
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="form_insert.var_dt_inicio.focus();">
<form name="form_insert" action="../modulo_FIN_PREV_ORCA/Insert_Exec.asp" method="post">
<% athBeginDialog WMD_WIDTH, "Previsão Orçamentária - Inserção" %>
<table width="100%" border="0" cellpadding="1" cellspacing="0">
	<tr><td colspan="2" height="10px"></td></tr>
	<tr> 
		<td align="right">*Data Início:&nbsp;</td>
      <td>
			<input name="var_dt_inicio" type="text" class="edtext" style="width:70px" maxlength="10" value=""
			onkeyUp="JavaScript:FormataInputData(this.form.name, this.name); return autoTab(this, 10, event);" 
			onkeypress="validateNumKey();">
		</td>
	</tr>
	<tr><td colspan="2" height="2px"></td></tr>
	<tr> 
		<td align="right">*Data Fim:&nbsp;</td>
      <td>
			<input name="var_dt_fim" type="text" class="edtext" style="width:70px" maxlength="10" value=""
			onkeyUp="JavaScript:FormataInputData(this.form.name, this.name); return autoTab(this, 10, event);" 
			onkeypress="validateNumKey();">			
		</td>
	</tr>
	<tr><td colspan="2" height="2px"></td></tr>
    <tr> 
      <td align="right">Descriçao:&nbsp;</td>
      <td><textarea name="var_descricao" rows="6" class="edtext" style="width:220px"></textarea></td>
    </tr>
	<tr><td align="right"></td><td class="texto_ajuda"><i>Campos com <span style="font-size:8px; vertical-align:middle; width:10px;">*</span>são obrigatórios</i></td></tr>
</table>
</form>
<% athEndDialog WMD_WIDTH, "../img/bt_save.gif", "document.form_insert.submit();", "", "", "", "" %>
</body>
</html>