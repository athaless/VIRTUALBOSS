<!--#include file="../_database/athdbConn.asp"--> <%' ATEN��O: language, option explicit, etc... est�o no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos �tens de formul�rio 
 ' e o tamanho da coluna dos t�tulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 Const auxAVISO  = "dlg_info.gif:ATEN��O! A QUEST�O ser� copiada, suas ALTERNATIVAS correspondentes tamb�m."' -------------------------------------------------------------------------------

 Dim objConn, objRS, objRSAux, strSQL
 Dim strCODIGO 

 strCODIGO = GetParam("var_chavereg")
 
 AbreDBConn objConn, CFG_DB 

 strSQL = "select COD_QUESTAO, COD_ENQUETE, ORDEM, QUESTAO from en_questao WHERE COD_QUESTAO =  " & strCODIGO
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
function ok() { document.form_copia.DEFAULT_LOCATION.value = ""; document.form_copia.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_copia.JSCRIPT_ACTION.value = "";	document.form_copia.submit(); }
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Quest�o - Duplica��o") %>
	<form name="form_copia" action="InsertCopiaQuestao_exec.asp" method="post">
        <input type="hidden" name="var_cod_questao"  value="<%=strCODIGO%>">	
        <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
        <input type="hidden" name="DEFAULT_LOCATION" value='InsertCopiaEnquete.asp?var_chavereg=<%=strCODIGO%>'>
          	<br><div class="form_label">Enquete:</div><select name='var_cod_nova_enquete' id='var_cod_nova_enquete' style='width:150px;'><option value='' selected></option><%=montaCombo("STR","SELECT COD_ENQUETE, TITULO FROM EN_ENQUETE ", "COD_ENQUETE", "TITULO", getValue(objRS,"COD_ENQUETE")) %></select>
            <br><div class="form_label">Ordem:</div><input name="var_nova_ordem" type="text" maxlength="2" value="<%=getValue(objRS,"ORDEM")%>" style="width:30px;">
            <br><div class="form_label">Quest�o:</div><input name="var_nova_questao" type="text" maxlength="250" value="<%="COPY_"&getValue(objRS,"QUESTAO")%>" style="width:200px;">
	</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
 End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>	