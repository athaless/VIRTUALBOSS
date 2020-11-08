<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_NF_CFG", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

 Dim objConn, objRS, strSQL
 Dim strCODIGO

 strCODIGO = GetParam("var_chavereg")

 if strCODIGO<>"" then 
	AbreDBConn objConn, CFG_DB 
	
	strSQL = "SELECT"					& VbCrlf &_
				"	SERIE,"				& VbCrlf &_
				"	DESCRICAO"			& VbCrlf &_
				"FROM"					& VbCrlf &_
				"	CFG_NF "			& VbCrlf &_
				"WHERE"	 				& VbCrlf &_
				"	COD_CFG_NF=" & strCODIGO				
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
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Nota Fiscal - Exclus&atilde;o") %>
  <div class="form_label">Cod:</div><div class="form_bypass"><%=strCODIGO%></div>
  <br><div class="form_label">S&eacute;rie:</div><div class="form_bypass"><%=GetValue(objRS,"SERIE")%></div>
  <br><div class="form_label">Descrição:</div><div class="form_bypass"><%=GetValue(objRS,"DESCRICAO")%></div>
  <form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="CFG_NF">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CFG_NF">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
    <input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
    <input type="hidden" name="DEFAULT_LOCATION" value=''>
  </form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok()", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
	end if 
	
	FechaRecordSet objRS
	FechaDBConn objConn
end if 
%>