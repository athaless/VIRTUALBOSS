<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<!--#include file="../_database/athUtils.asp"-->
<%
Dim strSQL1, strSQL2, objRS, objRSCT, objConn
Dim intCod_NF, intCod_Cfg_NF, intCodCliente
Dim strClienteNome, strObservacao
Dim strDataEmissao
Dim strIdUsuario, strMsg, dblValorTotal
Dim dblValorIRRF, dblValorISSQN, dblValorIRPJ
Dim dblValorPIS, dblValorCOFINS, dblValorCSocial
Dim dblTotalImposto, dblTotalNota, dblValorReducaoOutros
Dim dblValorComissao
Dim strIRRF, strREDUCAO_OUTROS, strABERTURA, strPrzVcto
Dim dblValorIRRF_Acum, strIRRF_Acum, strCOD_NFS_IRRF
Dim dblValorREDUCAO_Acum, strREDUCAO_Acum, strCOD_NFS_REDUCAO
Dim strSERIE

intCod_NF 				= GetParam("VAR_COD_NF")
intCod_Cfg_NF			= GetParam("VAR_COD_CFG_NF")
intCodCliente			= GetParam("VAR_COD_CLI")
strClienteNome			= GetParam("VAR_CLI_NOME")
strObservacao			= GetParam("VAR_OBS_NF")
strDataEmissao			= GetParam("VAR_DT_EMISSAO")
dblValorTotal			= GetParam("var_total_servicos") 
dblValorIRRF			= GetParam("var_vlr_IRRF")
dblValorPIS				= GetParam("var_vlr_PIS")
dblValorCOFINS			= GetParam("var_vlr_COFINS")
dblValorCSOCIAL			= GetParam("var_vlr_CSOCIAL")
strIRRF					= GetParam("var_IRRF")
strREDUCAO_OUTROS		= GetParam("var_reducao_outros")
dblValorReducaoOutros	= GetParam("var_vlr_reducao_outros")
dblValorComissao		= GetParam("var_vlr_COMISSAO")
strPrzVcto              = GetParam("VAR_PRZ_VCTO")

strIRRF_Acum			= GetParam("var_IRRF_acum")
dblValorIRRF_Acum		= GetParam("var_vlr_IRRF_Acum")
strCOD_NFS_IRRF         = GetParam("var_cod_nfs_IRRF")

strREDUCAO_Acum			= GetParam("var_REDUCAO_acum")
dblValorREDUCAO_Acum	= GetParam("var_vlr_REDUCAO_acum")
strCOD_NFS_REDUCAO      = GetParam("var_cod_nfs_REDUCAO")


strABERTURA = UCase(GetParam("var_abertura"))

