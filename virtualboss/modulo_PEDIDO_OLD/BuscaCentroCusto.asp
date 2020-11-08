<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_class/treeview/clsTreeView.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
Dim strSQL, objRS, ObjConn
Dim strCOD_DADO, strTITULO, strROTULO
Dim strLOCATION_Default
Dim strFORM
Dim strRETORNO1, strRETORNO2, strRETORNO3
Dim strPALAVRA_CHAVE, strCODIGOS_Raiz, strCODIGOS_Caminho
Dim objTree	

strFORM = GetParam("var_form")
strRETORNO1 = GetParam("var_retorno1")
strRETORNO2 = GetParam("var_retorno2")
strPALAVRA_CHAVE = GetParam("var_palavra_chave")
if strPALAVRA_CHAVE = "" then strPALAVRA_CHAVE = "%"

strROTULO = "Centros de Custos"

AbreDBConn objConn, CFG_DB 

 '-------------------------------------------------------------------
 ' Função recursiva que carrega numa TreeView os centros de custos
 '-------------------------------------------------------------------	
 Public Function CarregarDados(pr_codigo_menu, pr_codigos_raiz, pr_codigos_caminho, pr_palavra_chave, byref pr_objChild)
 Dim objRSLocal,strSQLLocal,Cont,objChild
 Dim strTexto1, strTexto2
 
   strSQLLocal = " SELECT COD_CENTRO_CUSTO AS CODIGO, NOME, COD_REDUZIDO, DT_INATIVO FROM FIN_CENTRO_CUSTO " 
   if pr_codigo_menu <> "" then
   	  strSQLLocal = strSQLLocal & " WHERE COD_CENTRO_CUSTO_PAI = " & pr_codigo_menu
   else
      if pr_codigos_raiz <> "" then
     	strSQLLocal = strSQLLocal & " WHERE COD_CENTRO_CUSTO IN (" & pr_codigos_raiz & ") "
      else
     	strSQLLocal = strSQLLocal & " WHERE COD_CENTRO_CUSTO_PAI IS NULL " 
      end if
   end if
   if pr_codigos_caminho <> "" then strSQLLocal = strSQLLocal & " AND COD_CENTRO_CUSTO IN (" & pr_codigos_caminho & ") "
   strSQLLocal = strSQLLocal & " ORDER BY ORDEM, COD_REDUZIDO " 
   
   Set objRSLocal = objConn.Execute(strSQLLocal)

   Cont = 0
   Set objChild = pr_objChild
   While not objRSLocal.EOF
	  strTexto1 = GetValue(objRSLocal,"NOME")
   	  strTexto2 = "<span>" & GetValue(objRSLocal,"COD_REDUZIDO") & "</span>&nbsp;&nbsp;"
	  If (InStr(strTexto1, pr_palavra_chave) > 0) And (pr_palavra_chave <> "") Then 
	  	strTexto2 = strTexto2 & "<span class='texto_ajuda'><strong>" & strTexto1 & "</strong></span>"
	  Else
	  	strTexto2 = strTexto2 & "<span class='texto_ajuda'>" & strTexto1 & "</span>"
	  End If
	  
	  objChild.ChildNodes.Add(objTree.CreateNode(strTexto2,"Javascript:GuardaInfo('" & GetValue(objRSLocal,"CODIGO") & "', '" & strTexto1 & "')",""))
	  objChild.ChildNodes.Item(Cont).ImageURL = "../_class/treeview/images/plus.gif"
	  CarregarDados GetValue(objRSLocal,"CODIGO"),"",pr_codigos_caminho,pr_palavra_chave,objChild.ChildNodes(Cont)
	  
	  objRSLocal.MoveNext
      Cont = Cont + 1
   Wend
   
   Set objChild = Nothing
   FechaRecordSet objRSLocal
 End function  
 
 '-------------------------------------------------------------------------------------------------
 ' Função recursiva que retorna os códigos dos centros de custos que se enquadraram na pesquisa
 '-------------------------------------------------------------------------------------------------	
 Public Function PesquisarDados(pr_palavra_chave, byref pr_CODIGOS_Raiz, byref pr_CODIGOS_Caminho)
 Dim objRS1,objRS2,strSQLLocal
 Dim strCOD_ITEM, strCOD_PAI
 
   strSQLLocal =               " SELECT COD_CENTRO_CUSTO, COD_CENTRO_CUSTO_PAI, NOME, COD_REDUZIDO, DT_INATIVO " 
   strSQLLocal = strSQLLocal & " FROM FIN_CENTRO_CUSTO " 
   strSQLLocal = strSQLLocal & " WHERE NOME LIKE '" & pr_palavra_chave & "%' "
   strSQLLocal = strSQLLocal & " ORDER BY ORDEM, COD_REDUZIDO " 
   
   Set objRS1 = objConn.Execute(strSQLLocal)
   
   pr_CODIGOS_Raiz    = ","
   pr_CODIGOS_Caminho = ","
   While not objRS1.EOF
		strCOD_ITEM = GetValue(objRS1,"COD_CENTRO_CUSTO")
   		strCOD_PAI  = GetValue(objRS1,"COD_CENTRO_CUSTO_PAI")
		
		If InStr(pr_CODIGOS_Caminho, "," & strCOD_ITEM & ",") = 0 Then pr_CODIGOS_Caminho = pr_CODIGOS_Caminho & strCOD_ITEM & ","
		
   		If strCOD_PAI = "" Then

			If InStr(pr_CODIGOS_Raiz, "," & strCOD_ITEM & ",") = 0 Then pr_CODIGOS_Raiz = pr_CODIGOS_Raiz & strCOD_ITEM & ","
		Else
			While strCOD_PAI <> ""
				strSQL = " SELECT COD_CENTRO_CUSTO_PAI, COD_CENTRO_CUSTO FROM FIN_CENTRO_CUSTO WHERE COD_CENTRO_CUSTO = " & strCOD_PAI
				Set objRS2 = objConn.Execute(strSQL)
				If Not objRS2.Eof Then
					strCOD_ITEM = GetValue(objRS2,"COD_CENTRO_CUSTO")
					strCOD_PAI  = GetValue(objRS2,"COD_CENTRO_CUSTO_PAI")
					
					If InStr(pr_CODIGOS_Caminho, "," & strCOD_ITEM & ",") = 0 Then pr_CODIGOS_Caminho = pr_CODIGOS_Caminho & strCOD_ITEM & ","
					
			   		If strCOD_PAI = "" Then
						If InStr(pr_CODIGOS_Raiz, "," & strCOD_ITEM & ",") = 0 Then pr_CODIGOS_Raiz = pr_CODIGOS_Raiz & strCOD_ITEM & ","
					End If
				Else
					strCOD_PAI = ""
				End If
				FechaRecordSet objRS2
			WEnd
		End If
		
		objRS1.MoveNext
   WEnd
   FechaRecordSet objRS1
   
   If pr_CODIGOS_Raiz <> "," And pr_CODIGOS_Caminho <> "," Then 
	   'Tira as duas vírgulas
	   pr_CODIGOS_Raiz    = Mid(pr_CODIGOS_Raiz   , 2, Len(pr_CODIGOS_Raiz)-2)
	   pr_CODIGOS_Caminho = Mid(pr_CODIGOS_Caminho, 2, Len(pr_CODIGOS_Caminho)-2)
   Else
	   pr_CODIGOS_Raiz    = ""
	   pr_CODIGOS_Caminho = ""
   End If
   
   'Response.Write("Raiz [" & pr_CODIGOS_Raiz & "]")
   'Response.Write("Caminho [" & pr_CODIGOS_Caminho & "]")
 End function  
 
 Set objTree = New TreeView

 objTree.DefaultTarget = "_self"
 objTree.ImagesFolder= "../_classTreeView/images_content"

 If strPALAVRA_CHAVE = "%" Then
	objTree.AddNode("<div class='texto_ajuda'>" & ReturnCodigo("Centro de Custo") & "</div>")
	objTree.Nodes(0).imageURL = "../_class/treeview/images/plus.gif"
	
	CarregarDados "", "", "", "", objTree.Nodes(0)
 ElseIf strPALAVRA_CHAVE <> "" Then
 	PesquisarDados strPALAVRA_CHAVE, strCODIGOS_Raiz, strCODIGOS_Caminho
	If strCODIGOS_Raiz <> "" And strCODIGOS_Caminho <> "" Then
		objTree.AddNode("<div class='texto_ajuda'>" & ReturnCodigo("Centro de Custo") & "</div>")
		objTree.Nodes(0).imageURL = "../img/BulletMais.gif"
		
		CarregarDados "", strCODIGOS_Raiz, strCODIGOS_Caminho, strPALAVRA_CHAVE, objTree.Nodes(0)
	End If
 End If
