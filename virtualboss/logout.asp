<!--#include file="_database/athdbConn.asp"--> <!-- ATENÇÃO: language, option explicite, etc... estão no athDBConn -->
<!--#include file="_database/athUtils.asp"-->
<%
 Dim objConn, objRS, objRSCT, strSQL, auxStr
 
 AbreDBConn objConn, CFG_DB
 
 auxStr = Request.Cookies("VBOSS")("PATHSTARTED")
 
 If Request.Cookies("VBOSS")("ID_USUARIO") <> "" Then
	 strSql = " SELECT COD_USUARIO_LOG FROM USUARIO_LOG " & _
			  "  WHERE ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "'" & _
			  "    AND NUM_SESSAO = '" & Session.SessionID & "'" & _
			  "    AND DT_LOGIN = '" & PrepDataBrToUni(Request.Cookies("VBOSS")("DT_LOGIN"), true) & "' " & _
			  "  ORDER BY COD_USUARIO_LOG DESC"

     'response.Write(strSQL)
     'response.End

	 Set objRS = objConn.execute(strSQL)
	 if not ObjRs.Eof then
		 strSQL = " UPDATE USUARIO_LOG " &_
	    	      "    SET EXTRA = CONCAT(EXTRA, ' / LOGOUT') " & _
		          "  WHERE COD_USUARIO_LOG = " & GetValue(objRS,"COD_USUARIO_LOG") 
		 'AQUI: NEW TRANSACTION
		 set objRSCT  = objConn.Execute("start transaction")
		 set objRSCT  = objConn.Execute("set autocommit = 0")
	     objConn.execute strSQL
		 If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem  "logout A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		 else
			set objRSCT = objConn.Execute("commit")
		 End If
		 
		 strSQL = " UPDATE USUARIO_LOG " &_
		          "    SET DT_LOGOUT = '" & PrepDataBrToUni(Now, true) & "' " & _
				  "  WHERE ID_USUARIO = '" & Request.Cookies("VBOSS")("ID_USUARIO") & "'" & _
				  "    AND NUM_SESSAO = '" & Session.SessionID & "'" & _
				  "    AND DT_LOGIN = '" & PrepDataBrToUni(Request.Cookies("VBOSS")("DT_LOGIN"), true) & "' "
		 'AQUI: NEW TRANSACTION
		 set objRSCT  = objConn.Execute("start transaction")
		 set objRSCT  = objConn.Execute("set autocommit = 0")
    	 objConn.execute strSQL
		 If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem  "logout B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		 else
			set objRSCT = objConn.Execute("commit")
		 End If

	 end if
	 FechaDBConn ObjConn
 End If
 
 Response.Cookies("VBOSS")("COD_USUARIO")     = ""
 Response.Cookies("VBOSS")("ID_USUARIO")      = ""
 Response.Cookies("VBOSS")("NOME_USUARIO")    = ""
 Response.Cookies("VBOSS")("GRUPO_USUARIO")   = ""
 Response.Cookies("VBOSS")("DT_LOGIN")        = ""
 Response.Cookies("VBOSS")("DEFAULT_EMP")     = ""
 Response.Cookies("VBOSS")("CLINAME")         = ""
 Response.Cookies("VBOSS")("PATHSTARTED")     = ""
 Response.Cookies("VBOSS")("SENHA")           = ""
 Response.Cookies("VBOSS")("ENTIDADE_CODIGO") = ""
 Response.Cookies("VBOSS")("ENTIDADE_TIPO")   = ""
 
 Session.Contents.RemoveAll()
 Session.Abandon()
%>
<html>
<head>
<title></title>
</head>
<body onLoad="document.formulario.submit()">
<form name="formulario" action="../<%=auxStr%>/login.asp" method="post" target="vbfr_pcenter"></form>
</body>
</html>