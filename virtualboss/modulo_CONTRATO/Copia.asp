<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_info.gif:ATENÇÃO! O Contrato, suas PARCELAS e ANEXOS serão copiados."' -------------------------------------------------------------------------------

 Dim objConn, objRS, objRSAux, strSQL
 Dim strCODIGO 

 strCODIGO = GetParam("var_chavereg")
 
 AbreDBConn objConn, CFG_DB 

 strSQL = "SELECT COD_CONTRATO, TITULO FROM CONTRATO WHERE COD_CONTRATO = " & strCODIGO
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 
 If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_copia.DEFAULT_LOCATION.value = ""; document.form_copia.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_copia.JSCRIPT_ACTION.value = "";	document.form_copia.submit(); }
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Contrato - Duplicação") %>
	<form name="form_copia" action="Copia_Exec.asp" method="post">
	<input type="hidden" name="var_cod_contrato"  value="<%=strCODIGO%>">
    <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
    <input type="hidden" name="DEFAULT_LOCATION" value='InsertCopiaUser.asp?var_chavereg=<%=strCODIGO%>'>
    <div class='form_label'>Contrato copiado:</div><div class="form_bypass"><%=strCODIGO%></div>
    <br><div class='form_label'>Título do novo contrato:</div><div class="form_bypass"><input name="var_novo_tit" type="text" style="width:250px;" value="<%="COPY_"&GetValue(objRS,"TITULO")%>"></div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
 End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>	