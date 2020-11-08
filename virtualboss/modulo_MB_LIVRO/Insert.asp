<!--#include file="../_database/athdbConn.asp"--><%'-- ATENÇÃO: language, option explicit, etc... estão no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_MB_LIVRO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Const WMD_WIDTH   = 520 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 
 	Const auxAVISO    = "<span class='texto_ajuda'>Campos com * são obrigatórios.</span>"
	Dim   auxContador, objConn
	
	AbreDBConn objConn, CFG_DB
	
	'Inicialização de Variáveis
	'auxContador = 0
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
			
			function submeterForm() {
				var var_msg = '';
				if (document.form_insert.DBVAR_STR_TITULOô.value  == '') var_msg += '\n Título';
				if (document.form_insert.DBVAR_STR_AUTORESô.value == '') var_msg += '\n Autores';
				if (document.form_insert.DBVAR_STR_EDITORAô.value == '') var_msg += '\n Editora';
				if (document.form_insert.DBVAR_STR_EDICAOô.value  == '') var_msg += '\n Edição';
				
				if (var_msg == ''){ document.form_insert.submit(); } 
				else{ alert('Favor verificar campos obrigatórios:\n' + var_msg); }
			}
			//****** Funções de ação dos botões - Fim ******
		</script>
	</head>
