<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_CONTAS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

	Dim objConn, objRS, strSQL, strSQLClause
	Dim strCOD_HORARIO
	Dim strCOD_CONTA, strSALDO_INI, strSALDO
	Dim Idx
	
	strCOD_CONTA  = GetParam("var_chavereg")
	
	if strCOD_CONTA <> "" then
		AbreDBConn objConn, CFG_DB 
		
		strSQL =	"SELECT" 					&_	
					"	CTA.NOME,"				&_
					"	CTA.DESCRICAO,"			&_
					"	CTA.TIPO,"				&_
					"	CTA.COD_BANCO,"			&_				
					"	BCO.NOME AS NOME_BCO,"	&_								
					"	CTA.AGENCIA,"			&_			
					"	CTA.CONTA,"				&_
					"	CTA.DT_CADASTRO," 		&_								
					"	CTA.VLR_SALDO_INI,"		&_								
					"	CTA.VLR_SALDO,"			&_
					"	CTA.ORDEM "				&_
					"FROM"						&_
					"	FIN_CONTA CTA "			&_
					"LEFT OUTER JOIN"			&_
					"	FIN_BANCO BCO ON (BCO.COD_BANCO=CTA.COD_BANCO) " &_				
					"WHERE CTA.COD_CONTA=" & strCOD_CONTA &_
					"	AND CTA.DT_INATIVO IS NULL"
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
		if not objRS.Eof then				 
			if GetValue(objRS,"VLR_SALDO_INI")<>"" then strSALDO_INI = FormataDecimal(GetValue(objRS,"VLR_SALDO_INI"),2)
			if GetValue(objRS,"VLR_SALDO")<>"" then strSALDO = FormataDecimal(GetValue(objRS,"VLR_SALDO"),2)
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
<%=athBeginDialog(WMD_WIDTH, "Contas - Exclus&atilde;o") %>
<% for Idx = 0 to objRS.fields.count - 1  'NÃO QUIZ EXIBIR TODOS OS DADOS... %>
<br><div class="form_label"><%=objRS.Fields(Idx).name%>:</div><div class="form_bypass"><%=GetValue (objRS, objRS.Fields(Idx).name)%></div>
<% next %>
<form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="FIN_CONTA">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_CONTA">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_CONTA%>">
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_FIN_CONTAS/DeleteAcumulados_Exec.asp?var_chavereg=<%=strCOD_CONTA%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="">
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