<!--#include file="_database/athDBConn.asp"-->
<%
	On Error resume Next
	
	Dim objUpload, objFile
	Dim strFORMNAME, strFIELDNAME, strDIR_UPLOAD, strFUNC
	Dim strFILE, strERRO
	
	strERRO = ""
	
	strFORMNAME = GetParam("var_formname")
	strFIELDNAME = GetParam("var_fieldname")
	strDIR_UPLOAD = GetParam("var_dir")
	
	Set objUpload = Server.CreateObject("Persits.Upload.1")
	
	objUpload.Save CFG_PHYSICAL_PATH & "\VirtualBoss\" & strDIR_UPLOAD 
	
	For Each objFile In objUpload.Files
		strFILE = objFile.ExtractFileName
	Next
	
	Set objUpload = Nothing
	
	If ERR.Number <> 0 Then
		strERRO = Err.Description
		strFUNC = 1
	Else
		strFUNC = 2
	End If
	Response.Redirect("athUploader.asp?var_file=" & strFILE & "&var_erro=" & strERRO & "&var_formname=" & strFORMNAME & "&var_fieldname=" & strFIELDNAME & "&var_func=" & strFUNC & "&var_dir=" & strDIR_UPLOAD)
%>