<%
Function TestaDundas()
 On Error Resume Next
 Set objUpload = Server.CreateObject("Dundas.Upload.2") 
 if Err.number = 0 then 
  TestaDundas = True
 else 
  TestaDundas = False
 end if
 Set objUpload = Nothing
end function

Function TestaASPUpload()
 On Error Resume Next
 Set objUpload = Server.CreateObject("Persits.Upload.1")
 if Err.number = 0 then
  TestaASPUpload = True
 else
  TestaASPUpload = False
 end if
 Set objUpload = Nothing
end function

Function TestaByteToByte()
 On Error Resume Next
 Dim FSO, Arq_Local, noBytes, binData
 
 Set FSO = Server.CreateObject("Scripting.FileSystemObject")
 noBytes = Request.TotalBytes
 binData = Request.BinaryRead(noBytes)
 Set Arq_Local = FSO.OpenTextFile(FindPhysicalPath("\virtualboss") & "\_database\teste_1.txt", 2, true)
 Arq_Local.Write binData
 'response.write Err.description
 'response.end 
 if Err.number = 0 then
   
  TestaByteToByte = True
 else
  TestaByteToByte = False
 end if
 
 Set Arq_Local = Nothing
 Set FSO = Nothing
end function
%>