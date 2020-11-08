<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%	
Dim objConn, objRS, objRSCT, strSQL 
Dim intCodServico, intCodNF, strVLR_SERVICO, strFATOR, strDESC_EXTRA, strPRC_COMISSAO, strVLR_COMISSAO

intCodServico = GetParam("var_cod_servico")
intCodNF = GetParam("var_cod_nf")
strVLR_SERVICO = GetParam("var_vlr_servico")
strFATOR = GetParam("var_fator")
strDESC_EXTRA = GetParam("var_desc_extra")
strPRC_COMISSAO = GetParam("var_prc_comissao")

If IsEmpty(strVLR_SERVICO)  Then strVLR_SERVICO = 0
If IsEmpty(strFATOR)        Then strFATOR = 0
If IsEmpty(strPRC_COMISSAO) Then strPRC_COMISSAO = 0

strVLR_SERVICO = strVLR_SERVICO * strFATOR
strVLR_COMISSAO = 0
If strPRC_COMISSAO > 0 Then strVLR_COMISSAO = strVLR_SERVICO * (strPRC_COMISSAO / 100)

AbreDBConn objConn, CFG_DB 

strSQL = "SELECT TITULO, DESCRICAO, OBS, VALOR FROM SV_SERVICO WHERE COD_SERVICO=" & intCodServico
AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
if not objRS.eof then
	strSQL = " INSERT INTO NF_ITEM "						&_
			"  ( COD_NF"									&_
			"  , COD_SERVICO"								&_
			"  , TIT_SERVICO"								&_
			"  , DESC_SERVICO"								&_
			"  , DESC_EXTRA"								&_
			"  , OBS_SERVICO"								&_
			"  , VALOR_ORIG"								&_																								
			"  , VALOR"										&_																								
			"  , PRC_COMISSAO"								&_																								
			"  , VLR_COMISSAO"								&_																								
			"  ) "											&_
			" VALUES"										&_
			" ( " & intCodNF 								&_ 
			" , " & intCodServico 	 						&_
			" , '" & GetValue(objRS,"TITULO") & "'"			&_  
			" , '" & GetValue(objRS,"DESCRICAO") & "'"		&_
			" , '" & strDESC_EXTRA & "'"					&_
			" , '" & GetValue(objRS,"OBS") & "'"			&_
			" , " & FormataDouble(GetValue(objRS,"VALOR"))	&_
			" , " & FormataDouble(strVLR_SERVICO)			&_
			" , " & FormataDouble(FormataDecimal(strPRC_COMISSAO, 2)) &_
			" , " & FormataDouble(FormataDecimal(strVLR_COMISSAO, 2)) &_
			" )"

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.InserrtServicos_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	'Resseta todas as informações sobre acumulados para serem recalculados depois

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(" UPDATE NF_NOTA SET VLR_IRRF_ACUM = 0, VLR_REDUCAO_ACUM = 0 WHERE COD_NF = " & intCodNF)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.InserrtServicos_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(" UPDATE NF_NOTA SET COD_NF_IRRF = NULL WHERE COD_NF_IRRF = " & intCodNF)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.InserrtServicos_Exec C: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(" UPDATE NF_NOTA SET COD_NF_REDUCAO = NULL WHERE COD_NF_REDUCAO = " & intCodNF)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.InserrtServicos_Exec D: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
end if
FechaRecordSet objRS

FechaDBConn objConn
%>
<script language="JavaScript">
	location='DetailServicos.asp?var_chavereg=<%=intCodNF%>';
</script>