<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|COPY|", BuscaDireitosFromDB("modulo_BS", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
 Dim strSQL, objRS, ObjConn

 AbreDBConn objConn, CFG_DB 

 strSQL = "SELECT" 	&_
			"	BS.COD_BOLETIM," 	&_
			"	BS.TITULO,"			&_
			"	MIN(TL.PREV_DT_INI) AS DT_INI," 	&_
			"	MAX(TL.PREV_DT_INI) AS DT_FIM " 	&_
			"FROM" 		&_
			"	BS_BOLETIM BS " 	&_
			"LEFT OUTER JOIN" 	&_	
			"	TL_TODOLIST TL ON (BS.COD_BOLETIM=TL.COD_BOLETIM) "	&_
			"WHERE" 		&_
			"	BS.TIPO LIKE 'MODELO' " &_
			"GROUP BY"	&_
			"	BS.COD_BOLETIM," 	&_
			"	BS.TITULO"			
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1		
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_cod_boletim.value == '')        		var_msg += '\nAtividade';

	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Atividade/BS - Modelo")%>
<form name="form_insert" action="InsertModelo_Exec.asp" method="post">
	<input type="hidden" name="var_dt_ini" value="<%=GetValue(objRS,"DT_INI")%>">
	<input type="hidden" name="var_dt_fim" value="<%=GetValue(objRS,"DT_FIM")%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='InsertModelo.asp'>
	<div class="form_label">*Atividades:</div><select name="var_cod_boletim" id="var_cod_boletim" style="width:300px;">
			<%	if not objRS.Eof then %>
				<option value="" selected>Selecione um modelo de atividade</option>
				<%	while not objRS.Eof %>
					<option value="<%=GetValue(objRS,"COD_BOLETIM")%>">
						<%
						Response.Write(Mid(GetValue(objRS,"TITULO"),1,80))
						if Len(GetValue(objRS,"TITULO"))>80 then Response.Write("...")
						if GetValue(objRS,"DT_INI") <> "" and GetValue(objRS,"DT_FIM") <> "" then
							Response.Write(" (" & GetValue(objRS,"DT_INI") & " - " & GetValue(objRS,"DT_FIM") & ")")
						end if
						%>
					</option>
				<%	objRS.MoveNext %>
				<%	wend %>
			<%	else	%>
				<option value="" selected>Não foi possível localizar modelo</option>
			<%	end if %>
			</select>
	<br><div class="form_label"><input name="var_change" id="var_change" type="radio" class="inputclean" value="true" checked="checked"></div><div class="form_bypass">Desejo alterar as datas das tarefas a partir da data <%=InputDate("var_date","","",false)%><%=ShowLinkCalendario("form_insert", "var_date", "ver calendário")%></div>
	<br><div class="form_label"><input name="var_change" id="var_change" type="radio" class="inputclean" value="false" onClick="form_insert.var_date.readOnly=true;"></div><div class="form_bypass">Desejo manter as datas originais nas tarefas e alterar mais tarde.</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
	FechaDBConn objConn 
%>