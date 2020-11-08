<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CHAMADO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Dim objConn , objRS, strSQL
	Dim strCODIGO, strCodEnquete
	
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

strCODIGO = Getparam("var_chavereg")
strCodEnquete = Getparam("var_codigo")
 
AbreDBConn objConn, CFG_DB

%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_insert.submit(); }
//****** Funções de ação dos botões - Fim ******

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Cadastro de Alternativas - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post" >
	<input type="hidden" name="DEFAULT_TABLE"    	  value="EN_ALTERNATIVA">
	<input type="hidden" name="DEFAULT_DB"            value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     	  value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  	  value="COD_ALTERNATIVA">
	<input type="hidden" name="DBVAR_NUM_COD_QUESTAO" value="<%=strCODIGO%>">	
	<!--input type="hidden" name="JSCRIPT_ACTION"   		   value='parent.frames["vbTopFrame"].document.form_principal.submit();'//-->
   	<input type="hidden" name="JSCRIPT_ACTION"   		   value=''>
	<input type="hidden" name="DEFAULT_LOCATION" 		   value='../modulo_ENQUETE/DetailQuestao.asp?var_chavereg=<%=strCodEnquete%>'>    
	<div class="form_label">Tipo:</div>
    	<select name="DBVAR_STR_TIPO" id="DBVAR_STR_TIPO">
    		<option value=""></option>
            <option value="OBJETIVA">OBJETIVA</option>
            <option value="SUBJETIVA">SUBJETIVA</option>
        </select>
   	<br><div class="form_label">Alternativa:</div><input name="DBVAR_STR_ALTERNATIVA" type="text" maxlength="250" value="" style="width:300px;"><span class="texto_ajuda">&nbsp;</span>		
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>
<%
FechaDBConn objConn
%>