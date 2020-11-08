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
		
		strSQL =          " SELECT  COD_QUESTAO, QUESTAO, TITULO  "
		strSql = strSql & " FROM EN_QUESTAO  "
		strSql = strSql & " INNER JOIN EN_ENQUETE ON EN_QUESTAO.COD_ENQUETE = EN_ENQUETE.COD_ENQUETE  "		
		strSQL = strSQL & " WHERE COD_QUESTAO = " & strCODIGO 
		'RESPONSE.Write(STRsql)
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
		athCssMenuAddItem "#", "onClick=""displayArea('table_header1');""", "_self", "Questão <strong>" & GetValue(objRS,"QUESTAO") & "</strong>", "", 1
	athEndCssMenu("")
%>
<!-- C6DBD6 -->
<div id="table_header1" style="width:100%">
	<table border="0" cellpadding="1" cellspacing="0" class="tableheader">
		<thead></thead>
        <tbody style="text-align:left;">			
				<tr><td>Enquete:&nbsp;</td> <td><%=GetValue(objRS,"TITULO")%></td><tr>	
                <tr><td>Questão:&nbsp;</td> <td><%=GetValue(objRS,"QUESTAO")%></td><tr>	                				
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
			athCssMenuAddItem "#", "onClick=""displayArea('table_header2');""", "_self", "ALTERNATIVAS", "", 1
			If VerificaDireito("|INS|", BuscaDireitosFromDB("modulo_ENQUETE", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
				athBeginCssSubMenu()
					athCssMenuAddItem "InsertAlternativa.asp?var_chavereg="& strCODIGO,"", "_self", "Inserir Alternativa", "div_modal", 0
				athEndCssSubMenu()
			End If
		athEndCssMenu("div_modal")
%>
<div id="table_header2" style="width:100%">
<%
		strSQL =          " SELECT COD_ALTERNATIVA, ALTERNATIVA, TIPO, NUM_VOTOS "
		strSQL = strSQL & " FROM EN_ALTERNATIVA "
		strSQL = strSQL & " WHERE COD_QUESTAO = " & strCODIGO
		strSQL = strSQL & " ORDER BY COD_ALTERNATIVA "
		
		Set objRSAux = objConn.Execute(strSQL)
		
		If Not objRSAux.Eof Then
%>
	<table border="0" style="width:100%;" align="center" cellpadding="0" cellspacing="1" class="tablesort">
		<thead>
			<tr>
				<th style="width:1%;"  class="sortable-numeric" nowrap></th>                
                <th style="width:1%;"  class="sortable-numeric" nowrap>Cod</th>
				<th style="width:10%;" class="sortable" nowrap>Alternativa</th>
				<th style="width:88%;" class="sortable">Tipo</th>	
	

			</tr>
		</thead>
		<tbody style="text-align:left;">
       <%
	   		do while not objRSAux.Eof
		%>
            <tr>
				
                <td style="text-align:left;" nowrap>
				<% If getValue(objRSAux,"NUM_VOTOS") = 0 Then %>
                	<a style="cursor:hand;" onClick="window.open('Delete_Alternativa.asp?var_chavereg=<%=GetValue(objRSAux,"COD_ALTERNATIVA")%>','','popup,width=10,height=10');">
					<img src='../img/IconAction_DEL.gif' border='0'>
					</a>                
                 <%End If%>
                </td>
				<td style="text-align:left" valign='top'><%=GetValue(objRSAux, "COD_ALTERNATIVA")%></td>
				<td style="text-align:left" valign='top' nowrap><%=GetValue(objRSAux, "ALTERNATIVA")%></td>
				<td style="text-align:left" valign='top' nowrap><%=GetValue(objRSAux, "TIPO")%></td>              
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