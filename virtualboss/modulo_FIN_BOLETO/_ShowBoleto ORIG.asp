<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Dim WMD_WIDTH, WMD_WIDTHTTITLES
WMD_WIDTH 		  = 785
WMD_WIDTHTTITLES = 100

Dim objConn, objRS, strSQL
Dim intCOD_CONTA_PAGAR_RECEBER, intCOD_CFG_BOLETO
Dim strBOLETO_IMG_LOGO, strBOLETO_CEDENTE_CODIGO_DV
Dim strBOLETO_AGENCIA, strBOLETO_ACEITE, strBOLETO_CARTEIRA
Dim strBOLETO_CEDENTE_NOME, strBOLETO_CEDENTE_CNPJ, strBOLETO_COD_BANCO
Dim strBOLETO_COD_BANCO_DV, strBOLETO_CONTA, strBOLETO_CONTA_DV
Dim strBOLETO_ESPECIE, strBOLETO_INSTRUCOES, strBOLETO_LOCAL_PGTO, strBOLETO_COD_CLIENTE
Dim strBOLETO_DT_VENCIMENTO, strBOLETO_NUM_DOCUMENTO, strBOLETO_SACADO_NOME
Dim strBOLETO_SACADO_ENDERECO, strBOLETO_SACADO_BAIRRO, strBOLETO_SACADO_CIDADE
Dim strBOLETO_SACADO_ESTADO, strBOLETO_SACADO_CEP,	strBOLETO_SACADO_IDENTIFICADOR
Dim strBOLETO_NOSSO_NUMERO, strCOD_CLI, strBOLETO_CEDENTE_CODIGO, strNUM_IMPRESSOES
Dim strCODIGO, strMSG, strBOLETO_VALOR, strBOLETO_IMG_PROMO, strBOLETO_TIPO_DOC
Dim strButtonAction, strFormAction, strDialogText
Dim arrEstados, arrNome, i

arrEstados = array("AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MG","MT","MS","PA","PB","PE","PI","PR","RJ","RN","RO","RR","RS","SC","SE","SP","TO")
arrNome = array("Acre","Alagoas","Amapá","Amazonas","Bahia","Ceará","Distrito Federal","Espírito Santo","Goias","Maranhão","Minas Gerais", "Mato Grosso",_
				 "Mato Grosso do Sul","Pará","Paraíba","Pernambuco","Piauí","Paraná","Rio de Janeiro","Rio Grande do Norte","Rondônia","Roraima","Rio Grande do Sul", _
				 "Santa Catarina","Sergipe","São Paulo","Tocantins")

intCOD_CONTA_PAGAR_RECEBER = GetParam("var_chavereg")
intCOD_CFG_BOLETO = GetParam("var_boleto")

AbreDBConn objConn, CFG_DB 

