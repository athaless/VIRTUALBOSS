<!--#include file="./_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="./_database/athUtils.asp"-->
<!--#include file="./_scripts/scripts.js"-->
<%
Dim strArquivo, strNomeArquivo, strCliente, strTipo, strFileType, objStream, objFS, boolFileExists, boolError
strCliente     = Trim(GetParam("var_cliente")) & "/"
strTipo        = Trim(GetParam("var_tipo")) & "/"
strNomeArquivo = Trim(GetParam("var_Arquivo"))
boolError      = false
boolFileExists = false
if ((strCliente <> "") and (strTipo <> "") and (strNomeArquivo <> "")) Then
	strArquivo = "./upload/" & strCliente & strTipo & strNomeArquivo	
	'Extensão do arquivo.
    strFileType = lcase(Right(strArquivo, 4))				
	Set objFS = Server.CreateObject("Scripting.FileSystemObject")
	If objFS.FileExists(Server.MapPath(strArquivo)) Then	
	    boolFileExists = true
		'Arquivos PDF e imagens são abertos diretamente no browser.
		Select Case strFileType
		  Case ".pdf",".jpg","jpeg",".gif",".png",".bmp",".jpe"
			Response.Redirect(strArquivo)
		  'Demais arquivos é realizado download.	
		  Case Else	  
			On Error Resume Next
			Set objStream = Server.CreateObject("ADODB.Stream")	
			objStream.Type = 1			
			objStream.Open
			objStream.LoadFromFile Server.Mappath(strArquivo)	
			If Err.number = 0 Then
				Response.Clear
				Response.ContentType = "application/octet-stream"
				Response.AddHeader "Content-Disposition", "attachment; filename=" & strNomeArquivo
				Response.AddHeader "Content-Transfer-Encoding","binary"
				'Mandamos o arquivo em partes de 3 MB, para não estourar o limite do buffer.
				Do Until objStream.EOS
					Response.BinaryWrite(objStream.Read(3000000))'Limite do buffer do ASP: 4194304 Bytes
					Response.Flush
				Loop				
				Response.End()
			Else
			  boolError = true
			End If  	
			objStream.Close
			Set objStream = Nothing						
        End Select						
	End If		
	If ((not boolFileExists) or (boolError)) Then
		Mensagem "Arquivo não encontrado.", "",  "", True
	End If			
    Set objFS = Nothing	
End If
%>