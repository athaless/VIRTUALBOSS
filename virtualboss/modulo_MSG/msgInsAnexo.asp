<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<%	
	Dim objConn, objRS, strSQL 
	Dim strARQUIVO, strDESCRICAO 
	
	strARQUIVO = GetParam("var_arquivo") 
	strDESCRICAO = GetParam("var_descricao") 
	
	If strARQUIVO <> "" Then 
		AbreDBConn objConn, CFG_DB 
		
		strSQL = " INSERT INTO MSG_TEMP_ANEXO ([SESSION], ARQUIVO, DESCRICAO) " &_
				   " VALUES ('" & Session.SessionID & "', '" & strARQUIVO & "', '" & strDESCRICAO & "')"
		objConn.Execute(strSQL)
		
		FechaDBConn objConn
	End If 
	
	Response.Redirect("msgShowAnexos.asp?var_session=" & Session.SessionID)
%>