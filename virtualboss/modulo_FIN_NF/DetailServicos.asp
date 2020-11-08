<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/Scripts.js"-->
<%
Dim objConn, objRS, objRSCT, strSQL
Dim i, intCOD_NF, strPARAMS
Dim dblTotalNota, dblTotalIRRF, dblTotalIRRFAcum, dblTotalPIS, dblTotalCOFINS, dblTotalCSOCIAL
Dim dblTotalReducaoOutros, dblTotalREDUCAOAcum, dblVlrComissao
Dim strItems, strCOD_NF_IRRF, strCOD_NF_REDUCAO

intCOD_NF = GetParam("var_chavereg")
strPARAMS = GetParam("var_params")

if intCOD_NF<>"" and strPARAMS="" then
	AbreDBConn objConn, CFG_DB 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
</head>
<script language="JavaScript" type="text/javascript">
function DeleteSelect(){
var i, strCodigoSv;
	i=1;
	strCodigoSv='';
	
	while (eval("document.formSv.checkSv_" + i)!=null){
		if (eval("document.formSv.checkSv_" + i).checked){
			if (strCodigoSv!='')
				strCodigoSv = strCodigoSv + ';' + eval("document.formSv.checkSv_" + i).value;
			else
				strCodigoSv = eval("document.formSv.checkSv_" + i).value;
		}
		i++;
	}
	
	if (strCodigoSv!=''){		
		if (confirm("Deseja remover o(s) servi&ccedil;o(s) selecionado(s)?")) 
			location = 'DetailServicos.asp?var_chavereg=<%=intCOD_NF%>&var_params=' + strCodigoSv;
	}
}

function EditaServico(prCodItem, prCodNF){
	AbreJanelaPAGENew('UpdateServicos.asp?var_chavereg=' + prCodItem + '&var_cod_nf=' + prCodNF,'400','220','no','');
}

function AtualizaTotal(prValorNota, prValorIRRF, prValorIRRFAcum, prValorPIS, prValorCOFINS, prValorCSOCIAL, prValorReducaoOutros, prValorREDUCAOAcum, prValorComissao, prCodNFsIRRF, prCodNFsREDUCAO) {
	window.parent.document.forms[0].var_total_servicos.value = prValorNota;
	window.parent.document.forms[0].var_vlr_IRRF.value = prValorIRRF;
	window.parent.document.forms[0].var_vlr_IRRF_acum.value = prValorIRRFAcum;
	window.parent.document.forms[0].var_vlr_PIS.value = prValorPIS;
	window.parent.document.forms[0].var_vlr_COFINS.value = prValorCOFINS;
	window.parent.document.forms[0].var_vlr_CSOCIAL.value = prValorCSOCIAL;
	window.parent.document.forms[0].var_vlr_reducao_outros.value = prValorReducaoOutros;
	window.parent.document.forms[0].var_vlr_REDUCAO_acum.value = prValorREDUCAOAcum;
	window.parent.document.forms[0].var_vlr_COMISSAO.value = prValorComissao;
	window.parent.document.forms[0].var_cod_nfs_IRRF.value = prCodNFsIRRF;
	window.parent.document.forms[0].var_cod_nfs_REDUCAO.value = prCodNFsREDUCAO;
	
	if ((prValorIRRFAcum != '') && (prValorIRRFAcum != '0'))
		window.parent.document.forms[0].var_IRRF_acum.checked = true;
	else
		window.parent.document.forms[0].var_IRRF_acum.checked = false;
	
	if ((prValorREDUCAOAcum != '') && (prValorREDUCAOAcum != '0'))
		window.parent.document.forms[0].var_REDUCAO_acum.checked = true;
	else
		window.parent.document.forms[0].var_REDUCAO_acum.checked = false;
	
	window.parent.Marcar();
}
</script>
<body>
<%	
	dblTotalNota = 0
	dblVlrComissao = 0
	
	strSQL = " SELECT"							&_
			"	 T1.COD_NF_ITEM"				&_
			"	,T1.VALOR_ORIG" 				&_
			"	,T1.VALOR" 						&_
			"	,T1.TIT_SERVICO AS TITULO "		&_
			"	,T1.VLR_COMISSAO"				&_
			" FROM" 							&_
			"	NF_ITEM T1 " 					&_
			" WHERE" 							&_
			"	T1.COD_NF=" & intCOD_NF			&_
			" ORDER BY"							&_
			"	T1.TIT_SERVICO"
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.eof then 
%>
<table width="100%" cellspacing="0px" cellpadding="0px">
<form name="formSv" action="" method="post">
	<tr>
		<td width="1%" height="18px"></td>
		<td width="1%"></td>
		<td width="95%"><div style="padding-left:3px;">Servi&ccedil;o</div></td>
		<td width="1%" align="right" nowrap><div style="padding-right:8px;">Vlr Comissão</div></td>
		<td width="1%" align="right" nowrap><div style="padding-right:8px;">Vlr Orig</div></td>
		<td width="1%" align="right" nowrap><div style="padding-right:8px;">Valor</div></td>
	</tr>
	<tr><td colspan="6" height="3px"></td></tr>
	<tr><td colspan="6" height="1px" bgcolor="#CCCCCC"></td></tr>
	<tr><td colspan="6" height="3px"></td></tr>
