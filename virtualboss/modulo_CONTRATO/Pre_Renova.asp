<!--#include file="../_database/athdbConn.asp"--> <%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CONTRATO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos �tens de formul�rio 
 ' e o tamanho da coluna dos t�tulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 'Const auxAVISO  = "dlg_info.gif:ATEN��O! O Contrato, suas PARCELAS e ANEXOS ser�o copiados."' -------------------------------------------------------------------------------
 Const auxAVISO = "O processo de renova��o consiste na cria��o de um novo contrato a partir deste, onde seus par�metros podem ser devidamente ajustados. O novo contrato ficar� marcado como ""filho"" do atual.<br>Ao cancelar a renova��o, o contrato n�o poder� mais ser renovado."
 
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
//****** Fun��es de a��o dos bot�es - In�cio ******
function ok() { document.form_pre_renova.DEFAULT_LOCATION.value = ""; document.form_pre_renova.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Contrato - Renova��o") %>
	<form name="form_pre_renova" action="Pre_Renova_Exec.asp" method="post">
	<input type="hidden" name="var_cod_contrato"  value="<%=strCODIGO%>">
    <!--<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_pre_renova.submit();'>//-->
    <input type="hidden" name="DEFAULT_LOCATION" value='Pre_Renova.asp?var_chavereg=<%=strCODIGO%>'>
    <br><div class='form_label'>Contrato:</div><div class="form_bypass"><%=strCODIGO & " - " & GetValue(objRS, "TITULO")%></div>   
    <br><div class="form_label">A��o:</div><input type='radio' name='acao_renova' id='acao_renova' class='inputclean' value='renovar'checked>&nbsp;Renovar Contrato   
    <br><div class="form_label">     </div><input type='radio' name='acao_renova' id='acao_renova' class='inputclean' value='cancelar'      >&nbsp;Cancelar Renova��o       
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