%>
<html>
<head>
<title>vboss</title>
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
<!--
function GuardaInfo(pr_codigo, pr_nome) { 
	document.formretorno.var_codigo.value = pr_codigo; 
	document.formretorno.var_hierarquia.value = '.../' + pr_nome; 
}

function Ok() {
	var var_form     = '<%=strFORM%>';
	var var_retorno1 = '<%=strRETORNO1%>';
	var var_retorno2 = '<%=strRETORNO2%>';
	var var_retorno3 = '<%=strRETORNO3%>';	
	
	if ((document.formretorno.var_codigo.value != '') && (document.formretorno.var_hierarquia.value != '')) {
		if (var_form != '') {		
			if (var_retorno1 != '') eval("self.opener." + var_form + "." + var_retorno1 + ".value = "	+ document.formretorno.var_codigo.value		 + ";");
			if (var_retorno2 != '') eval("self.opener." + var_form + "." + var_retorno2 + ".value = '"	+ document.formretorno.var_hierarquia.value + "';");
		}
		
		objOption = window.opener.document.createElement("OPTION");
		eval("window.opener.document." + var_form + "." + var_retorno1 + ".options.add(objOption)" + ";");
		
		objOption.innerText	= (document.formretorno.var_hierarquia.value).replace(".../","")
		objOption.value = document.formretorno.var_codigo.value;	
		objOption.selected = 1;
	}
	window.close();
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
<tr>
	<td height="1%" valign="top">
	<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>
			<!-- ini -->
			<table align="center" cellpadding="0" cellspacing="0" width="100%" height="58">
				<tr>
					<td width="04%" background="../img/Menu_TopBGLeft.jpg"></td>
					<td width="01%"><img src="../img/Menu_TopImgCenter.jpg"></td>
					<td width="95%" background="../img/Menu_TopBgRight.jpg">
						<div style="padding-top:20px;padding-right:3px;"> 
							<table align="right" height="30" cellpadding="0" cellspacing="0" border="0">
								<form name="FormBusca" method="post" action="BuscaCentroCusto.asp">
								<input name="var_form"     type="hidden" value="<%=strFORM%>">
								<input name="var_retorno1" type="hidden" value="<%=strRETORNO1%>">
								<input name="var_retorno2" type="hidden" value="<%=strRETORNO2%>">
								<tr>
									<td width="50" nowrap style="text-align:right">Nome</td>
									<td width="5"></td><td width="100"><input name="var_palavra_chave" type="text" size="20" class="edtext" value="<%=strPALAVRA_CHAVE%>"></td><td width="5"></td>
									<td width="5"></td>
									<td width="27"><a href="javascript:FormBusca.submit();"><img src="../img/bt_search_mini.gif" title="Atualizar consulta..." border="0"></a></td>
								</tr>
								</form>
							</table>
						</div>
					</td>
				</tr>
			</table>
			<!-- fim -->
			</td>
		</tr>
	</table>
	</td>
</tr>
<tr>
	<td height="99%" valign="top">
	<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>
			<!-- ini -->
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
			<tr> 
				<td colspan="2" height="22" align="left"> 
					<div style="padding-left:10px;"><strong>Hierarquia</strong></div>
				</td>
			</tr>
			<tr> 
				<td colspan="2" align="center" valign="top">
					<div style="padding-left:10px; padding-right:10px; padding-top:10px; padding-bottom:10px"> 
					<table width="98%" border="0" cellspacing="0" cellpadding="4">
					<tr> 
						<td width='100%' align='left' valign='top'>
							<div style="padding-left:3px; padding-right:3px;">
							 <%
							 if (objTree.Nodes.Length > 0) then
								 objTree.Display
								 %>
								 <script>
								   toggle('N0_0','P00'); //Serve para abrir o primeiro nível dos filhos de ROOT
								 </script>
							 <%
							 end if
							 %>
							</div>
						</td>
					</tr>
					</table>
					</div>
				</td>
			</tr>
			</table>
			<!-- fim -->
			</td>
		</tr>
	</table>
	</td>
</tr>
<tr>
  <td>
	<div style="padding:10px; text-align:right">
	<table width="440" height="25" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" style="border:1px solid #CCCCCC">
		<form name="formretorno" action="javascript:Ok();" method="post">
		<input name="var_nivel"      id="var_nivel" type="hidden">
		<tr>
			<td style="text-align:left">&nbsp;
				<input name="var_codigo"       id="var_codigo"     type="text" size="5"  readonly value="" class="edtext">
				<input name="var_hierarquia"   id="var_hierarquia" type="text" size="60" readonly value="" class="edtext">
			</td>
			<td style="text-align:left;">
				<a href="#" onClick="javascript:Ok();"><img src="../img/ok.gif" border="0" align="left"></a>
			</td>
		</tr>
		</form>
	</table>
	</div>
  </td>	
</tr>
</table>
</body>
</html>
<%	FechaDBConn ObjConn %>