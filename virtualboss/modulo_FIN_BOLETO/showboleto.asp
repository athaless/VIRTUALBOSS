<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"

Dim objConn, objRS, strSQL

Dim strCOD_CONTA_PAGAR_RECEBER, strCOD_CFG_BOLETO
Dim strBOLETO_IMG_LOGO, strBOLETO_CEDENTE_CODIGO_DV
Dim strBOLETO_AGENCIA, strBOLETO_ACEITE, strBOLETO_CARTEIRA
Dim strBOLETO_CEDENTE_NOME, strBOLETO_CEDENTE_CNPJ, strBOLETO_CEDENTE_ENDERECO 
Dim strBOLETO_COD_BANCO, strBOLETO_COD_BANCO_DV, strBOLETO_CONTA, strBOLETO_CONTA_DV
Dim strBOLETO_ESPECIE, strBOLETO_INSTRUCOES, strBOLETO_LOCAL_PGTO, strBOLETO_COD_CLIENTE
Dim strBOLETO_DT_VENCIMENTO, strBOLETO_NUM_DOCUMENTO, strBOLETO_SACADO_NOME
Dim strBOLETO_SACADO_ENDERECO, strBOLETO_SACADO_BAIRRO, strBOLETO_SACADO_CIDADE
Dim strBOLETO_SACADO_ESTADO, strBOLETO_SACADO_CEP,	strBOLETO_SACADO_IDENTIFICADOR, strBOLETO_SACADO_CNPJ
Dim strBOLETO_NOSSO_NUMERO, strCOD_CLI, strBOLETO_CEDENTE_CODIGO, strNUM_IMPRESSOES
Dim strCODIGO, strMSG, strBOLETO_VALOR, strBOLETO_IMG_PROMO, strBOLETO_TIPO_DOC
Dim strButtonAction, strFormAction, strDialogText
Dim arrEstados, arrNome, i

arrEstados	= array("AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MG","MT","MS","PA","PB","PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO")
arrNome 	= array("Acre","Alagoas","Amapá","Amazonas","Bahia","Ceará","Distrito Federal","Espírito Santo","Goias","Maranhão","Minas Gerais", "Mato Grosso",_
					"Mato Grosso do Sul","Pará","Paraíba","Pernambuco","Piauí","Paraná","Rio de Janeiro","Rio Grande do Norte","Rondônia","Roraima","Rio Grande do Sul", _
					"Santa Catarina","Sergipe","São Paulo","Tocantins")

strCOD_CONTA_PAGAR_RECEBER = GetParam("var_chavereg")
strCOD_CFG_BOLETO = GetParam("var_boleto")

AbreDBConn objConn, CFG_DB 