if intCOD_CFG_BOLETO<>"" and intCOD_CONTA_PAGAR_RECEBER<>"" then 
	strSQL = " SELECT" 						&_				
				"	CEDENTE_NOME," 			&_
				"	CEDENTE_AGENCIA," 		&_
				"	CEDENTE_CNPJ," 			&_
				"	CEDENTE_CODIGO,"			&_
				"	CEDENTE_CODIGO_DV,"		&_				
				"	COD_CLIENTE,"	 			&_
				"	BANCO_CODIGO," 			&_				
				"	BANCO_DV," 					&_
				"	BANCO_IMG," 				&_
				"	BOLETO_ACEITE," 			&_
				"	BOLETO_CARTEIRA," 		&_
				"	BOLETO_ESPECIE," 			&_
				"	BOLETO_TIPO_DOC,"			&_				
				"	LOCAL_PGTO," 				&_
				"	INSTRUCOES," 				&_
				"	MODELO_HTML " 				&_				
				" FROM" 							&_
				"	CFG_BOLETO " 				&_
				" WHERE"	 						&_
				"	COD_CFG_BOLETO=" & intCOD_CFG_BOLETO
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
	
	strSQL = "SELECT"								&_	
				"	TIPO,"		 					&_
				"	CODIGO,"		 				&_				
				"	DT_EMISSAO," 					&_
				"	DT_VCTO," 						&_
				"	VLR_CONTA AS VALOR,"			&_
				"	NUM_IMPRESSOES,"				&_													
				"	NUM_DOCUMENTO, " 				&_
				"	NUM_NF "		 				&_
				"FROM" 								&_
				"	FIN_CONTA_PAGAR_RECEBER "	&_
				"WHERE"								&_
				"	COD_CONTA_PAGAR_RECEBER="	& intCOD_CONTA_PAGAR_RECEBER
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then 
		strBOLETO_VALOR          	= FormataDecimal(GetValue(objRS,"VALOR"),2)
		strBOLETO_DT_VENCIMENTO  	= GetValue(objRS,"DT_VCTO")
		strBOLETO_NUM_DOCUMENTO		= GetValue(objRS,"NUM_DOCUMENTO")
		strNUM_IMPRESSOES			= GetValue(objRS,"NUM_IMPRESSOES")
		
		strBOLETO_NOSSO_NUMERO = GetValue(objRS,"NUM_NF")
		If strBOLETO_NOSSO_NUMERO = "" Then strBOLETO_NOSSO_NUMERO = intCOD_CONTA_PAGAR_RECEBER
		
		strSQL = ""				
		if GetValue(objRS,"CODIGO") <> "" then 
			strSQL = "SELECT" 								&_
						"	NOME 			AS CLI_NOME," 		&_
						"	CPF 			AS CLI_NUM_DOC," 	&_
						"	CEP 			AS CLI_CEP,"		&_
						"	ENDERECO		AS CLI_ENDER," 	&_
						"	NUMERO		AS CLI_NUMERO," 	&_
						"	COMPLEMENTO	AS CLI_COMPL," 	&_						
						"	BAIRRO		AS CLI_BAIRRO," 	&_
						"	CIDADE		AS CLI_CIDADE," 	&_
						"	ESTADO		AS CLI_ESTADO  "
			if GetValue(objRS,"TIPO")<>"ENT_COLABORADOR" then 
				strSQL = "SELECT" 										&_			
							"	RAZAO_SOCIAL	AS CLI_NOME," 			&_
							"	NUM_DOC 			AS CLI_NUM_DOC," 		&_
							"	ENTR_CEP 		AS CLI_CEP," 			&_
							"	ENTR_ENDERECO	AS CLI_ENDER," 		&_
							"	ENTR_NUMERO		AS CLI_NUMERO," 		&_
							"	ENTR_COMPLEMENTO	AS CLI_COMPL," 	&_						
							"	ENTR_BAIRRO		AS CLI_BAIRRO," 		&_
							"	ENTR_CIDADE		AS CLI_CIDADE," 		&_
							"	ENTR_ESTADO		AS CLI_ESTADO "				
			end if
			strSQL = strSQL & "FROM "& GetValue(objRS,"TIPO") &" WHERE COD_"& Mid(GetValue(objRS,"TIPO"),5) &"="& GetValue(objRS,"CODIGO")
		end if
	end if
	FechaRecordSet objRS		
	
	if strSQL<>"" then 
		AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
		if not objRS.eof then
			strBOLETO_SACADO_NOME				= GetValue(objRS,"CLI_NOME")
			strBOLETO_SACADO_ENDERECO			= GetValue(objRS,"CLI_ENDER") 
			if GetValue(objRS,"CLI_NUMERO")<>"" then strBOLETO_SACADO_ENDERECO = strBOLETO_SACADO_ENDERECO & ", "  & GetValue(objRS,"CLI_NUMERO")
			if GetValue(objRS,"CLI_COMPL") <>"" then strBOLETO_SACADO_ENDERECO = strBOLETO_SACADO_ENDERECO & " - " & GetValue(objRS,"CLI_COMPL")
			strBOLETO_SACADO_BAIRRO				= GetValue(objRS,"CLI_BAIRRO")
			strBOLETO_SACADO_CIDADE				= GetValue(objRS,"CLI_CIDADE")
			strBOLETO_SACADO_ESTADO				= GetValue(objRS,"CLI_ESTADO")
			strBOLETO_SACADO_CEP					= GetValue(objRS,"CLI_CEP")
			strBOLETO_SACADO_IDENTIFICADOR	= GetValue(objRS,"CLI_NUM_DOC")
			FechaRecordSet objRS		
		end if
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
	if (CodBoleto=='') CodBoleto = formBoleto.var_boleto.value;
	location='ShowBoleto.asp?var_chavereg=<%=intCOD_CONTA_PAGAR_RECEBER%>&var_boleto=' + CodBoleto;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%=athBeginDialog(WMD_WIDTH, "Geração de Boleto" & strDialogText) %>
    <form name="formBoleto" action="<%=strFormAction%>" method="post">
	<input name="var_chavereg"					type="hidden" value="<%=intCOD_CONTA_PAGAR_RECEBER%>">
	<input name="var_boleto_NUM_IMPRESSOES"		type="hidden" value="<%=strNUM_IMPRESSOES%>">	
	<input name="var_boleto_IMG_LOGO"			type="hidden" value="<%=strBOLETO_IMG_LOGO%>">
	<input name="var_boleto_IMG_PROMO"			type="hidden" value="<%=strBOLETO_IMG_PROMO%>">	
	<input name="var_boleto_COD_CLIENTE"		type="hidden" value="<%=strBOLETO_COD_CLIENTE%>">	
