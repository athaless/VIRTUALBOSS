<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_info.gif:ATENÇÃO! A ENQUETE será copiada, suas QUESTÕES e ALTERNATIVAS correspondentes também."' -------------------------------------------------------------------------------

 Dim objConn, objRS, objRSAux, strSQL
 Dim strCODIGO 

 strCODIGO = GetParam("var_chavereg")
 
 AbreDBConn objConn, CFG_DB 

 strSQL = "SELECT TITULO, TIPO_ENTIDADE, DT_INI, DT_FIM, QUORUM FROM en_enquete WHERE COD_ENQUETE =  " & strCODIGO
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
<%=athBeginDialog(WMD_WIDTH, "Enquete - Duplicação") %>
	<form name="form_copia" action="InsertCopiaEnquete_exec.asp" method="post">
        <input type="hidden" name="var_cod_enquete"  value="<%=strCODIGO%>">	
        <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
        <input type="hidden" name="DEFAULT_LOCATION" value='InsertCopiaEnquete.asp?var_chavereg=<%=strCODIGO%>'>    
        <div class="form_label">* Título:</div><input name="var_novo_titulo" type="text" style="width:300px" value="<%="COPY_"&getValue(objRS,"TITULO")%>" maxlength="250">
        <br><div class="form_label">Entidade:</div><select name="var_nova_entidade"><option value=""></option><option <%if getValue(objRS,"TIPO_ENTIDADE") = "ENT_COLABORADOR" THEN %>SELECTED<%end if%> value="ENT_COLABORADOR">COLABORADOR</option><option  <%if getValue(objRS,"ENT_CLIENTE") = "ENT_COLABORADOR" THEN %>SELECTED<%end if%>  value="ENT_CLIENTE">CLIENTE</option><!--option <%if getValue(objRS,"ENT_CLIENTE") = "ENT_FORNECEDOR" THEN %>SELECTED<%end if%> value="ENT_FORNECEDOR">FORNECEDOR</option//--></select>
        <br><div class="form_label">Quórum:</div><select name="var_novo_quorum"><option value="0">0</option><option value="1">1</option><option value="5">5</option><option value="10">10</option><option value="25">25</option><option value="50">50</option><option value="75">75</option><option value="100">100</option></select>
        <div style="padding-left:110px;"><span class="texto_ajuda">O valores do campo Quorum, referem-se ao porcentual mínimo de respostas para que os resultados da enquete sejam vistos por usuário que já respondeu</span></div>
        <br><div class="form_label">Data Início:</div><%=InputDate("var_novo_dt_ini","",getValue(objRS,"DT_INI"),false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_novo_dt_ini", "ver calendário")%>
        <br><div class="form_label">Data Fim:</div><%=InputDate("var_novo_dt_fim","",getValue(objRS,"DT_FIM"),false)%>&nbsp;<%=ShowLinkCalendario("form_insert", "var_novo_dt_fim", "ver calendário")%>    
	</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
 End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>	