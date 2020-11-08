<!--#include file="../_database/athdbConn.asp"--><%'-- ATEN��O: language, option explicit, etc... est�o no athDBConn --%>
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_MB_LIVRO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
	Const WMD_WIDTH   = 520 'Tamanho(largura) da Dialog gerada para conter os �tens de formul�rio 
 	Const auxAVISO    = "<span class='texto_ajuda'>Campos com * s�o obrigat�rios.</span>"
	Dim   auxContador, objConn
	
	AbreDBConn objConn, CFG_DB
	
	'Inicializa��o de Vari�veis
	'auxContador = 0
%>
<html>
	<head>
		<title>vboss</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
		<script language="JavaScript" type="text/javascript">
			//****** Fun��es de a��o dos bot�es - In�cio ******
			function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
			function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
			function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
			
			function submeterForm() {
				var var_msg = '';
				if (document.form_insert.DBVAR_STR_TITULO�.value  == '') var_msg += '\n T�tulo';
				if (document.form_insert.DBVAR_STR_AUTORES�.value == '') var_msg += '\n Autores';
				if (document.form_insert.DBVAR_STR_EDITORA�.value == '') var_msg += '\n Editora';
				if (document.form_insert.DBVAR_STR_EDICAO�.value  == '') var_msg += '\n Edi��o';
				
				if (var_msg == ''){ document.form_insert.submit(); } 
				else{ alert('Favor verificar campos obrigat�rios:\n' + var_msg); }
			}
			//****** Fun��es de a��o dos bot�es - Fim ******
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
		<br><div class="form_label">*T�tulo:</div><input name="DBVAR_STR_TITULO�" type="text" style="width:270px;" maxlength="200" value="">
		<br><div class="form_label">*Autores:</div><textarea name="DBVAR_STR_AUTORES�" style="width:270px;height:50px;"></textarea>
		<br><div class="form_label">*Editora:</div><input name="DBVAR_STR_EDITORA�" type="text" style="width:150px;" maxlength="200" value="">
		<br><div class="form_label">*Edi��o:</div><select name="DBVAR_STR_EDICAO�" style="width:50px;"><option value=""></option><% for auxContador = 1 to 50 %><option value="<%=auxContador%>"><%=auxContador%></option><% next %></select>
		<div class="form_label_nowidth" style="text-align:right;width:35px;">*Ano:</div><select name="DBVAR_NUM_ANO�" style="width:60px;"><option value=""></option><% montaComboAno(1700-2050) %></select>
		<div class="form_label_nowidth" style="text-align:right;width:40px;">Volume:</div><input name="DBVAR_STR_VOLUME" type="text" style="width:40px;" maxlength="10" value="">
		<br><div class="form_label">Assunto:</div><input name="DBVAR_STR_ASSUNTO" type="text" style="width:250px;" maxlength="200" value="">
		<br><div class="form_label">Categoria:</div><select name="DBVAR_INT_COD_CATEGORIA" style="width:140px;"><option value="NULL"></option><%=montaCombo("STR","SELECT COD_CATEGORIA, NOME FROM mb_livro_categoria WHERE DT_INATIVO IS NULL","COD_CATEGORIA","NOME","")%></select>
		<br><div class="form_label">Idioma:</div><select name="DBVAR_STR_IDIOMA" style="width:140px;">
													<option value="" selected="selected"></option>
													<option value="PORTUGUES">PORTUGU�S</option>
													<option value="ESPANHOL">ESPANHOL</option>
													<option value="ALEMAO">ALEM�O</option>
													<option value="INGLES-GRA">INGL�S - GRA</option>
													<option value="INGLES-EUA">INGL�S - EUA</option>
													<option value="RUSSO">RUSSO</option>
													<option value="CHINES-CANTONES">CHIN�S - CANTON�S</option>
													<option value="CHINES-MANDARIM">CHIN�S - MANDARIM</option>
													<option value="JAPONES">JAPON�S</option>
													<option value="BENGALES">BENGAL�S</option>
													<option value="ARABE">�RABE</option>
													<option value="HINDI">HINDI</option>
												 </select>
		<br><div class="form_label">Imagem:</div><input name="DBVAR_STR_IMG" type="text" maxlength="250" value="" style="width:200px;"><a href="javascript:UploadArquivo('form_insert','DBVAR_STR_IMG', 'upload//<%=Request.Cookies("VBOSS")("CLINAME")%>//MB_LIVRO//');"><img src="../img/BtUpload.gif" border="0" style="vertical-align:top; padding-top:2px;" vspace="0" hspace="0"></a>
	</div>
	
	<div class="form_grupo" id="form_grupo_2">
		<div class="form_label"></div>
		<img src="../img/BulletMenos.gif" id="form_collapse_2" border="0" onClick="ShowArea('form_grupo_2','form_collapse_2');" 
		style="cursor:pointer;">
		<b>Dados de Cataloga��o</b><br>
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
		<b>Dados de Aquisi��o/Loca��o</b><br>
		<br><div class="form_label">Prz. de Empr�stimo:</div><select name="DBVAR_NUM_PRAZO_EMPR" style="width:50px;">
														 <% for auxContador = 1 to 50 %>
														 	<% if(auxContador = 1 or auxContador = 2 or auxContador = 3 or auxContador = 4 or auxContador = 5 or auxContador = 10 or auxContador = 15 or auxContador = 20 or auxContador = 25 or auxContador = 30 or auxContador = 50) then %>
															<option value="<%=auxContador%>"><%=auxContador%></option>
															<% end if %>
														 <% next %>
														 </select><span class="texto_ajuda">dia(s)</span>
		<br><div class="form_label">Aquisi��o:</div><%=InputDate("DBVAR_DATE_AQUISICAO","","",true)%>&nbsp;<%=ShowLinkCalendario("form_insert", "DBVAR_DATE_AQUISICAO", "ver calend�rio")%>
		<br><div class="form_label">Localiza��o:</div><input name="DBVAR_STR_LOCALIZACAO" type="text" style="width:150px;" maxlength="20" value="">
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