<%
		while not objRS.eof
			i = i + 1
			dblTotalNota = dblTotalNota + CDbl("0" & GetValue(objRS,"VALOR"))
			dblVlrComissao = dblVlrComissao + CDbl("0" & GetValue(objRS,"VLR_COMISSAO"))
%>
	<tr>
		<td width="1%"><input type="checkbox" name="checkSv_<%=i%>" value="<%=objRS("COD_NF_ITEM")%>"></td>
		<td width="1%" valign="middle" style="cusrsor:hand;">
			<a href="JavaScript:EditaServico(<%=objRS("COD_NF_ITEM")%>, <%=intCOD_NF%>);">
				<img align="absmiddle" border="0px" hspace="4" src="../img/IconAction_EDIT.gif" title="Alterar serviço">
			</a>
		</td>
		<td width="95%"><div style="padding-left:3px;"><%=GetValue(objRS,"TITULO")%></div></td>
		<td width="1%" align="right" nowrap><div style="padding-right:8px;"><%=FormataDecimal(GetValue(objRS,"VLR_COMISSAO"),2)%></div></td>
		<td width="1%" align="right" nowrap><div style="padding-right:8px;"><%=FormataDecimal(GetValue(objRS,"VALOR_ORIG"),2)%></div></td>
		<td width="1%" align="right" nowrap><div style="padding-right:8px;"><%=FormataDecimal(GetValue(objRS,"VALOR"),2)%></div></td>
	</tr>
<%
			objRS.MoveNext
		wend
		
		if objRS.RecordCount>0 then
%>
	<tr><td colspan="6" height="5px"></td></tr>
	<tr>
   	<td height="20" bgcolor="#CCCCCC" colspan="6">
			<div style="padding-left:5px;">
				<a href="JavaScript:DeleteSelect();"><img src="../img/IcoLixo.gif" title="Remover servi&ccedil;os selecionados" border="0px" align="absmiddle"></a>
			</div>
		</td>
	</tr>
<%
		end if 
%>
</form>
</table> 
<%
	end if 
