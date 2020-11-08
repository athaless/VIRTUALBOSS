<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/Scripts.js"--> 
<!--#include file="../_class/treeview/clsTreeView.asp"-->
<%
	Dim objRS, objConn, strSQL
	Dim objRS1, objRS2 
	Dim objTree, objChild
	Dim Cont

	'--------------------------------------
	' Cria e inicializa objeto árvore
	'--------------------------------------
	Set objTree = New TreeView
	
	objTree.DefaultTarget = "" 
	objTree.ImagesFolder= "../_class/treeview/images"
	
	
	AbreDBConn objConn, CFG_DB
	
	strSQL =          " SELECT T1.TIPO, T1.DESCRICAO, T1.ORDEM, COUNT(T2.COD_USUARIO) AS TOTAL " 
	strSQL = strSQL & " FROM SYS_ENTIDADE T1, USUARIO T2 " 
	strSQL = strSQL & " WHERE T1.TIPO = T2.TIPO " 
	strSQL = strSQL & " GROUP BY T1.TIPO, T1.DESCRICAO, T1.ORDEM " 
	strSQL = strSQL & " ORDER BY T1.ORDEM, T1.DESCRICAO " 
	
	Set objRS1 = objConn.Execute(strSQL)
	
	Cont = 0 
	do wile not objRS1.Eof 
		'--------------------
		' Insere nodo-pai
		'--------------------
		objTree.AddNode("<span style='color:#3C6BC0;'><b>" & objRS1("DESCRICAO") & "</b></span>")
		Set objChild = objTree.Nodes(Cont)
		
		'--------------------
		' Busca filhos
		'--------------------
		strSQL =          " SELECT ID_USUARIO, NOME " 
		strSQL = strSQL & " FROM USUARIO " 
		strSQL = strSQL & " WHERE DT_INATIVO IS NULL " 
		strSQL = strSQL & " AND TIPO LIKE '" & objRS1("TIPO") & "' " 
		strSQL = strSQL & " ORDER BY NOME " 
		
		Set objRS2 = objConn.Execute(strSQL)
		
		do while not objRS2.Eof 
			'--------------------
			' Insere nodo-filho
			'--------------------
			objChild.ChildNodes.Add(objTree.CreateNode(objRS2("NOME") & " ( " & objRS2("ID_USUARIO") & " )", "JavaScript:novaMSG('" & objRS2("ID_USUARIO") & "');", ""))
			objRS2.MoveNext 
		loop 
		
		FechaRecordSet(objRS2) 
		Set objChild = Nothing 
		Cont = Cont + 1
		
		objRS1.MoveNext 
	loop 
	
	FechaRecordSet(objRS1) 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
function novaMSG(pr_user) {
	AbreJanelaPAGE_NOVA('msgNovaMensagem.asp?var_destino=' + pr_user, '560', '430');
}

function Atualizar()	{
	parent.msg_top_left.document.location.reload();
	parent.msg_top_right.document.location.reload();
	parent.msg_bottom_right.location.href="msgAbreMensagem.asp";
}
</script>
</head>
<body>
<table border="0" width="100%" cellpadding="0" cellspacing="2">
	<tr valign="top"> 
		<td width="100%"><div style="padding-left:3px;padding-right:3px;"><%objTree.Display%></div></td>
	</tr>
</table>
</body>
</html>
<%
	Set objTree = Nothing
	FechaDBConn objConn
%>