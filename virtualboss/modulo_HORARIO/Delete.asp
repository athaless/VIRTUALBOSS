<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_HORARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."
' -------------------------------------------------------------------------------

Dim objConn, objRS, strSQL, strSQLClause
Dim strCOD_HORARIO, Idx
Dim strE1, strS1, strE2, strS2, strTOTAL

AbreDBConn objConn, CFG_DB 

strCOD_HORARIO = GetParam("var_chavereg")
if strCOD_HORARIO<>"" then
	strSQL =	"SELECT"		&_
				"	COD_HORARIO,"	&_
				"	COD_EMPRESA,"	&_
				"	ID_USUARIO,"	&_
				"	DIA_SEMANA,"	&_
				"	IN_1,OUT_1,"	&_
				"	IN_2,OUT_2,"	&_
				"	IN_3,OUT_3,"	&_				
				"	TOTAL,"	&_
				"	OBS "		&_
				"FROM "		&_
				"	USUARIO_HORARIO "	&_
				"WHERE COD_HORARIO=" & strCOD_HORARIO

	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then				 
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
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%=athBeginDialog(WMD_WIDTH, "Horário - Exclus&atilde;o") %>
<!-- Esse não tem como razer o laço pois não dá pra estimar o numeo de registros de entrada e saída no dia... -->
<form name="form_delete" action="Delete_Exec.asp" method="post">
	<input name="COD_HORARIO" type="hidden" value="<%=strCOD_HORARIO%>">
	<input name="ID_USUARIO" type="hidden" value="<%=GetValue(objRs,"ID_USUARIO")%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
    <input type="hidden" name="DEFAULT_LOCATION" value=''>
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=GetValue(objRs,"COD_HORARIO")%></div>
	<br><div class="form_label">Usuário:</div><div class="form_bypass"><%=GetValue(objRs,"ID_USUARIO")%></div>
	<br><div class="form_label">Empresa:</div><div class="form_bypass"><%=GetValue(objRs,"COD_EMPRESA")%></div>
	<br><div class="form_label">Dia da semana:</div><div class="form_bypass"><%=GetValue(objRs,"DIA_SEMANA")%></div>
	<br><div class="form_label">Entrada 1:</div><div class="form_bypass"><%=GetValue(objRs,"IN_1")%></div>
	<br><div class="form_label">Saída 1:</div><div class="form_bypass"><%=GetValue(objRs,"OUT_1")%></div>
	<br><div class="form_label">Entrada 2:</div><div class="form_bypass"><%=GetValue(objRs,"IN_2")%></div>
	<br><div class="form_label">Saída 2:</div><div class="form_bypass"><%=GetValue(objRs,"OUT_2")%></div>
	<% if GetValue(objRs,"IN_3")<>"" then %>
	<br><div class="form_label">Entrada 3:</div><div class="form_bypass"><%=GetValue(objRs,"IN_3")%></div>
	<br><div class="form_label">Saída 3:</div><div class="form_bypass"><%=GetValue(objRs,"OUT_3")%></div>
	<% end if %>
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