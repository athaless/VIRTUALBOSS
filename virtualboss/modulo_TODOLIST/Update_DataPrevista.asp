<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|INS_RESP|", BuscaDireitosFromDB("modulo_TODOLIST", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strSQL, objRS, ObjConn
Dim strCODIGO, strVALOR, Cont
Dim strTITULO, strRESPONSAVEL, strDESCRICAO
Dim strPREV_DT_INI, strPREV_HR_INI, strPREV_HR_INI_hora, strPREV_HR_INI_min, strPREV_HORAS_HH, strPREV_HORAS_MM

strCODIGO = GetParam("var_chavereg")

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	'Busca todos os dados da tarefa apenas para poder repassá-los 
	'para a InsertRespostaExec para que ela possa enviar e-mails completos
	strSQL = "SELECT TT.TITULO, TT.ID_RESPONSAVEL, TT.PREV_DT_INI, TT.PREV_HR_INI, TT.PREV_HORAS, TT.SITUACAO " &_
			 "     , TT.PRIORIDADE, TT.DESCRICAO " &_
			 "  FROM TL_TODOLIST TT  " &_
			 " WHERE TT.COD_TODOLIST = " & strCODIGO 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then
		strTITULO         = GetValue(objRS,"TITULO")
		strRESPONSAVEL    = LCase(GetValue(objRS,"ID_RESPONSAVEL"))
		strPREV_DT_INI    = GetValue(objRS,"PREV_DT_INI")
        strPREV_HR_INI    = GetValue(objRS,"PREV_HR_INI")
		strDESCRICAO      = GetValue(objRS,"DESCRICAO")
		
	If strPREV_HR_INI <> "" Then
		strPREV_HR_INI_hora = Mid(strPREV_HR_INI, 1, InStr(strPREV_HR_INI, ":")-1)
		strPREV_HR_INI_min = Mid(strPREV_HR_INI, InStr(strPREV_HR_INI, ":")+1, 2) 
	End If		
	
	strPREV_HORAS_HH = FormataHoraNumToHHMM(GetValue(objRS,"PREV_HORAS"))
	strPREV_HORAS_MM = strPREV_HORAS_HH
	if strPREV_HORAS_HH <> "" then 
		strPREV_HORAS_HH = Mid(strPREV_HORAS_HH, 1, InStr(strPREV_HORAS_HH, ":")-1)
		strPREV_HORAS_MM = Mid(strPREV_HORAS_MM, InStr(strPREV_HORAS_MM, ":")+1, 2) 
	end if 
	
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
//****** Funções de ação dos botões - Início ******
function ok2()       { document.form_upd_dt_prev.DEFAULT_LOCATION.value = ""; submeterForm2(); }
function cancelar2() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar2()  { document.form_upd_dt_prev.JSCRIPT_ACTION.value = ""; submeterForm2(); }
function submeterForm2() {
	var var_msg = '';
	//if (document.form_upd_dt_prev.var_motivo.value == '')    var_msg += '\nPara';
	//if (document.form_upd_dt_prev.var_resposta.value == '')  var_msg += '\nResposta';
	
	if (var_msg == '')
		document.form_upd_dt_prev.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>

<%=athBeginDialog(WMD_WIDTH, "ToDo List - Alteração de Data Prevista")%>
<form name="form_upd_dt_prev" action="Update_DataPrevistaExec.asp" method="post">
	<input type="hidden" name="var_chavereg"     value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='Update_DataPrevista.asp?var_chavereg=<%=strCODIGO%>'>
	<input type="hidden" name="var_old_prev_dt_ini" value="<%=strPREV_DT_INI%>">
	<br><div class="form_label">Categoria:</div><select name="var_ch_categoria" style="width:100px;">
   			<option value='' selected='selected'>[selecione]</option>
			<%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM CH_CATEGORIA ORDER BY NOME ","COD_CATEGORIA","NOME","")%>
	</select>&nbsp;<span class="texto_ajuda"><i>mudar categoria do chamado</i></span>
    <br><div class="form_label">Prev. In&iacute;cio:</div><%=InputDate("var_prev_dt_ini","",PrepData(strPREV_DT_INI,true,false),false)%>
			<select name="var_prev_hr_ini_hora" size="1" style="width:40px">
				<option value="" <% If CStr(strPREV_HR_INI_hora) = "" Then Response.Write(" selected='selected'") End If %>></option>
				<% 
				For Cont = 0 to 23
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'")
					If CStr(strPREV_HR_INI_hora) = strVALOR Then Response.Write(" selected='selected'")
					Response.Write(">" & strVALOR & "</option>")
				Next
				%>
			</select>
			<select name="var_prev_hr_ini_min" size="1" style="width:60px">
				<option value="" <% If CStr(strPREV_HR_INI_min) = "" Then Response.Write(" selected='selected'") End If %>></option>
				<%
				Cont = 0
				Do While (Cont <= 55)
					If Cont < 10 Then strVALOR = CStr("0" & Cont) Else strVALOR = CStr(Cont) End If
					Response.Write("<option value='" & strVALOR & "'")
					If CStr(strPREV_HR_INI_min) = strVALOR Then Response.Write(" selected='selected'")
					Response.Write(">" & strVALOR & " min</option>")
					Cont = Cont + 5
				Loop
				%>
			</select>&nbsp;<span class="texto_ajuda">&nbsp;<i>dd/mm/aaaa hh:mm</i></span>
    <br><div class="form_label">Prev. Horas:</div><input name="var_prev_horas" type="text" style="width:40px;" maxlength="5" value="<%=strPREV_HORAS_HH%>" onKeyPress="validateNumKey();">&nbsp;h&nbsp;
            <select name="var_prev_minutos" style="width:70px;">
                <option value="00" <% If strPREV_HORAS_MM =  "0" Then Response.Write(" selected='selected'") End If %>>00 min</option>
                <option value="25" <% If strPREV_HORAS_MM = "15" Then Response.Write(" selected='selected'") End If %>>15 min</option>
                <option value="50" <% If strPREV_HORAS_MM = "30" Then Response.Write(" selected='selected'") End If %>>30 min</option>
                <option value="75" <% If strPREV_HORAS_MM = "45" Then Response.Write(" selected='selected'") End If %>>45 min</option>
            </select>
	<br><div class='form_label'></div><input  style="border:0px; vertical-align:middle;" type="checkbox" name="var_add_resp_default" value="T" checked>&nbsp;Incluir resposta padrão de alteração da data prevista
    <br><div class='form_label'>Motivo:</div><textarea name="var_motivo" rows="8" style="width:340px;"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok2();", "../img/butxp_cancelar.gif", "cancelar2();", "../img/butxp_aplicar.gif", "aplicar2();")%>
</body>
</html>
<%
	end if
	FechaDBConn objConn
end if 
%>