<!--#include file="_database/athDBConn.asp"-->
<%
 On Error Resume Next
	Dim RST, Arq, FSO
	Dim strERRO, strFORMNAME, strFIELDNAME, strDIR_UPLOAD
	Dim ForWriting, lngNumberUploaded
	Dim noBytes, binData, LenBinary
	Dim strDataWhole, FileName, arrFileName, strBoundry, lngBoundryPos, strData, PathFile, Arquivo, strFUNC
	Dim lngCurrentBegin, lngCurrentEnd, lngBeginFileName, lngEndFileName, strFilename
	Dim lngCT, lngBeginPos, lngEndPos
	Dim lngDataLenth, strFileData
	
	strERRO = ""
	
	strFORMNAME = GetParam("var_formname")
	strFIELDNAME = GetParam("var_fieldname")
	strDIR_UPLOAD = GetParam("var_dir")
	
	ForWriting = 2
	lngNumberUploaded = 0

	'Get binary data from form		
	noBytes = Request.TotalBytes
	binData = Request.BinaryRead(noBytes)
	'convery the binary data to a string
	Set RST = CreateObject("ADODB.Recordset")
	LenBinary = LenB(binData)

	If LenBinary > 0 Then
		RST.Fields.Append "myBinary", adLongVarChar, LenBinary
		RST.Open
		RST.AddNew
		RST("myBinary").AppendChunk BinData
		RST.Update
		strDataWhole = RST("myBinary")
		
		
		'---------------------------------------------------------------------------------------------------
		'Exemplo de strDataWhole:
		'-----------------------------7d76f1f1408f8 Content-Disposition: form-data;
		' name="type_upload" athUploader_BYTEBYTE.asp -----------------------------7d76f1f1408f8
		' Content-Disposition: form-data; name="file1"; filename="C:\Documents and Settings\ares\Meus documentos\Minhas imagens\painel.jpg"
		' Content-Type: image/pjpeg ÿØÿà
		'
		'Cuidar, pois existem caracteres escondidos entre os espaços dos parâmetros da string (Chr(13) e Chr(10))
		'
		'*** Debbug strDataWhole ***
		'response.write strDataWhole
		'response.end
		'---------------------------------------------------------------------------------------------------
				
		'corta a string até a palavra filename
		FileName = Mid(strDataWhole, InStr(1,strDataWhole,"filename"))
		'corta a string até 1 caracter antes do Content
		FileName = Left(FileName, Instr(1,FileName,"Content")-1)
		'retira a string ' filename=" ' e as (") que tem no nome
		FileName = Replace(Replace(FileName,"filename=""",""),"""","")
		'retira dois caracteres ocultos que atrapalham na hora de gravar o arquivo no servidor
		FileName = Replace(Replace(FileName,Chr(13),""),Chr(10),"")
		'Quebra o nome do arquivo com o path pelo caracter (\)
		arrFileName = Split(FileName,"\")
		'Pega o nome do arquivo sem o path
		FileName = Cstr(arrFileName(Ubound(arrFileName)))
		
	End If
	'get the boundry indicator
	strBoundry = Request.ServerVariables ("HTTP_CONTENT_TYPE")
	lngBoundryPos = instr(1,strBoundry,"boundary=") + 8 
	strBoundry = "--" & right(strBoundry,len(strBoundry)-lngBoundryPos)
	'Get first file boundry positions.
	lngCurrentBegin = instr(1,strDataWhole,strBoundry)
	lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1
	Do While lngCurrentEnd > 0
		'Get the data between current boundry and remove it from the whole.
		strData = mid(strDataWhole,lngCurrentBegin, lngCurrentEnd - lngCurrentBegin)
		strDataWhole = replace(strDataWhole,strData,"")

		'Get the full path of the current file.
		lngBeginFileName = instr(1,strdata,"filename=") + 10
		lngEndFileName = instr(lngBeginFileName,strData,chr(34)) 
		'There could be one or more empty file boxes.	
		If lngBeginFileName <> lngEndFileName Then
			'strFilename = mid(strData,lngBeginFileName,lngEndFileName - lngBeginFileName)
			'Loose the path information and keep just the file name.
			' ****Comentado porque foi criada outra rotina para conseguir o nome do arquivo sem o path
			
			'tmpLng = instr(1,strFilename,"\")
			'Do While tmpLng > 0
			'	PrevPos = tmpLng
			'	tmpLng = instr(PrevPos + 1,strFilename,"\")
			'Loop
			'FileName = right(strFilename,len(strFileName) - PrevPos)
			
			' ****Comentado porque foi criada outra rotina para conseguir o nome do arquivo sem o path
			
			'Get the begining position of the file data sent.
			'if the file type is registered with the browser then there will be a Content-Type
			lngCT = instr(1,strData,"Content-Type:")
			If lngCT > 0 Then
				lngBeginPos = instr(lngCT,strData,chr(13) & chr(10)) + 4
			Else
				lngBeginPos = lngEndFileName
			End If
			'Get the ending position of the file data sent.
			lngEndPos = len(strData) 
			'Calculate the file size.	
			lngDataLenth = lngEndPos - lngBeginPos
			'Get the file data	
			strFileData = mid(strData,lngBeginPos,lngDataLenth)
			'Create the file.
				
			Set FSO = CreateObject("Scripting.FileSystemObject")
			PathFile = FindPhysicalPath("\virtualboss") & strDIR_UPLOAD
			
			Arquivo = PathFile & FileName 
			'Response.Write(arquivo)
			'Response.End()
			
			'Debbug ------------------------------------------------------------------
            'Response.Write("<br>PathFile [" & PathFile & "]")
            'Response.Write("<br>NomeArquivo [" & Trim(CStr(NomeArquivo & "")) & "]")
            'Response.Write("<br>NomeArquivo(Len) [" & Len(NomeArquivo) & "]")			
            'Response.end

			Set Arq = fso.OpenTextFile(arquivo, ForWriting, True)
			Arq.Write strFileData
			Set Arq = Nothing
			Set fso = Nothing
			
			lngNumberUploaded = lngNumberUploaded + 1
		End If

		'Get then next boundry postitions if any.
		lngCurrentBegin = instr(1,strDataWhole,strBoundry)
		lngCurrentEnd = instr(lngCurrentBegin + 1,strDataWhole,strBoundry) - 1
    Loop
	If ERR.Number <> 0 Then
		strERRO = Err.Description
		strFUNC = 1
	Else
		strFUNC = 2			
	End If
	
	Set RST = Nothing'strFILE
	
	Response.Redirect("athUploader.asp?var_file=" & FileName & "&var_erro=" & strERRO & "&var_formname=" & strFORMNAME & "&var_fieldname=" & strFIELDNAME & "&var_func=" & strFUNC & "&var_dir=" & strDIR_UPLOAD)

%>