%>
</body>
</html>
<%
	FechaRecordSet objRS
	
	'---------------------------------------------
	' Busca as alíquotas e calcula valores
	'---------------------------------------------
	strSQL =          " SELECT ALIQ_IRRF, ALIQ_PIS, ALIQ_COFINS, ALIQ_CSOCIAL " 
	strSQL = strSQL & " FROM CFG_NF WHERE DT_INATIVO IS NULL"
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	if not objRS.eof then 
		dblTotalIRRF    = CDbl("0" & dblTotalNota) * (CDbl("0" & GetValue(objRS,"ALIQ_IRRF"))/100)
		dblTotalPIS     = CDbl("0" & dblTotalNota) * (CDbl("0" & GetValue(objRS,"ALIQ_PIS"))/100)
		dblTotalCOFINS  = CDbl("0" & dblTotalNota) * (CDbl("0" & GetValue(objRS,"ALIQ_COFINS"))/100)
		dblTotalCSOCIAL = CDbl("0" & dblTotalNota) * (CDbl("0" & GetValue(objRS,"ALIQ_CSOCIAL"))/100)
	end if
	FechaRecordSet objRS
	
	'---------------------------------------------
	' Busca o IRRF acumulado
	'---------------------------------------------
	strSQL = " SELECT VLR_IRRF_ACUM, COD_NF_IRRF, VLR_REDUCAO_ACUM, COD_NF_REDUCAO FROM NF_NOTA WHERE COD_NF = " & intCOD_NF
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	dblTotalIRRFAcum = ""
	if not objRS.eof then 
		dblTotalIRRFAcum	= GetValue(objRS,"VLR_IRRF_ACUM")
		dblTotalREDUCAOAcum = GetValue(objRS,"VLR_REDUCAO_ACUM")
		
		strCOD_NF_IRRF		= GetValue(objRS,"COD_NF_IRRF")
		strCOD_NF_REDUCAO	= GetValue(objRS,"COD_NF_REDUCAO")
	end if
	FechaRecordSet objRS
	
	If (dblTotalIRRFAcum = "") Or (Not IsNumeric(dblTotalIRRFAcum)) Then dblTotalIRRFAcum = 0 End If
	If (dblTotalREDUCAOAcum = "") Or (Not IsNumeric(dblTotalREDUCAOAcum)) Then dblTotalREDUCAOAcum = 0 End If
	
	dblTotalNota = FormataDecimal(dblTotalNota,2)
	dblTotalIRRF = FormataDecimal(dblTotalIRRF + dblTotalIRRFAcum,2)
	dblTotalReducaoOutros = FormataDecimal(dblTotalPIS + dblTotalCOFINS + dblTotalCSOCIAL + dblTotalREDUCAOAcum,2)
	dblVlrComissao = FormataDecimal(dblVlrComissao,2)
	
	FechaDBConn objConn
	%>
	<script language="JavaScript">
		AtualizaTotal('<%=dblTotalNota%>', '<%=dblTotalIRRF%>', '<%=dblTotalIRRFAcum%>', '<%=dblTotalPIS%>', '<%=dblTotalCOFINS%>', '<%=dblTotalCSOCIAL%>', '<%=dblTotalReducaoOutros%>', '<%=dblTotalREDUCAOAcum%>', '<%=dblVlrComissao%>', '<%=strCOD_NF_IRRF%>', '<%=strCOD_NF_REDUCAO%>');
	</script>
	<%
else
	AbreDBConn objConn, CFG_DB
	
	if strPARAMS<>"" then
		strItems = Split(strPARAMS,";")
		for each i in strItems
			'AQUI: NEW TRANSACTION
			set objRSCT  = objConn.Execute("start transaction")
			set objRSCT  = objConn.Execute("set autocommit = 0")
			objConn.Execute("DELETE FROM NF_ITEM WHERE COD_NF_ITEM = " & i)
			If Err.Number <> 0 Then
				set objRSCT = objConn.Execute("rollback")
				Mensagem "modulo_FIN_NF.DetailServicos A" & i & ": " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
				Response.End()
			else
				set objRSCT = objConn.Execute("commit")
			End If
		next
		
		'Resseta todas as informações sobre acumulados para serem recalculados depois

		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(" UPDATE NF_NOTA SET VLR_IRRF_ACUM = 0, VLR_REDUCAO_ACUM = 0 WHERE COD_NF = " & intCod_NF)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_NF.DetailServicos B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If

		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(" UPDATE NF_NOTA SET COD_NF_IRRF = NULL WHERE COD_NF_IRRF = " & intCod_NF)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_NF.DetailServicos C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If

		'AQUI: NEW TRANSACTION
		set objRSCT  = objConn.Execute("start transaction")
		set objRSCT  = objConn.Execute("set autocommit = 0")
		objConn.Execute(" UPDATE NF_NOTA SET COD_NF_REDUCAO = NULL WHERE COD_NF_REDUCAO = " & intCod_NF)
		If Err.Number <> 0 Then
			set objRSCT = objConn.Execute("rollback")
			Mensagem "modulo_FIN_NF.DetailServicos D: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
			Response.End()
		else
			set objRSCT = objConn.Execute("commit")
		End If

	end if
	FechaDBConn objConn
	
	Response.Redirect("DetailServicos.asp?var_chavereg=" & intCOD_NF)
end if
%>