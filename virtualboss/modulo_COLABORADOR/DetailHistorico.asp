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
		
		strSQL =          "SELECT T1.COD_COLABORADOR, T1.NOME, T1.CPF, T1.RG, T1.FONE_1, T1.FONE_2, T1.CELULAR, T1.EMAIL, T1.EMAIL_EXTRA "
		strSQL = strSQL & "     , T1.ENDERECO, T1.NUMERO, T1.COMPLEMENTO, T1.CEP, T1.BAIRRO, T1.CIDADE, T1.ESTADO, T1.PAIS, T1.DT_CADASTRO, T1.DT_INATIVO "
		strSQL = strSQL & "     , T1.ORGAO_EXPEDITOR, T1.MSN_MESSENGER, T1.FOTO, T1.DT_NASC, T1.FILIAL_VINCULADA, T1.DT_CONTRATACAO "
		strSQL = strSQL & "     , T1.DT_DESLIGAMENTO, T1.SETOR, T1.REMUNERACAO_MENSAL, T1.REGIME, T1.DT_ASSIN_CARTEIRA, T1.UTILIZA_VT, T1.VLR_VT_UNIT "
		strSQL = strSQL & "     , T1.QTDE_VT_DIA, T1.UTILIZA_VRVA, T1.VLR_VRVA, T1.AUXILIO_ESTUDO, T1.COD_BANCO, T1.AGENCIA, T1.CONTA, T1.FORMA_PGTO, T1.FOTO "
		strSQL = strSQL & "     , T2.NOME AS BANCO, T1.FILIACAO_PAI, T1.FILIACAO_MAE "
		strSQL = strSQL & " FROM ENT_COLABORADOR T1 "
		strSQL = strSQL & " LEFT OUTER JOIN FIN_BANCO T2 ON (T1.COD_BANCO = T2.COD_BANCO) "
		strSQL = strSQL & " WHERE T1.COD_COLABORADOR = " & strCODIGO 
		
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
		athCssMenuAddItem "#", "onClick=""displayArea('table_header1');""", "_self", "COLABORADOR <strong>" & GetValue(objRS,"NOME") & "</strong>", "", 1
	athEndCssMenu("")