<% 
	if intCOD_CFG_BOLETO="" then 
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
			<table width="775" border="0" cellpadding="1" cellspacing="0">
				<tr><td colspan="4" height="12px;"></td></tr>		
				<tr> 
					<td style="text-align:right;">Boleto:&nbsp;</td>
					<td>
						<select name="var_boleto" style="width:220px;">
							<% MontaCombo "STR"," SELECT COD_CFG_BOLETO, DESCRICAO FROM CFG_BOLETO WHERE DT_INATIVO IS NULL ORDER BY DESCRICAO ","COD_CFG_BOLETO","DESCRICAO",intCOD_CFG_BOLETO %>
						</select>
					</td>
				</tr>
			</table>
			<%
		end if
		FechaRecordSet objRS
		strButtonAction = "carregarDados('');"
	end if

	' -----------------------	DADOS DO CEDENTE -----------------------	
	if intCOD_CFG_BOLETO<>"" and intCOD_CONTA_PAGAR_RECEBER<>""  then 
		strButtonAction = "formBoleto.submit();"
%>
<table width="775" border="0" cellpadding="1" cellspacing="0">
	<tr><td colspan="2" height="10"></td></tr>
    <tr> 
      <td></td>
      <td colspan="3"><div class="divgrupo"><b>Dados do Cedente</b></div></td>
    </tr>
    <tr><td colspan="2" height="10"></td></tr>
	<tr> 
	  <td style="text-align:right;width:105px;">Cedente:&nbsp;</td>
      <td width="330"><input name="var_boleto_CEDENTE_NOME" type="text" style="width:330px;" value="<%=strBOLETO_CEDENTE_NOME%>"></td>
	  <td colspan="2"></td>
	</tr>
	<tr><td colspan="4" height="2px"></td></tr>
	<tr>
		<td style="text-align:right;">CNPJ:&nbsp;</td>
		<td><input maxlength="14" name="var_boleto_CEDENTE_CNPJ" type="text" style="width:105px;" value="<%=strBOLETO_CEDENTE_CNPJ%>" onKeyPress="validateFloatKey();"></td>				
		<td style="text-align:right;width:100px;">Agência:&nbsp;</td>
		<td><input maxlength="04" name="var_boleto_AGENCIA" type="text" style="width:35px;" value="<%=strBOLETO_AGENCIA%>" onKeyPress="validateNumKey();"></td>
	</tr>
	<tr><td colspan="4" height="2px"></td></tr>	
	<tr>
		<td style="text-align:right;">Conta:&nbsp;</td>
		<td>
			<input maxlength="10" name="var_boleto_CEDENTE_CODIGO" type="text" style="width:70px;" value="<%=strBOLETO_CEDENTE_CODIGO%>" onKeyPress="validateNumKey();">
			&nbsp;-&nbsp;
			<input maxlength="01" name="var_boleto_CEDENTE_CODIGO_DV" type="text" style="width:18px;" value="<%=strBOLETO_CEDENTE_CODIGO_DV%>" onKeyPress="validateNumKey();"> 
		</td>					
		<td style="text-align:right;">Carteira:&nbsp;
		<td><input maxlength="03" name="var_boleto_CARTEIRA" type="text" style="width:70px;" value="<%=strBOLETO_CARTEIRA%>"></td>
	</tr>
</table>

<%' -------------------	DADOS DO BOLETO ------------------- %>
<table width="775" border="0" cellpadding="1" cellspacing="0">
	<tr><td colspan="2" height="10"></td></tr>
    <tr> 
      <td></td>
      <td colspan="3"><div class="divgrupo"><b>Dados do Boleto</b></div></td>
    </tr>
    <tr><td colspan="2" height="10"></td></tr>
	<tr>
		<td style="text-align:right;width:105px;">Valor:&nbsp;</td>
		<td width="330"><input maxlength="14" name="var_boleto_VALOR" type="text" style="width:105px;" value="<%=strBOLETO_VALOR%>" onKeyPress="validateFloatKey();"></td>				
		<td style="text-align:right;width:100px;">Data Vencimento:&nbsp;</td>
		<td>
			<%=InputDate("var_boleto_DT_VENCIMENTO","",strBOLETO_DT_VENCIMENTO,false)%>&nbsp;
			<span class="texto_ajuda" style="width:10px; font-style:italic;">&nbsp;dd/mm/aaaa</span>
		</td>
	</tr>
	<tr><td colspan="4" height="2px"></td></tr>	
	<tr>
		<td style="text-align:right;">Aceite:&nbsp;</td>
		<td><input maxlength="14" name="var_boleto_ACEITE" type="text" style="width:70px;" value="<%=strBOLETO_ACEITE%>"></td>
		<td style="text-align:right;">N&deg;. Documento:&nbsp;</td>
		<td><input maxlength="14" name="var_boleto_NUM_DOCUMENTO" type="text" style="width:70px;" value="<%=strBOLETO_NUM_DOCUMENTO%>"></td>
	</tr>
	<tr>
		<td style="text-align:right;">Espécie:&nbsp;</td>
		<td><input maxlength="50" name="var_boleto_ESPECIE" type="text" style="width:70px;" value="<%=strBOLETO_ESPECIE%>"></td>
		<td style="text-align:right;">Nosso Número:&nbsp;</td>
		<td><input maxlength="50" name="var_boleto_NOSSO_NUMERO" type="text" style="width:105px;" value="<%=strBOLETO_NOSSO_NUMERO%>"></td>
	</tr>
	<tr>
		<td style="text-align:right;">Codigo Banco:&nbsp;</td>
		<td>
			<input maxlength="10" name="var_boleto_COD_BANCO" type="text" style="width:70px;" value="<%=strBOLETO_COD_BANCO%>" readonly>
			&nbsp;-&nbsp;
			<input maxlength="01" name="var_boleto_COD_BANCO_DV" type="text" style="width:18px;" value="<%=strBOLETO_COD_BANCO_DV%>" readonly> 
		</td>	
		<td style="text-align:right;">Espécie Doc.:&nbsp;</td><td><input maxlength="50" name="var_boleto_ESPECIE_DOC" type="text" style="width:105px;" value="<%=strBOLETO_TIPO_DOC%>"></td>
	</tr>
	<tr>
		<td style="text-align:right;" valign="top">Local Pagamento:&nbsp;</td>
		<td colspan="3"><textarea name="var_boleto_LOCAL_PGTO" rows="7" style="width:330px;"><%=strBOLETO_LOCAL_PGTO%></textarea></td>
	</tr>	
