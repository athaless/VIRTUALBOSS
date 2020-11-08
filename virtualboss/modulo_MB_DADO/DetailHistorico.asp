<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%

 Const WMD_WIDTHTTITLES = 150

Dim strSQL, objRS, ObjConn
Dim strCODIGO, strTITULO, strID, strCDD, strCDU
Dim strPRODUTOR,strANO,strMIDIA,strFORMATO,strTAMANHO
Dim strPRAZOEMPR,strLOCADO,strLOCALIZACAO,strAQUISICAO,strCATEGORIA
Dim strPROPRIEDADE,strEXTRA,strIMG,strOBS
Dim strSITUACAO

strCODIGO   = GetParam("var_chavereg")

if strCODIGO <> "" then
	AbreDBConn objConn, CFG_DB 
	
	strSQL =          "SELECT T1.COD_DADO, T1.ID, T1.CDD, T1.CDU, T1.TITULO, T1.PRODUTOR, T1.ANO, T1.MIDIA "
	strSQL = strSQL & "     , T1.FORMATO, T1.TAMANHO, T1.PRAZO_EMPR, T1.LOCADO, T1.LOCALIZACAO, T1.AQUISICAO, T1.COD_CATEGORIA, T1.PROPRIEDADE "
	strSQL = strSQL & "     , T1.EXTRA, T1.IMG, T1.OBS, T1.DT_INATIVO  " 
	strSQL = strSQL & "  FROM MB_DADO T1 "
	strSQL = strSQL & " WHERE T1.COD_DADO = " & strCODIGO 
	strSQL = strSQL & " ORDER BY COD_DADO "	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.eof then 
		strTITULO      = GetValue(objRS,"TITULO")
		strID          = GetValue(objRS,"ID")
		strCDD         = GetValue(objRS,"CDD")
		strCDU         = GetValue(objRS,"CDU")
		strPRODUTOR    = GetValue(objRS,"PRODUTOR")
		strANO         = GetValue(objRS,"ANO")
		strMIDIA       = GetValue(objRS,"MIDIA")
		strFORMATO     = GetValue(objRS,"FORMATO")
		strTAMANHO     = GetValue(objRS,"TAMANHO")
		strPRAZOEMPR   = GetValue(objRS,"PRAZO_EMPR")
		strLOCADO      = GetValue(objRS,"LOCADO")
		strLOCALIZACAO = GetValue(objRS,"LOCALIZACAO")
		strAQUISICAO   = GetValue(objRS,"AQUISICAO")
		strCATEGORIA   = GetValue(objRS,"COD_CATEGORIA")
		strPROPRIEDADE = GetValue(objRS,"PROPRIEDADE")
		strEXTRA 	   = GetValue(objRS,"EXTRA")
		strIMG   	   = GetValue(objRS,"IMG")
		strOBS         = GetValue(objRS,"OBS")
		strSITUACAO    = GetValue(objRS,"DT_INATIVO")
	
		FechaRecordSet objRS
%>

<html>
<head>
	<title>vboss</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="../_css/virtualboss.css">
	<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
	<link rel="stylesheet" type="text/css" href="../_css/menupure.css">
	<script type="text/javascript" src="../_scripts/tablesort.js"></script>
	<!-- estilo abaixo precisa ficar nesse arquivo porque é específico da página -->
	<!-- será usado para abrir e fechar uma área, se tiver mais de uma, cada uma terá de ter um nome -->

	<script type="text/javascript">
		//****** Funções de ação dos botões - Início ******
		function ok()			{ document.form_insert.DEFAULT_LOCATION.value = ""; submeterForm(); }
		function cancelar()		{ parent.frames["vbTopFrame"].document.form_principal.submit(); }
		function aplicar()      { document.form_insert.JSCRIPT_ACTION.value = ""; submeterForm(); }
		
		function submeterForm() {
			var var_msg = '';
			if (document.form_insert.DBVAR_STR_TITULOô.value   == '')  var_msg += '\n Título';
		
			if (var_msg == ''){ document.form_insert.submit(); } 
			else{ alert('Favor verificar campos obrigatórios:\n' + var_msg); }
		}
		//****** Funções de ação dos botões - Fim ******
	</script>
</head>
<body>
<%
	'Concatenamos o link corretamente para os casos
	'onde o redirect tenha sido informado ou não
	athBeginCssMenu()
		athCssMenuAddItem "#", "onClick=""displayArea('table_header');""", "_self", "DADO <strong>" & strCODIGO & "</strong> - " & strTITULO, "", 0
	athEndCssMenu("")
