<!--#include file="_database/athdbConn.asp"--> <!-- ATENÇÃO: language, option explicit, etc... estão no athDBConn -->
<!--#include file="_database/athUtils.asp"-->
<!--#include file="_database/md5.asp"-->
<!--#include file="_include/_IncludePonto_CalcTotais.asp"--> 
<%
  Dim objConn, objRS, objRSCT
  Dim strUserID, strUserpwd, strCLINAME
  Dim strUserIDfromDB, strUserGRPfromDB, strUserpwdfromDB, strDtInativofromDB
  Dim strUserCOD_USUARIOfromDB, strUserGrupofromDB, strUserDefaultEmp, strExtra, strFbEmail, strFbUserName, strFbAccessToken
  Dim strSQL, strURL, strErro, strITEM, strPStarted
  Dim strDT_LOGIN, strPWDSUs 
  
  CFG_DB		   = GetParam("var_dbselect")	    '
  strUserID		   = GetParam("var_userid")	        '  
  strUserpwd	   = GetParam("var_senha")		    '	
  strExtra		   = GetParam("var_extra")		    ' Obs.: varchar(25)  no CHAMADO para  possibilitar uma identificação a mais sobre a origem do chamado
  strPStarted	   = GetParam("var_pstarted")	    '
  strFbEmail       = GetParam("var_fb_mail")	    ' Email do Facebook
  strFbUserName    = GetParam("var_fb_username")    ' Username do Facebook
  strFbAccessToken = GetParam("var_fb_accessToken") 'Acess Token do Facebook, para acessar Mural do usuário
  
  strCLINAME = Replace(CFG_DB,"vboss_","")'Pega o nome do Cliente apartir do nome do banco de dados

  
  
  
  strDT_LOGIN  = now()
  strErro = ""
  strURL  = "../" & strPStarted & "/login.asp"
   
  'athDebug strFbAccessToken, true

  AbreDBConn objConn, CFG_DB
 ' response.write(strPStarted)
 ' response.end()
  'INI: Busca senhas de usuários SU ------------------------------------------------------
  strPWDSUs = ""
  strSQL = "SELECT SENHA FROM USUARIO WHERE GRP_USER = 'SU' AND DT_INATIVO IS NULL"

 set objRS = objConn.execute(strSQL)
  while not objRS.EOF
    strPWDSUs = strPWDSUs & GetValue(objRS,"SENHA") & " "
	objRS.MoveNext
  Wend
  'athDebug strPWDSUs & "<br>", false
  'athDebug md5(strUserpwd) & "<br>", false
  'athDebug InStr(strPWDSUs,md5(strUserpwd)), true
  FechaRecordSet objRS
  'FIM: Busca senhas de usuários SU ------------------------------------------------------


  'INI: Busca dados do usuário que quer logar-se -----------------------------------------
  strSQL = "SELECT DISTINCT U.COD_USUARIO, U.ID_USUARIO, U.NOME, U.SENHA, U.GRP_USER " & _
		   "     , U.CODIGO, U.TIPO, U.DIR_DEFAULT, UH.COD_EMPRESA " & _
           "  FROM USUARIO U " & _
		   "  LEFT OUTER JOIN USUARIO_HORARIO UH ON (U.ID_USUARIO = UH.ID_USUARIO) "
  If (strFbUsername = "") Then 		   
	   strSQL = strSQL & " WHERE U.ID_USUARIO = '" & strUserID & "'"
  Else
       strSQL = strSQL & " WHERE (U.LOGIN_FACEBOOK = '" & strFbEmail & "' OR U.LOGIN_FACEBOOK = '" & strFbUserName & "')"
  End If  
  strSQL = strSQL & "   AND U.DT_INATIVO IS NULL "		   
  'Restrição para que usuário só possa entrar no dia que estiver cadastrado para ele entrar
  'Colocando em comentário, mais tarde veremos isso
  '29/11/2006 - by Clv, Aless, Alan
  'AND UH.DIA_SEMANA = '" & ucase( DiaDaSemana(Day(Date), Month(Date), Year(Date) ) ) & "'" 

  'athDebug strSQL, true
  set objRS = objConn.execute(strSQL)
  If not (objRS.BOF and objRS.EOF) Then
    strUserCOD_USUARIOfromDB = GetValue(objRS,"COD_USUARIO")
    strUserIDfromDB          = GetValue(objRS,"ID_USUARIO")
    strUserpwdfromDB         = GetValue(objRS,"SENHA")
    strUserGrupofromDB       = GetValue(objRS,"GRP_USER")
    strUserDefaultEmp        = GetValue(objRS,"COD_EMPRESA")
  Else
    If(strFbUserName = "") Then
    	strErro = "usuário não encontrado"
	Else
		strErro = "usuário do Facebook não encontrado"	
	End If	
  End If 
  'FIM: Busca dados do usuário que quer logar-se -----------------------------------------


  ' ------------------------------------------------------------------------
  ' Testa se o usuario digitado foi encontrado no BD, caso contrário volta  
  ' para a tela de login.                                                   
  ' ------------------------------------------------------------------------
  ' Verifica se a senha digita confere com a cadastrada no sistema, caso    
  ' contrário envia mensagem erro em HTML e aborta/finaliza o programa.     
  ' ------------------------------------------------------------------------
  If strErro="" Then
        'Testa se a SENHA digitada confere com a senha do próprio usuário OU se confere com a senha de algum SUPER USER
		'If (StrComp(strUserpwdfromDB, md5(strUserpwd),vbBinaryCompare)=0)	Then
		If (strUserpwdfromDB = md5(strUserpwd)) OR (InStr(strPWDSUs,md5(strUserpwd)) > 0) OR (strFbUserName <> "") Then
            strURL = "modulo_PAINEL/default.asp"
			If GetValue(objRS,"DIR_DEFAULT") = "CLIENTE" Then strURL = "modulo_PAINEL_CLIENTE/default.asp"
			'Verifica se não tem alguma sessão anterior aberta - se existe fecha
			'Atualiza DT_LOGOUT se for NULO e EXTRA for NULO
			strSQL = " UPDATE USUARIO_LOG SET DT_LOGOUT = '" & PrepDataBrToUni(now(), true) & "' " &_
					 " , DT_OCORRENCIA = '" & PrepDataBrToUni(now(), true) & "', EXTRA = CONCAT(EXTRA, ' / ERRO: LOGIN DUPLO ou SEM FECHAMENTO') " & _
					 " WHERE ID_USUARIO = '" & strUserIDfromDB & "' AND DT_LOGOUT IS NULL AND EXTRA IS NULL"
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.execute strSQL,,adCmdText + adExecuteNoRecords
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "login_verify A: "& Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
			
			'Atualiza DT_LOGOUT se EXTRA não for NULO
			strSQL = " UPDATE USUARIO_LOG SET DT_LOGOUT = '" & PrepDataBrToUni(now(), true) & "' " &_
					 " , DT_OCORRENCIA = '" & PrepDataBrToUni(now(), true) & "', EXTRA = CONCAT(EXTRA, ' / SYSTEM LOGOUT') " & _
					 " WHERE ID_USUARIO = '" & strUserIDfromDB & "' AND DT_LOGOUT IS NULL AND EXTRA IS NOT NULL "
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.execute strSQL,,adCmdText + adExecuteNoRecords
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "login_verify B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
			
			'Remove os logs deste usuário de mais de 32 dias
			strSQL = " DELETE FROM USUARIO_LOG WHERE ID_USUARIO = '" & strUserIDfromDB & "' " &_
					 " AND DT_OCORRENCIA < '" & PrepDataBrToUni(DateAdd("D",-30,Date),false) & "' "
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.execute strSQL,,adCmdText + adExecuteNoRecords
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "login_verify C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
			
			'Grava o registro de inicialização da sessão do usuário
			strSQL =          " INSERT INTO USUARIO_LOG (NUM_SESSAO, ID_USUARIO, DT_LOGIN, DT_OCORRENCIA, EXTRA) " 
			strSQL = strSQL & " VALUES ('" & Session.SessionID & "' ,'" & strUserIDfromDB & "' " 
			if (strDT_LOGIN <> "") then strSQL = strSQL & ", '" & PrepDataBrToUni(strDT_LOGIN, true) & "'" 
			strSQL = strSQL & ", '" & PrepDataBrToUni(now, true) & "', 'LOGIN')" 
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute(strSQL)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem  "login_verify C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If

			
			'NO IE8 e em nossos IIS LOCAIS não conseguimos mais que funcione com acesso sem ser por IP
			'por isso acessamos o the_atena através do IP
            Response.Cookies("VBOSS").expires = Now() + 2  '2 dia para o cookie permanecer ativo.
			
			Response.Cookies("VBOSS")("COD_USUARIO")		   = strUserCOD_USUARIOfromDB
			Response.Cookies("VBOSS")("ID_USUARIO")			   = strUserIDfromDB
			Response.Cookies("VBOSS")("NOME_USUARIO")		   = GetValue(objRS, "NOME")
			Response.Cookies("VBOSS")("GRUPO_USUARIO")		   = strUserGrupofromDB
			Response.Cookies("VBOSS")("DT_LOGIN")			   = strDT_LOGIN
			Response.Cookies("VBOSS")("DEFAULT_EMP")		   = strUserDefaultEmp
			Response.Cookies("VBOSS")("DBNAME")				   = CFG_DB
			Response.Cookies("VBOSS")("CLINAME")			   = strCLINAME
			Response.Cookies("VBOSS")("SENHA")				   = md5(strUserpwd)
			Response.Cookies("VBOSS")("PATHSTARTED")		   = strPStarted
			Response.Cookies("VBOSS")("ENTIDADE_CODIGO")	   = GetValue(objRS, "CODIGO")
			Response.Cookies("VBOSS")("ENTIDADE_TIPO")		   = GetValue(objRS, "TIPO")
			Response.Cookies("VBOSS")("EXTRA")				   = strExtra 
			'Guarda no Cookie que o login foi realizado via Facebook
			Response.Cookies("VBOSS")("FACEBOOK_USERNAME")     = strFbUserName
			'Login via Face guarda o Access Token
			If (strFbUserName <> "") Then
				Response.Cookies("VBOSS")("FACEBOOK_ACCESS_TOKEN") = strFbAccessToken			
			Else 
				Response.Cookies("VBOSS")("FACEBOOK_ACCESS_TOKEN") = ""
			End If	
						
			'--------------------------------------------------------------------
			' Processo que insere faltas de forma automática no registro ponto
			'--------------------------------------------------------------------
			If (Request.Cookies("VBOSS")("DEFAULT_EMP") <> "") And (Request.Cookies("VBOSS")("GRUPO_USUARIO") <> "SU") Then
				MarcacaoFolga Request.Cookies("VBOSS")("ID_USUARIO")
			End If
        Else
            strErro = "senha não confere"
        End If
  End If
  
  FechaRecordSet objRS
  FechaDBConn ObjConn
%>
<html>
<head>
<title></title>
</head>
<body onLoad="document.formulario.submit()">
<form name="formulario" action="<%=strUrl%>" method="post">
    <input type="hidden" name="var_erro" value="<%=strErro%>">
    <input type="hidden" name="var_nome" value="<%=strUserID%>">
</form>
</body>
</html>