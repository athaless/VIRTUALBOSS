<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_FIN_NF", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
' e o tamanho da coluna dos títulos dos inputs
Dim WMD_WIDTH, WMD_WIDTHTTITLES, auxAVISO
WMD_WIDTH = 570
WMD_WIDTHTTITLES = 170
' -------------------------------------------------------------------------------
Dim objConn, objRS, strSQL
Dim intCOD_NF, Idx

auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro <br> acima visualizado." &_ 
            "Para confirmar clique no botão [ok], para desistir clique em [cancelar]."

AbreDBConn objConn, CFG_DB 

intCOD_NF = GetParam("var_chavereg")

if intCOD_NF<>"" then 
	strSQL = " SELECT"																	&_
				"	T1.COD_NF,"															&_
				"	T1.NUM_NF," 														&_
				"	T1.SERIE,"															&_
				"	T1.COD_CLI,"														&_
				"	T1.CLI_NOME,"														&_
				"	T1.OBS_NF,"															&_
				"	T1.DT_EMISSAO,"														&_
				"	T1.TOT_SERVICO,"													&_
				"	T1.TOT_NF,"															&_
				"	T1.SITUACAO"														&_
				" FROM"																	&_
				"	NF_NOTA T1 " 														&_
				" WHERE T1.COD_NF=" & intCOD_NF											&_
				" AND T1.SYS_DTT_INATIVO IS NULL " 										&_
				" AND T1.SITUACAO <> 'CANCELADA' "
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
	<table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
	<% for Idx = 0 to objRS.fields.count - 1  'NÃO QUIS EXIBIR TODOS OS DADOS... %> 
	  <tr> 
		<td width=<%=WMD_WIDTHTTITLES%> style="text-align:right;"><%=objRS.Fields(Idx).name%>:&nbsp;</td>
		<td><%=GetValue(objRS, objRS.Fields(Idx).name)%>&nbsp;</td>
	  </tr>
	<% next %>
	</table>
	<form name="form_delete" action="../modulo_FIN_NF/Delete_Exec.asp" method="post">
	   <input name="var_chavereg"	  type="hidden" value="<%=intCOD_NF%>">
       <input name="JSCRIPT_ACTION"	  type="hidden"  value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	   <input name="DEFAULT_LOCATION" type="hidden" value=''>
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