</table>

<%' -------------------	 DADOS DO BOLETO 	------------------- %>
<table width="775" border="0" cellpadding="1" cellspacing="0">
	<tr><td colspan="2" height="10"></td></tr>
    <tr> 
      <td></td>
      <td colspan="3"><div class="divgrupo"><b>Dados do Sacado</b></div></td>
    </tr>
    <tr><td colspan="2" height="10"></td></tr>
	<tr> 
		<td style="text-align:right;width:105px;">Nome:&nbsp;</td>
      <td width="330"><input name="var_boleto_SACADO_NOME" type="text" style="width:330px;" value="<%=strBOLETO_SACADO_NOME%>"></td>
		<td colspan="2"></td>
	</tr>
	<tr><td colspan="4" height="2px"></td></tr>
	<tr>
		<td style="text-align:right;">Endereço:&nbsp;</td>
		<td><input name="var_boleto_SACADO_ENDERECO" type="text" style="width:330px;" value="<%=strBOLETO_SACADO_ENDERECO%>"></td>					
		<td style="text-align:right;width:100px;">Bairro:&nbsp;</td>
		<td><input name="var_boleto_SACADO_BAIRRO" type="text" style="width:180px;" value="<%=strBOLETO_SACADO_BAIRRO%>"></td>
	</tr>
	<tr><td colspan="4" height="2px"></td></tr>
	<tr>
		<td style="text-align:right;">Cidade:&nbsp;</td>
		<td><input name="var_boleto_SACADO_CIDADE" type="text" style="width:250px;" value="<%=strBOLETO_SACADO_CIDADE%>"></td>					
		<td style="text-align:right;">Estado:&nbsp;</td>
		<td>
			<select name="var_boleto_SACADO_ESTADO">
			<%	for i = 0 to UBound(arrEstados) %>
				<option value="<%=arrEstados(i)%>" <% if strBOLETO_SACADO_ESTADO=CStr(arrEstados(i)) then Response.Write "selected"%>><%=arrNome(i)%>
			<% next %>
			</select>
		</td>
	</tr>
	<tr><td colspan="4" height="2px"></td></tr>
	<tr>
		<td style="text-align:right;">CEP:&nbsp;</td>
		<td><input maxlength="12" name="var_boleto_SACADO_CEP" type="text" style="width:95;" value="<%=strBOLETO_SACADO_CEP%>"></td>					
		<td style="text-align:right;">Identificador:&nbsp;</td>
		<td><input name="var_boleto_SACADO_IDENTIFICADOR" type="text" style="width:140px;" value="<%=strBOLETO_SACADO_IDENTIFICADOR%>"></td>
	</tr>
	<tr><td colspan="4" height="2px"></td></tr>
	<tr>
		<td style="text-align:right;" valign="top">Instruções:&nbsp;</td>
	   <td colspan="3"><textarea name="var_boleto_INSTRUCOES" rows="7" style="width:330px;"><%=strBOLETO_INSTRUCOES%></textarea></td>
	</tr>
</table>
<%end if%>
</form>
<%=athEndDialog("", "../img/butxp_aplicar.gif", strButtonAction, "", "", "", "") %>
</body>
</html>
<%
	FechaDBConn objConn
%>