<body>
<%=athBeginDialog(WMD_WIDTH, "Livro - Inser&ccedil;&atilde;o") %>
<form name="form_insert" action="../_database/athInsertToDB.asp" method="post">
	<input type="hidden" name="DEFAULT_TABLE"    value="MB_LIVRO">
	<input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
	<input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
	<input type="hidden" name="RECORD_KEY_NAME"  value="COD_LIVRO">
	<input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
	<input type="hidden" name="DEFAULT_LOCATION" value='../modulo_MB_LIVRO/insert.asp'>
	<input type="hidden" name="DBVAR_DATETIME_SYS_DTT_INS"   value="<%=now()%>">
	<input type="hidden" name="DBVAR_STR_SYS_ID_USUARIO_INS" value="<%=Request.Cookies("VBOSS")("ID_USUARIO")%>">
	<div class="form_grupo" id="form_grupo_1">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_1" border="0" onClick="ShowArea('form_grupo_1','form_collapse_1');" 
		style="cursor:pointer;">
		<b>Dados do Livro</b><br>
		<br><div class="form_label">*Título:</div><input name="DBVAR_STR_TITULOô" type="text" style="width:270px;" maxlength="200" value="">
		<br><div class="form_label">*Autores:</div><textarea name="DBVAR_STR_AUTORESô" style="width:270px;height:50px;"></textarea>
		<br><div class="form_label">*Editora:</div><input name="DBVAR_STR_EDITORAô" type="text" style="width:150px;" maxlength="200" value="">
		<br><div class="form_label">*Edição:</div><select name="DBVAR_STR_EDICAOô" style="width:50px;"><option value=""></option><% for auxContador = 1 to 50 %><option value="<%=auxContador%>"><%=auxContador%></option><% next %></select>
		<div class="form_label_nowidth" style="text-align:right;width:35px;">*Ano:</div><select name="DBVAR_NUM_ANOô" style="width:60px;"><option value=""></option><% montaComboAno(1700-2050) %></select>
		<div class="form_label_nowidth" style="text-align:right;width:40px;">Volume:</div><input name="DBVAR_STR_VOLUME" type="text" style="width:40px;" maxlength="10" value="">
		<br><div class="form_label">Assunto:</div><input name="DBVAR_STR_ASSUNTO" type="text" style="width:250px;" maxlength="200" value="">
		<br><div class="form_label">Categoria:</div><select name="DBVAR_INT_COD_CATEGORIA" style="width:140px;"><option value="NULL"></option><%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM mb_livro_categoria WHERE DT_INATIVO IS NULL","COD_CATEGORIA","NOME","")%></select>
		<br><div class="form_label">Idioma:</div><select name="DBVAR_STR_IDIOMA" style="width:140px;">
													<option value="" selected="selected"></option>
													<option value="PORTUGUES">PORTUGUÊS</option>
													<option value="ESPANHOL">ESPANHOL</option>
													<option value="ALEMAO">ALEMÃO</option>
													<option value="INGLES-GRA">INGLÊS - GRA</option>
													<option value="INGLES-EUA">INGLÊS - EUA</option>
													<option value="RUSSO">RUSSO</option>
													<option value="CHINES-CANTONES">CHINÊS - CANTONÊS</option>
													<option value="CHINES-MANDARIM">CHINÊS - MANDARIM</option>
													<option value="JAPONES">JAPONÊS</option>
													<option value="BENGALES">BENGALÊS</option>
													<option value="ARABE">ÁRABE</option>
													<option value="HINDI">HINDI</option>
												 </select>
		<br><div class="form_label">Imagem:</div><input name="DBVAR_STR_IMG" type="text" maxlength="250" value="" style="width:200px;"><a href="javascript:UploadArquivo('form_insert','DBVAR_STR_IMG', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//MB_LIVRO//');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	</div>
	
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
		style="cursor:pointer;">
		<b>Dados de Catalogação</b><br>
		<br><div class="form_label">ID:</div><input name="DBVAR_STR_ID" type="text" style="width:50px;" maxlength="10" value="">
		<br><div class="form_label">CDU:</div><input name="DBVAR_STR_CDU" type="text" style="width:100px;" maxlength="50" value="">
		<br><div class="form_label">CDD:</div><input name="DBVAR_STR_CDD" type="text" style="width:100px;" maxlength="50" value="">
		<br><div class="form_label">ISBN:</div><input name="DBVAR_STR_ISBN" type="text" style="width:150px;" maxlength="25" value="">
		<br><div class="form_label">Cod. de Barras:</div><input name="DBVAR_STR_CODBAR" type="text" style="width:150px;" maxlength="25" value="">
	</div>	
	
	<div class="form_grupo" id="form_grupo_3">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_3" border="0" onClick="ShowArea('form_grupo_3','form_collapse_3');" 
		style="cursor:pointer;">
		<b>Dados de Aquisição/Locação</b><br>
		<br><div class="form_label">Prz. de Empréstimo:</div><select name="DBVAR_NUM_PRAZO_EMPR" style="width:50px;">
														 <% for auxContador = 1 to 50 %>
														 	<% if(auxContador = 1 or auxContador = 2 or auxContador = 3 or auxContador = 4 or auxContador = 5 or auxContador = 10 or auxContador = 15 or auxContador = 20 or auxContador = 25 or auxContador = 30 or auxContador = 50) then %>
															<option value="<%=auxContador%>"><%=auxContador%></option>
															<% end if %>
														 <% next %>
														 </select><span class="texto_ajuda">dia(s)</span>
		<br><div class="form_label">Aquisição:</div><%=InputDate("DBVAR_DATE_AQUISICAO","","",true)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_AQUISICAO", "ver calendário")%>
		<br><div class="form_label">Localização:</div><input name="DBVAR_STR_LOCALIZACAO" type="text" style="width:150px;" maxlength="20" value="">
		<br><div class="form_label">Propriedade:</div><input name="DBVAR_STR_PROPRIEDADE" type="text" size="50" maxlength="200" value="">
		<br><div class="form_label">Classe:</div><input name="DBVAR_STR_CLASSE" type="text" size="50" maxlength="200" value="">
		<br><div class="form_label">Extra:</div><input name="DBVAR_STR_EXTRA" type="text" size="50" maxlength="50" value="">
		<br><div class="form_label">Resenha:</div><textarea name="DBVAR_STR_RESENHA" style="width:270px;height:100px;"></textarea>
		<br><div class="form_label">Status:</div><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="NULL" checked>Ativo
		&nbsp;&nbsp;<div class="form_label_nowidth"><input name="DBVAR_DATE_DT_INATIVO" type="radio" class='inputclean' value="">Inativo</div>
	</div>
</form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();")%>
<!--#include file="../_calendar/frCalendar.htm"-->
</body>
</html>