%>
<!-- C6DBD6 -->
<div id="table_header1" style="width:100%">
	<table border="0" cellpadding="1" cellspacing="0" class="tableheader">
		<tbody style="text-align:left;">
			<tr>
				<td>Nome:&nbsp;</td>           
				<td><%=GetValue(objRS,"NOME")%></td>
				<% If GetValue(objRS,"FOTO") <> "" Then %>
					<td><div style='height:16px; position:relative; overflow:visible;text-align:right;padding-right:10px;'><img src='../upload/<%=Request.Cookies("VBOSS")("CLINAME")%>/<%=GetValue(objRS,"FOTO")%>' width='160' /></div></td>
				<% Else %>
					<td></td>
				<% End If %>
			</tr>
			<tr><td>RG:&nbsp;</td>			   	<td colspan="2"><%=GetValue(objRS,"RG")%></td></tr>
			<tr><td>CPF:&nbsp;</td>            	<td colspan="2"><%=GetValue(objRS,"CPF")%></td></tr>
			<tr><td>Fone 1:&nbsp;</td>         	<td colspan="2"><%=GetValue(objRS,"FONE_1")%></td></tr>
			<tr><td>Fone 2:&nbsp;</td>         	<td colspan="2"><%=GetValue(objRS,"FONE_2")%></td></tr>
			<tr><td>Celular:&nbsp;</td>        	<td colspan="2"><%=GetValue(objRS,"CELULAR")%></td></tr>
			<tr><td>Email:&nbsp;</td>          	<td colspan="2"><%=GetValue(objRS,"EMAIL")%></td></tr>
			<tr><td>Email Extra:&nbsp;</td>    	<td colspan="2"><%=GetValue(objRS,"EMAIL_EXTRA")%></td></tr>
			<tr><td>Data Nascimento:&nbsp;</td>	<td colspan="2"><%=PrepData(GetValue(objRS,"DT_NASC"), True, False)%></td></tr>
			<tr><td>Idade:&nbsp;</td>          	<td colspan="2">
				<%
					If IsDate(GetValue(objRS,"DT_NASC")) Then 
						strIDADE = DateDiff("M", GetValue(objRS,"DT_NASC"), Date)
						If strIDADE > 0 Then strIDADE = Fix(strIDADE / 12) End If
						If strIDADE > 0 Then Response.Write(strIDADE & " anos") End If
					End If
				%>
			</td></tr>
			<tr><td>Nome da Mãe:&nbsp;</td>    <td colspan="2"><%=GetValue(objRS,"FILIACAO_MAE")%></td></tr>
			<tr><td>Nome do Pai:&nbsp;</td>    <td colspan="2"><%=GetValue(objRS,"FILIACAO_PAI")%></td></tr>
			<tr><td>Status:&nbsp;</td>         <td colspan="2"><% if GetValue(objRS,"DT_INATIVO") = "" then Response.Write "Ativo" else Response.Write "Inativo" end if %></td></tr>
			<tr><td colspan="3" height="10" style="text-align:right;background-color:#E7EFF1;border:#E7EFF1;background-image:none;"></td></tr>
			<tr><td>Endereço:&nbsp;</td>    <td colspan="2"><%=GetValue(objRS,"ENDERECO")%></td></tr>
			<tr><td>Num.:&nbsp;</td>        <td colspan="2"><%=GetValue(objRS,"NUMERO")%></td></tr>
			<tr><td>Complemento:&nbsp;</td> <td colspan="2"><%=GetValue(objRS,"COMPLEMENTO")%></td></tr>
			<tr><td>CEP:&nbsp;</td>         <td colspan="2"><%=GetValue(objRS,"CEP")%></td></tr>
			<tr><td>Cidade:&nbsp;</td>      <td colspan="2"><%=GetValue(objRS,"CIDADE")%></td></tr>
			<tr><td>Bairro:&nbsp;</td>      <td colspan="2"><%=GetValue(objRS,"BAIRRO")%></td></tr>
			<tr><td>Estado:&nbsp;</td>      <td colspan="2"><%=GetValue(objRS,"ESTADO")%></td></tr>
			<tr><td>País Extra:&nbsp;</td>  <td colspan="2"><%=GetValue(objRS,"PAIS")%></td></tr>
			<% If VerificaDireito("|DADOS_RH|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then %>
				<tr><td colspan="3" height="10" style="text-align:right;background-color:#E7EFF1;border:#E7EFF1;background-image:none;"></td></tr>
				<tr><td>Filial Vinculada:&nbsp;</td>     <td colspan="2"><%=GetValue(objRS,"FILIAL_VINCULADA")%></td></tr>
				<tr><td>Data Contratação:&nbsp;</td>     <td colspan="2"><%=PrepData(GetValue(objRS,"DT_CONTRATACAO"),True,False)%></td></tr>
				<tr id="tableheader_last_row"><td>Tempo de Casa:&nbsp;</td>        <td colspan="2">
				<%
				strTEMPO_MESES = ""
				strTEMPO_CASA = ""
				
				If IsDate(GetValue(objRS,"DT_CONTRATACAO")) Then 
					strTEMPO_ANOS  = DateDiff("M", GetValue(objRS,"DT_CONTRATACAO"), Date)
					strTEMPO_MESES = DateDiff("M", GetValue(objRS,"DT_CONTRATACAO"), Date)
					
					If strTEMPO_ANOS > 0 Then strTEMPO_ANOS = Fix(strTEMPO_ANOS / 12)
					If strTEMPO_MESES > 0 Then strTEMPO_MESES = strTEMPO_MESES Mod 12
					
					If strTEMPO_ANOS > 0 Then
						strTEMPO_CASA = strTEMPO_CASA & strTEMPO_ANOS
						If strTEMPO_ANOS = 1 Then 
							strTEMPO_CASA = strTEMPO_CASA & " ano "
						Else
							strTEMPO_CASA = strTEMPO_CASA & " anos "
						End If
					End If
					
					If strTEMPO_MESES > 0 Then
						strTEMPO_CASA = strTEMPO_CASA & strTEMPO_MESES
						If strTEMPO_MESES = 1 Then 
							strTEMPO_CASA = strTEMPO_CASA & " mês "
						Else
							strTEMPO_CASA = strTEMPO_CASA & " meses "
						End If
					End If
				End If
				
				If strTEMPO_CASA <> "" Then Response.Write("em torno de " & strTEMPO_CASA) End If
				%>
				</td></tr>
				<tr><td>Data Assin. Carteira:&nbsp;</td> <td colspan="2"><%=PrepData(GetValue(objRS,"DT_ASSIN_CARTEIRA"),True,False)%></td></tr>
				<tr><td>Data Desligamento:&nbsp;</td>    <td colspan="2"><%=PrepData(GetValue(objRS,"DT_DESLIGAMENTO"),True,False)%></td></tr>
				<tr><td>Setor:&nbsp;</td>                <td colspan="2"><%=GetValue(objRS,"SETOR")%></td></tr>
				<tr><td>Remuneração Mensal:&nbsp;</td>   <td colspan="2"><%=FormataDecimal(GetValue(objRS,"REMUNERACAO_MENSAL"), 2)%></td></tr>
				<tr><td>Regime:&nbsp;</td>               <td colspan="2"><%=GetValue(objRS,"REGIME")%></td></tr>
				<tr><td>Auxílio Estudo:&nbsp;</td>       <td colspan="2"><%=GetValue(objRS,"AUXILIO_ESTUDO")%></td></tr>
				<tr><td>Forma de Pagamento:&nbsp;</td>   <td colspan="2"><%=GetValue(objRS,"FORMA_PGTO")%></td></tr>
				<tr><td>Vale Transporte:&nbsp;</td>      <td colspan="2"><% If GetValue(objRS,"UTILIZA_VT") = "VT" Then Response.Write("Sim") Else Response.Write("Não") End If %></td></tr>
				<tr><td>Valor Unitário:&nbsp;</td>       <td colspan="2"><%=FormataDecimal(GetValue(objRS,"VLR_VT_UNIT"), 2)%></td></tr>
				<tr><td>Qtde por Dia:&nbsp;</td>         <td colspan="2"><%=GetValue(objRS,"QTDE_VT_DIA")%></td></tr>
				<tr><td>Valor Total por Dia:&nbsp;</td>
				<td colspan="2">
				<%
					If (GetValue(objRS,"UTILIZA_VT") = "VT") And (CDbl(0 & GetValue(objRS,"VLR_VT_UNIT")) > 0) And (CDbl(0 & GetValue(objRS,"QTDE_VT_DIA")) > 0) Then
						Response.Write(FormataDecimal(GetValue(objRS,"VLR_VT_UNIT") * GetValue(objRS,"QTDE_VT_DIA"), 2))
					End If
				%>
				</td></tr>
				<tr><td>Vale Refeição/Alim.:&nbsp;</td>  
				<td colspan="2">
				<% 
					If GetValue(objRS,"UTILIZA_VRVA") = "VR" Then 
						Response.Write("Vale Refeição") 
					ElseIf GetValue(objRS,"UTILIZA_VRVA") = "VA" Then 	
						Response.Write("Vale Alimentação") 
					Else 
						Response.Write("Não") 
					End If
				%>
				</td></tr>
				<tr><td>Valor:&nbsp;</td>       <td colspan="2"><%=FormataDecimal(GetValue(objRS,"VLR_VRVA"), 2)%></td></tr>
				<tr><td colspan="3" height="10"></td></tr>
				<tr><td>Banco:&nbsp;</td>       <td colspan="2"><%=GetValue(objRS,"BANCO")%></td></tr>
				<tr><td>Agênca:&nbsp;</td>      <td colspan="2"><%=GetValue(objRS,"AGENCIA")%></td></tr>
				<tr><td>Conta:&nbsp;</td>       <td colspan="2"><%=GetValue(objRS,"CONTA")%></td></tr>
				<tr id="tableheader_last_row"><td colspan="3" height="10"></td></tr>
			<% End If %>
		 </tbody>
	</table>
</div>
<br/>
<% 
	If VerificaDireito("|DADOS_RH|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
		'Menu CSS INSERT DETAIL
		athBeginCssMenu()
			athCssMenuAddItem "#", "onClick=""displayArea('table_header2');""", "_self", "HISTÓRICOS", "", 1
			If VerificaDireito("|INS|", BuscaDireitosFromDB("modulo_COLABORADOR", Request.Cookies("VBOSS")("ID_USUARIO")), false) Then
				athBeginCssSubMenu()
					athCssMenuAddItem "InsertHistorico.asp?var_codigo="& strCODIGO,"", "_self", "Inserir Histórico", "div_modal", 0
				athEndCssSubMenu()
			End If
		athEndCssMenu("div_modal")
%>
<div id="table_header2" style="width:100%">
<%
		strSQL =          " SELECT COD_HISTORICO, TEXTO, SYS_DTT_INS, SYS_USR_INS, ARQUIVO_ANEXO "
		strSQL = strSQL & " FROM ENT_HISTORICO "
		strSQL = strSQL & " WHERE TIPO = 'ENT_COLABORADOR' "
		strSQL = strSQL & " AND CODIGO = " & strCODIGO
		strSQL = strSQL & " ORDER BY SYS_DTT_INS DESC "
		
		Set objRSAux = objConn.Execute(strSQL)
		
		If Not objRSAux.Eof Then
%>
	<table border="0" align="center" cellpadding="0" cellspacing="1" class="tablesort">
		<thead>
			<tr>
				<th width="1%"  class="sortable-numeric" nowrap>Cod</th>
				<th width="74%" class="sortable" nowrap>Texto</th>
				<th width="10%" class="sortable">Por</th>
				<th width="15%" class="sortable">Quando</th>
                <th width="1%"  ></th>
			</tr>
		</thead>
		<tbody style="text-align:left">
			<% Do While Not objRSAux.Eof 
            	strARQUIVOANEXO = GetValue(objRSAux,"ARQUIVO_ANEXO")
			%>
			<tr>
				<td style="text-align:right" nowrap><%=GetValue(objRSAux, "COD_HISTORICO")%></td>
				<td style="text-align:left" valign='top'><%=GetValue(objRSAux, "TEXTO")%></td>
				<td style="text-align:left" valign='top' nowrap><%=GetValue(objRSAux, "SYS_USR_INS")%></td>
				<td style="text-align:left" valign='top' nowrap><%=PrepData(GetValue(objRSAux, "SYS_DTT_INS"), True, True)%></td>
                <td align="right" nowrap><% if strARQUIVOANEXO<>"" then %><a href="../athdownloader.asp?var_cliente=<%=Request.Cookies("VBOSS")("CLINAME")%>&var_tipo=COLABORADOR_Anexos&var_arquivo=<%=strARQUIVOANEXO%>" target="_blank" style="cursor:hand;"><img src="../img/ico_clip.gif" border="0" title="Anexo"></a><% end if%></td>
			</tr>
			<% 
				objRSAux.MoveNext 
				Loop 
			%>
		</tbody>
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