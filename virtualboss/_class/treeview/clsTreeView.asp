<%
' ======================================================================================
' Desc:		This code show how to create a simple treeview class using ASP and Cascading Stylesheets.
'			Greate for programmers who want to learn how to create simple ASP controls.
'
' Author:	Tanwani Anyangwe (tanwani@aspwebsolution.com)
' Modified by: Alan and Aless (20/10/2006 - 15:38)
'
' Requires: ASP 2.1 +
'
' Copyright © 2001 Tanwani Anyangwe for AspWebSolution.com
' --------------------------------------------------------------------------------------
' Visit AspWebSolution - free source code for ASP & AS.NET programmers
' http://aspwebsolution.com
' --------------------------------------------------------------------------------------
'
' Please ensure you visit the site and read their free source licensing
' information and requirements before using their code in your own
' application.
'
' ======================================================================================



Class Collection
	Private m_next,m_len
	Private m_dic	
	
	Public Sub Add(Item)
		m_dic.Add "K" & m_next,Item
		m_next = m_next+1		
		m_len = m_len+1		
	End Sub
	
	Public Sub Clear
		m_dic.RemoveAll 
	End Sub
	
	Public Function Length
		Length=m_len
	End Function
	
	Public Default Function Item(Index)
		Dim tempItem,i
		For Each tempItem In m_dic.Items 
			If i=Index Then
				Set Item=tempItem
				Exit Function
			End If
			i=i+1
		Next	
	End Function
	
	Public Sub Remove(ByVal Index)
		Dim Item,i
		For Each Item In m_dic.Items 
			If i=Index Then
				m_dic.Remove(Item)
				m_len=m_len-1
				Exit Sub
			End If
			i=i+1
		Next			
	End Sub
	
	Private Sub Class_Initialize
		m_len=0
		Set m_dic = Server.CreateObject("Scripting.Dictionary")				
	End Sub
	
	Private Sub Class_Terminate
		Set m_dic = Nothing				
	End Sub
End Class

Class Node	
	'Public Parent
	Public Text
	Public Href
	Public Target
	Public ToolTipText
	Public ChildNodes
	Public ImageUrl
	Public ID
	
	Public Sub Init(strText,strHref,strToolTipText)
		Text=strText
		Href=strHref
		ToolTipText=strToolTipText
	End Sub
	Public Sub Add(objNode)
		ChildNodes.Add(objNode)
	End Sub
	
	Private Sub Class_Initialize
		Set ChildNodes = New Collection				
	End Sub
	
	Private Sub Class_Terminate
		Set ChildNodes = Nothing				
	End Sub
End Class

