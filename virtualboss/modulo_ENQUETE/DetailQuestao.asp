<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
	Const WMD_WIDTHTTITLES = 150
	
	Dim strSQL, objRS, objRSAux, ObjConn
	Dim strCODIGO
	Dim strTEMPO_CASA, strTEMPO_ANOS, strTEMPO_MESES, strIDADE
	Dim strARQUIVOANEXO
	
	strCODIGO   = GetParam("var_chavereg")
	
	If strCODIGO <> "" Then
		AbreDBConn objConn, CFG_DB 
		
		strSQL =          " SELECT  COD_ENQUETE, TITULO ,DT_INI, DT_FIM , TIPO_ENTIDADE"
		strSql = strSql & " FROM EN_ENQUETE  "
		
		strSQL = strSQL & " WHERE COD_ENQUETE = " & strCODIGO 
		
		Set objRS = objConn.Execute(strSQL)
		
		If Not objRS.Eof Then 
%>
<html>
<head>
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
	<script type="text/javascript">
		function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
		function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
		function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
		function submeterForm() { document.form_insert.submit(); }
	</script>
</head>
<body>
<%
	'Menu Display/Block TABLEHEADER
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header1');""", "_self", "Enquete <strong>" & GetValue(objRS,"TITULO") & "</strong>", "", 1
	athEndCssMenu("")
%>
<!-- C6DBD6 -->
<div id="table_header1" style="width:100%">
	<table border="0" cellpadding="1" cellspacing="0" class="tableheader">
		<thead></thead>
        <tbody style="text-align:left;">
			
				<tr><td>Título:&nbsp;</td> <td><%=GetValue(objRS,"TITULO")%></td><tr>
                <tr><td>Entidade:&nbsp;</td> <td><%=GetValue(objRS,"TIPO_ENTIDADE")%></td><tr>				
				<tr><td>Data Início:&nbsp;</td>	<td colspan="2"><%=PrepData(GetValue(objRS,"DT_INI"), True, False)%></td></tr>
                <tr><td>Data Fim:&nbsp;</td>	<td colspan="2"><%=PrepData(GetValue(objRS,"DT_FIM"), True, False)%></td></tr>
				<tr id="tableheader_last_row"><td colspan="2" height="10"></td></tr>		
		 </tbody>
         <tfoot></tfoot>
	</table>
</div>
<br/>
<% 
	If VerificaDireito("|UPD|", BuscaDireitosFromDB("modulo_ENQUETE", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
		'Menu CSS INSERT DETAIL
		athBeginCssMenu()
			athCssMenuAddItem "#", "onClick=""displayArea('table_header2');""", "_self", "QUESTÕES", "", 1
			If VerificaDireito("|INS|", BuscaDireitosFromDB("modulo_ENQUETE", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
				athBeginCssSubMenu()
					athCssMenuAddItem "InsertQuestao.asp?var_codigo="& strCODIGO,"", "_self", "Inserir Questao", "div_modal", 0
				athEndCssSubMenu()
			End If
		athEndCssMenu("div_modal")
%>
<div id="table_header2" style="width:100%">
<%
		strSQL =          " SELECT DISTINCT EN_QUESTAO.COD_QUESTAO, EN_QUESTAO.ORDEM, EN_QUESTAO.QUESTAO, EN_QUESTAO.COD_ENQUETE , EN_ALTERNATIVA.COD_QUESTAO AS quest"
		strSQL = strSQL & " FROM EN_QUESTAO "
		strSql = strSql & " LEFT JOIN EN_ALTERNATIVA ON EN_QUESTAO.COD_QUESTAO = EN_ALTERNATIVA.COD_QUESTAO "
		strSQL = strSQL & " WHERE EN_QUESTAO.COD_ENQUETE = " & strCODIGO
		strSQL = strSQL & " ORDER BY EN_QUESTAO.ORDEM "
		
		Set objRSAux = objConn.Execute(strSQL)
		
		If Not objRSAux.Eof Then
%>
	<table border="0" style="width:100%;" align="center" cellpadding="0" cellspacing="1" class="tablesort">
		<thead>
			<tr>
				<th style="width:1%;"  class="sortable-numeric" nowrap></th>    
                <th style="width:1%;"  class="sortable-numeric" nowrap></th>                
                <th style="width:1%;"  class="sortable-numeric" nowrap></th>
                <th style="width:1%;"  class="sortable-numeric" nowrap></th>
                <th style="width:1%;"  class="sortable-numeric" nowrap>Cod</th>                
				<th style="width:10%;" class="sortable" nowrap>Ordem</th>
				<th style="width:86%;" class="sortable">Questão</th>
			</tr>
		</thead>
		<tbody style="text-align:left;">
       <%
	   		do while not objRSAux.Eof
		%>
            <tr>
				<% if GetValue(objRSAux,"quest") = "" THEN %>
                <td style="text-align:left;" nowrap>
					<a style="cursor:hand;" onClick="window.open('Delete_Questao.asp?var_chavereg=<%=GetValue(objRSAux,"COD_QUESTAO")%>','','popup,width=10,height=10');">
					<img src='../img/IconAction_DEL.gif' border='0'>
					</a>                
                </td>                
                <% Else %>
                <td style="text-align:left;" nowrap></td>
                <% End If %>
                <td style="text-align:left;" nowrap><%=MontaLinkGrade("modulo_ENQUETE_QUESTAO","Update.asp",GetValue(objRSAux,"COD_QUESTAO"),"IconAction_EDIT.gif","EDITA")%></td>
               	<td style="text-align:left;" nowrap><%=MontaLinkGrade("modulo_ENQUETE_QUESTAO","DetailQuestao.asp",GetValue(objRSAux,"COD_QUESTAO"),"IconAction_DETAILadd.gif","INSERE ALTERNATIVAS")%></td>
                <td style="text-align:left;" nowrap><%=MontaLinkGrade("modulo_ENQUETE_QUESTAO","InsertCopiaQuestao.asp",GetValue(objRSAux,"COD_QUESTAO"),"IconAction_COPY.gif","COPIA QUESTÃO")%></td>
				<td style="text-align:left" valign='top'><%=GetValue(objRSAux, "COD_QUESTAO")%></td>
				<td style="text-align:left" valign='top' nowrap><%=GetValue(objRSAux, "ORDEM")%></td>
				<td style="text-align:left" valign='top' nowrap><%=GetValue(objRSAux, "QUESTAO")%></td>
			</tr>
			<% 
				athMoveNext objRSAux, ContFlush, CFG_FLUSH_LIMIT 
			Loop 
			%>
		</tbody>
        <tfoot></tfoot>
	</table>
<% 
		End If
		FechaRecordSet objRSAux
	End If 
%>
</div>
<br>
</body>
</html>
<%
		End If 
		FechaRecordSet objRS
		FechaDBConn objConn
	End If 
%>