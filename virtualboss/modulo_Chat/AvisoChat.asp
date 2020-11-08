<% Option Explicit %>
<!--#include file="../_database/ADOVBS.INC"-->
<!--#include file="../_database/athDBConn.asp"-->
<!--#include file="../_database/athUtils.asp"-->
<%
	Session.LCID =  1046 
	
	Dim objConn, objRS, strSQL

	AbreDBConn objConn, CFG_DB

	strSQL = " SELECT COD_CONVITE, COD_USER_DE, SYS_DT_CONVITE " &_
			 " FROM CHAT_CONVITES WHERE COD_EMPRESA = " & CFG_USR_COD_EMPRESA &_ 
			 " AND AVISADO = False AND COD_USER_PARA LIKE '" & CFG_USR_COD_USER & "' " 
	Set objRS = objConn.Execute(strSQL)
	
	If Not objRS.EOF Then
		Response.Write("<script language=""javascript"">")
		Response.Write("	alert('Você foi convidado pelo usuário " & GetValue(objRS, "COD_USER_DE") & " para entrar no chat em " & PrepData(GetValue(objRS, "SYS_DT_CONVITE"), True, True) & ".');")
		Response.Write("</script>")
		
		strSQL = " UPDATE CHAT_CONVITES SET AVISADO = True WHERE COD_CONVITE = " & GetValue(objRS, "COD_CONVITE")
		objConn.Execute(strSQL)
	End If
	
	FechaRecordset(objRS)
	FechaDBConn(objConn)
%>
<html>
	<meta http-equiv="refresh" content="15">
</html>