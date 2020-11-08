<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

	Dim strSQL, objRS, ObjConn
	Dim strCODIGO, strData, strRESP, arrESTADOS, arrNOMES, Cont
	
	strCODIGO = GetParam("var_chavereg")

	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSQL =          " SELECT  COD_ENQUETE, TITULO ,DT_INI, DT_FIM, TIPO_ENTIDADE ,QUORUM "
		strSql = strSql & " FROM EN_ENQUETE  "
		strSQL = strSQL & " WHERE COD_ENQUETE = " & strCODIGO 
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok() { document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar() { document.form_update.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() { document.form_update.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Enquete - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE" value="EN_ENQUETE">
	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME" value="COD_ENQUETE">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value="../modulo_ENQUETE/update.asp?var_chavereg=<%=strCODIGO%>">
    <div class="form_label">Cód.:</div><div class="form_bypass"><%=strCODIGO%></div>
    <br><div class="form_label">Nome:</div><input name="DBVAR_STR_TITULOô" type="text" style="width:300px" value="<%=GetValue(objRS,"TITULO")%>" maxlength="250">
    <br><div class="form_label">Entidade:</div><select name="DBVAR_STR_TIPO_ENTIDADEô">
            	<option value=""></option>
                <option value="ENT_COLABORADOR" <% if getValue(objRS,"TIPO_ENTIDADE") = "ENT_COLABORADOR" Then %> SELECTED <% End If %>>COLABORADOR</option>
                <option value="ENT_CLIENTE" <% if getValue(objRS,"TIPO_ENTIDADE") = "ENT_CLIENTE" Then %> SELECTED <% End If %>>CLIENTE</option>
                <!--option value="ENT_FORNECEDOR" <% 'if getValue(objRS,"TIPO_ENTIDADE") = "ENT_FORNECEDOR"  Then %> SELECTED <% 'End If %>>FORNECEDOR</option//-->
            </select>
    <br><div class="form_label">Quórum:</div><select name="DBVAR_NUM_QUORUM">
    	<option value="0"    <% if Cint(getValue(objRS,"QUORUM")) = 0   Then %>SELECTED<% End If %>>0</option>
        <option value="1"    <% if Cint(getValue(objRS,"QUORUM")) = 1   Then %>SELECTED<% End If %>>1</option>
        <option value="5"    <% if Cint(getValue(objRS,"QUORUM")) = 5   Then %>SELECTED<% End If %>>5</option>
        <option value="10"   <% if Cint(getValue(objRS,"QUORUM")) = 10  Then %>SELECTED<% End If %>>10</option>
        <option value="20"   <% if Cint(getValue(objRS,"QUORUM")) = 20  Then %>SELECTED<% End If %>>20</option>
        <option value="25"   <% if Cint(getValue(objRS,"QUORUM")) = 25  Then %>SELECTED<% End If %>>25</option>
        <option value="50"   <% if Cint(getValue(objRS,"QUORUM")) = 50  Then %>SELECTED<% End If %>>50</option>
        <option value="75"   <% if Cint(getValue(objRS,"QUORUM")) = 75  Then %>SELECTED<% End If %>>75</option>
        <option value="100"  <% if Cint(getValue(objRS,"QUORUM")) = 100 Then %>SELECTED<% End If %>>100</option>
     </select>         
    <div style="padding-left:110px;"><span class="texto_ajuda">O valores do campo Quorum, referem-se ao porcentual mínimo de respostas para que os resultados da enquete sejam vistos por usuário que já respondeu</span></div>
    <br><div class="form_label">Data Início:</div><%=InputDate("DBVAR_DATE_DT_INI","",PrepData(GetValue(objRS,"DT_INI"),True,False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_INI", "ver calendário")%>
    <br><div class="form_label">Data Fim:</div><%=InputDate("DBVAR_DATE_DT_FIM","",PrepData(GetValue(objRS,"DT_FIM"),True,False),false)%>&nbsp;<%=ShowLinkCalendario("form_update", "DBVAR_DATE_DT_FIM", "ver calendário")%>
</form>
<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
		End If 
	    FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>