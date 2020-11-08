<!--#include file="../_database/athdbConn.asp"--> <%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_IMPORTACAO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/athSendMail.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "dlg_info.gif:ATENÇÃO! Somente arquivos do tipo XLS.<br> <span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

 Dim objConn, objRS, objRSAux, strSQL
 Dim strCODIGO 

 strCODIGO = GetParam("var_chavereg")
 
 AbreDBConn objConn, CFG_DB 

	strSQL="show tables " 
 	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 
 If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { 
	var var_msg
	var_msg = '';
		
	if (document.form_principal.var_tabela.value == '')        var_msg += '\nTabela';
	if (document.form_principal.var_arquivo_excel.value == '')  var_msg += '\nArquivo';

	if (var_msg == ''){
		document.form_principal.DEFAULT_LOCATION.value = ""; 
		document.form_principal.submit(); 
    }
	else {alert('Favor verificar campos obrigatórios:\n' + var_msg);}
}
function cancelar() { document.location.href = document.form_principal.DEFAULT_LOCATION.value; }
function aplicar() { document.form_insert.JSCRIPT_ACTION.value = "";	document.form_principal.submit(); }
function updateFrame(prValor){
//	alert(prValor);	
	document.getElementById("var_tables").value = prValor;
	document.getElementById("campostable").submit();
	
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Importação Planilhas Excel") %>
	<form name="form_principal" action="ImportExcel_exec.asp" method="post">
	    <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
   		<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_PAINEL/principal.htm'>    
        <div class='form_label'>*Tabela:</div><select name="var_tabela" id="var_tabela" class="textbox180" onChange="updateFrame(this.value);">
                <option value="" selected>Selecione a tabela...</option>
                <%
                while not objRS.EOF
                    Response.Write("<option value="&GetValue(objRS,"tables_in_"&CFG_DB)&" >"&GetValue(objRS,"tables_in_"&CFG_DB)&"</option>")
                    objRS.Movenext
                Wend
                %>
            </select>
     <br><div class='form_label'>Campos:</div><iframe id="view_tables" name="view_tables" frameborder="0" style="height:200px; width:303px; background-color:#E8EEFA; margin-left:2px; margin-top:7px;"  scrolling="auto"></iframe>
     <br><div class="form_label">*Arquivo:</div><input name="var_arquivo_excel" id="var_arquivo_excel" type="text" readonly="readonly" maxlength="250" value="" style="width:300px;"><a href="javascript:UploadArquivo('form_principal','var_arquivo_excel', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>');"> <img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a><span class="texto_ajuda">&nbsp; Upload.</span>
</form>
<form id="campostable" name="campostable" action="ViewTables.asp" target="view_tables">
	<input type="hidden" id="var_tables" name="var_tables">
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "", "") %>
</body>
</html>
<%
 End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>	