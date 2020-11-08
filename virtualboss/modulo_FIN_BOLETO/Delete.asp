<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_BOLETO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

 Dim objConn, objRS, strSQL
 Dim strCODIGO
 
 AbreDBConn objConn, CFG_DB 

 strCODIGO = GetParam("var_chavereg")

 auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado." &_ 
             "Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

 if strCODIGO<>"" then 
	strSQL = "SELECT" 						&_
				"	DESCRICAO,"					&_
				"	CEDENTE_NOME," 			&_
				"	CEDENTE_AGENCIA," 		&_
				"	CEDENTE_CNPJ," 			&_
				"	CEDENTE_CODIGO,"			&_
				"	CEDENTE_CODIGO_DV,"		&_				
				"	BANCO_CODIGO," 			&_
				"	BANCO_DV," 					&_
				"	BANCO_IMG," 				&_
				"	BOLETO_ACEITE," 			&_
				"	BOLETO_CARTEIRA," 		&_
				"	BOLETO_ESPECIE," 			&_
				"	BOLETO_TIPO_DOC,"			&_
				"	LOCAL_PGTO," 				&_
				"	INSTRUCOES," 				&_
				"	DT_INATIVO," 				&_				
				"	MODELO_HTML " 				&_				
				"FROM" 							&_
				"	CFG_BOLETO " 				&_ 
				"WHERE"	 						&_
				"	COD_CFG_BOLETO=" & strCODIGO
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
<%=athBeginDialog(WMD_WIDTH, "Tipo de Boleto - Dele&ccedil;&atilde;o")%>     
<% for Idx = 0 to objRS.fields.count - 1  'NÃO QUIZ EXIBIR TODOS OS DADOS... %>
<br><div class="form_label"><%=objRS.Fields(Idx).name%>:</div><div class="form_bypass"><%=GetValue (objRS, objRS.Fields(Idx).name)%></div>
<% next %>
  <form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="CFG_BOLETO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CFG_BOLETO">
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