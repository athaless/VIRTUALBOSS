<!--#include file="_database/athDBConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<%
	On Error resume Next
	
	Dim objUpload, objFileToSave, objUploadedFile, strERRO
	Dim strFORMNAME, strFIELDNAME, strDIR_UPLOAD, strFUNC
	Dim strFILE 
	
	strERRO = ""
	
	strFORMNAME		= GetParam("var_formname")
	strFIELDNAME	= GetParam("var_fieldname")
	strDIR_UPLOAD	= GetParam("var_dir")
	
	Set objUpload = Server.CreateObject("Dundas.Upload.2")
	objUpload.UseUniqueNames = false

	'objUpload.Save FindUploadPath & "\" & strDIR_UPLOAD ------------------------------------
	'Coloca no buffer p/ poder fazer o SaveAS, pois precisamso renomear o arquivo retirando 
	'caracteres especiais). Obs.: Como nete caso estamos usando o .SaveAS, o setup de 
	'objUpload.UseUniqueNames=true não interefere em nada, de maneira que nós é que passamos 
	'a colocar prefixo nos arquivos para garanti-los como únicos (ao menos numa mesma session)
	objUpload.SaveToMemory
	For Each objUploadedFile in objUpload.Files 
		strFILE = objUpload.GetFileName(objUploadedFile.OriginalPath)
		strFILE = "{" & Session.SessionID & "}_" & getNormalString(strFILE)
		objUploadedFile.SaveAs FindUploadPath & "\" & strDIR_UPLOAD & "\" & strFILE
	Next	

	'apenas pra confirmar, pega o nome do arquivo que foi salvo
	If objUpload.Files.Count > 0 then
	  strFILE = objUpload.Files(0).Path
	  strFILE = objUpload.GetFileName(strFILE)
	End If
	
	Set objUpload = Nothing
	
	If ERR.Number <> 0 Then
		strERRO = Err.Description
		strFUNC = 1
	Else
		strFUNC = 2
	End If
	
	Response.Redirect("athUploader.asp?var_file=" & strFILE & "&var_erro=" & strERRO & "&var_formname=" & strFORMNAME & "&var_fieldname=" & strFIELDNAME & "&var_func=" & strFUNC & "&var_dir=" & strDIR_UPLOAD)
%>