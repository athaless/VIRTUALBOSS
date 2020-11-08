<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%	
Dim objConn, objRS, objRSCT, strSQL 
Dim intCOD_NF_ITEM, intCOD_NF, strVLR_VALOR_ORIG, strVLR_VALOR, strPRC_COMISSAO, strVLR_COMISSAO
Dim strFATOR, strDESC_EXTRA

intCOD_NF_ITEM		= GetParam("var_chavereg")
intCOD_NF			= GetParam("var_cod_nf")
strVLR_VALOR_ORIG	= GetParam("var_valor_orig")
strVLR_VALOR		= GetParam("var_valor")
strPRC_COMISSAO		= GetParam("var_prc_comissao")
strVLR_COMISSAO		= GetParam("var_vlr_comissao")
strFATOR			= GetParam("var_fator")
strDESC_EXTRA		= GetParam("var_desc_extra")

If IsEmpty(strVLR_VALOR) Then strVLR_VALOR = 0
If IsEmpty(strPRC_COMISSAO) Then strPRC_COMISSAO = 0
If IsEmpty(strVLR_COMISSAO) Then strVLR_COMISSAO = 0
If IsEmpty(strFATOR) Then strFATOR = 0

AbreDBConn objConn, CFG_DB 

If intCOD_NF_ITEM <> "" And intCOD_NF <> "" Then
	strSQL =          " UPDATE NF_ITEM "
	strSQL = strSQL & " SET VALOR_ORIG = " & FormataDouble(FormataDecimal(strVLR_VALOR_ORIG, 2))
	strSQL = strSQL & "   , VALOR = " & FormataDouble(FormataDecimal(strVLR_VALOR, 2))
	strSQL = strSQL & "   , PRC_COMISSAO = " & FormataDouble(FormataDecimal(strPRC_COMISSAO, 2))
	strSQL = strSQL & "   , VLR_COMISSAO = " & FormataDouble(FormataDecimal(strVLR_COMISSAO, 2))
	strSQL = strSQL & "   , DESC_EXTRA = '" & strDESC_EXTRA & "' "
	strSQL = strSQL & " WHERE COD_NF_ITEM = " & intCOD_NF_ITEM
	
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.UpdateServicos_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	'Resseta todas as informações sobre acumulados para serem recalculados depois

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(" UPDATE NF_NOTA SET VLR_IRRF_ACUM = 0, VLR_REDUCAO_ACUM = 0 WHERE COD_NF = " & intCOD_NF)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.UpdateServicos_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(" UPDATE NF_NOTA SET COD_NF_IRRF = NULL WHERE COD_NF_IRRF = " & intCOD_NF)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.UpdateServicos_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(" UPDATE NF_NOTA SET COD_NF_REDUCAO = NULL WHERE COD_NF_REDUCAO = " & intCOD_NF)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.UpdateServicos_Exec D: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
End If

FechaDBConn objConn
%>
<script language="JavaScript">
	opener.location.reload();
	window.close();
</script>