if strCOD_CFG_BOLETO<>"" and strCOD_CONTA_PAGAR_RECEBER<>"" then 
	strSQL = " SELECT" 						&_				
				"	CEDENTE_NOME," 			&_
				"	CEDENTE_AGENCIA," 		&_
				"	CEDENTE_CNPJ," 			&_
				"	CEDENTE_CODIGO,"		&_
				"	CEDENTE_CODIGO_DV,"		&_				
				"	CEDENTE_ENDERECO,"		&_				
				"	COD_CLIENTE,"			&_
				"	BANCO_CODIGO," 			&_				
				"	BANCO_DV," 				&_
				"	BANCO_IMG," 			&_
				"	BOLETO_ACEITE," 		&_
				"	BOLETO_CARTEIRA," 		&_
				"	BOLETO_ESPECIE," 		&_
				"	BOLETO_TIPO_DOC,"		&_				
				"	LOCAL_PGTO," 			&_
				"	INSTRUCOES," 			&_
				"	MODELO_HTML " 			&_				
				" FROM" 					&_
				"	CFG_BOLETO " 			&_
				" WHERE"	 				&_
				"	COD_CFG_BOLETO=" & strCOD_CFG_BOLETO
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1	
	if not objRS.eof then		
		strFormAction	= GetValue(objRS,"MODELO_HTML")
		
		if strFormAction<>"" then 
			strBOLETO_IMG_LOGO = LCase(strFormAction)
			strBOLETO_IMG_LOGO = Mid(strBOLETO_IMG_LOGO, InStr(strBOLETO_IMG_LOGO, "_") + 1 )
			strBOLETO_IMG_LOGO = Mid(strBOLETO_IMG_LOGO, 1, Len(strBOLETO_IMG_LOGO)-4)
			strDialogText		 = " - " & Cap(strBOLETO_IMG_LOGO)
		end if
		
		strBOLETO_IMG_PROMO			= GetValue(objRS,"BANCO_IMG")
		
		strBOLETO_AGENCIA			= GetValue(objRS,"CEDENTE_AGENCIA")
		strBOLETO_ACEITE 			= GetValue(objRS,"BOLETO_ACEITE")
		
		strBOLETO_CARTEIRA			= GetValue(objRS,"BOLETO_CARTEIRA")
		strBOLETO_CEDENTE_NOME		= GetValue(objRS,"CEDENTE_NOME")
		strBOLETO_CEDENTE_CODIGO	= GetValue(objRS,"CEDENTE_CODIGO")
		strBOLETO_CEDENTE_CODIGO_DV	= GetValue(objRS,"CEDENTE_CODIGO_DV")
		strBOLETO_CEDENTE_CNPJ	  	= GetValue(objRS,"CEDENTE_CNPJ")
		strBOLETO_CEDENTE_ENDERECO 	= GetValue(objRS,"CEDENTE_ENDERECO")

		strBOLETO_COD_BANCO			= GetValue(objRS,"BANCO_CODIGO")
		strBOLETO_COD_BANCO_DV		= GetValue(objRS,"BANCO_DV")
		strBOLETO_COD_CLIENTE		= GetValue(objRS,"COD_CLIENTE")
		strBOLETO_CONTA				= GetValue(objRS,"CEDENTE_CODIGO")
		strBOLETO_CONTA_DV			= GetValue(objRS,"CEDENTE_CODIGO_DV")
		
		strBOLETO_ESPECIE 			= GetValue(objRS,"BOLETO_ESPECIE")
		strBOLETO_TIPO_DOC			= GetValue(objRS,"BOLETO_TIPO_DOC")
		strBOLETO_INSTRUCOES		= GetValue(objRS,"INSTRUCOES")
		strBOLETO_LOCAL_PGTO		= GetValue(objRS,"LOCAL_PGTO")
	end if
	FechaRecordSet objRS		
	
	strSQL = " SELECT TIPO, CODIGO, DT_EMISSAO, DT_VCTO, VLR_CONTA AS VALOR, NUM_IMPRESSOES, NUM_DOCUMENTO, NUM_NF " &_
			 " FROM FIN_CONTA_PAGAR_RECEBER " &_
			 " WHERE COD_CONTA_PAGAR_RECEBER = " & strCOD_CONTA_PAGAR_RECEBER
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then 
		strBOLETO_VALOR          	= FormataDecimal(GetValue(objRS,"VALOR"),2)
		strBOLETO_DT_VENCIMENTO  	= GetValue(objRS,"DT_VCTO")
		strBOLETO_NUM_DOCUMENTO		= GetValue(objRS,"NUM_DOCUMENTO")
		strNUM_IMPRESSOES			= GetValue(objRS,"NUM_IMPRESSOES")
		
		strBOLETO_NOSSO_NUMERO = GetValue(objRS,"NUM_NF")
		If strBOLETO_NOSSO_NUMERO = "" Then strBOLETO_NOSSO_NUMERO = strCOD_CONTA_PAGAR_RECEBER
		
		strSQL = ""				
		if GetValue(objRS,"CODIGO") <> "" then 
			If GetValue(objRS,"TIPO") = "ENT_COLABORADOR" Then 
				strSQL = "SELECT NOME 			AS CLI_NOME " 		&_
							"  , CPF 			AS CLI_NUM_DOC " 	&_
							"  , CEP 			AS CLI_CEP "		&_
							"  , ENDERECO		AS CLI_ENDER " 		&_
							"  , NUMERO			AS CLI_NUMERO " 	&_
							"  , COMPLEMENTO	AS CLI_COMPL " 		&_						
							"  , BAIRRO			AS CLI_BAIRRO " 	&_
							"  , CIDADE			AS CLI_CIDADE " 	&_
							"  , ESTADO			AS CLI_ESTADO  "
			Else
				strSQL = "SELECT RAZAO_SOCIAL		AS CLI_NOME " 		&_
							"  , NUM_DOC 			AS CLI_NUM_DOC "	&_
							"  , COBR_CEP 			AS CLI_CEP " 		&_
							"  , COBR_ENDERECO		AS CLI_ENDER " 		&_
							"  , COBR_NUMERO		AS CLI_NUMERO " 	&_
							"  , COBR_COMPLEMENTO	AS CLI_COMPL " 		&_						
							"  , COBR_BAIRRO		AS CLI_BAIRRO " 	&_
							"  , COBR_CIDADE		AS CLI_CIDADE " 	&_
							"  , COBR_ESTADO		AS CLI_ESTADO "				
			end if
			strSQL = strSQL & " FROM "& GetValue(objRS,"TIPO") &" WHERE COD_"& Mid(GetValue(objRS,"TIPO"),5) & " = " & GetValue(objRS,"CODIGO")
		end if
	end if
	FechaRecordSet objRS		
	
	if strSQL<>"" then 
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRS.eof then
			strBOLETO_SACADO_NOME				= GetValue(objRS,"CLI_NOME")
			strBOLETO_SACADO_BAIRRO				= GetValue(objRS,"CLI_BAIRRO")
			strBOLETO_SACADO_CIDADE				= GetValue(objRS,"CLI_CIDADE")
			strBOLETO_SACADO_ESTADO				= GetValue(objRS,"CLI_ESTADO")
			strBOLETO_SACADO_CEP				= GetValue(objRS,"CLI_CEP")
			strBOLETO_SACADO_ENDERECO			= GetValue(objRS,"CLI_ENDER") 
			strBOLETO_SACADO_IDENTIFICADOR		= GetValue(objRS,"CLI_NUM_DOC")
			strBOLETO_SACADO_CNPJ			    = GetValue(objRS,"CLI_NUM_DOC") 

			if GetValue(objRS,"CLI_NUMERO")<>"" then strBOLETO_SACADO_ENDERECO = strBOLETO_SACADO_ENDERECO & ", "  & GetValue(objRS,"CLI_NUMERO")
			if GetValue(objRS,"CLI_COMPL") <>"" then strBOLETO_SACADO_ENDERECO = strBOLETO_SACADO_ENDERECO & " - " & GetValue(objRS,"CLI_COMPL")
		end if
		FechaRecordSet objRS		
	end if	
