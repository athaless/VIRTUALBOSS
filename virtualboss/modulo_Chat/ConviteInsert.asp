<!--#include file="../_database/ConfigINC.asp"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"-->
<%
	Session.LCID = 1046 
	
	Dim objConn, objRS, strSQL
	Dim strValue
	
	If UCase(CFG_USR_STATUS) <> "LOGADO" Then 
		Response.Redirect("../modulo_Principal/Default.asp")
		Response.End()
	End If 
	
	AbreDBConn objConn, CFG_DB
	
	strValue = GetParam("chkName")
	strValue = Split(strValue, "|")
	
	If isArray(strValue) Then
		If UBound(strValue) > 0 Then
			If strValue(0) <> "" And strValue(1) <> "" Then
				strSQL = " INSERT INTO CHAT_CONVITES (COD_USER_DE, COD_USER_PARA, SYS_DT_CONVITE, COD_EMPRESA) " &_
						 " VALUES ('" & CFG_USR_COD_USER & "', '" & strValue(0) & "', #" & PrepData(Now(), False, True) & "#, " & CFG_USR_COD_EMPRESA & ")"
				objConn.Execute(strSQL)
			End If
		End If
	End If
	
	FechaDBConn(objConn)	
	Response.Redirect("ShowCall.asp")
%>