AbreDBConn objConn, CFG_DB 

	strMsg=""
	
	if IsEmpty(intCod_NF) or intCod_NF="" then strMsg = strMsg & "Informar código da nota<br>"
	if IsEmpty(intCodCliente) or intCodCliente="" then strMsg = strMsg & "Informar cliente<br>"
	if IsEmpty(intCod_Cfg_NF) or intCod_Cfg_NF="" then strMsg = strMsg & "Parâmetro inválido para modelo de nota<br>"
	if IsEmpty(dblValorTotal) or dblValorTotal="" then strMsg = strMsg & "Parâmetro inválido para valor de conta<br>"
	if IsEmpty(strDataEmissao) or not IsDate(strDataEmissao) then strMsg = strMsg & "Parâmetro inválido para data de emissao<br>"
	
	if strMSG<>"" then 
		Mensagem strMsg, "Javascript:history.back();", "Voltar", 1
		Response.End()
	end if
	
	strObservacao	= Replace(strObservacao,"'","<ASLW_APOSTROFE>")
	strIdUsuario	= LCase(Request.Cookies("VBOSS")("ID_USUARIO"))
	strDataEmissao	= "'" & PrepDataBrToUni(strDataEmissao,true) & "'"
	
	If strIRRF = "" Then dblValorIRRF = 0
	
	If strIRRF_Acum = "" Then dblValorIRRF_Acum = 0
	If strIRRF_Acum = "" Then strCOD_NFS_IRRF = ""
	
	If strREDUCAO_Acum = "" Then dblValorREDUCAO_Acum = 0
	If strREDUCAO_Acum = "" Then strCOD_NFS_REDUCAO = ""
	
	If strREDUCAO_OUTROS = "" Then 
		dblValorPIS = 0
		dblValorCOFINS = 0
		dblValorCSOCIAL = 0
		dblValorReducaoOutros = 0
	End If
	
	'--------------------------------------------------------
	' Busca dados do modelo da nota para calcular valores
	'--------------------------------------------------------
	strSQL1 = " SELECT"								&_
				"	ALIQ_ISSQN,"					&_
				"	ALIQ_IRPJ,"						&_
				"	SERIE"						&_
				" FROM"								&_
				"	CFG_NF "						&_
				" WHERE"							&_
				"	DT_INATIVO IS NULL AND"			&_
				"	COD_CFG_NF =" & intCod_Cfg_NF
	AbreRecordSet objRS, strSQL1, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	
	strSERIE = ""
	
	dblValorIRPJ 	= 0
	dblValorISSQN 	= 0
	dblTotalNota	= 0
	dblTotalImposto	= 0
	
	if not objRS.eof then
		strSERIE = GetValue(objRS,"SERIE")
		
		dblValorIRPJ  = CDbl("0" & dblValorTotal) * (CDbl("0" & GetValue(objRS,"ALIQ_IRPJ"))/100)
		dblValorISSQN = CDbl("0" & dblValorTotal) * (CDbl("0" & GetValue(objRS,"ALIQ_ISSQN"))/100)
		
		dblTotalNota = CDbl("0" & dblValorTotal) - CDbl("0" & dblValorIRRF) - CDbl("0" & dblValorReducaoOutros) + CDbl("0" + dblValorComissao)
		
		dblTotalImposto	= CDbl(dblValorPIS + dblValorIRPJ + dblValorISSQN + dblValorCOFINS + dblValorCSocial)
	end if
	FechaRecordSet objRS		
	
	dblValorIRRF         = FormataDouble(FormataDecimal(dblValorIRRF, 2))
	dblValorIRPJ         = FormataDouble(FormataDecimal(dblValorIRPJ, 2))
	dblValorISSQN        = FormataDouble(FormataDecimal(dblValorISSQN, 2))
	dblValorPIS          = FormataDouble(FormataDecimal(dblValorPIS, 2))
	dblValorCOFINS       = FormataDouble(FormataDecimal(dblValorCOFINS, 2))
	dblValorCSocial      = FormataDouble(FormataDecimal(dblValorCSocial, 2))
	dblValorComissao     = FormataDouble(FormataDecimal(dblValorComissao, 2))
	dblTotalImposto      = FormataDouble(FormataDecimal(dblTotalImposto, 2))
	dblValorTotal        = FormataDouble(FormataDecimal(dblValorTotal, 2))
	dblTotalNota         = FormataDouble(FormataDecimal(dblTotalNota, 2))
	dblValorIRRF_Acum    = FormataDouble(FormataDecimal(dblValorIRRF_Acum, 2))
	dblValorREDUCAO_Acum = FormataDouble(FormataDecimal(dblValorREDUCAO_Acum, 2))
	
	'--------------------------------------------------------
	' Monta SQL de atualização
	'--------------------------------------------------------
	strSQL2 = 	" UPDATE NF_NOTA " &_
				" SET TOT_SERVICO = " & dblValorTotal &_
				"   , TOT_NF = " & dblTotalNota &_
				"   , TOT_IMPOSTO = " & dblTotalImposto &_
				"   , TOT_IMPOSTO_CLI = " & dblValorIRRF &_
				"   , VLR_ISSQN	= "	& dblValorISSQN &_
				"   , VLR_IRPJ = " & dblValorIRPJ &_
				"   , VLR_PIS = " & dblValorPIS &_
				"   , VLR_COFINS = " & dblValorCOFINS &_
				"   , VLR_CSOCIAL = " & dblValorCSocial &_
				"   , VLR_IRRF = " & dblValorIRRF &_
				"	, VLR_IRRF_ACUM = " & dblValorIRRF_Acum &_
				"	, VLR_REDUCAO_ACUM = " & dblValorREDUCAO_Acum &_
				"   , VLR_COMISSAO = " & dblValorComissao &_
				"   , OBS_NF = '" & strObservacao & "'" &_
				"   , SITUACAO = 'NAO_EMITIDA'" &_
				"   , DT_EMISSAO = " & strDataEmissao &_
				"   , PRZ_VCTO = '" & strPrzVcto & "'" &_
				"   , COD_CFG_NF = " & intCod_Cfg_NF &_
				"   , SERIE = '" & strSERIE & "'"
	
	'--------------------------------------------------------
	' Busca dados do cliente da nota para armazenar na nota
	'--------------------------------------------------------
	strSQL1 = " SELECT"					&_
				" 	FATURA_ENDERECO"	&_
				" ,	FATURA_COMPLEMENTO"	&_
				" ,	FATURA_NUMERO"		&_
				" ,	FATURA_BAIRRO"		&_
				" ,	FATURA_CIDADE"		&_
				" ,	FATURA_ESTADO"		&_
				" ,	FATURA_CEP"			&_
				" ,	FONE_1"				&_
				" ,	NUM_DOC"			&_
				" ,	INSC_ESTADUAL "		&_
				" FROM"					&_
				"	ENT_CLIENTE "		&_
				" WHERE"				&_
				"	COD_CLIENTE=" & intCodCliente
	
	AbreRecordSet objRS, strSQL1, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
	if not objRS.eof then
		strSQL2 = strSQL2 & "	, COD_CLI = " & intCodCliente
		strSQL2 = strSQL2 & "	, CLI_NOME	='" & strClienteNome & "'"
		
		strSQL2 = strSQL2 & "	, CLI_ENDER	='" & GetValue(objRS,"FATURA_ENDERECO")
		If GetValue(objRS,"FATURA_NUMERO") <> ""      Then strSQL2 = strSQL2 & ", " & GetValue(objRS,"FATURA_NUMERO")
		If GetValue(objRS,"FATURA_COMPLEMENTO") <> "" Then strSQL2 = strSQL2 & " / " & GetValue(objRS,"FATURA_COMPLEMENTO")
		strSQL2 = strSQL2 & "'"
		
		strSQL2 = strSQL2 & "	, CLI_NUM_DOC		='" & GetValue(objRS,"NUM_DOC")				& "'"
		strSQL2 = strSQL2 & "	, CLI_INSC_ESTADUAL	='" & GetValue(objRS,"INSC_ESTADUAL")		& "'"
		strSQL2 = strSQL2 & "	, CLI_CEP			='" & GetValue(objRS,"FATURA_CEP")			& "'"
		strSQL2 = strSQL2 & "	, CLI_BAIRRO		='" & GetValue(objRS,"FATURA_BAIRRO") 		& "'"
		strSQL2 = strSQL2 & "	, CLI_CIDADE		='" & GetValue(objRS,"FATURA_CIDADE") 		& "'"
		strSQL2 = strSQL2 & "	, CLI_ESTADO		='" & GetValue(objRS,"FATURA_ESTADO") 		& "'"
		strSQL2 = strSQL2 & "	, CLI_FONE			='" & GetValue(objRS,"FONE_1") 				& "'"
	end if
	FechaRecordSet objRS		
	
	'---------------------------------
	'Monta parte final e executa
	'---------------------------------
	strSQL2 = strSQL2 & " WHERE COD_NF=" & intCod_NF
	objConn.Execute(strSQL2)
	
	'--------------------------------------------------------------------------------
	'Se IRRF da nota acumulou IRRFs de outras notas então faz ligação entre todas
	'--------------------------------------------------------------------------------
	If strCOD_NFS_IRRF <> "" Then
		strSQL1 =           " UPDATE NF_NOTA "
		strSQL1 = strSQL1 & " SET COD_NF_IRRF = " & intCod_NF
		strSQL1 = strSQL1 & " WHERE COD_NF IN (" & strCOD_NFS_IRRF & ") "
	Else
		strSQL1 =           " UPDATE NF_NOTA "
		strSQL1 = strSQL1 & " SET COD_NF_IRRF = NULL "
		strSQL1 = strSQL1 & " WHERE COD_NF_IRRF = " & intCod_NF
	End If
	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL1)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.Update_Exec A: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	'-------------------------------------------------------------------------------------
	'Se Redução da nota acumulou Reduções de outras notas então faz ligação entre todas
	'-------------------------------------------------------------------------------------
	If strCOD_NFS_REDUCAO <> "" Then
		strSQL1 =           " UPDATE NF_NOTA "
		strSQL1 = strSQL1 & " SET COD_NF_REDUCAO = " & intCod_NF
		strSQL1 = strSQL1 & " WHERE COD_NF IN (" & strCOD_NFS_REDUCAO & ") "
	Else
		strSQL1 =           " UPDATE NF_NOTA "
		strSQL1 = strSQL1 & " SET COD_NF_REDUCAO = NULL "
		strSQL1 = strSQL1 & " WHERE COD_NF_REDUCAO = " & intCod_NF
	End If

	'AQUI: NEW TRANSACTION
	set objRSCT  = objConn.Execute("start transaction")
	set objRSCT  = objConn.Execute("set autocommit = 0")
	objConn.Execute(strSQL1)
	If Err.Number <> 0 Then
		set objRSCT = objConn.Execute("rollback")
		Mensagem "modulo_FIN_NF.Update_Exec B: " & Err.Number & " - "& Err.Description , DEFAULT_LOCATION, 1, True
		Response.End()
	else
		set objRSCT = objConn.Execute("commit")
	End If
	
	FechaDBConn objConn

'----------------------------
'Melhorar isso mais tarde
'----------------------------
If strABERTURA = "EXTERNA" Then 
	Response.Redirect("Insert.asp")
Else
	Response.Redirect("Update.asp?var_chavereg=" & intCod_NF)
End If
%>