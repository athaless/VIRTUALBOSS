<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
	Dim strSQL, objRS, ObjConn
	Dim objRS1, objRS2
	Dim strCODIGO, strINSTAREFAS, aux
	Dim auxSTRCOD_PROCESSO, auxSTRID_PROCESSO, auxSTRNOME, auxSTRDESCRICAO, auxSTRAUTORES, auxSTRDATA, auxSTRDT_HOMOLOGACAO, auxSTRSYS_DT_CRIACAO, auxSTRSYS_INS_ID_USUARIO, auxSTRSYS_DT_ALTERACAO, auxSTRSYS_ALT_ID_USUARIO, auxSTRCATEGORIA, auxSTRFULLCATEGORIA
	
	strCODIGO = GetParam("var_chavereg")
	strINSTAREFAS = Ucase(GetParam("var_instarefas"))
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSql =          "SELECT T1.COD_PROCESSO, T1.ID_PROCESSO, T1.NOME, T1.DESCRICAO, T1.AUTORES, T1.DATA, T1.DT_HOMOLOGACAO, T1.COD_CATEGORIA, T2.NOME AS CATEGORIA"
		strSql = strSql & "      ,T1.SYS_DT_CRIACAO, T1.SYS_INS_ID_USUARIO, T1.SYS_DT_ALTERACAO, T1.SYS_ALT_ID_USUARIO " 
		strSql = strSql & "  FROM PROCESSO T1, PROCESSO_CATEGORIA T2 "
		strSql = strSql & " WHERE T1.COD_CATEGORIA = T2.COD_CATEGORIA " 
		strSql = strSql & "   AND T1.COD_PROCESSO = " & strCODIGO 
		
		Set objRS1 = objConn.Execute(strSQL)

		If Not objRS1.Eof Then 
		  auxSTRCOD_PROCESSO       = GetValue(objRS1, "COD_PROCESSO")
		  auxSTRID_PROCESSO        = GetValue(objRS1, "ID_PROCESSO")
		  auxSTRNOME               = GetValue(objRS1, "NOME")
		  auxSTRDESCRICAO          = GetValue(objRS1, "DESCRICAO")
		  auxSTRAUTORES            = GetValue(objRS1, "AUTORES")
		  auxSTRDATA               = PrepData(GetValue(objRS1, "DATA"), True, False)
		  auxSTRDT_HOMOLOGACAO     = PrepData(GetValue(objRS1, "DT_HOMOLOGACAO"), True, False)
		  auxSTRSYS_DT_CRIACAO     = PrepData(GetValue(objRS1, "SYS_DT_CRIACAO"), True, True)
		  auxSTRSYS_INS_ID_USUARIO = GetValue(objRS1, "SYS_INS_ID_USUARIO")
		  auxSTRSYS_DT_ALTERACAO   = PrepData(GetValue(objRS1, "SYS_DT_ALTERACAO"), True, True)
		  auxSTRSYS_ALT_ID_USUARIO = GetValue(objRS1, "SYS_ALT_ID_USUARIO")
		  auxSTRCATEGORIA          = GetValue(objRS1, "CATEGORIA")
		  auxSTRFULLCATEGORIA      = GetValue(objRS1, "COD_CATEGORIA") & " - " & auxSTRCATEGORIA
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
	<script type="text/javascript">
		//****** Funções de ação dos botões - Início ******
		function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
		function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
		function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
				
		function submeterForm() {
			var var_msg = '';
			if (document.form_insert.DBVAR_NUM_NUMEROô.value       == '')  var_msg += '\n Número';
			if (document.form_insert.DBVAR_STR_DESC_OQUEô.value    == '')  var_msg += '\n O Quê';
			if (document.form_insert.DBVAR_STR_DESC_QUEMô.value    == '')  var_msg += '\n Quem';
			if (document.form_insert.DBVAR_STR_DESC_QUANDOô.value  == '')  var_msg += '\n Quando';
		
			if (var_msg == ''){ document.form_insert.submit(); } 
				else{ alert('Favor verificar campos obrigatórios:\n' + var_msg); }
			}
		//****** Funções de ação dos botões - Fim ******
		
		function UploadImage(formname,fieldname, dir_upload){
			var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
			window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
		}
	</script>
</head>
<body>
<%
	'Menu Display/Block TABLEHEADER
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "PROCESSO <strong>" & auxSTRID_PROCESSO & "</strong> - " & auxSTRNOME, "", 1
	athEndCssMenu("")