%>
<!-- C6DBD6 -->
<div id="table_header" style="width:100%">
	<table border="0" cellpadding="0" cellspacing="1" class="tableheader">
		<tbody>
			<tr>
				<td>ID:&nbsp;</td>
				<td>
					<span style='height:16px; position:relative;float:right;overflow:visible;text-align:right;padding-right:10px;'><img src='../upload/<%=Request.Cookies("VBOSS")("CLINAME")%>/MB_DADO/<%=strIMG%>' width='160' /></span>
					<%=strID%>
				</td>
			</tr>
			<tr>
				<td>CDD:&nbsp;</td>
				<td><%=strCDD%></td>
			</tr>
			<tr>
				<td>CDU:&nbsp;</td>
				<td><%=strCDU%></td>
			</tr>
			<tr>
				<td>Produtor:&nbsp;</td>
				<td><%=strPRODUTOR%></td>
			</tr>
			<tr>
				<td>Ano:&nbsp;</td>
				<td><%=strANO%></td>
			</tr>
			<tr>
				<td>Mídia:&nbsp;</td>
				<td><%=strMIDIA%></td>
			</tr>
			<tr>
				<td>Formato:&nbsp;</td>
				<td><%=strFORMATO%></td>
			</tr>
			<tr>
				<td>Tamanho:&nbsp;</td>
				<td><%=strTAMANHO%></td>
			</tr>
			<tr>
				<td>Prazo Empr.:&nbsp;</td>
				<td><%=strPRAZOEMPR%></td>
			</tr>
			<tr>
				<td>Locado:&nbsp;</td>
				<td><%=strLOCADO%></td>
			</tr>
			<tr>
				<td>Localização:&nbsp;</td>
				<td><%=strLOCALIZACAO%></td>
			</tr>
			<tr>
				<td>Aquisição:&nbsp;</td>
				<td><%=strAQUISICAO%></td>
			</tr>
			<tr>
				<td>Categoria:&nbsp;</td>
				<td><%=strCATEGORIA%></td>
			</tr>
			<tr>
				<td>Propriedade:&nbsp;</td>
				<td><%=strPROPRIEDADE%></td>
			</tr>
			<tr>
				<td>Extra:&nbsp;</td>
				<td><%=strExtra%></td>
			</tr>
			<tr>
				<td>OBS:&nbsp;</td>
				<td><%=strOBS%></td>
			</tr>
			<tr id="tableheader_last_row">
				<td>Situação:&nbsp;</td>
				<td style="background-color:#E7EFF1;border:#E7EFF1;"><%=strSITUACAO%></td>
			</tr>
		</tbody>
	</table>
</div>
<br>

<% 
	end if 
	strSQL = "SELECT COD_DADO_ITEM, COD_DADO, TITULO, TAMANHO, EXTRA FROM mb_dado_item " 
	strSQL = strSQL & " WHERE COD_DADO = " & strCODIGO & " ORDER BY TITULO " 
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1


	'Montagem do MENU DETAIL
	athBeginCssMenu()
		athCssMenuAddItem "", "", "_self", "ITENS", "", 1
		athBeginCssSubMenu()
			athCssMenuAddItem "InsertDetail.asp?var_chavereg="& strCODIGO, "", "_self", "Inserir Item", "div_modal", 0
		athEndCssSubMenu()
	athEndCssMenu("div_modal")
	
	
	if not objRS.eof then 
%>
	
<table style="width:100%;" border="0" align="center" cellpadding="0" cellspacing="1" class="tablesort">
	<thead>
		<tr>
			<th width="01%"></th>
			<th width="01%"></th>
			<th class="sortable-numeric" width="02%">Cod</th>
			<th class="sortable"         width="47%">Título</th>
			<th class="sortable" 	 	 width="10%">Tamanho</th>
			<th class="sortable" 		 width="40%">Extra</th>
		</tr>
	</thead>
	<tbody style="text-align:left">
		<% do while not objRS.Eof %>
		<tr>
			<td style="vertical-align:middle;"><%=MontaLinkGrade("modulo_MB_DADO","DeleteDetail.asp",GetValue(objRS,"COD_DADO_ITEM"),"IconAction_DEL.gif","REMOVER")%></td>
			<td style="vertical-align:middle;"><%=MontaLinkGrade("modulo_MB_DADO","UpdateDetail.asp",GetValue(objRS,"COD_DADO_ITEM"),"IconAction_EDIT.gif","ALTERAR")%></td>
			<td style="text-align:center;vertical-align:middle;"><%=GetValue(objRS,"COD_DADO_ITEM")%></td>
			<td style="text-align:left;  vertical-align:middle;"><%=GetValue(objRS,"TITULO")%></td>
			<td style="text-align:center;vertical-align:middle;"><%=GetValue(objRS,"TAMANHO")%></td>
			<td style="text-align:justify;vertical-align:middle;"><%=GetValue(objRS,"EXTRA")%></td>
		</tr>
		<% 
			objRS.MoveNext 
			loop 
		%>
	</tbody>
</table>
<br/>
<%	end if %>
</body>
</html>
<%
	FechaRecordSet objRS
	FechaDBConn objConn
	end if
%>