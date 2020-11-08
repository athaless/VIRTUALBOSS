<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CLIENTE", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 Const WMD_WIDTH = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 Const auxAVISO  = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
	Dim strSQL, objRS, ObjConn
	Dim strCODIGO, strData, strRESP, arrESTADOS, arrNOMES, Cont
	
	strCODIGO = GetParam("var_chavereg")

	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSQL =          "SELECT T1.RAZAO_SOCIAL, T1.NOME_FANTASIA, T1.NOME_COMERCIAL, T1.NUM_DOC, T1.TIPO_DOC, T1.INSC_ESTADUAL, T1.INSC_MUNICIPAL "
		strSQL = strSQL & "      ,T1.FONE_1, T1.FONE_2, T1.FAX, T1.EMAIL, T1.SITE, T1.TEM_ALIQ_IRPJ, T1.ALIQ_IRPJ "
		strSQL = strSQL & "      ,T1.DT_INATIVO, T1.FATURA_ENDERECO, T1.FATURA_NUMERO, T1.FATURA_COMPLEMENTO, T1.SIGLA_PONTO "
		strSQL = strSQL & "      ,T1.FATURA_CEP, T1.FATURA_BAIRRO, T1.FATURA_CIDADE, T1.FATURA_ESTADO, T1.FATURA_PAIS, T1.CONTATO, T1.CLASSE, T1.TIPO_CHAMADO " 
		strSQL = strSQL & "      ,T1.COBR_ENDERECO, T1.COBR_NUMERO, T1.COBR_COMPLEMENTO "
		strSQL = strSQL & "      ,T1.COBR_CEP, T1.COBR_BAIRRO, T1.COBR_CIDADE, T1.COBR_ESTADO, T1.COBR_PAIS "
		strSQL = strSQL & "      ,T1.ENTR_ENDERECO, T1.ENTR_NUMERO, T1.ENTR_COMPLEMENTO "
		strSQL = strSQL & "      ,T1.ENTR_CEP, T1.ENTR_BAIRRO, T1.ENTR_CIDADE, T1.ENTR_ESTADO, T1.ENTR_PAIS "
		strSQL = strSQL & "      ,T1.COD_BANCO, T1.AGENCIA, T1.CONTA, T1.FAVORECIDO, T1.OBS "
		strSQL = strSQL & "  FROM ENT_CLIENTE T1"
		strSQL = strSQL & " WHERE T1.COD_CLIENTE = " & strCODIGO
		
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
function CopiaDados(pr_form, pr_fieldbase)
{
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_ENDERECO.value = " + pr_form + ".DBVAR_STR_FATURA_ENDERECO.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_NUMERO.value = " + pr_form + ".DBVAR_STR_FATURA_NUMERO.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_COMPLEMENTO.value = " + pr_form + ".DBVAR_STR_FATURA_COMPLEMENTO.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_CEP.value = " + pr_form + ".DBVAR_STR_FATURA_CEP.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_BAIRRO.value = " + pr_form + ".DBVAR_STR_FATURA_BAIRRO.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_CIDADE.value = " + pr_form + ".DBVAR_STR_FATURA_CIDADE.value;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_ESTADO.options[" + pr_form + ".DBVAR_STR_FATURA_ESTADO.selectedIndex].selected = true;");
 eval(pr_form + ".DBVAR_STR_" + pr_fieldbase +"_PAIS.value = " + pr_form + ".DBVAR_STR_FATURA_PAIS.value;");
}
</script>
</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Cliente - Alteração")%>
<form name="form_update" action="../_database/athUpdateToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE" value="ENT_CLIENTE">
	<input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX" value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME" value="COD_CLIENTE">
	<input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_CLIENTE/Update.asp?var_chavereg=<%=strCODIGO%>'>
	<div class="form_label">Cod.:</div><div class="form_bypass"><%=strCODIGO%></div>
	<br><div class="form_label">Raz&atilde;o Social:</div><input name="DBVAR_STR_RAZAO_SOCIAL" type="text" style="width:300px" value="<%=GetValue(objRS,"RAZAO_SOCIAL")%>">
	<br><div class="form_label">Nome Fantasia:</div><input name="DBVAR_STR_NOME_FANTASIA" type="text" style="width:300px" value="<%=GetValue(objRS,"NOME_FANTASIA")%>">
	<br><div class="form_label">Nome Comercial:</div><input name="DBVAR_STR_NOME_COMERCIAL" type="text" style="width:300px" value="<%=GetValue(objRS,"NOME_COMERCIAL")%>">
	<br><div class="form_label">Sigla Ponto:</div><input name="DBVAR_STR_SIGLA_PONTO" type="text" maxlength="5" style="width:40px" value="<%=GetValue(objRS,"SIGLA_PONTO")%>">
    <br><div class="form_label">N&uacute;m. Documento:</div><select name="DBVAR_STR_TIPO_DOC" style="width:80px">
													         <option value="F" <%if GetValue(objRS,"TIPO_DOC") = "F" then%> selected<%end if%>>CPF</option>
													         <option value="J" <%if GetValue(objRS,"TIPO_DOC") = "J" then%> selected<%end if%>>CNPJ</option>
														  </select><input name="DBVAR_STR_NUM_DOC" type="text" style="width:120px" value="<%=GetValue(objRS,"NUM_DOC")%>">
    <br><div class="form_label">Inscri&ccedil;&atilde;o Estadual:</div><input name="DBVAR_STR_INSC_ESTADUAL" type="text" style="width:120px" value="<%=GetValue(objRS,"INSC_ESTADUAL")%>">
	<br><div class="form_label">Inscri&ccedil;&atilde;o Municipal:</div><input name="DBVAR_STR_INSC_MUNICIPAL" type="text" style="width:120px" value="<%=GetValue(objRS,"INSC_MUNICIPAL")%>">
    <br><div class="form_label">Fone:</div><input name="DBVAR_STR_FONE_1" type="text" style="width:100px" value="<%=GetValue(objRS,"FONE_1")%>" maxlength="25">
    <br><div class="form_label">Fone Extra:</div><input name="DBVAR_STR_FONE_2" type="text" style="width:100px" value="<%=GetValue(objRS,"FONE_2")%>">
    <br><div class="form_label">Fax:</div><input name="DBVAR_STR_FAX" type="text" style="width:100px" value="<%=GetValue(objRS,"FAX")%>">
	<br><div class="form_label">E-mail:</div><input name="DBVAR_STR_EMAIL" type="text" style="width:300px" value="<%=GetValue(objRS,"EMAIL")%>">
    <br><div class="form_label">Dom&iacute;nio:</div><input name="DBVAR_STR_SITE" type="text" style="width:300px" value="<%=GetValue(objRS,"SITE")%>">
    <br><div class="form_label">Contato:</div><input name="DBVAR_STR_CONTATO" type="text" style="width:120px" value="<%=GetValue(objRS,"CONTATO")%>">
	<br><div class="form_label">Classe:</div><input name="DBVAR_STR_CLASSE" type="text" style="width:120px" value="<%=GetValue(objRS,"CLASSE")%>">
    <br><div class="form_label">Tipo de Chamado:</div><select name="DBVAR_STR_TIPO_CHAMADO" style="width:100px">
												         <option value="LIVRE"     <%if GetValue(objRS,"TIPO_CHAMADO") = "LIVRE" Or GetValue(objRS,"TIPO_CHAMADO") = "" then%> selected<%end if%>>LIVRE</option>
												         <option value="BLOQUEADO" <%if GetValue(objRS,"TIPO_CHAMADO") = "BLOQUEADO" then%> selected<%end if%>>BLOQUEADO</option>
													  </select>
	<br><div class="texto_ajuda" style="padding-left:110px; padding-right:20px;">Indica se os chamados criados pelo cliente necessitam ou não de pré-aprovação para execução.</div>
	<br><div class="form_label">Observação:</div><textarea name="DBVAR_STR_OBS" style="width:320px; height:140px;"><%=GetValue(objRS,"OBS")%></textarea>
	<br><div class="form_label">Status:</div>
	<%
	If GetValue(objRS,"DT_INATIVO") = "" Then
		Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL' checked>Ativo&nbsp;&nbsp;")
		Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "'>Inativo")
	Else
		Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='NULL'>Ativo&nbsp;&nbsp;")
		Response.Write("<input type='radio' class='inputclean' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "' checked>Inativo")
	End If
	%>
	
	<div class="form_grupo_collapse" id="form_grupo_4">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_4" border="0" onClick="ShowArea('form_grupo_4','form_collapse_4');" 
  		style="cursor:pointer;">
		<b>Alíquota IRPJ</b><br>
		<br><div class="form_label">IRPJ Específico:</div><%
		If GetValue(objRS,"TEM_ALIQ_IRPJ") = "0" Or GetValue(objRS,"TEM_ALIQ_IRPJ") = "" Then
			%><input name="DBVAR_BOOL_TEM_ALIQ_IRPJ" class="inputclean" type="radio" value="TRUE">Sim&nbsp;&nbsp;<input name="DBVAR_BOOL_TEM_ALIQ_IRPJ" class="inputclean" type="radio" value="FALSE" checked>Não<%
		Else
			%><input name="DBVAR_BOOL_TEM_ALIQ_IRPJ" class="inputclean" type="radio" value="TRUE" checked>Sim&nbsp;&nbsp;<input name="DBVAR_BOOL_TEM_ALIQ_IRPJ" class="inputclean" type="radio" value="FALSE">Não<%
		End If
		%>
		<br><div class="form_label">Alíquota:</div><input name="DBVAR_MOEDA_ALIQ_IRPJ" type="text" style="width:60px;" maxlength="15" onKeyPress="validateFloatKey();" value="<%=GetValue(objRS,"ALIQ_IRPJ")%>">
		<div style="padding-left:110px;"><span class="texto_ajuda"><i>Marque a opção e informe o percentual se cliente possui uma<br>alíquota específica de IRPJ.</i></span></div>
	</div>	

	<div class="form_grupo" id="form_grupo_33">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" style="cursor:pointer;">
		<b>Dados Bancários</b><br>
		<br><div class="form_label">Banco:</div><select name="DBVAR_NUM_COD_BANCO" style="width:120px">
													<% montaCombo "STR", "SELECT COD_BANCO, NOME FROM FIN_BANCO ORDER BY NOME ", "COD_BANCO", "NOME", GetValue(objRS,"COD_BANCO") %>
												</select>
		<br><div class="form_label">Agênca:</div><input name="DBVAR_STR_AGENCIA" type="text" style="width:70px" maxlength="50" value="<%=GetValue(objRS,"AGENCIA")%>">
		<br><div class="form_label">Conta:</div><input name="DBVAR_STR_CONTA" type="text" style="width:100px" maxlength="50" value="<%=GetValue(objRS,"CONTA")%>">
		<br><div class="form_label">Favorecido:</div><input name="DBVAR_STR_FAVORECIDO" type="text" style="width:300px" maxlength="120" value="<%=GetValue(objRS,"FAVORECIDO")%>">
	</div>

	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
  		style="cursor:pointer;">
		<b>Endereço de Fatura</b>
		<br><br><div class="form_label">Endere&ccedil;o:</div><input name="DBVAR_STR_FATURA_ENDERECO" type="text" style="width:300px" maxlength="190" value="<%=GetValue(objRS,"FATURA_ENDERECO")%>">
		<br><div class="form_label">N&uacute;mero:</div><input name="DBVAR_STR_FATURA_NUMERO" type="text" style="width:50px" maxlength="20" value="<%=GetValue(objRS,"FATURA_NUMERO")%>"><div class="form_label_nowidth">Complemento:</div><input name="DBVAR_STR_FATURA_COMPLEMENTO" type="text" style="width:50px" maxlength="40" value="<%=GetValue(objRS,"FATURA_COMPLEMENTO")%>">
		<br><div class="form_label">CEP:</div><input name="DBVAR_STR_FATURA_CEP" type="text" style="width:90px"	value="<%=GetValue(objRS,"FATURA_CEP")%>">
		<br><div class="form_label">Bairro:</div><input name="DBVAR_STR_FATURA_BAIRRO" type="text" style="width:150px" value="<%=GetValue(objRS,"FATURA_BAIRRO")%>">
		<br><div class="form_label">Cidade:</div><input name="DBVAR_STR_FATURA_CIDADE" type="text" style="width:200px" value="<%=GetValue(objRS,"FATURA_CIDADE")%>">
		<br><div class="form_label">Estado:</div><select name="DBVAR_STR_FATURA_ESTADO" style="width:200px">
										         	<option value="">Selecione...</option>
											        <%
												      arrESTADOS = array("AC","AL","AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
												      arrNOMES = array("Acre","Alagoas","Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goias", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins")
	      
												      For Cont = 0 To UBound(arrESTADOS)
					Response.Write("<option value='" & arrESTADOS(Cont) & "' ")
					if Cstr(arrESTADOS(Cont)) = Cstr(GetValue(objRS,"FATURA_ESTADO")&"") then Response.Write(" selected")  
					Response.Write(">" & UCase(arrNOMES(Cont)) & "</option>")
				Next
												    %>
											      </select>
		<br><div class="form_label">Pa&iacute;s:</div><input type="text" name="DBVAR_STR_FATURA_PAIS" style="width:150px" value="<%=GetValue(objRS,"FATURA_PAIS")%>">
	</div>	
	
	<div class="form_grupo_collapse" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
  		style="cursor:pointer;">
		<b>Endereço de Cobrança</b>&nbsp;<a style="cursor:hand" onClick="CopiaDados('form_update','COBR');">(Copiar Dados)</a>
		<br><br><div class="form_label">Endere&ccedil;o:</div><input name="DBVAR_STR_COBR_ENDERECO" type="text" style="width:300px" value="<%=GetValue(objRS,"COBR_ENDERECO")%>">
		<br><div class="form_label">N&uacute;mero:</div><input name="DBVAR_STR_COBR_NUMERO" type="text" style="width:50px" value="<%=GetValue(objRS,"COBR_NUMERO")%>"><div class="form_label_nowidth">Complemento:</div><input name="DBVAR_STR_COBR_COMPLEMENTO" type="text" style="width:50px" value="<%=GetValue(objRS,"COBR_COMPLEMENTO")%>">
		<br><div class="form_label">CEP:</div><input name="DBVAR_STR_COBR_CEP" type="text" style="width:90px" value="<%=GetValue(objRS,"COBR_CEP")%>">
		<br><div class="form_label">Bairro:</div><input name="DBVAR_STR_COBR_BAIRRO" type="text" style="width:150px" value="<%=GetValue(objRS,"COBR_BAIRRO")%>">
		<br><div class="form_label">Cidade:</div><input name="DBVAR_STR_COBR_CIDADE" type="text" style="width:200px" value="<%=GetValue(objRS,"COBR_CIDADE")%>">
		<br><div class="form_label">Estado:</div><select name="DBVAR_STR_COBR_ESTADO" style="width:200px">
										          <option value="">Selecione...</option>
										          <%
          arrESTADOS = array("AC","AL","AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
	      arrNOMES = array("Acre","Alagoas","Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goias", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins")
		  
	      For Cont = 0 To UBound(arrESTADOS)
	      	Response.Write("<option value='" & arrESTADOS(Cont) & "'")
			if arrESTADOS(Cont) = GetValue(objRS,"COBR_ESTADO") then Response.Write(" selected")
			Response.Write(">" & UCase(arrNOMES(Cont)) & "</option>")
	      Next
	      %>
										        </select>
		<br><div class="form_label">Pa&iacute;s:</div><input type="text" name="DBVAR_STR_COBR_PAIS" style="width:150px" value="<%=GetValue(objRS,"COBR_PAIS")%>">
	</div>
		
	<div class="form_grupo_collapse" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMais.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
  		style="cursor:pointer;">
		<b>Endereço de Entrega</b>&nbsp;<a style="cursor:hand" onClick="CopiaDados('form_update','ENTR');">(Copiar Dados)</a>
		<br><br><div class="form_label">Endere&ccedil;o:</div><input name="DBVAR_STR_ENTR_ENDERECO" type="text" style="width:300px" value="<%=GetValue(objRS,"ENTR_ENDERECO")%>">
		<br><div class="form_label">N&uacute;mero:</div><input name="DBVAR_STR_ENTR_NUMERO" type="text" style="width:50px" value="<%=GetValue(objRS,"ENTR_NUMERO")%>">
		<div class="form_label_nowidth">Complemento:</div><input name="DBVAR_STR_ENTR_COMPLEMENTO" type="text" style="width:50px" value="<%=GetValue(objRS,"ENTR_COMPLEMENTO")%>"> 
      	<br><div class="form_label">CEP:</div><input name="DBVAR_STR_ENTR_CEP" type="text" style="width:90px" value="<%=GetValue(objRS,"ENTR_CEP")%>">
		<br><div class="form_label">Bairro:</div><input name="DBVAR_STR_ENTR_BAIRRO" type="text" style="width:150px" value="<%=GetValue(objRS,"ENTR_BAIRRO")%>">
		<br><div class="form_label">Cidade:</div><input name="DBVAR_STR_ENTR_CIDADE" type="text" style="width:200px" value="<%=GetValue(objRS,"ENTR_CIDADE")%>">
		<br><div class="form_label">Estado:</div><select name="DBVAR_STR_ENTR_ESTADO" style="width:200px">
			<option value="">Selecione...</option>
	        <%
			  arrESTADOS = array("AC","AL","AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")
			  arrNOMES = array("Acre","Alagoas","Amapá", "Amazonas", "Bahia", "Ceará", "Distrito Federal", "Espírito Santo", "Goias", "Maranhão", "Mato Grosso", "Mato Grosso do Sul", "Minas Gerais", "Pará", "Paraíba", "Paraná", "Pernambuco", "Piauí", "Rio de Janeiro", "Rio Grande do Norte", "Rio Grande do Sul", "Rondônia", "Roraima", "Santa Catarina", "São Paulo", "Sergipe", "Tocantins")
			  
			  For Cont = 0 To UBound(arrESTADOS)
				Response.Write("<option value='" & arrESTADOS(Cont) & "'")
				if arrESTADOS(Cont) = GetValue(objRS,"ENTR_ESTADO") then Response.Write(" selected")
				Response.Write(">" & UCase(arrNOMES(Cont)) & "</option>")
			  Next
			  %>	
		     </select>
		<br><div class="form_label">Pa&iacute;s:</div><input type="text" name="DBVAR_STR_ENTR_PAIS" style="width:150px" value="<%=GetValue(objRS,"ENTR_PAIS")%>">
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
</body>
</html>
<%
		End If 
	    FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>