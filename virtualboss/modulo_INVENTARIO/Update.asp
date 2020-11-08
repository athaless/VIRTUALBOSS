<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_INVENTARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
	Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
    Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 Dim objConn, objRS, strSQL, strCODIGO
 
 AbreDBConn objConn, CFG_DB
 
 strCODIGO = GetParam("var_chavereg")
 
 strSQL =          " SELECT COD_INVENTARIO, ID_ITEM, NOME_ITEM, DESC_ITEM "
 strSQL = strSQL & "      , PROPRIEDADE, DT_COMPRA, LOCAL_COMPRA, PRC_COMPRA, DT_GARANTIA "  
 strSQL = strSQL & "      , TIPO, MARCA, DIVISAO, OBS, ARQUIVO_ANEXO, DT_INATIVO "
 strSQL = strSQL & "      , SYS_DT_INS, SYS_USR_INS, SYS_DT_ALT, SYS_USR_ALT "
 strSQL = strSQL & " FROM INVENTARIO "
 strSQL = strSQL & " WHERE COD_INVENTARIO = " & strCODIGO
 
 Set objRS = objConn.execute(strSQL)
 
 If Not objRS.EOF then  
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	/*if (document.form_update.var_nome.value == '') var_msg += '\nNome';*/
	if (var_msg == '')
		document.form_update.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Inventário - Atualização")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="INVENTARIO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_INVENTARIO">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="DBVAR_DATE_SYS_DT_ALT"  value="<%=Date()%>">
	<input type="hidden" name="DBVAR_STR_SYS_USR_ALT"  value="<%=request.Cookies("VBOSS")("ID_USUARIO")%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value="parent.frames['vbTopFrame'].document.form_principal.submit();">
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_INVENTARIO/Update.asp?var_chavereg=<%=strCODIGO%>">
    <div class="form_label">Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">ID:</div><input name="DBVAR_STR_ID_ITEM" type="text" style="width:120px" maxlength="50" value="<%=objRS("ID_ITEM")%>">
    <br><div class="form_label">Nome:</div><input name="DBVAR_STR_NOME_ITEM" type="text" style="width:220px" maxlength="255" value="<%=objRS("NOME_ITEM")%>">
	<br><div class="form_label">Descrição:</div><textarea name="DBVAR_STR_DESC_ITEM" rows="5" cols="60"><%=objRS("DESC_ITEM")%></textarea>
	<br><div class="form_label">Owner:</div><input name="DBVAR_STR_PROPRIEDADE" type="text" style="width:150px" maxlength="80" value="<%=objRS("PROPRIEDADE")%>">
    <br><div class="form_label">Divisão/Área:</div><input name="DBVAR_STR_DIVISAO" type="text" style="width:150px" maxlength="80" value="<%=objRS("DIVISAO")%>">
    <br><div class="form_label">Tipo:</div><select name="DBVAR_STR_TIPO" style="width:150px">
			<option value=""<%if objRS("TIPO") = "" then%>selected<%end if%>>[tipo]</option>
			<option value="VEICULO"  <%if objRS("TIPO") = "VEICULO"  then%>selected<%end if%>>VEÍCULO (VU 5)</option>
			<option value="MOVEIS"   <%if objRS("TIPO") = "MOVEIS"   then%>selected<%end if%>>MÓVEIS (VU 10)</option>
			<option value="IMOVEL"   <%if objRS("TIPO") = "IMOVEL"   then%>selected<%end if%>>IMÓVEL (VU 25)</option>
			<option value="HARDWARE" <%if objRS("TIPO") = "HARDWARE" then%>selected<%end if%>>HARDWARE (VU 10)</option>
			<option value="SOFTWARE" <%if objRS("TIPO") = "SOFTWARE" then%>selected<%end if%>>SOFTWARE (VU 1)</option>
            <option value="OUTROS"   <%if objRS("TIPO") = "OUTROS"   then%>selected<%end if%>>OUTROS (VU ~)</option>
        </select>
	<br><div class="form_label">Marca:</div><input name="DBVAR_STR_MARCA" type="text" style="width:220px" maxlength="50" value="<%=objRS("MARCA")%>">
	<br><div class="form_label">Local da Compra:</div><input name="DBVAR_STR_LOCAL_COMPRA" type="text" style="width:250px" maxlength="50" value="<%=objRS("LOCAL_COMPRA")%>">
	<br><div class="form_label">Preço da Compra ou Avaliação:</div><input name="DBVAR_MOEDA_PRC_COMPRA" type="text" style="width:50px" maxlength="10" value="<%=FormataDecimal(objRS("PRC_COMPRA"), 2)%>" onKeyPress="validateFloatKey();">
	<br><div class="form_label">Data da Compra ou Avaliação:</div><%=InputDate("DBVAR_DATE_DT_COMPRA","",PrepData(GetValue(objRS,"DT_COMPRA"), True, False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_COMPRA", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
	<br><div class="form_label">Data da Garantia:</div><%=InputDate("DBVAR_DATE_DT_GARANTIA","",PrepData(GetValue(objRS,"DT_GARANTIA"), True, False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_GARANTIA", "ver calendário")%>&nbsp;<span class="texto_ajuda"><i>dd/mm/aaaa</i></span>
    <br><div class="form_label">Obs.:</div><textarea name="DBVAR_STR_OBS" rows="5"><%=objRS("OBS")%></textarea>
    <br><div class="form_label">Status:</div><%
		If GetValue(objRS,"DT_INATIVO") = "" Then
		  Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL' checked>Ativo")
		  Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "'>Inativo")
		Else
		  Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL'>Ativo")
		  Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "' checked>Inativo")
		End If
	 %>
     <br><div class="form_label">Anexo:</div><input name="DBVAR_STR_ARQUIVO_ANEXO" type="text" readonly="readonly" maxlength="250" value="<%=objRS("ARQUIVO_ANEXO")%>" style="width:160px;"><a href="javascript:UploadArquivo('form_update','DBVAR_STR_ARQUIVO_ANEXO', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//INVENTARIO_Anexos');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a><span class="texto_ajuda">&nbsp; Anexo principal do chamado.</span>		
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
 FechaRecordset(objRS)
 FechaDBConn(objConn)
 End if 
%>