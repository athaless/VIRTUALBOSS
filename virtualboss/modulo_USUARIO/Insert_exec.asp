<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_database/md5.asp"--> 
<%
	Dim objConn, objRS, strSQL
	Dim strNOME, strID_USUARIO, strSENHA, strEMAIL, strTIPO, strCODIGO
	Dim strGRP_USER, strDIR_DEFAULT, strOBS, strFOTO, strDT_INATIVO, strAPELIDO, strLOGINFB, strIDUSERMODEL
	Dim strJSCRIPT_ACTION, strDEFAULT_LOCATION
	
	AbreDBConn objConn, CFG_DB
	
	strNOME        = GetParam("var_nome")
	strID_USUARIO  = GetParam("var_id_usuario")
	strAPELIDO     = GetParam("var_apelido")
	strSENHA       = GetParam("var_senha")
	strEMAIL       = GetParam("var_email")
	strTIPO        = GetParam("var_tipo")
	strCODIGO      = GetParam("var_codigo")
	strGRP_USER    = GetParam("var_grp_user")
	strDIR_DEFAULT = GetParam("var_dir_default")
	strOBS         = GetParam("var_obs")
	strFOTO        = GetParam("var_foto")
	strDT_INATIVO  = GetParam("var_dt_inativo")
	strJSCRIPT_ACTION   = GetParam("JSCRIPT_ACTION")
	strDEFAULT_LOCATION = GetParam("DEFAULT_LOCATION")
	strLOGINFB     = GetParam("var_login_fb")  
	strIDUSERMODEL = GetParam("var_id_usuario_modelo")
	
	if IsDate(strDT_INATIVO) then 
		strDT_INATIVO = "'" & PrepDataBrToUni(strDT_INATIVO,false) & "'" 
	else 
		strDT_INATIVO = "NULL"
	end if
	
	If strAPELIDO = "" Then strAPELIDO = strID_USUARIO
	
	strSQL =          " INSERT INTO USUARIO ( NOME, ID_USUARIO, SENHA, EMAIL, TIPO, CODIGO, GRP_USER, APELIDO "
	strSQL = strSQL & "                     , DIR_DEFAULT, FOTO, OBS, DT_INATIVO, DT_CRIACAO,  LOGIN_FACEBOOK, ID_USUARIO_MODELO) "
	strSQL = strSQL & " VALUES ( '" & strNOME & "', '" & strID_USUARIO & "', '" & md5(strSENHA) & "', '" & strEMAIL & "' "
	strSQL = strSQL & "        , '" & strTIPO & "', " & strCODIGO & ", '" & strGRP_USER & "', '" & strAPELIDO & "', '" & strDIR_DEFAULT & "' "
	strSQL = strSQL & "        , '" & strFOTO & "', '" & strOBS & "', " & strDT_INATIVO & ", '" & PrepDataBrToUni(Now,true) & "', '" & strLOGINFB & "', '" & strIDUSERMODEL &"') "
    athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "USUARIO - " & strID_USUARIO, strSQL
	
	'athDebug strSQL, true

	objConn.execute(strSQL)
	
	'Se for usuário de cliente estamos inserindo os direitos básicos dos 
	'módulos que ele precisará para usar o sistema de chamados 
	If strGRP_USER = "CLIENTE" Then
		'Insere direitos básicos do módulo de CHAMADO: INS, UPD, DEL, VIEW
		'O direito de ATENDE tem que ser dado para cada usuário
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_CHAMADO' AND ID_DIREITO = 'VIEW' ")
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_CHAMADO' AND ID_DIREITO = 'INS' ")
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_CHAMADO' AND ID_DIREITO = 'UPD' ")
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_CHAMADO' AND ID_DIREITO = 'DEL' ")
		
		'Insere direitos básicos para usar o módulo de TODOLIST: VIEW, INS_RESP, UPD, CLOSE
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_TODOLIST' AND ID_DIREITO = 'VIEW' ")
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_TODOLIST' AND ID_DIREITO = 'INS_RESP' ")
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_TODOLIST' AND ID_DIREITO = 'CLOSE' ")
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_TODOLIST' AND ID_DIREITO = 'UPD' ")
		
		'Insere direitos básicos para usar o módulo de MSG: VIEW, INS, DEL
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_MSG' AND ID_DIREITO = 'VIEW' ")
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_MSG' AND ID_DIREITO = 'INS' ")
		objConn.execute(" INSERT INTO SYS_APP_DIREITO_USUARIO (COD_APP_DIREITO, ID_USUARIO) SELECT COD_APP_DIREITO, '" & strID_USUARIO & "' FROM SYS_APP_DIREITO WHERE ID_APP = 'modulo_MSG' AND ID_DIREITO = 'DEL' ")
	    athSaveLog "INS", Request.Cookies("VBOSS")("ID_USUARIO"), "SYS_APP_DIREITO_USUARIO - " & strID_USUARIO, "'Insere direitos básicos do módulo de CHAMADO (chamado, todo e msg): INS, UPD, DEL, VIEW ver modulo_USUARIO/Insert_Exec.asp"
	End If
	
	FechaDBConn(objConn)
	
	response.write "<script>" & vbCrlf 
	if (strJSCRIPT_ACTION <> "")   then response.write strJSCRIPT_ACTION & vbCrlf end if
	if (strDEFAULT_LOCATION <> "") then response.write "location.href='" & strDEFAULT_LOCATION & "'" & vbCrlf
	response.write "</script>"
%>