%>
<div id="table_header">
	<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tableheader">
	 <!-- Possibilidades de tipo de sort...
	  class="sortable-date-dmy"  /  "sortable-currency"  /  "sortable-numeric"  / "sortable"
	 -->
	 	<!--thead>
	   		<tr> 
		  		<th width="150"></th>
		  		<th>Dados</th>
	   		</tr>
	 	</thead-->
	 	<tbody style="text-align:left;">
		   	<tr><td align="right" valign="top">Descrição:&nbsp;</td><td><%=auxSTRDESCRICAO%></td></tr>
		   	<tr><td align="right" valign="top">Autores:&nbsp;</td><td><%=auxSTRAUTORES%></td></tr>
		   	<tr><td align="right" valign="top">Data:&nbsp;</td><td><%=auxSTRDATA%></td></tr>
		   	<tr><td align="right" valign="top">Categoria:&nbsp;</td><td><%=auxSTRCATEGORIA%></td></tr>
		   	<tr><td align="right" valign="top">Criação:&nbsp;</td><td><%=auxSTRSYS_DT_CRIACAO%> ( <%=auxSTRSYS_INS_ID_USUARIO%> )</td></tr>
		   	<tr><td align="right" valign="top">Alteração:&nbsp;</td><td><%=auxSTRSYS_DT_ALTERACAO%> ( <%=auxSTRSYS_ALT_ID_USUARIO%> )</td></tr>
		   	<tr id="tableheader_last_row"><td align="right" valign="top">Homologação:&nbsp;</td><td><%=auxSTRDT_HOMOLOGACAO%></td></tr>
	 	</tbody>
	</table>
</div>
<br />
<%
	athBeginCssMenu()
		athCssMenuAddItem "#", "", "_self", "TAREFAS DO PROCESSO", "", 1
		athBeginCssSubMenu()
			athCssMenuAddItem "InsertDetail.asp?var_chavereg=" & strCODIGO ,"", "_self", "Inserir Tarefa", "div_modal", 0
		athEndCssSubMenu()
	athEndCssMenu("div_modal")
  
  
  	strSQL =          " SELECT COD_TAREFA, NUMERO, DESC_OQUE, DESC_QUEM, DESC_QUANDO, COMPLEMENTAR, ARQ_ANEXO "
  	strSQL = strSQL & " FROM PROCESSO_TAREFA " 
  	strSQL = strSQL & " WHERE COD_PROCESSO = " & strCODIGO 
  	strSQL = strSQL & " ORDER BY NUMERO, COD_TAREFA " 
  	Set objRS2 = objConn.Execute(strSQL) 

  	If Not objRS2.Eof Then
%>
	<table align="center" cellpadding="0" cellspacing="1" style="width:100%" class="tablesort">
	 <thead>
	   <tr> 
   		  <th width="1%" nowrap></th>
		  <th width="1%" nowrap></th>
		  <th width="1%"  class="sortable-numeric" nowrap>N°</th>
		  <th width="93%" class="sortable" nowrap>O que</th>
		  <th width="1%"  class="sortable" nowrap>Quem</th>
		  <th width="1%"  class="sortable" nowrap>Quando</th>
		  <th width="1%"  class="sortable">Complementar</th>
		  <th width="1%" nowrap></th>
		</tr>
	  </thead>
 <tbody style="text-align:left;">
		<%
    	While Not objRS2.Eof
		%>
		<tr>
		  <td width="1%" nowrap><%=MontaLinkGrade("modulo_PROCESSO","DeleteDetail.asp",GetValue(objRS2, "COD_TAREFA") & "&var_instarefas=" & strINSTAREFAS,"IconAction_DEL.gif","REMOVER")%></td>
		  <td width="1%" nowrap><%=MontaLinkGrade("modulo_PROCESSO","UpdateDetail.asp",GetValue(objRS2, "COD_TAREFA"),"IconAction_EDIT.gif","ALTERAR")%></td>
		  <td width="1%" nowrap><%=GetValue(objRS2, "NUMERO")%></td>
		  <td width="93%"><%=GetValue(objRS2, "DESC_OQUE")%></td>
		  <td width="1%"><%=GetValue(objRS2, "DESC_QUEM")%></td>
		  <td width="1%"><%=GetValue(objRS2, "DESC_QUANDO")%></td>
		  <td width="1%"><%=GetValue(objRS2, "COMPLEMENTAR")%></td>
		  <td width="1%" nowrap>
		  <% If GetValue(objRS2, "ARQ_ANEXO") <> "" Then %>
			<a href="../upload/<%=Request.Cookies("VBOSS")("CLINAME")%>/<%=GetValue(objRS2, "ARQ_ANEXO")%>" target="_blank"><img src="../img/ico_clip.gif" alt="VISUALIZAR/BAIXAR ANEXO" border="0"></a>
		  <% End If %>
		  </td>
		</tr>
		<%
		  athMoveNext objRS2, ContFlush, CFG_FLUSH_LIMIT
		wend
		FechaRecordSet objRS2
		%>
	  <tbody>	 
	</table>
<%
  End If 
%>
</body>
</html>
<%
		End If 
        FechaRecordSet objRS1
		FechaDBConn objConn
	End If 
%>