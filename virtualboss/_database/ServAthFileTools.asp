<%
Sub AbreArquivo (byref pr_objFSO, byref pr_objOpenFile, prStrFile, pr_type)
  Set pr_objFSO      = Server.CreateObject("Scripting.FileSystemObject")
  Set pr_objOpenFile = objFSO.OpenTextFile(prStrFile, pr_type)
End Sub


Sub FechaArquivo(byref pr_objFSO,  pr_objOpenFile)
  Set pr_objFSO = Nothing
  Set pr_objOpenFile = Nothing
End Sub


Sub RemoveArquivo(pr_ObjFSConn, prStrFile)
 If pr_ObjFSConn.FileExists(prStrFile) Then 
    pr_ObjFSConn.DeleteFile prStrFile
 end if
End Sub

Function RemoveArquivos(DEFAULT_DB, DEFAULT_TABLE, RECORD_KEY_NAME, RECORD_KEY_VALUE, RECORD_KEY_NAME_ARQUIVO, PATH_NAME)
	Dim ObjConn, ObjRS, strSQL
	Dim ObjFSConn, ObjFS
	
	If RECORD_KEY_VALUE <> "" Then
		AbreDBConn ObjConn, DEFAULT_DB 
		
		strSQL = " SELECT " & RECORD_KEY_NAME & ", " & RECORD_KEY_NAME_ARQUIVO &_
		         " FROM " & DEFAULT_TABLE &_
				 " WHERE " & RECORD_KEY_NAME & " IN (" & RECORD_KEY_VALUE & ")"	
		
		Set ObjFSConn = CreateObject("Scripting.FileSystemObject") 
		Set ObjRS = objConn.Execute(strSQL)
		
		If NOT ObjRS.EOF Then
	        While NOT ObjRS.EOF
				RemoveArquivo ObjFSConn, PATH_NAME & ObjRS(RECORD_KEY_NAME_ARQUIVO)
				ObjRS.MoveNext
	        Wend
		End If
	    'dá erro!!!
		'ObjFSConn = Nothing
		FechaRecordSet objRS
		FechaDBConn ObjConn
	End If
End Function

%>
