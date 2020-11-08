<%
Const ForReading   = 1
Const ForAppending = 8

Sub AbreArquivo (byref pr_objFSO, byref pr_objOpenFile, pr_type)
  Set pr_objFSO      = Server.CreateObject("Scripting.FileSystemObject")
  Set pr_objOpenFile = objFSO.OpenTextFile(Server.MapPath("_database/faq.txt"),pr_type)
End Sub


Sub FechaArquivo(byref pr_objFSO,  pr_objOpenFile)
  Set pr_objFSO = Nothing
  Set pr_objOpenFile = Nothing
End Sub

'=================================================================================
Sub AbreFSConn(byref pr_ObjFSConn, byref pr_SiteDir)
  Set pr_ObjFSConn = CreateObject("Scripting.FileSystemObject") 

  pr_SiteDir = server.mappath("/")

  if instr(pr_SiteDir,"wwwroot")>0 then
    pr_SiteDir = pr_SiteDir & CFG_DIR_SITE & "\"
  else
    pr_SiteDir = pr_SiteDir & CFG_DIR_SITE & "\html\"
  end if
End Sub

'===========================================================================
Sub RemoveArquivo(pr_ObjFSConn, prStrFile)
 If pr_ObjFSConn.FileExists(prStrFile) Then 
    pr_ObjFSConn.DeleteFile prStrFile
 end if
End Sub
'===========================================================================
Sub FechaFSConn(byref pr_ObjFS)
 'pr_ObjFS.Close()
 Set pr_ObjFS = Nothing
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