Class TreeView
	
	Private m_folder
	Public Color	
	Public Nodes
	Public DefaultTarget
	Public ID
	
	Public Property Let ImagesFolder(strFolder)
		m_folder=strFolder
	End Property
	Public Property Get ImagesFolder()
		ImagesFolder=m_folder	
	End Property
	
	Private Sub Class_Initialize
		Set Nodes = New Collection	
		Color="Navy"
		m_folder="images"					
	End Sub
	
	Private Sub Class_Terminate
		Set Nodes = Nothing				
	End Sub
	
	Public Function AddNode(Text)
		Dim tn 
		Set tn = new Node
		tn.Text=Text
		Nodes.Add(tn)
	End Function
	
	Public Function CreateNode(Text,Href,ToolTipText)
		Dim tn 
		Set tn = new Node
		Call tn.Init(Text,Href,ToolTipText)
		Set CreateNode=tn
	End Function
	Public Function CreateSimpleNode(Text)
		Dim tn 
		Set tn = new Node
		tn.Text = Text
		Set CreateSimpleNode=tn
	End Function

	
	Private Sub LoopThru(NodeList,Parent)	
		Dim i,j,Node,blnHasChild,strStyle
		
		If Parent<>"0" Then
			Out ("<ul class=tree id=""N" & Parent & """>")
		Else
			Out ("<ul xstyle='margin-left:20px;' id=""N" & Parent & """>")
		End If
		For i=0 To NodeList.Length-1
			Set Node = NodeList(i)		
			If (Node.ChildNodes.Length>0) Then 
				blnHasChild=True	
			Else
				blnHasChild=False
			End If
			If Node.ImageUrl="" Then
				strStyle=""
			Else
				strStyle="style='list-style-image: url("& Node.ImageUrl &");'"
			End If				
			If blnHasChild Then
			    If Node.Href="" Then 'Este caso é apenas para leitura do ROOT da tree view... by Alan e Aless
				    Out("<li "& strStyle &" class=folder id=""P" & Parent & i & """><a class=treeview href=""javascript:toggle"& id &"('N" & Parent & "_" & i & "','P" & Parent & i & "')"">" & Node.Text & "</a>")
				else
				    Out("<li "& strStyle &" class=folder id=""P" & Parent & i & """><a href=""" & Node.Href & """ target="""& DefaultTarget & """ class=treeview onClick=""javascript:toggle"& id &"('N" & Parent & "_" & i & "','P" & Parent & i & "')"">" & Node.Text & "</a>")
			    End If
			Else
				If Node.Target="" Then
					Node.Target=DefaultTarget
				End If
				Out("<li "& strStyle &" class=file><a class=treeview href=""" & Node.Href & """ target=""" & Node.Target & """  title=""" & Node.ToolTipText & """>" & Node.Text & "</a>")
			End If
			
			If blnHasChild Then		
				Call LoopThru(Node.ChildNodes,Parent & "_" & i)
			End If	
					
			Out ("</li>")
		Next
		Out ("</ul>")
	End Sub

	Private Sub Out(s)
		Response.Write(s)
	End Sub
	
	Public Sub Display
		Out("<script>function toggle"& id &"(id,p){var myChild = document.getElementById(id);if(myChild.style.display!='block'){myChild.style.display='block';document.getElementById(p).className='folderOpen';}else{myChild.style.display='none';document.getElementById(p).className='folder';}}</script>")
		Out("<style>ul.tree{display:none;margin-left:17px;}li.folder{list-style-image: url("& ImagesFolder &"/plus.gif);}li.folderOpen{list-style-image: url("& ImagesFolder &"/minus.gif);}li.file{list-style-image: url("& ImagesFolder &"/dot.gif);}a.treeview{color:"& Color &";font-family:verdana;font-size:8pt;}a.treeview:link {text-decoration:none;}a.treeview:visited{text-decoration:none;}a.treeview:hover {text-decoration:underline;}</style>")
		Call LoopThru(Nodes,0)		
	End Sub
	
	Public Sub LoadFromDB(strConn,strMenuTable)
		Dim Conn 
		Set Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open strConn
		
		Dim RS,node,parentid,parentNode
		Set RS = Conn.Execute("SELECT * FROM " & strMenuTable & " ORDER BY MenuID,ParentID")
		
		If Not RS.EOF Then
			Do While Not RS.EOF
				parentid=RS("ParentID")
				
				Dim child				 
				Set child = new Node
				Call child.Init(RS("Text"),RS("URL"),RS("ToolTip"))
				child.ID =RS("MenuID")
				
				If parentid=0 then
					Nodes.Add(child)
				Else
					Set parentNode = FindNode(Nodes,ParentID)
					If Not (parentNode is Nothing) Then
						parentNode.Add(child)
					End If
				End If
				RS.MoveNext		
			Loop
			RS.Close
		End If
		Set RS = Nothing
		Conn.Close 
		Set Conn = Nothing		
	End Sub
	
	Private Function FindNode (nodes,ID)
		dim i,tempNode		
		For i=0 To nodes.Length-1
			Set tempNode = nodes(i)
			if tempNode.Id=ID then
				Set FindNode=tempNode
				Exit Function
			Else
				If tempNode.ChildNodes.length>0 Then
					Set tempNode = FindNode(tempNode.ChildNodes,ID)
					If Not (tempNode is Nothing) Then
						Set FindNode=tempNode
						Exit Function
					End If
				end if
			End If				
		Next
		Set FindNode = Nothing			
	End Function
	
	Public Sub DisplayFolderContents(ByVal strFolderPath)
		Out("<script>function toggle"& id &"(id,p){var myChild = document.getElementById(id);if(myChild.style.display!='block'){myChild.style.display='block';document.getElementById(p).className='folderOpen';}else{myChild.style.display='none';document.getElementById(p).className='folder';}}</script>")
		Out("<style>ul.tree{display:none;margin-left:17px;}li.folder{list-style-image: url("& ImagesFolder &"/plus.gif);}li.folderOpen{list-style-image: url("& ImagesFolder &"/minus.gif);}li.file{list-style-image: url("& ImagesFolder &"/dot.gif);}a.treeview{color:"& Color &";font-family:verdana;font-size:8pt;}a.treeview:link {text-decoration:none;}a.treeview:visited{text-decoration:none;}a.treeview:hover {text-decoration:underline;}</style>")

		Dim fso 
		Set fso = Server.CreateObject("Scripting.FileSystemObject")
		If fso.FolderExists(strFolderPath) Then			
			Call ListFolderContents(fso.GetFolder(strFolderPath),0)			
		Else
			Out "<font color=red>Folder <b>'" & strFolder & "'</b> does not exist</font>"
		End If
		Set fso = Nothing
	End Sub
	
	Private Sub ListFolderContents(objFolder,Parent)
		Dim objSubFolder, objFile	
		If Parent<>"0" Then
			Out ("<ul class=tree id=""N" & Parent & """>")
		Else
			Out ("<ul xstyle='margin-left:20px;' id=""N" & Parent & """>")
		End If	
		
		dim i
		For Each objSubFolder In objFolder.SubFolders
			Out("<li class=folder id=""P" & Parent & i & """><a class=treeview href=""javascript:toggle"& id &"('N" & Parent & "_" & i & "','P" & Parent & i & "')"">")
			Out objSubFolder.Name & "</a>"			
			Call ListFolderContents(objSubFolder,Parent & "_" & i)
			Out "</li>"
			i=i+1
		Next
		
		For Each objFile In objFolder.Files
			Out "<li class=file>" & objFile.Name & "</li>"
		Next
		
		Out "</ul>"
		
		Set objFile = Nothing
		Set objSubFolder = Nothing
	End Sub
End Class




%>

<!--

	
	Public Sub LoadFromDB(strConn,strMenuTable)
		Dim Conn 
		Set Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open strConn
		
		
		Call AddNodesFromDB(Conn,strMenuTable,0,-1)
		
		Conn.Close 
		Set Conn = Nothing		
	End Sub
	
	Private Sub AddNodesFromDB(objConn,strTable,intParentId,intDepth)
		Dim RS,node
		Set RS = objConn.Execute("SELECT * FROM " & strTable & " WHERE ParentID=" & intParentId)
		intDepth=intDepth+1
		If Not RS.EOF Then
			Do While Not RS.EOF
				node
				'Call AddNodesFromDB(objConn,strTable,RS("MenuID"),intDepth)
				RS.MoveNext
			Loop
			RS.Close
		End If
		Set RS = Nothing
	End Sub
	-->
