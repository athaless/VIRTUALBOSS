<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_HORARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strVALUE,i

strVALUE="00:00:00"
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
function GetTotal(){
	var strTOTAL;
	var strE1, strS1;
	var strE2, strS2;
	var strE3, strS3;
	var strH, strM;
	
	if (strE1!='' && strS1!='' && strE2!='' && strS2!=''){
		strE1 = document.form_insert.var_in_1.value;
		strS1 = document.form_insert.var_out_1.value;
				
		strE2 = document.form_insert.var_in_2.value;
		strS2 = document.form_insert.var_out_2.value;

		strE3 = document.form_insert.var_in_3.value;
		strS3 = document.form_insert.var_out_3.value;
	
		strE1 = strE1.substr(0,2)*60 + strE1.substr(3,2)*1;
		strS1 = strS1.substr(0,2)*60 + strS1.substr(3,2)*1;

		strE2 = strE2.substr(0,2)*60 + strE2.substr(3,2)*1; 
		strS2 = strS2.substr(0,2)*60 + strS2.substr(3,2)*1;

		strE3 = strE3.substr(0,2)*60 + strE3.substr(3,2)*1; 
		strS3 = strS3.substr(0,2)*60 + strS3.substr(3,2)*1;
		
		strTOTAL = (strS1 - strE1) 
		strTOTAL = strTOTAL + (strS2 - strE2);
		strTOTAL = strTOTAL + (strS3 - strE3);			
		strTOTAL = strTOTAL/60;
		
		strH = (parseInt(strTOTAL))
		if (strH<10)  strH = '0' + strH;
		
		strM	= parseInt((strTOTAL - parseInt(strTOTAL)) *60);
		if (strM<10) strM = '0' + strM;
		
		strTOTAL = strH + ':' + strM + ':00';
		
		document.form_insert.var_total.value = strTOTAL;
	}
}
function PreenchAuto(formname, fieldname){
	var input, inputValue;
	
	input = eval('document.'+formname+'.'+fieldname);
	inputValue = input.value;	

	if (inputValue=='') 
		input.value='00:00:00';
	else 
		if (inputValue.length==3) input.value = inputValue + '00:00';
}
	
//****** Funções de ação dos botões - Início ******
function ok() 		{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); /*window.close();*/ }
function aplicar()  { document.form_insert.JSCRIPT_ACTION.value = "";	submeterForm(); }

function submeterForm() {
	var var_msg = '';
	
	if (document.form_insert.var_id_usuario.value == '')   var_msg += '\nUsuário';
	if (document.form_insert.var_cod_empresa.value == '')  var_msg += '\nEmpresa';

	if ( !(document.form_insert.var_dia_semana_1.checked)
	  && !(document.form_insert.var_dia_semana_2.checked)
	  && !(document.form_insert.var_dia_semana_3.checked)
	  && !(document.form_insert.var_dia_semana_4.checked)
	  && !(document.form_insert.var_dia_semana_5.checked)
	  && !(document.form_insert.var_dia_semana_6.checked)
	  && !(document.form_insert.var_dia_semana_7.checked) ) var_msg += '\nDia da semana';

	if (var_msg == '')
		document.form_insert.submit();
	else
		alert('Favor verificar campos obrigatórios:\n' + var_msg);
}
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Horário - Inserção")%>
<form name="form_insert" action="Insert_Exec.asp" method="post">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='Insert.asp'>
	<div class="form_label">*Usuário:</div><select name="var_id_usuario" style="width:120px;">
										    <%'=montaCombo("STR","SELECT DISTINCT ID_USUARIO FROM USUARIO WHERE DT_INATIVO IS NULL", "ID_USUARIO", "ID_USUARIO","")%>
											<%=montaCombo("STR"," SELECT ID_USUARIO FROM USUARIO WHERE TIPO LIKE '" & Request.Cookies("VBOSS")("ENTIDADE_TIPO") & "' AND GRP_USER <> 'SU' AND DT_INATIVO IS NULL ORDER BY ID_USUARIO ", "ID_USUARIO", "ID_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO"))%>
										   </select>
	<br><div class="form_label">*Empresa:</div><select name="var_cod_empresa" style="width:60px;">
						 				   		<%=montaCombo("STR","SELECT SIGLA_PONTO FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL AND SIGLA_PONTO IS NOT NULL ORDER BY SIGLA_PONTO","SIGLA_PONTO", "SIGLA_PONTO", "")%>
												</select>
	<br><div class="form_label">*Dia da semana:</div>
			<% for i=1 to 3 %>
				<div class="form_label_nowidth"><input name="var_dia_semana_<%=i%>" class="inputclean" type="checkbox" value="<%=UCase(WeekDayName(i,1,2))%>" style="border:1px dashed #CCCCCC;"><span style="padding-left:3px; text-align:top;"><%=UCase(WeekDayName(i,1,2))%></span></div>
			<%	next %>														
	<br><div class="form_label"></div><% for i=1 to 4 %>
				<div class="form_label_nowidth"><input name="var_dia_semana_<%=i+3%>" class="inputclean" type="checkbox" value="<%=UCase(WeekDayName(i,1,5))%>" style="border:1px dashed #CCCCCC;"><span style="padding-left:3px; text-align:top;"><%=UCase(WeekDayName(i,1,5))%></span></div>																	
			<%	next %>											
	<br><div class="form_label">Entrada 1:</div><input name="var_in_1" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);"
												onBlur="PreenchAuto(this.form.name, this.name);" 	
												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strVALUE%>">
	<div class="form_label_nowidth">Saída 1:</div><input name="var_out_1" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);" 
												onBlur="PreenchAuto(this.form.name, this.name); GetTotal();" 	
												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strVALUE%>">
	<br><div class="form_label">Entrada 2:</div><input name="var_in_2" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);"
												onBlur="PreenchAuto(this.form.name, this.name);"
											 	onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strVALUE%>">
	<div class="form_label_nowidth">Saída 2:</div><input name="var_out_2" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);"
												onBlur="PreenchAuto(this.form.name,this.name);this.form.var_total.focus(); GetTotal();"
											 	onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strVALUE%>">
	<br><div class="form_label">Entrada 3:</div><input name="var_in_3" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);"
												onBlur="PreenchAuto(this.form.name, this.name);" 	
												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strVALUE%>">
	<div class="form_label_nowidth">Saída 3:</div><input name="var_out_3" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);" 
												onBlur="PreenchAuto(this.form.name,this.name);this.form.var_total.focus(); GetTotal();"												
												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strVALUE%>">
	<br><div class="form_label">Total:</div><input name="var_total" type="text" maxlength="8" style="width:60px;" 
												onFocus="GetTotal();" value="<%=strVALUE%>" readonly>
	<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="OBS" rows="5"></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
</body>
</html>