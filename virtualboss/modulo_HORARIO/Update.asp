<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_HORARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"--> 
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim strVALUE,i
strVALUE="00:00:00"

Dim objConn, objRS, strSQL, strSQLClause
Dim strCOD_HORARIO
Dim strE1, strS1, strE2, strS2, strE3, strS3, strTOTAL
AbreDBConn objConn, CFG_DB 

strCOD_HORARIO = GetParam("var_chavereg")

if strCOD_HORARIO<>"" then
	strSQL =	"SELECT"		&_
				"	COD_HORARIO,"	&_
				"	ID_USUARIO,"	&_
				"	DIA_SEMANA,"	&_
				"	IN_1,OUT_1,"	&_
				"	IN_2,OUT_2,"	&_
				"	IN_3,OUT_3,"	&_	
				"	COD_EMPRESA,"	&_					
				"	TOTAL,"	&_
				"	OBS "		&_
				"FROM "		&_
				"	USUARIO_HORARIO "	&_
				"WHERE COD_HORARIO=" & strCOD_HORARIO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.Eof then				 
	
		strE1	=	GetValue(objRS,"IN_1")
		if strE1="" then strE1	= "00:00:00"
		
		strS1	=	GetValue(objRS,"OUT_1")
		if strS1="" then strS1	= "00:00:00"
		
		strE2	=	GetValue(objRS,"IN_2")
		if strE2="" then strE2	= "00:00:00"
		
		strS2	=	GetValue(objRS,"OUT_2")
		if strS2="" then strS2	= "00:00:00"

		strE3	=	GetValue(objRs,"IN_3")
		if strE3="" then strE3	= "00:00:00"
		
		strS3	=	GetValue(objRS,"OUT_3")
		if strS3="" then strS3	= "00:00:00"
		
		strTOTAL = GetValue(objRS,"TOTAL")
		if strTOTAL="" then strTOTAL = "00:00:00"
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
			strE1 = document.form_update.var_in_1.value;
			strS1 = document.form_update.var_out_1.value;
					
			strE2 = document.form_update.var_in_2.value;
			strS2 = document.form_update.var_out_2.value;
	
			strE3 = document.form_update.var_in_3.value;
			strS3 = document.form_update.var_out_3.value;
		
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
			
			document.form_update.var_total.value = strTOTAL;
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
	function ok() 		{ document.form_update.DEFAULT_LOCATION.value = ""; submeterForm(); }
	function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); /*window.close();*/ }
	function aplicar()  { document.form_update.JSCRIPT_ACTION.value = "";	submeterForm(); }
	
	function submeterForm() {
		var var_msg = '';
		
		if (document.form_update.var_id_usuario.value == '') var_msg += '\nID Usuário';
		if (document.form_update.var_cod_empresa.value == '') var_msg += '\nEmpresa';
		
		if (var_msg == '')
			document.form_update.submit();
		else
			alert('Favor verificar campos obrigatórios:\n' + var_msg);
	}
	//****** Funções de ação dos botões - Fim ******

</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Horário - Alteração")%>
<form name="form_update" action="Update_Exec.asp" method="post">
	<input name="var_chavereg" type="hidden" value="<%=strCOD_HORARIO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='Update.asp?var_chavereg=<%=strCOD_HORARIO%>'>
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=GetValue(objRS,"COD_HORARIO")%></div>
	<br><div class="form_label">*Usuário:</div><select name="var_id_usuario" style="width:90px;">
													<option value="<%=GetValue(objRs,"ID_USUARIO")%>">
														<%=GetValue(objRs,"ID_USUARIO")%>
													</option>	
												</select>
	<br><div class="form_label">*Empresa:</div><select name="var_cod_empresa" style="width:90px;">
											   <%=montaCombo("STR","SELECT SIGLA_PONTO FROM ENT_CLIENTE WHERE DT_INATIVO IS NULL AND SIGLA_PONTO IS NOT NULL ORDER BY SIGLA_PONTO", "SIGLA_PONTO", "SIGLA_PONTO", GetValue(objRS,"COD_EMPRESA"))%>
											   </select>
											   <span class="texto_ajuda">
											   	"empresa padrão" para marcação do reg. de horas
											   </span>
	<br><div class="form_label">Dia da semana:</div><div class="form_bypass"><%=GetValue(objRs,"DIA_SEMANA")%></div>
	<br><div class="form_label">Entrada 1:</div><input name="var_in_1" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);"
												onBlur="PreenchAuto(this.form.name, this.name);" 	
												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strE1%>">
	<div class="form_label_nowidth">Saída 1:</div><input name="var_out_1" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);" 
												onBlur="PreenchAuto(this.form.name, this.name); GetTotal();" 	
												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strS1%>">
	<br><div class="form_label">Entrada 2:</div><input name="var_in_2" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);"
												onBlur="PreenchAuto(this.form.name, this.name);"
												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strE2%>">
	<div class="form_label_nowidth">Saída 2:</div><input name="var_out_2" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);"
												onBlur="PreenchAuto(this.form.name,this.name);this.form.var_total.focus(); GetTotal();"
											 	onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strS2%>">
	<br><div class="form_label">Entrada 3:</div><input name="var_in_3" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);"
												onBlur="PreenchAuto(this.form.name, this.name);" 	
												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strE3%>">
	<div class="form_label_nowidth">Saída 3:</div><input name="var_out_3" type="text" maxlength="5" style="width:60px;" 
												onKeyUp="FormataInputHora(this.form.name, this.name);" 
												onBlur="PreenchAuto(this.form.name,this.name);this.form.var_total.focus(); GetTotal();" 												onKeyPress="validateNumKey();" onFocus="this.value='';"
												value="<%=strS3%>">
	
	
	<br><div class="form_label">Total:</div><input name="var_total" type="text" maxlength="8" style="width:60px;" 
												onFocus="GetTotal();" value="<%=strTOTAL%>" readonly>
	<br><div class="form_label">Observa&ccedil;&atilde;o:</div><textarea name="OBS" rows="5"><%=GetValue(objRs,"OBS")%></textarea>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
		FechaRecordSet objRS
	end if
	FechaDBConn objConn
end if
%>