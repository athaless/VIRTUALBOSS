<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 'Const auxAVISO  = "dlg_info.gif:ATENÇÃO! O Contrato, suas PARCELAS e ANEXOS serão copiados."' -------------------------------------------------------------------------------
 Const auxAVISO = "O processo de renovação consiste na criação de um novo contrato a partir deste, onde seus parâmetros podem ser devidamente ajustados. O novo contrato ficará marcado como ""filho"" do atual.<br>Ao cancelar a renovação, o contrato não poderá mais ser renovado."
 
 Dim objConn, objRS, objRSAux, strSQL
 Dim strCODIGO 

 strCODIGO = GetParam("var_chavereg")
 
 AbreDBConn objConn, CFG_DB 

 strSQL = "SELECT (DT_FIM + 1) AS DT_FIM, TITULO FROM CONTRATO WHERE COD_CONTRATO = " & strCODIGO
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
function ok() { document.form_pre_renova.DEFAULT_LOCATION.value = ""; document.form_pre_renova.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Contrato - Renovação") %>
	<form name="form_pre_renova" action="Pre_Renova_Exec.asp" method="post">
	<input type="hidden" name="var_cod_contrato"  value="<%=strCODIGO%>">
    <!--<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_pre_renova.submit();'>//-->
    <input type="hidden" name="DEFAULT_LOCATION" value='Pre_Renova.asp?var_chavereg=<%=strCODIGO%>'>
    <br><div class='form_label'>Contrato:</div><div class="form_bypass"><%=strCODIGO & " - " & GetValue(objRS, "TITULO")%></div>   
    <br><div class="form_label">Ação:</div><input type='radio' name='acao_renova' id='acao_renova' class='inputclean' value='renovar'checked>&nbsp;Renovar Contrato   
    <br><div class="form_label">     </div><input type='radio' name='acao_renova' id='acao_renova' class='inputclean' value='cancelar'      >&nbsp;Cancelar Renovação       
    <br><br><%= auxAVISO%>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "") %>
</body>
</html>
<%
 End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>