end if
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
function carregarDados(prCodBoleto){
	var CodBoleto;
	
	CodBoleto = prCodBoleto;
	if (CodBoleto=='') CodBoleto = form_boleto.var_boleto.value;
	location='ShowBoleto.asp?var_chavereg=<%=strCOD_CONTA_PAGAR_RECEBER%>&var_boleto=' + CodBoleto;
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Geração de Boleto" & strDialogText) %>
<form name="form_boleto" action="<%=strFormAction%>" method="post">
	<input name="var_chavereg"					type="hidden" value="<%=strCOD_CONTA_PAGAR_RECEBER%>">
	<input name="var_boleto_NUM_IMPRESSOES"		type="hidden" value="<%=strNUM_IMPRESSOES%>">	
	<input name="var_boleto_IMG_LOGO"			type="hidden" value="<%=strBOLETO_IMG_LOGO%>">
	<input name="var_boleto_IMG_PROMO"			type="hidden" value="<%=strBOLETO_IMG_PROMO%>">	
	<input name="var_boleto_COD_CLIENTE"		type="hidden" value="<%=strBOLETO_COD_CLIENTE%>">	
<% 
	if strCOD_CFG_BOLETO="" then 
		strSQL = "SELECT COD_CFG_BOLETO FROM CFG_BOLETO WHERE DT_INATIVO IS NULL "
		
		'Usa adOpenStatic para que o RecordCount retorne o número de registros
		'AbreRecordSet objRS, strSQL, objConn, adOpenStatic
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenStatic, adUseClient, -1
		if objRS.RecordCount=1 then
			%>
			<input name="var_boleto" type="hidden" value="<%=GetValue(objRS,"COD_CFG_BOLETO")%>">	
			<script>carregarDados('');</script>
			<%
		else
			%>
			<div class="form_label">Boleto:</div><select name="var_boleto" style="width:220px;">
				<% MontaCombo "STR"," SELECT COD_CFG_BOLETO, DESCRICAO FROM CFG_BOLETO WHERE DT_INATIVO IS NULL ORDER BY DESCRICAO ","COD_CFG_BOLETO","DESCRICAO",strCOD_CFG_BOLETO %>
			</select>
			<%
		end if
		FechaRecordSet objRS
		strButtonAction = "carregarDados('');"
	end if

	if strCOD_CFG_BOLETO<>"" and strCOD_CONTA_PAGAR_RECEBER<>""  then 
		strButtonAction = "form_boleto.submit();"
	%>
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Dados do Cedente</b><br>
		<br><div class="form_label">Cedente CNPJ:</div><input maxlength="14" name="var_boleto_CEDENTE_CNPJ" type="text" style="width:105px;" value="<%=strBOLETO_CEDENTE_CNPJ%>" onKeyPress="validateFloatKey();">
		<br><div class="form_label">Cedente R.Social:</div><input name="var_boleto_CEDENTE_NOME" type="text" style="width:330px;" value="<%=strBOLETO_CEDENTE_NOME%>">
		<br><div class="form_label">Cedente Endereço:</div><input maxlength="250" name="var_boleto_CEDENTE_ENDERECO" type="text" style="width:330px;" value="<%=strBOLETO_CEDENTE_ENDERECO%>">
		<br><div class="form_label">Agência:</div><input maxlength="04" name="var_boleto_AGENCIA" type="text" style="width:35px;" value="<%=strBOLETO_AGENCIA%>" onKeyPress="validateNumKey();">
		<br><div class="form_label">Conta:</div><input maxlength="10" name="var_boleto_CEDENTE_CODIGO" type="text" style="width:70px;" value="<%=strBOLETO_CEDENTE_CODIGO%>" onKeyPress="validateNumKey();">&nbsp;-&nbsp;<input maxlength="01" name="var_boleto_CEDENTE_CODIGO_DV" type="text" style="width:18px;" value="<%=strBOLETO_CEDENTE_CODIGO_DV%>" onKeyPress="validateNumKey();">
		<br><div class="form_label">Carteira:</div><input maxlength="03" name="var_boleto_CARTEIRA" type="text" style="width:70px;" value="<%=strBOLETO_CARTEIRA%>">
	</div>
	
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Dados do Boleto</b><br>
		<br><div class="form_label">Valor:</div><input maxlength="14" name="var_boleto_VALOR" type="text" style="width:105px;" value="<%=strBOLETO_VALOR%>" onKeyPress="validateFloatKey();">
		<br><div class="form_label">Data Vencimento:</div><%=InputDate("var_boleto_DT_VENCIMENTO","",strBOLETO_DT_VENCIMENTO,false)%><%=ShowLinkCalendario("form_boleto", "var_boleto_DT_VENCIMENTO", "ver calendário")%>&nbsp;<span class="texto_ajuda">dd/mm/aaaa</span>
		<br><div class="form_label">Aceite:</div><input maxlength="14" name="var_boleto_ACEITE" type="text" style="width:70px;" value="<%=strBOLETO_ACEITE%>">
		<br><div class="form_label">N&deg;. Documento:</div><input maxlength="14" name="var_boleto_NUM_DOCUMENTO" type="text" style="width:70px;" value="<%=strBOLETO_NUM_DOCUMENTO%>">
		<br><div class="form_label">Espécie:</div><input maxlength="50" name="var_boleto_ESPECIE" type="text" style="width:70px;" value="<%=strBOLETO_ESPECIE%>">
		<br><div class="form_label">Nosso Número:</div><input maxlength="50" name="var_boleto_NOSSO_NUMERO" type="text" style="width:105px;" value="<%=strBOLETO_NOSSO_NUMERO%>">
		<br><div class="form_label">Código Banco:</div><input maxlength="10" name="var_boleto_COD_BANCO" type="text" style="width:70px;" value="<%=strBOLETO_COD_BANCO%>" readonly>&nbsp;-&nbsp;<input maxlength="01" name="var_boleto_COD_BANCO_DV" type="text" style="width:18px;" value="<%=strBOLETO_COD_BANCO_DV%>" readonly>
		<br><div class="form_label">Espécie Doc:</div><input maxlength="50" name="var_boleto_ESPECIE_DOC" type="text" style="width:105px;" value="<%=strBOLETO_TIPO_DOC%>">
		<br><div class="form_label">Local Pagamento:</div><textarea name="var_boleto_LOCAL_PGTO" rows="7" style="width:330px;"><%=strBOLETO_LOCAL_PGTO%></textarea>
	</div>
	
	<div class="form_grupo" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
  		style="cursor:pointer;">
		<b>Dados do Sacado</b><br>
		<br><div class="form_label">Nome:</div><input name="var_boleto_SACADO_NOME" type="text" style="width:330px;" value="<%=strBOLETO_SACADO_NOME%>">
		<br><div class="form_label">Endereço:</div><input name="var_boleto_SACADO_ENDERECO" type="text" style="width:330px;" value="<%=strBOLETO_SACADO_ENDERECO%>">
		<br><div class="form_label">Bairro:</div><input name="var_boleto_SACADO_BAIRRO" type="text" style="width:180px;" value="<%=strBOLETO_SACADO_BAIRRO%>">
		<br><div class="form_label">Cidade:</div><input name="var_boleto_SACADO_CIDADE" type="text" style="width:250px;" value="<%=strBOLETO_SACADO_CIDADE%>">
		<br><div class="form_label">Estado:</div><select name="var_boleto_SACADO_ESTADO">
			<%	for i = 0 to UBound(arrEstados) %>
				<option value="<%=arrEstados(i)%>" <% if strBOLETO_SACADO_ESTADO=CStr(arrEstados(i)) then Response.Write "selected"%>><%=arrNome(i)%>
			<% next %>
			</select>
		<br><div class="form_label">CEP:</div><input maxlength="12" name="var_boleto_SACADO_CEP" type="text" style="width:95;" value="<%=strBOLETO_SACADO_CEP%>">
		<br><div class="form_label">Identificador:</div><input name="var_boleto_SACADO_IDENTIFICADOR" type="text" style="width:140px;" value="<%=strBOLETO_SACADO_IDENTIFICADOR%>">
		<br><div class="form_label">CNPJ/CPF:</div><input name="var_boleto_SACADO_CNPJ" type="text" style="width:140px;" value="<%=strBOLETO_SACADO_CNPJ%>">
		<br><div class="form_label">Instruções:</div><textarea name="var_boleto_INSTRUCOES" rows="7" style="width:330px;"><%=strBOLETO_INSTRUCOES%></textarea>
	</div>
<%	end if %>
</form>
<%=athEndDialog("", "../img/butxp_aplicar.gif", strButtonAction, "", "", "", "") %>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>
<%
	FechaDBConn objConn
%>