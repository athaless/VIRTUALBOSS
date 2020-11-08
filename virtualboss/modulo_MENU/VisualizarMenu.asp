<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_class/treeview/clsTreeView.asp"-->
<%
'declare your treeview object
Dim objTree, objConn, strSQL, objRS, Cont

abreDBConn objConn, CFG_DB

'create an instance of your treeview
Set objTree = New TreeView

objTree.DefaultTarget = "_self"
objTree.ImagesFolder= "../_class/treeview/images"

Public Function RecursiveSubMenus(pr_codmenu, byref pr_objChild)
   Dim objRSLocal,LocalauxCont,LocalstrSQL,objChild
   Set objChild = pr_objChild
   
   LocalstrSQL ="SELECT COD_MENU, ROTULO, LINK FROM SYS_MENU WHERE COD_MENU_PAI = " & pr_codmenu & " and DT_INATIVO is NULL ORDER by ORDEM"
   Set objRSLocal = objConn.Execute(LocalstrSQL)
   LocalauxCont = 0
   While not objRSLocal.EOF
	  objChild.ChildNodes.Add(objTree.CreateNode("<span style='color:#3C6BC0;'><b>"&objRSLocal("ROTULO")&"</b></span>","#",""))
	  RecursiveSubMenus GetValue(objRSLocal,"COD_MENU"),objChild.ChildNodes(LocalauxCont)
	  objRSLocal.MoveNext
      LocalauxCont = LocalauxCont + 1
   Wend
	
 Set objChild = Nothing
 FechaRecordSet(objRSLocal) 
End function 
  

strSQL ="SELECT COD_MENU, ROTULO, LINK FROM SYS_MENU WHERE COD_MENU_PAI <= 0 AND DT_INATIVO IS NULL ORDER BY ORDEM"
Set objRS = objConn.Execute(strSQL)
Cont = 0
While not ObjRS.EOF
	objTree.AddNode("<span style='tcolor:#3C6BC0;'><b>" & objRS("ROTULO") & "</b></span>")
	RecursiveSubMenus GetValue(ObjRS,"COD_MENU"),objTree.Nodes(Cont)				
	ObjRS.MoveNext
	Cont = Cont + 1
Wend
FechaRecordSet objRS
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="35" marginwidth="0" marginheight="0" bgcolor="#EDF2F6">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr><td colspan="2" valign="middle"><%objTree.Display%></td></tr>
  <tr><td colspan="2" height="6"></td></tr>
</table> 
</body>
</html>
<%
Set objTree = Nothing
FechaDBConn objConn
%>